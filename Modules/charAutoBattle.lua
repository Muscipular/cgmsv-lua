---模块类
---@class Module: ModuleType
local Module = ModuleBase:createModule('charAutoBattle')

function Module:talked(player, _msg)
  if _msg == '/autobattle on' then
    Char.SetData(player, CONST.对象_自动战斗开关, 1);
    NLG.SystemMessage(player, "自动战斗开启");
    return 0;
  elseif _msg == '/autobattle off' then
    Char.SetData(player, CONST.对象_自动战斗开关, 0);
    Char.SetTempData(player, "LastAction", nil);
    NLG.SystemMessage(player, "自动战斗关闭");
    return 0;
  end
end

function DoAction(charIndex, actionNum)
  print(charIndex, actionNum, Battle.IsWaitingCommand(charIndex), Char.GetTempData(charIndex, "LastAction"));
  if (Battle.IsWaitingCommand(charIndex) == 1) then
    local last = Char.GetTempData(charIndex, "LastAction") or "";
    local actions = table.map(string.split(last, ","), function(v) return tonumber(v) end);
    Battle.ActionSelect(charIndex, actions[actionNum * 3 + 1] or CONST.BATTLE_COM.BATTLE_COM_ATTACK,
      actions[actionNum * 3 + 2] or 15, actions[actionNum * 3 + 3] or -1);
  end
end

function Module:battleAction(battleIndex, ch)
  local petSlot = Char.GetData(ch, CONST.对象_战宠);
  local ridePet = Char.GetData(ch, CONST.对象_骑宠);
  local ch2 = ch;
  if petSlot >= 0 && petSlot < 5 then
    ch2 = Char.GetPet(ch, petSlot);
  end
  if ridePet >= 0 && ridePet < 5 && ridePet == petSlot then
    ch = ch2;
  end
  self:logInfo(ch, ch2, ridePet, petSlot, Battle.GetTurn(battleIndex));
  DoAction(ch, 1);
  DoAction(ch2, 2);
  return 1;
end

function Module:BattleActionEventCallBack(charIndex, Com1, Com2, Com3, actionNum)
  if (Char.GetData(charIndex, CONST.对象_自动战斗开关) == 1) then
    return
  end
  if actionNum == 2 then
    Char.SetTempData(charIndex, "LastAction",
      string.format('%s,%d,%d,%d', Char.GetTempData(charIndex, "LastAction"), Com1, Com2, Com3))
  else
    Char.SetTempData(charIndex, "LastAction", string.format('%d,%d,%d', Com1, Com2, Com3))
  end
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.talked, self))
  self:regCallback('AutoBattleCommandEvent', Func.bind(self.battleAction, self))
  self:regCallback('BattleActionEvent', Func.bind(self.BattleActionEventCallBack, self))
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
