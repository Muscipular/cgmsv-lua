---模块类
local Module = ModuleBase:createModule('summonDemo')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  getModule('adminCommands'):regCommand('testNextBattle', function(charIndex)
    local battleIndex = Battle.PVE(charIndex, charIndex, nil, { 1 }, { 1 });
    Battle.SetNextBattle(battleIndex, -2, 0xeeff);
  end)
  self:regCallback('BattleNextEnemyEvent', function(battleIndex, flg)
    if flg >= 0xeeff and flg < 0xeeff + 5 then
      Battle.SetNextBattle(battleIndex, -2, flg + 1);
      return { 0, 2 + flg - 0xeeff }
    end
    return nil
  end)

  self:regCallback('EnemyCommandEvent', function(battleIndex, side, slot, action)
    if Battle.GetNextBattleFlg(battleIndex) and Battle.GetNextBattleFlg(battleIndex) >= 0xeeff and Battle.GetNextBattleFlg(battleIndex) < 0xeeff + 5 then
      local char = Battle.GetPlayer(battleIndex, slot);
      Char.SetData(char, CONST.CHAR_EnemySummon1, 1);
      Char.SetData(char, CONST.CHAR_EnemySummon2, 2);
      if action == 0 then
        Char.SetData(char, CONST.CHAR_BattleCom1, CONST.BATTLE_COM.BATTLE_COM_M_SUMMON)
        Char.SetData(char, CONST.CHAR_BattleCom2, 0)
        Char.SetData(char, CONST.CHAR_BattleCom3, 9303)
      end
    end
  end)

  self:regCallback('BattleSummonEnemyEvent', function(battleIndex, charIndex, enemyId)
    if Battle.GetNextBattleFlg(battleIndex) and Battle.GetNextBattleFlg(battleIndex) >= 0xeeff and Battle.GetNextBattleFlg(battleIndex) < 0xeeff + 5 then
      return { 2, 10, 0 }
    end
  end)
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
