local chained = {
  TalkEvent = function(list, ...)
    local res = 1;
    for i, v in ipairs(list) do
      res = v(...)
      if res ~= 1 then
        return res;
      end
    end
    return res
  end,
  BeforeBattleTurnEvent = function(list, ...)
    local res = false;
    for i, v in ipairs(list) do
      res = v(...) or res;
    end
    return res
  end,
  ProtocolOnRecv = function(list, ...)
    local res = 0;
    for i, v in ipairs(list) do
      res = v(...) or res;
      if res < 0 then
        return res;
      end
    end
    return res
  end,
  BattleDamageEvent = function(list, CharIndex, DefCharIndex, OriDamage, Damage, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg)
    local dmg = Damage;
    for i, v in ipairs(list) do
      dmg = v(CharIndex, DefCharIndex, OriDamage, dmg, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg)
      if type(dmg) ~= 'number' or dmg <= 0 then
        dmg = 1
      end
    end
    return dmg
  end,
  ItemExpansionEvent = function(list, itemIndex, type, msg)
    for i, v in ipairs(list) do
      local m = v(itemIndex, type, msg);
      if m == nil then
        m = msg;
      end
      msg = m;
    end
    return msg;
  end,
  Init = function(fnList, ...)
    fnList = table.copy(fnList)
    local res;
    for i, v in ipairs(fnList) do
      res = v(...)
    end
    return res
  end,
}

for i, v in ipairs({
  'ItemPickUpEvent', 'ItemDropEvent', 'ItemAttachEvent', 'ItemUseEvent',
}) do
  chained[v] = function(list, ...)
    for _i, fn in ipairs(list) do
      local res = tonumber(fn(...)) or 0;
      if res < 0 then
        return -1;
      end
    end
    return 0
  end
end

for i, v in ipairs({ 'ItemOverLapEvent', }) do
  chained[v] = function(list, ...)
    for _i, fn in ipairs(list) do
      local res = tonumber(fn(...)) or 0;
      if res ~= 0 then
        return 1;
      end
    end
    return 0
  end
end

for i, v in ipairs({ 'PartyEvent', }) do
  chained[v] = function(list, ...)
    for _i, fn in ipairs(list) do
      local res = tonumberEx(fn(...)) or 0;
      if res == 0 then
        return 0;
      end
    end
    return 1
  end
end

for i, v in ipairs({ 'GetExpEvent', 'ProductSkillExpEvent', 'BattleSkillExpEvent', }) do
  chained[v] = function(list, CharIndex, SkillID, Exp)
    local res = Exp;
    for _, fn in ipairs(list) do
      res = fn(CharIndex, SkillID, Exp);
      if res == nil then
        res = Exp;
      end
      Exp = res;
    end
    return res
  end
end

local defaultChain = function(fnList, ...)
  local res;
  for i, v in ipairs(fnList) do
    res = v(...)
  end
  return res
end

local function makeEventHandle(name)
  local list = {}
  list.map = {};
  return Func.bind(chained[name] or defaultChain, list), list
end

local eventCallbacks = {}
local ix = 0;

local function takeCallbacks(eventName, extraSign, shouldInit)
  local name = eventName .. extraSign
  if eventCallbacks[name] then
    return eventCallbacks[name], name, _G[name]
  end
  if shouldInit then
    local fn1, list = makeEventHandle(eventName);
    _G[name] = fn1;
    eventCallbacks[name] = list;
    if NL['Reg' .. eventName] then
      logInfo('GlobalEvent', 'NL.Reg' .. eventName, extraSign)
      if extraSign == '' then
        NL['Reg' .. eventName](nil, name);
      else
        NL['Reg' .. eventName](nil, name, extraSign);
      end
    elseif eventName == 'ProtocolOnRecv' then
      Protocol.OnRecv(nil, name, extraSign);
    end
    return list, name, fn1;
  end
  return nil;
end

--- 注册全局事件
---@param eventName string
---@param fn function
---@param moduleName string
---@param extraSign string|nil
---@return number 全局注册Index
function _G.regGlobalEvent(eventName, fn, moduleName, extraSign)
  extraSign = extraSign or ''
  logInfo('GlobalEvent', 'regGlobalEvent', eventName, moduleName, ix + 1, eventCallbacks[eventName .. extraSign])
  local callbacks, name, fn1 = takeCallbacks(eventName, extraSign, true)
  ix = ix + 1;
  callbacks.map[ix] = #callbacks + 1;
  callbacks[#callbacks + 1] = function(...)
    --logDebug('ModuleSystem', 'callback', eventName .. extraSign, fn, ...)
    local success, result = pcall(fn, ...)
    if not success then
      logError(moduleName, name .. ' event callback error: ', result)
      return nil;
    end
    --logDebug('ModuleSystem', 'callback', eventName .. extraSign, fn, result, ...)
    return result;
  end
  return ix;
end

--- 移除全局事件
---@param eventName string
---@param fnIndex number 全局注册Index
---@param moduleName string
---@param extraSign string|nil
function _G.removeGlobalEvent(eventName, fnIndex, moduleName, extraSign)
  extraSign = extraSign or ''
  logInfo('GlobalEvent', 'removeGlobalEvent', eventName .. extraSign, moduleName, fnIndex)
  local callbacks, name, fn1 = takeCallbacks(eventName, extraSign)
  --logInfo('GlobalEvent', 'callbacks', eventCallbacks[eventName .. extraSign])
  if not callbacks then
    return true;
  end
  --logInfo('GlobalEvent', 'fnIndex', fnIndex, eventCallbacks[eventName .. extraSign][fnIndex])
  if callbacks.map[fnIndex] ~= nil then
    table.remove(callbacks, callbacks.map[fnIndex]);
    callbacks.map[fnIndex] = nil;
  end
  if #callbacks == 0 then
    if not NL['Reg' .. eventName] then
      eventCallbacks[name] = nil;
      _G[name] = nil;
    end
  end
  return true;
end
