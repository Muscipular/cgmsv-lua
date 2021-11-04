local Module = ModuleBase:createModule('autoBattle')

--local disCacheCom = {}
--disCacheCom[0] = 1;
--disCacheCom[1] = 1;
--disCacheCom[2] = 1;
--disCacheCom[3] = 1;
--disCacheCom[5] = 1;
--disCacheCom[6] = 1;
--disCacheCom[7] = 1;
--disCacheCom[8] = 1;
--disCacheCom[9] = 1;
--disCacheCom[0xe] = 1;
--disCacheCom[0x1a] = 1;
--disCacheCom[0x9CB] = 1;
--disCacheCom[0x9CC] = 1;
--disCacheCom[0xDAC] = 1;

--local charData = {};

local battleData = {};

function Module:onLoad()
  self:logInfo('load')
  --self:regCallback('TalkEvent', Func.bind(Module.handleChat, self))
  --self:regCallback('LogoutEvent', Func.bind(Module.cleanUp, self))
  --self:regCallback('BattleActionEvent', Func.bind(Module.battleActionEventCallBack, self))
  self:regCallback('BattleOverEvent', Func.bind(Module.battleOverEventCallback, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(Module.handleBattleAutoCommand, self))
end

function Module:battleOverEventCallback(battleIndex)
  battleData[battleIndex] = nil;
end

function Module:handleBattleAutoCommand(battleIndex)
  local turn = Battle.GetTurn(battleIndex)
  if battleData[battleIndex] == turn then
    return
  end
  battleData[battleIndex] = turn;
  local hasAutoBattle = false;
  self:logDebug('handleBattleAutoCommand', battleIndex)
  self:logDebug('turn', turn);
  local hasPlayer = false;
  for i = 0, 9 do
    local charIndex = Battle.GetPlayer(battleIndex, i);
    if charIndex >= 0 then
      --if Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人 then
      if Char.IsDummy(charIndex) then
        local petIndex = Battle.GetPlayer(battleIndex, math.fmod(i + 5, 10));
        self:logDebug('auto battle', charIndex, petIndex);
        hasAutoBattle = true;
        if Battle.IsWaitingCommand(charIndex) then
          Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_P_RANDOMSHOT, 10, 9500);
        end
        if petIndex >= 0 then
          Battle.ActionSelect(petIndex, CONST.BATTLE_COM.BATTLE_COM_ATTACK, 10, -1);
        else
          Battle.ActionSelect(petIndex, CONST.BATTLE_COM.BATTLE_COM_ATTACK, 10, -1);
        end
      else
        hasPlayer = true;
      end
      --local data = charData[charIndex]
      --if type(data) == 'table' and Char.GetData(charIndex, CONST.CHAR_BattleMode) == 2 then
      --  hasAutoBattle = true;
      --  Char.SetData(charIndex, CONST.CHAR_BattleMode, 3);
      --  Char.SetData(charIndex, CONST.CHAR_BattleCom1, data.comA1 or 0);
      --  Char.SetData(charIndex, CONST.CHAR_BattleCom2, data.comA2 or -1);
      --  Char.SetData(charIndex, CONST.CHAR_BattleCom3, data.comA3 or -1);
      --  Char.SetData(charIndex, CONST.CHAR_Battle2Com1, data.comB1 or 0);
      --  Char.SetData(charIndex, CONST.CHAR_Battle2Com2, data.comB2 or -1);
      --  Char.SetData(charIndex, CONST.CHAR_Battle2Com3, data.comB3 or -1);
      --end
      --end
    end
  end
  self:logDebug(hasAutoBattle, hasPlayer, not hasPlayer)
  if not hasPlayer and hasAutoBattle then
    for i = 0, 9 do
      local charIndex = Battle.GetPlayer(battleIndex, i);
      if charIndex >= 0 and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人 then
        local petIndex = Battle.GetPlayer(battleIndex, math.fmod(i + 5, 10));
        self:logDebug('auto battle', charIndex, petIndex);
        hasAutoBattle = true;
        if Battle.IsWaitingCommand(charIndex) then
          Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_ESCAPE, -1, -1);
        end
        if petIndex >= 0 then
          Battle.ActionSelect(petIndex, CONST.BATTLE_COM.BATTLE_COM_ATTACK, -1, -1);
        else
          Battle.ActionSelect(petIndex, CONST.BATTLE_COM.BATTLE_COM_ESCAPE, -1, -1);
        end
      end
    end
  end
  return hasAutoBattle;
end

--function Module:handleChat(charIndex, msg, color, range, size)
--  if msg == '/battle auto' then
--    charData[charIndex] = true;
--    NLG.SystemMessage(charIndex, '开启自动战斗');
--    return 0;
--  elseif msg == '/battle off' then
--    charData[charIndex] = nil;
--    NLG.SystemMessage(charIndex, '关闭自动战斗');
--    return 0;
--  end
--  return 1
--end

--function Module:cleanUp(charIndex)
--  if charData[charIndex] then
--    charData[charIndex] = nil;
--  end
--  return 0;
--end

--function Module:battleActionEventCallBack(charIndex, battleIndex, com1, com2, com3, actionNum)
--  if charData[charIndex] then
--    local data = { }
--    charData[charIndex] = data;
--    local flag = 'A';
--    data['comA1'] = 0;
--    data['comA2'] = -1;
--    data['comA3'] = -1;
--    data['comB1'] = 0;
--    data['comB2'] = -1;
--    data['comB3'] = -1;
--    if disCacheCom[com1] then
--      charData[charIndex] = true;
--      return
--    end
--    if actionNum == 2 then
--      flag = 'B';
--    end
--    data['com' .. flag .. '1'] = com1;
--    data['com' .. flag .. '2'] = com2;
--    data['com' .. flag .. '3'] = com3;
--  end
--end

function Module:onUnload()
  self:logInfo('unload');
  --self.hook.uninstall();
end

return Module;
