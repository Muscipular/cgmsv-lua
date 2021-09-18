----- @return number BatteIndex
function Battle.GetCurrentBattle(CharIndex)
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
      print('[BATTLE EX] error:', err, battleIndex, side, slot);
    end
    if Char.GetData(p, CONST.CHAR_EnemyActionFlag) == 1 then
      success, err = pcall(fn, battleIndex, side, slot, 1)
      if not success then
        print('[BATTLE EX] error:', err, battleIndex, side, slot);
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

function Battle.RegEnemyCommandEvent(luaFile, callback)
  --004C27E0 ; char __cdecl Battle_Do_EnemyCommand(int battleIndex, unsigned int side, int a3)
  print('onReg', callback);
  if luaFile then
    local success, err = pcall(dofile, luaFile);
    if success == false then
      print('[BATTLE EX]', 'load lua error', err);
    end
  end
  local addr = 0x004C27E0;
  fnList[addr .. ''] = callback;
  if Battle_Do_EnemyCommand == nil then
    Battle_Do_EnemyCommand = ffi.hook.new('char (__cdecl *)(int battleIndex, unsigned int side, int slot)', HookEnemyCommand, addr, 5)
  end
end

Battle.Commands = {}

function Battle.Commands.GetTargets(battleIndex, attackerSlot)
  local attacker = Battle.GetPlayer(battleIndex, attackerSlot);
  local weapon, weaponSlot = Char.GetWeapon(attacker);
  local isRanger = false;
  if weapon > 0 and table.indexOf(Item.Types.RangerWeaponType, Item.GetData(weapon, CONST.道具_类型)) > 0 then
    isRanger = true;
  end
  local targets = {}
  local allowTargets = {}
  if attackerSlot < 10 then
    allowTargets = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }
    for i = 10, (attackerSlot >= 5 or isRanger) and 19 or 14 do
      if Battle.GetPlayer(battleIndex, i) > i then
        table.insert(targets, i);
      end
    end
    allowTargets = table.combine(allowTargets, targets);
  else
    allowTargets = { 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 }
    for i = 0, (attackerSlot >= 5 or isRanger) and 9 or 4 do
      if Battle.GetPlayer(battleIndex, i) > i then
        table.insert(targets, i);
      end
    end
    allowTargets = table.combine(allowTargets, targets);
  end
  return targets, allowTargets
end

