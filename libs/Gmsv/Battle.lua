local bit32 = require 'bit'
local bnot = bit32.bnot
local bxor = bit32.bxor
local band = bit32.band
local bor = bit32.bor

----- @return number BatteIndex
function Battle.GetCurrentBattle(CharIndex)
  if Char.GetData(CharIndex, CONST.CHAR_战斗状态) == 0 then
    return -1;
  end
  return Char.GetData(CharIndex, CONST.CHAR_BattleIndex)
end

----- @return number encountIndex
function Battle.GetNextBattle(BattleIndex)
  if BattleIndex < 0 or BattleIndex >= Addresses.BattleMax then
    return -3
  end
  local battleAddr = Addresses.BattleTable + BattleIndex * 0x1480
  if FFI.readMemoryDWORD(battleAddr) == 0 then
    return -2
  end
  return FFI.readMemoryInt32(battleAddr + 0x38)
end

function Battle.UnsetWinEvent(battleIndex)
  if battleIndex < 0 or battleIndex >= Addresses.BattleMax then
    return -3
  end
  local battleAddr = Addresses.BattleTable + battleIndex * 0x1480
  if FFI.readMemoryInt32(battleAddr) == 0 then
    return -2
  end
  FFI.setMemoryInt32(battleAddr + 0x13E4, 0)
  FFI.setMemoryInt32(battleAddr + 0x1464, 0)
  return 1
end

Battle.UnsetPVPWinEvent = Battle.UnsetWinEvent;

function Battle.SetNextBattle(battleIndex, encountIndex)
  if battleIndex < 0 or battleIndex >= Addresses.BattleMax then
    return -3
  end
  local battleAddr = Addresses.BattleTable + battleIndex * 0x1480
  if FFI.readMemoryInt32(battleAddr) == 0 then
    return -2
  end
  encountIndex = tonumber(encountIndex);
  if encountIndex < 0 or encountIndex == nil then
    encountIndex = -1;
  end
  if not FFI.setMemoryInt32(battleAddr + 0x38, encountIndex) then
    return -1;
  end
  return 1;
end

---获取当前回合数
function Battle.GetTurn(battleIndex)
  if battleIndex < 0 or battleIndex >= Addresses.BattleMax then
    return -3
  end
  local battleAddr = Addresses.BattleTable + battleIndex * 0x1480
  if FFI.readMemoryDWORD(battleAddr) == 0 then
    return -2
  end
  return FFI.readMemoryInt32(battleAddr + 0x1c)
end

local fnList = {}
local Battle_Do_EnemyCommand;
--local BATTLE_Bid2No = ffi.cast('int (__cdecl*)(int battleIndex, uint32_t charAddr)', 0x00479B90);
--00479B90 ; int __cdecl BATTLE_Bid2No(int a1, Char *a2)

local function RunBattleCommand(fn, battleIndex, side, slot)
  local p = Battle.GetPlayer(battleIndex, slot);
  --print('[BATTLE EX] loop', slot, p)
  if p >= 0 then
    local success, err = pcall(fn, battleIndex, side, slot, 0)
    if not success then
      print('[BATTLE][HookEnemyCommand] error:', err, battleIndex, side, slot);
    end
    if Char.GetData(p, CONST.CHAR_EnemyActionFlag) == 1 then
      success, err = pcall(fn, battleIndex, side, slot, 1)
      if not success then
        print('[BATTLE][HookEnemyCommand] error:', err, battleIndex, side, slot);
      end
    end
  end
end

local function HookEnemyCommand(battleIndex, side, slot)
  --print('[BATTLE EX]', battleIndex, side, slot)
  --print(Battle.GetType(battleIndex), fnList[addr .. ''], _G[fnList[addr .. '']])
  local addr = 0x004C27E0;
  local ret = Battle_Do_EnemyCommand(battleIndex, side, slot);
  if Battle.GetType(battleIndex) == CONST.战斗_PVP then
    return ret;
  end
  local fn = fnList[addr .. ''];
  if fn and _G[fn .. ''] then
    if slot == 0 then
      for i = 10, 19 do
        RunBattleCommand(_G[fn], battleIndex, side, i);
      end
    else
      RunBattleCommand(_G[fn], battleIndex, side, slot);
    end
  end
  return ret;
end

