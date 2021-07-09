---装备插卡模块
local ModuleCard = ModuleBase:createModule('mCard')

function ModuleCard:onBattleStartEvent(battleIndex)
  local type = Battle.GetType(battleIndex)
  if type == CONST.战斗_普通 then
    local enemyDataList = {};
    self.cache[battleIndex] = enemyDataList;
    for i = 10, 19 do
      local charIndex = Battle.GetPlayer(battleIndex, i);
      if charIndex >= 0 then
        enemyDataList[tostring(i)] = {
          PetId = Char.GetData(charIndex, CONST.PET_PetID),
          Level = Char.GetData(charIndex, CONST.CHAR_等级),
          Name = Char.GetData(charIndex, CONST.CHAR_名字),
          Ethnicity = Char.GetData(charIndex, CONST.CHAR_种族),
        };
      end
    end
  end
end
function ModuleCard:onBattleOverEvent(battleIndex)
  local type = Battle.GetType(battleIndex)
  if type == CONST.战斗_普通 then
    local enemyDataList = self.cache[battleIndex];
    self.cache[battleIndex] = nil;
    local winSide = Battle.GetWinSide(battleIndex);
    if winSide == 0 then
      for i, enemy in pairs(enemyDataList) do
        
      end
    end
  end
end

--- 加载模块钩子
function ModuleCard:onLoad()
  self:logInfo('load')
  self.cache = { }
end

--- 卸载模块钩子
function ModuleCard:onUnload()
  self:logInfo('unload')
end

return ModuleCard;
