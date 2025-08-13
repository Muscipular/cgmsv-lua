local chained = {
  TalkEvent = function(list, ...)
    local res = 1;
    --print('TalkEventChain', ...)
    for i, v in ipairs(list) do
      res = v(...)
      if res == nil then
        res = 1;
      end
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
  BattleDamageEvent = function(list, CharIndex, DefCharIndex, OriDamage, Damage, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg, ExFlag)
    local dmg = Damage;
    for i, v in ipairs(list) do
      dmg = v(CharIndex, DefCharIndex, OriDamage, dmg, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg, ExFlag)
      if type(dmg) ~= 'number' or dmg <= 0 then
        if Flg == CONST.DamageFlags.Miss or Flg == CONST.DamageFlags.Dodge or Damage == 0 then
          dmg = 0
        else
          dmg = 1
        end
      end
    end
    return dmg
  end,
  ItemExpansionEvent = function(list, itemIndex, type, msg, charIndex, slot)
    for i, v in ipairs(list) do
      local m = v(itemIndex, type, msg, charIndex, slot);
      if m == nil then
        m = msg;
      end
      msg = m;
    end
    return msg;
  end,
  BattleSurpriseEvent = function(list, battleIndex, result)
    for i, v in ipairs(list) do
      local m = v(battleIndex, result);
      if type(m) == 'number' then
        result = m;
      end
    end
    return result;
  end,
  DamageCalculateEvent = function(list, CharIndex, DefCharIndex, OriDamage, Damage, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg, ExFlag)
    for i, v in ipairs(list) do
      local m = v(CharIndex, DefCharIndex, OriDamage, Damage, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg, ExFlag);
      if type(m) == 'number' then
        m = math.floor(m);
        if m <= 0 then
          if Flg == CONST.DamageFlags.Miss or Flg == CONST.DamageFlags.Dodge or Damage == 0 then
            m = 0
          else
            m = 1
          end
        end
        Damage = m;
      end
    end
    --if math.type and math.type(Damage) == 'float' then
    --  Damage = math.tointeger(Damage)
    --end
    --print('dmg', OriDamage, Damage);
    return Damage;
  end,
  BattleHealCalculateEvent = function(list, CharIndex, DefCharIndex, OriDamage, Damage, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg, ExFlag)
    for i, v in ipairs(list) do
      local m = v(CharIndex, DefCharIndex, OriDamage, Damage, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg, ExFlag);
      if type(m) == 'number' then
        m = math.floor(m);
        if m <= 0 then
          m = 0;
        end
        Damage = m;
      end
    end
    --if math.type and math.type(Damage) == 'float' then
    --  Damage = math.tointeger(Damage)
    --end
    return Damage;
  end,
  BattleInjuryEvent = function(list, charIndex, battleIndex, oVal, val)
    for i, v in ipairs(list) do
      local m = v(charIndex, battleIndex, oVal, val);
      if type(m) == 'number' then
        m = math.floor(m);
        if m <= 0 then
          return m;
        end
        val = m;
      end
    end
    return val;
  end,
  TechOptionEvent = function(list, charIndex, option, techID, val)
    for i, v in ipairs(list) do
      local m = v(charIndex, option, techID, val);
      if type(m) == 'number' then
        val = m;
      end
    end
    return val;
  end,
  BattleSummonEnemyEvent = function(list, battleIndex, charIndex, enemyId)
    local ret = nil;
    for i, v in ipairs(list) do
      local m = v(battleIndex, charIndex, enemyId);
      if type(m) == 'table' then
        ret = m;
      end
    end
    return ret;
  end,
  BattleNextEnemyEvent = function(list, battleIndex, flg)
    local ret = nil;
    for i, v in ipairs(list) do
      local m = v(battleIndex, flg);
      if type(m) == 'table' then
        ret = m;
      end
    end
    return ret;
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

for i, v in ipairs({
  'LoginGateEvent', 'LogoutEvent', 'LoginEvent',
}) do
  chained[v] = function(list, ...)
    for i, v in ipairs(list) do
      v(...);
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

for i, v in ipairs({ 'GetExpEvent', }) do
  chained[v] = function(list, CharIndex, Exp)
    local res = Exp;
    for _, fn in ipairs(list) do
      res = fn(CharIndex, Exp);
      if res == nil then
        res = Exp;
      end
      Exp = res;
    end
    return res
  end
end

for i, v in ipairs({ 'ProductSkillExpEvent', 'BattleSkillExpEvent', }) do
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
  --list.map = {};
  return function(...)
    --print('makeEventHandle', name, ...);
    local ok, ret = pcall(chained[name] or defaultChain, list, ...);
    if ok then
      return ret;
    end
    logError('GlobalEvent', 'invoke ' .. name .. ' callback error.', ret);
    error(ret)
  end, list
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
      logDebug('GlobalEvent', 'NL.Reg' .. eventName, extraSign)
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

---@return OrderedCallback|function
---@param fn function
---@param order number Խ��Խ����ִ��
function _G.OrderedCallback(fn, order)
  if type(fn) == 'table' and fn.type == 'OrderedCallback' then
    return fn;
  end
  local n = { fn = fn, order = order, type = 'OrderedCallback' }
  return setmetatable(n, { __call = function(self, ...)
    return fn(...);
  end })
end

--- ע��ȫ���¼�
---@param eventName string
---@param fn function|OrderedCallback
---@param moduleName string
---@param extraSign string|nil
---@return number ȫ��ע��Index
function _G.regGlobalEvent(eventName, fn, moduleName, extraSign)
  extraSign = extraSign or ''
  logDebug('GlobalEvent', 'regGlobalEvent', eventName, moduleName, ix + 1)
  local callbacks, name, fn1 = takeCallbacks(eventName, extraSign, true)
  --logInfo('GlobalEvent', 'callbacks', #callbacks)
  ix = ix + 1;
  local order = 0;
  if type(fn) == 'table' and fn.type == 'OrderedCallback' then
    order = fn.order;
  end
  local fx = OrderedCallback(function(...)
    --logDebug('ModuleSystem', 'callback', eventName .. extraSign, fn, order, ...)
    local success, result = pcall(fn, ...)
    if not success then
      logError(moduleName, name .. ' event callback error: ', result)
      return nil;
    end
    --logDebug('ModuleSystem', 'callback', eventName .. extraSign, fn, result, ...)
    return result;
  end, order);
  callbacks[#callbacks + 1] = fx;
  table.sort(callbacks, function(a, b)
    return a.order > b.order;
  end)
  fx.index = ix;
  --callbacks.map[ix] = table.indexOf(callbacks, fx);
  --logInfo('GlobalEvent', 'mapIndex', ix, callbacks.map[ix], fx);
  return ix;
end

--- �Ƴ�ȫ���¼�
---@param eventName string
---@param fnIndex number ȫ��ע��Index
---@param moduleName string
---@param extraSign string|nil
function _G.removeGlobalEvent(eventName, fnIndex, moduleName, extraSign)
  extraSign = extraSign or ''
  logDebug('GlobalEvent', 'removeGlobalEvent', eventName .. extraSign, moduleName, fnIndex)
  local callbacks, name, fn1 = takeCallbacks(eventName, extraSign)
  if not callbacks then
    return true;
  end
  --logInfo('GlobalEvent', 'callbacks', #callbacks, callbacks.map[fnIndex])
  --logInfo('GlobalEvent', 'fnIndex', fnIndex, eventCallbacks[eventName .. extraSign][fnIndex])
  local ix = table.findIndex(callbacks, function(e, i, list)
    return e.index == fnIndex
  end)
  table.remove(callbacks, ix);
  if #callbacks == 0 then
    if not NL['Reg' .. eventName] then
      eventCallbacks[name] = nil;
      _G[name] = nil;
    end
  end
  return true;
end