local function RegEnemyCommandEvent(luaFile, callback)
  --004C27E0 ; char __cdecl Battle_Do_EnemyCommand(int battleIndex, unsigned int side, int a3)
  --print('onReg', callback);
  if luaFile then
    local success, err = pcall(dofile, luaFile);
    if success == false then
      print('[BATTLE][EnemyCommandEvent]', 'load lua error', err);
    end
  end
  local addr = 0x004C27E0;
  fnList[addr .. ''] = callback;
  if Battle_Do_EnemyCommand == nil then
    Battle_Do_EnemyCommand = ffi.hook.new('char (__cdecl *)(int battleIndex, unsigned int side, int slot)', HookEnemyCommand, addr, 5)
  end
end

NL.RegEnemyCommandEvent = RegEnemyCommandEvent;
local sendCommandUpdateToClient = ffi.cast('uint32_t (__cdecl *)(int battleIndex)', 0x0047C4B0);

local _BeforeBattleTurnCallback;
function NL.RegBeforeBattleTurnEvent(luaFile, fn)
  if luaFile then
    local r, msg = pcall(dofile, luaFile)
    if not r then
      print('[LUA] RegBeforeBattleTurnEvent error: ', msg);
    end
  end
  _BeforeBattleTurnCallback = fn;
end

local function handleBeforeBattleTurn(battleIndex)
  if _BeforeBattleTurnCallback and _G[_BeforeBattleTurnCallback] then
    local r, msg = pcall(_G[_BeforeBattleTurnCallback], battleIndex)
    if not r then
      print('[LUA] BeforeBattleTurnCallback error: ', msg);
    else
      if msg then
        sendCommandUpdateToClient(battleIndex);
      end
    end
  end
end

ffi.hook.inlineHook('void (__cdecl *)(int battleIndex)', handleBeforeBattleTurn, 0x00487A40, 0xb,
  { 0x50, 0x53 }, --push ebx
  { 0x5b, 0x58 }  --pop ebx
)

--local enemyHooked = false
--local _ENEMY_getEnemyFromEncountArray
--
--local function OnCallback(charAddr, encountId, nextEncountId, formation, randRange, nnn)
--  -- statements
--end
--
----00462E10 ; int *__cdecl ENEMY_getEnemyFromEncountArray(Char *a1, int encountId, _DWORD *nextEncountId, _DWORD *formation, _DWORD *randRange, _DWORD *a6)
--local function hook()
--  if enemyHooked == false then
--    _ENEMY_getEnemyFromEncountArray = FFI.hook.new(
--      'void *(__cdecl *)(int a1, int encountId, int *nextEncountId, uint32_t *formation, uint32_t *randRange, uint32_t *nnn)',
--      OnCallback,
--      0x00462E10,
--      5
--    )
--  end
--end
--
----function NL.RegVSEnemyCreateEvent(Dofile, FuncName)
----    if Dofile and _G[FuncName] == nil then
----        dofile(Dofile)
----    end
----    fnList.VSEnemyCreateEvent = FuncName
----    hook()
----end

local _ProcessBattleCommand = ffi.cast('int (__cdecl *)(uint32_t charAddr, int com, int com2, int com3)', 0x0048BD50);

function Battle.ActionSelect(charIndex, com1, com2, com3)
  if not Char.IsValidCharIndex(charIndex) then
    return -1;
  end
  if not Battle.IsWaitingCommand(charIndex) then
    return -2;
  end
  local charPtr = Char.GetCharPointer(charIndex);
  _ProcessBattleCommand(charPtr, com1, com2, com3);
end

function Battle.IsWaitingCommand(charIndex)
  return Char.GetBattleIndex(charIndex) >= 0 and Char.GetData(charIndex, CONST.CHAR_BattleMode) == 2;
end

local emitCalcCriticalRateEvent = NL.newEvent('CalcCriticalRateEvent', nil)
local function hookCalcCriticalRateEvent (charPtr, cri)
  --printAsHex('CalcCriticalRateEvent', charPtr, cri);
  local ret = emitCalcCriticalRateEvent(ffi.readMemoryInt32(charPtr + 4), cri)
  if type(ret) == 'number' then
    if ret > 0 then
      return ret;
    end
    return 0;
  end
  return cri;
end
ffi.hook.inlineHook('int (__cdecl *)(uint32_t, int)', hookCalcCriticalRateEvent, 0x0048E6A9, 6, {
  0x9C,
  0x51, -- push edx
  0x50, -- push eax
  0xFF, 0xB5, 0xE0, 0xFE, 0xFF, 0xFF, -- push [ebp-120]
}, {
  0x51 + 8, -- pop edx
  0x51 + 8, -- pop edx
  0x51 + 8, -- pop edx
  0x9D,
})

