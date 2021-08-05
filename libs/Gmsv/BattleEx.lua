----- @return number BatteIndex
function Battle.GetCurrentBattle(CharIndex)
  Char.GetData(CharIndex, CONST.CHAR_BattleIndex)
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
  return FFI.setMemoryInt32(battleAddr + 0x38, encountIndex)
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
local enemyHooked = false
local _ENEMY_getEnemyFromEncountArray

local function OnCallback(charAddr, encountId, nextEncountId, formation, randRange, nnn)
  -- statements
end

--00462E10 ; int *__cdecl ENEMY_getEnemyFromEncountArray(Char *a1, int encountId, _DWORD *nextEncountId, _DWORD *formation, _DWORD *randRange, _DWORD *a6)
local function hook()
  if enemyHooked == false then
    _ENEMY_getEnemyFromEncountArray = FFI.hook.new(
      'void *(__cdecl *)(int a1, int encountId, int *nextEncountId, uint32_t *formation, uint32_t *randRange, uint32_t *nnn)',
      OnCallback,
      0x00462E10,
      5
    )
  end
end

--function NL.RegVSEnemyCreateEvent(Dofile, FuncName)
--    if Dofile and _G[FuncName] == nil then
--        dofile(Dofile)
--    end
--    fnList.VSEnemyCreateEvent = FuncName
--    hook()
--end
