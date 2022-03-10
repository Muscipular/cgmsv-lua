---模块类
local Module = ModuleBase:createModule('charAutoBattle')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback("ProtocolOnRecv", function(fd, head, list)
    local charIndex = Protocol.GetCharIndexFromFd(fd);
    Protocol.Send(charIndex, "AutoBattle");
    local p = Battle.GetSlot(Battle.GetCurrentBattle(charIndex), charIndex);
    p = math.fmod(p + 5, 10);
    p = Battle.GetPlayer(Battle.GetCurrentBattle(charIndex), p);
    Char.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_ATTACK, CONST.BATTLE_COM_TARGETS.SINGLE.SIDE_1.POS_0);
    Char.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_ATTACK, CONST.BATTLE_COM_TARGETS.SINGLE.SIDE_1.POS_0);
    if p >= 0 then
      Char.ActionSelect(p, CONST.BATTLE_COM.BATTLE_COM_ATTACK, CONST.BATTLE_COM_TARGETS.SINGLE.SIDE_1.POS_0);
    end
  end, "AutoBattle")
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