function Battle.Commands.Attack(battleIndex, attackerSlot, action, slot)
  local attacker = Battle.GetPlayer(battleIndex, attackerSlot);
  if attacker < 0 then
    return -1;
  end
  local targets, allowTargets = Battle.Commands.GetTargets(battleIndex, attackerSlot);
  if slot == nil or Battle.GetPlayer(battleIndex, slot) < 0 or table.indexOf(allowTargets, slot) < 1 then
    slot = targets[math.random(0, #targets)]
  end

  Char.SetData(attacker, action == 1 and CONST.CHAR_Battle2Com1 or CONST.CHAR_BattleCom1, Battle.COM_LIST.BATTLE_COM_ATTACK);
  Char.SetData(attacker, action == 1 and CONST.CHAR_Battle2Com2 or CONST.CHAR_BattleCom2, slot);
  Char.SetData(attacker, action == 1 and CONST.CHAR_Battle2Com3 or CONST.CHAR_BattleCom3, -1);
  return 0;
end

Battle.COM_LIST = {
  BATTLE_COM_NONE = 0x0,
  BATTLE_COM_GUARD = 0x1,
  BATTLE_COM_POSITION = 0x2,
  BATTLE_COM_EQUIP = 0x3,
  BATTLE_COM_ATTACK = 0x4,
  BATTLE_COM_CAPTURE = 0x5,
  BATTLE_COM_ESCAPE = 0x6,
  BATTLE_COM_PETIN = 0x7,
  BATTLE_COM_PETOUT = 0x8,
  BATTLE_COM_ITEM = 0x9,
  BATTLE_COM_BOOMERANG = 0xA,
  BATTLE_COM_COMBO = 0xB,
  BATTLE_COM_COMBOEND = 0xC,
  BATTLE_COM_WAIT = 0xD,
  BATTLE_COM_ALLESCAPE = 0xE,
  BATTLE_COM_CALL = 0xF,
  BATTLE_COM_P_RENZOKU = 0x10,
  BATTLE_COM_P_PARAMETER = 0x11,
  BATTLE_COM_P_SPIRACLESHOT = 0x12,
  BATTLE_COM_P_EDGE = 0x13,
  BATTLE_COM_P_CHARGEATTACK = 0x14,
  BATTLE_COM_P_BUSTATTACK = 0x15,
  BATTLE_COM_P_GUARDBREAK = 0x16,
  BATTLE_COM_P_FORCECUT = 0x17,
  BATTLE_COM_P_RANDOMSHOT = 0x18,
  BATTLE_COM_P_PANIC = 0x19,
  BATTLE_COM_P_ASSASSIN = 0x1A,
  BATTLE_COM_RANBU = 0x1B,
  BATTLE_COM_ATTACKALL = 0x1C,
  BATTLE_COM_DETECTENEMY = 0x1D,
  BATTLE_COM_URGENTALLOWANCE = 0x1E,
  BATTLE_COM_URGENTMEDIC = 0x1F,
  BATTLE_COM_INDIRECTSTATUSATTACK = 0x20,
  BATTLE_COM_AXEBOMBER = 0x21,
  BATTLE_COM_ULTIMATEATTACK = 0x22,
  BATTLE_COM_PICKPOCKET = 0x23,
  BATTLE_COM_RCVUP = 0x24,
  BATTLE_COM_PARRYING = 0x25,
  BATTLE_COM_THROWITEM = 0x26,
  BATTLE_COM_PROVOCATION = 0x27,
  BATTLE_COM_P_BODYGUARD = 0x28,
  BATTLE_COM_P_DODGE = 0x29,
  BATTLE_COM_P_CROSSCOUNTER = 0x2A,
  BATTLE_COM_P_SPECIALGARD = 0x2B,
  BATTLE_COM_P_MAGICGARD = 0x2C,
  BATTLE_COM_P_HEAL = 0x2D,
  BATTLE_COM_P_MAGIC = 0x2E,
  BATTLE_COM_P_DORAIN = 0x2F,
  BATTLE_COM_P_STATUSCHANGE = 0x30,
  BATTLE_COM_P_STATUSRECOVER = 0x31,
  BATTLE_COM_P_REVIVE = 0x32,
  BATTLE_COM_P_REFLECTION_PHYSICS = 0x33,
  BATTLE_COM_P_ABSORB_PHYSICS = 0x34,
  BATTLE_COM_P_INEFFECTIVE_PHYSICS = 0x35,
  BATTLE_COM_P_ABSORB_MAGIC = 0x36,
  BATTLE_COM_P_REFLECTION_MAGIC = 0x37,
  BATTLE_COM_P_INEFFECTIVE_MAGIC = 0x38,
  BATTLE_COM_P_LP_RECOVERY = 0x39,
  BATTLE_COM_P_TREAT_TYPE = 0x3A,
  BATTLE_COM_P_REVERSE_TYPE = 0x3B,
  BATTLE_COM_P_CONSENTRATION = 0x3C,
  BATTLE_COM_P_DRESSAGE = 0x3D,
  BATTLE_COM_P_RAISE = 0x3E,
  BATTLE_COM_P_EXTORTION = 0x3F,
  BATTLE_COM_P_STEAL = 0x40,
  BATTLE_COM_P_POSITIONATTACK = 0x41,
  BATTLE_COM_P_DANCE = 0x42,
  BATTLE_COM_P_DEFUP = 0x43,
  BATTLE_COM_P_DEFDOWN = 0x44,
  BATTLE_COM_P_ATKUP = 0x45,
  BATTLE_COM_P_ATKDOWN = 0x46,
  BATTLE_COM_P_AGLUP = 0x47,
  BATTLE_COM_P_AGLDOWN = 0x48,
  BATTLE_COM_M_DEATH = 0x49,
  BATTLE_COM_M_STATUSATTACK = 0x4A,
  BATTLE_COM_M_BREAKATTACK = 0x4B,
  BATTLE_COM_M_GOLDATTACK = 0x4C,
  BATTLE_COM_M_ENERGYDRAIN = 0x4D,
  BATTLE_COM_M_BOMB = 0x4E,
  BATTLE_COM_M_SACRIFICE = 0x4F,
  BATTLE_COM_M_BLOODATTACK = 0x50,
  BATTLE_COM_M_SUMMON = 0x51,
  BATTLE_COM_M_EARTHQUAKE = 0x52,
  BATTLE_COM_SEKIBAN = 0x3E8,
  BATTLE_COM_S_RENZOKU = 0x3E9,
  BATTLE_COM_S_GBREAK = 0x3EA,
  BATTLE_COM_S_GUARDIAN_ATTACK = 0x3EB,
  BATTLE_COM_S_GUARDIAN_GUARD = 0x3EC,
  BATTLE_COM_S_CHARGE = 0x3ED,
  BATTLE_COM_S_MIGHTY = 0x3EE,
  BATTLE_COM_S_POWERBALANCE = 0x3EF,
  BATTLE_COM_S_STATUSCHANGE = 0x3F0,
  BATTLE_COM_S_EARTHROUND0 = 0x3F1,
  BATTLE_COM_S_EARTHROUND1 = 0x3F2,
  BATTLE_COM_S_LOSTESCAPE = 0x3F3,
  BATTLE_COM_S_ABDUCT = 0x3F4,
  BATTLE_COM_S_STEAL = 0x3F5,
  BATTLE_COM_S_NOGUARD = 0x3F6,
  BATTLE_COM_S_CHARGE_OK = 0x3F7,
  BATTLE_COM_JYUJYUTU = 0x7D0,
  BATTLE_COM_DELAYATTACK = 0x9C4,
  BATTLE_COM_BILLIARD = 0x9C5,
  BATTLE_COM_KNIGHTGUARD = 0x9C6,
  BATTLE_COM_FIRSTATTACK = 0x9C7,
  BATTLE_COM_REST = 0x9C8,
  BATTLE_COM_COPY = 0x9C9,
  BATTLE_COM_RETRIBUTION = 0x9CA,
  BATTLE_COM_RIDER = 0x9CB,
  BATTLE_COM_RIDER_BREAK = 0x9CC,
  BATTLE_COM_M_ACIDRAIN = 0xA28,
  BATTLE_COM_M_TORNADE = 0xA29,
  BATTLE_COM_M_BARRIER = 0xA2A,
  BATTLE_COM_REBIRTH = 0xBB8,
}

for i, v in pairs(Battle.COM_LIST) do
  Battle.COM_LIST[v] = i;
end

NL.RegEnemyCommandEvent = Battle.RegEnemyCommandEvent;

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
