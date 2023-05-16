Data = _G.Data or {};

function Data.GetEnemyBaseIdByEnemyId(enemyId)
    enemyId = tonumber(enemyId)
    if enemyId == nil then
      return nil;
    end
    local index = Data.EnemyGetDataIndex(enemyId)
    if index < 0 then
      return nil;
    end
    return Data.EnemyGetData(index, CONST.DATA_ENEMY_TEMPNO)
  end
  
  function Data.GetEnemyBaseIndexByEnemyId(enemyId)
    local id = Data.GetEnemyBaseIdByEnemyId(enemyId)
    if id == nil or id < 0 then
      return id;
    end
    return Data.EnemyBaseGetDataIndex(id);
  end
  