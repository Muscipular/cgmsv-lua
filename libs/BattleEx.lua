local BattleTable = FFI.readMemoryDWORD(0x09202B14)
print('BattleTable:', BattleTable)
local BattleMax = FFI.readMemoryDWORD(0x09203B80)
print('BattleMax:', BattleMax)
--00462E10 ; int *__cdecl ENEMY_getEnemyFromEncountArray(Char *a1, int encountId, _DWORD *nextEncountId, _DWORD *formation, _DWORD *randRange, _DWORD *a6)

----- @return number BatteIndex
function Battle.GetCurrentBattle(CharIndex)
    Char.GetData(CharIndex, CONST.CHAR_BattleIndex)
end

----- @return number EncountId
function Battle.GetNextBattle(BattleIndex)
    if BattleIndex < 0 or BattleIndex >= BattleMax then
        return -3
    end
    local battleAddr = BattleTable + BattleIndex * 0x1480
    if FFI.readMemoryInt32(battleAddr) == 0 then
        return -2
    end
    return FFI.readMemoryInt32(battleAddr + 0x38)
end

function Battle.SetNextBattle(BattleIndex, encountId)
    if BattleIndex < 0 or BattleIndex >= BattleMax then
        return -3
    end
    local battleAddr = BattleTable + BattleIndex * 0x1480
    if FFI.readMemoryInt32(battleAddr) == 0 then
        return -2
    end
    return FFI.setMemoryInt32(battleAddr + 0x38, tonumber(encountId))
end

local fnList = {}
local enemyHooked = false
local _ENEMY_getEnemyFromEncountArray

function OnCallback(charAddr, encountId, nextEncountId, formation, randRange, nnn)
    -- statements
end

function hook()
    if enemyHooked == false then
        _ENEMY_getEnemyFromEncountArray =
            FFI.hook.new(
            'void *(__cdecl *)(int a1, int encountId, int *nextEncountId, uint32_t *formation, uint32_t *randRange, uint32_t *nnn)',
            OnCallback,
            0x00462E10,
            5
        )
    end
end

function NL.RegVSEnemyCreateEvent(Dofile, FuncName)
    if Dofile and _G[FuncName] == nil then
        dofile(Dofile)
    end
    fnList.VSEnemyCreateEvent = FuncName
    hook()
end
