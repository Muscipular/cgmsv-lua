---模块类
---@class Module: ModuleType
local Module = ModuleBase:createModule('charAutoBattle')

function Module:talked(player, _msg)
  if _msg == '/autobattle on' then
    Char.SetTempData(player, "__SKIP_BATTLE_ACTION", 1);
    NLG.SystemMessage(player, "自动战斗开启");
    return 0;
  elseif _msg == '/autobattle off' then
    Char.SetTempData(player, "__SKIP_BATTLE_ACTION", nil);
    NLG.SystemMessage(player, "自动战斗关闭");
    return 0;
  end
end

function Module:battleAction(battleIndex, turn)
  for i = 1, 5 do
    local ch = Battle.GetPlayIndex(battleIndex, i - 1);
    if ch >= 0 then
      if Char.GetData(ch, CONST.CHAR_类型) == CONST.对象类型_人 then
        if (Char.GetTempData(ch, "__SKIP_BATTLE_ACTION") == 1 && Battle.IsWaitingCommand(ch) == 1) then
          Battle.ActionSelect(ch, CONST.BATTLE_COM.BATTLE_COM_ATTACK, 10, -1);
        end
        goto CONTINUE;
      end
    end
    local ch2 = Battle.GetPlayIndex(battleIndex, i - 1 + 5);
    if ch2 >= 0 then
      if ch < 0 then
        ch = ch2;
      end
      if (Char.GetTempData(ch2, "__SKIP_BATTLE_ACTION") == 1 && Battle.IsWaitingCommand(ch) == 1) then
        Battle.ActionSelect(ch, CONST.BATTLE_COM.BATTLE_COM_ATTACK, 10, -1);
      end
    end
    ::CONTINUE::
  end
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.talked, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.battleAction, self))
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