local emitCalcFpConsumeEvent = NL.newEvent('CalcFpConsumeEvent', nil);
local _orgCalcFpConsume;
local function hookCalcFpConsumeEvent(charPtr)
  --printAsHex('hookCalcFpConsumeEvent', charPtr);
  local org = _orgCalcFpConsume(charPtr);
  local ret = emitCalcFpConsumeEvent(ffi.readMemoryInt32(charPtr + 4), ffi.readMemoryInt32(charPtr + 4 * CONST.CHAR_BattleCom3), org);
  if type(ret) == 'number' then
    if ret > 0 then
      return ret;
    end
    return 0;
  end
  return org;
end
_orgCalcFpConsume = ffi.hook.new('int (__cdecl*)(uint32_t a1)', hookCalcFpConsumeEvent, 0x00478F30, 6)

local emitBattleSurpriseEvent = NL.newEvent('BattleSurpriseEvent', nil);
local _BattleSurprise;
local function hookBattleSurprise(battleIndex)
  local result = _BattleSurprise(battleIndex);
  local ret = emitBattleSurpriseEvent(battleIndex, result);
  if type(ret) == 'number' then
    return ret;
  end
  return result;
end
_BattleSurprise = ffi.hook.new('int (__cdecl*)(int a1)', hookBattleSurprise, 0x004956A0, 6)

---获取乱射hit数 1,2,3,4.....
---@param defSlot number 防御者slot
---@param battleIndex number
function Battle.GetRandomShotHit(battleIndex, defSlot)
  if battleIndex < 0 then
    return -1;
  end
  if defSlot < 0 or defSlot > 19 then
    return -2;
  end
  local offset = 0x6C;
  if defSlot >= 10 then
    defSlot = defSlot - 10;
    offset = offset + 0x968;
  end
  offset = offset + 0xC + 0xD0 * defSlot + 0xA8;
  return ffi.readMemoryInt32(Addresses.BattleTable + 0x1480 * battleIndex + offset)
end

local emitBattleInjuryEvent = NL.newEvent('BattleInjuryEvent', nil);

ffi.hook.inlineHook('int (__cdecl *)(uint32_t a, int b)', function(charPtr, val)
  local charIndex = ffi.readMemoryInt32(charPtr + 4);
  local battleIndex = Char.GetBattleIndex(charIndex);
  local e = Char.GetData(charIndex, CONST.CHAR_受伤);
  local ret = emitBattleInjuryEvent(charIndex, battleIndex, val, val);
  --print('BattleInjuryEvent', charIndex, battleIndex, val, ret);
  if ret == nil then
    ret = val;
  end
  if ret <= 0 then
    if Char.GetData(charIndex, CONST.CHAR_受伤) > e then
      return 1;
    end
    if e <= 0 then
      local s = ffi.readMemoryDWORD(charPtr + 0x5e8 + 0x24);
      s = band(s, bnot(0x2000))
      ffi.setMemoryDWORD(charPtr + 0x5e8 + 0x24, s);
    end
    return 0;
  end
  Char.SetData(charIndex, CONST.CHAR_受伤, math.floor(math.max(1, math.min(100, ret))));
  return 1;
end, 0x00496AA9, 6 + 7 + 6, {
  0x53, --push ebx
  0x50, --push eax
  0x53, --push ebx
}, {
  0x58 + 3, --pop ebx
  0x58 + 3, --pop ebx
  0x58 + 3, --pop ebx
  0x85, 0xC0, --test eax,eax
  0x75, 12, --jnz
  0xB8, 0xFF, 0xFF, 0xFF, 0xFF, --mov eax, -1
  0xB8, 0x09, 0x69, 0x49, 0x00, --mov eax,0x00496909 
  0xff, 0xE0, --jmp [ebx]
  0x83, 0xBD, 0xC8, 0xFE, 0xFF, 0xFF, 0x00, -- cmp     [ebp+var_138], 0
  0x0F, 0x84, 0x07, 0x00, 0x00, 0x00, -- jz 
  0xB8, 0xBC, 0x6A, 0x49, 0x00, --mov eax,0x00496ABC  
  0xff, 0xE0, --jmp [ebx]
  0xB8, 0x78, 0x6B, 0x49, 0x00, --mov eax,0x00496B78  
  0xff, 0xE0, --jmp [ebx]
}, { ignoreOriginCode = true })
