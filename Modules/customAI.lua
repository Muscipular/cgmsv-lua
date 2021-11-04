---模块类
local CustomAI = ModuleBase:createModule('customAI.lua')



function CustomAI:OnEnemyCommand(battleIndex, side, slot, action)
  self:logDebug('OnEnemyCommand', battleIndex, side, slot, action, Battle.GetTurn(battleIndex));
  local char = Battle.GetPlayer(battleIndex, slot);
  self:logDebug('charIndex:', char);
  if char >= 0 then
    self:logDebug('char:', char, Char.GetData(char, CONST.CHAR_名字));
    self:logDebug('mode:', Char.GetData(char, CONST.CHAR_BattleMode));
    if action == 0 then
      self:logDebug('com_1:', CONST.BATTLE_COM[Char.GetData(char, CONST.CHAR_BattleCom1)]);
      self:logDebug('com2_1:', CONST.BATTLE_COM[Char.GetData(char, CONST.CHAR_Battle2Com1)]);
      Char.SetData(char, CONST.CHAR_BattleCom1, CONST.BATTLE_COM.BATTLE_COM_GUARD);
      --self:logDebug('com_2:', Char.GetData(char, CONST.CHAR_BattleCom2));
      --self:logDebug('com_3:', Char.GetData(char, CONST.CHAR_BattleCom3));
      Char.SetData(char, CONST.CHAR_BattleCom2, 0);
      Char.SetData(char, CONST.CHAR_BattleCom3, 0);
      self:logDebug('com_1:', CONST.BATTLE_COM[Char.GetData(char, CONST.CHAR_BattleCom1)]);
    else
      self:logDebug('com_1:', CONST.BATTLE_COM[Char.GetData(char, CONST.CHAR_BattleCom1)]);
      self:logDebug('com2_1:', CONST.BATTLE_COM[Char.GetData(char, CONST.CHAR_Battle2Com1)]);
      --self:logDebug('com2_2:', Char.GetData(char, CONST.CHAR_Battle2Com2));
      --self:logDebug('com2_3:', Char.GetData(char, CONST.CHAR_Battle2Com3));
      Char.SetData(char, CONST.CHAR_Battle2Com1, CONST.BATTLE_COM.BATTLE_COM_GUARD);
      Char.SetData(char, CONST.CHAR_Battle2Com2, 0);
      Char.SetData(char, CONST.CHAR_Battle2Com3, 0);
      self:logDebug('com2_1:', CONST.BATTLE_COM[Char.GetData(char, CONST.CHAR_Battle2Com1)]);
    end
  end
end

--- 加载模块钩子
function CustomAI:onLoad()
  self:logInfo('load')
  self:regCallback('EnemyCommandEvent', Func.bind(self.OnEnemyCommand, self));
end

--- 卸载模块钩子
function CustomAI:onUnload()
  self:logInfo('unload')
end

return CustomAI;
