---模块类
local BattleEx = ModuleBase:createModule('battleEx')

--- 加载模块钩子
function BattleEx:onLoad()
  self:logInfo('load')
  --self:regCallback('BattleStartEvent', function(battleIndex)
  --  local encountId = Data.GetEncountData(Battle.GetNextBattle(battleIndex), CONST.Encount_ID)
  --  local nextencountid = Data.GetEncountData(Battle.GetNextBattle(battleIndex), CONST.Encount_NextEncountID)
  --  self:logDebug(Battle.GetNextBattle(battleIndex), encountId, nextencountid);
  --  self:logDebug(Data.GetEncountIndex(1041));
  --  if encountId ~= 1041 then
  --    Battle.SetNextBattle(battleIndex, Data.GetEncountIndex(1041));
  --  end
  --end)
end

--- 卸载模块钩子
function BattleEx:onUnload()
  self:logInfo('unload')
end

return BattleEx;
