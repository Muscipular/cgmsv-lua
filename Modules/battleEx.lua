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
  self:regCallback('EnemyCommandEvent', function(battleIndex, side, slot, action)
    self:logDebug('OnEnemyCommand', battleIndex, side, slot, action, Battle.GetTurn(battleIndex));
    local char = Battle.GetPlayer(battleIndex, slot);
    self:logDebug('charIndex:', char);
    if char >= 0 then
      self:logDebug('char:', char, Char.GetData(char, CONST.CHAR_名字));
      self:logDebug('mode:', Char.GetData(char, CONST.CHAR_BattleMode));
      if action == 0 then
        self:logDebug('com_1:', Battle.COM_LIST[Char.GetData(char, CONST.CHAR_BattleCom1)]);
        self:logDebug('com2_1:', Battle.COM_LIST[Char.GetData(char, CONST.CHAR_Battle2Com1)]);
        Char.SetData(char, CONST.CHAR_BattleCom1, Battle.COM_LIST.BATTLE_COM_GUARD);
        --self:logDebug('com_2:', Char.GetData(char, CONST.CHAR_BattleCom2));
        --self:logDebug('com_3:', Char.GetData(char, CONST.CHAR_BattleCom3));
        Char.SetData(char, CONST.CHAR_BattleCom2, 0);
        Char.SetData(char, CONST.CHAR_BattleCom3, 0);
        self:logDebug('com_1:', Battle.COM_LIST[Char.GetData(char, CONST.CHAR_BattleCom1)]);
      else
        self:logDebug('com_1:', Battle.COM_LIST[Char.GetData(char, CONST.CHAR_BattleCom1)]);
        self:logDebug('com2_1:', Battle.COM_LIST[Char.GetData(char, CONST.CHAR_Battle2Com1)]);
        --self:logDebug('com2_2:', Char.GetData(char, CONST.CHAR_Battle2Com2));
        --self:logDebug('com2_3:', Char.GetData(char, CONST.CHAR_Battle2Com3));
        Char.SetData(char, CONST.CHAR_Battle2Com1, Battle.COM_LIST.BATTLE_COM_GUARD);
        Char.SetData(char, CONST.CHAR_Battle2Com2, 0);
        Char.SetData(char, CONST.CHAR_Battle2Com3, 0);
        self:logDebug('com2_1:', Battle.COM_LIST[Char.GetData(char, CONST.CHAR_Battle2Com1)]);
      end
    end
  end);
end

--- 卸载模块钩子
function BattleEx:onUnload()
  self:logInfo('unload')
end

return BattleEx;
