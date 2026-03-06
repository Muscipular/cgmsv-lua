local function makeBroadcastChain(returnValue)
  return function(list, ...)
    for _, fn in ipairs(list) do
      fn(...);
    end
    return returnValue;
  end
end

local function makeStopOnNegativeChain(blockedResult)
  return function(list, ...)
    for _, fn in ipairs(list) do
      local res = tonumber(fn(...)) or 0;
      if res < 0 then
        return blockedResult or res;
      end
    end
    return 0;
  end
end

-- carryIndex 表示链式值位于回调参数中的位置，从 1 开始计数
-- 例如 makeReduceValueChain(4, ...) 表示将上一轮回调处理后的值写回第 4 个参数
local function makeReduceValueChain(carryIndex, shouldAccept, normalize)
  return function(list, ...)
    local args = { ... };
    for _, fn in ipairs(list) do
      local res = fn(unpack(args));
      if shouldAccept(res, args[carryIndex], args) then
        if normalize then
          res = normalize(res, args[carryIndex], args);
        end
        args[carryIndex] = res;
      end
    end
    return args[carryIndex];
  end
end
local function acceptAnyNonNil(res)
  return res ~= nil;
end

local function acceptNumber(res)
  return type(res) == 'number';
end

local function acceptTable(res)
  return type(res) == 'table';
end

-- 事件参数: BattleDamageEvent(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, exFlag)
-- 链式参数位置: args[4] 对应 damage，args[13] 对应 flg
local function normalizeBattleDamage(dmg, _, args)
  dmg = math.floor(dmg);
  if dmg <= 0 then
    local flg = args[13];
    local damage = args[4];
    if flg == CONST.DamageFlags.Miss or flg == CONST.DamageFlags.Dodge or damage == 0 then
      return 0;
    end
    return 1;
  end
  return dmg;
end

-- 事件参数: BattleHealCalculateEvent(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, exFlag)
-- 链式参数位置: damage 归一化为向下取整，最小为 0
local function normalizeBattleHeal(dmg)
  dmg = math.floor(dmg);
  if dmg <= 0 then
    return 0;
  end
  return dmg;
end

-- 事件参数: BattleInjuryEvent(charIndex, battleIndex, oVal, val)
-- 链式参数位置: val 归一化为向下取整
local function normalizeBattleInjury(val)
  return math.floor(val);
end
local chained = {
  -- 事件参数: TalkEvent(talker, meindex, color, msg, area)
  -- 链式规则: 任一回调返回值不为 1 时立即返回该值，否则返回 1
  TalkEvent = function(list, ...)
    local res = 1;
    for _, fn in ipairs(list) do
      res = fn(...);
      if res == nil then
        res = 1;
      end
      if res ~= 1 then
        return res;
      end
    end
    return res;
  end,

  -- 事件参数: BeforeBattleTurnEvent(battleIndex)
  -- 链式规则: 任一回调返回 true 时结果为 true
  BeforeBattleTurnEvent = function(list, ...)
    local res = false;
    for _, fn in ipairs(list) do
      res = fn(...) or res;
    end
    return res;
  end,

  -- 事件参数: ProtocolOnRecv(fd, head, data)
  -- 链式规则: 返回值小于 0 时拦截，其他返回值继续执行
  ProtocolOnRecv = makeStopOnNegativeChain(),

  -- 事件参数: BattleDamageEvent(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, exFlag)
  -- 链式参数位置: 4，对应参数 damage
  BattleDamageEvent = makeReduceValueChain(4, acceptNumber, normalizeBattleDamage),

  -- 事件参数: ItemExpansionEvent(itemIndex, type, msg, charIndex, slot)
  -- 链式参数位置: 3，对应参数 msg
  ItemExpansionEvent = makeReduceValueChain(3, acceptAnyNonNil),

  -- 事件参数: BattleSurpriseEvent(battleIndex, result)
  -- 链式参数位置: 2，对应参数 result
  BattleSurpriseEvent = makeReduceValueChain(2, acceptNumber),

  -- 事件参数: DamageCalculateEvent(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, exFlag)
  -- 链式参数位置: 4，对应参数 damage
  DamageCalculateEvent = makeReduceValueChain(4, acceptNumber, normalizeBattleDamage),

  -- 事件参数: BattleHealCalculateEvent(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, exFlag)
  -- 链式参数位置: 4，对应参数 damage
  BattleHealCalculateEvent = makeReduceValueChain(4, acceptNumber, normalizeBattleHeal),

  -- 事件参数: BattleInjuryEvent(charIndex, battleIndex, oVal, val)
  -- 链式参数位置: 4，对应参数 val
  BattleInjuryEvent = function(list, charIndex, battleIndex, oVal, val)
    for _, fn in ipairs(list) do
      local res = fn(charIndex, battleIndex, oVal, val);
      if acceptNumber(res) then
        val = normalizeBattleInjury(res);
        if val <= 0 then
          return val;
        end
      end
    end
    return val;
  end,

  -- 事件参数: TechOptionEvent(charIndex, option, techID, val)
  -- 链式参数位置: 4，对应参数 val
  TechOptionEvent = makeReduceValueChain(4, acceptNumber),

  -- 事件参数: BattleSummonEnemyEvent(battleIndex, charIndex, enemyId, ret)
  -- 链式参数位置: 4，对应参数 ret
  BattleSummonEnemyEvent = makeReduceValueChain(4, acceptTable),

  -- 事件参数: BattleNextEnemyEvent(battleIndex, flg, ret)
  -- 链式参数位置: 3，对应参数 ret
  BattleNextEnemyEvent = makeReduceValueChain(3, acceptTable),

  -- 事件参数: Init(fnList, ...)
  -- 链式规则: 按顺序执行所有回调，返回最后一个回调的返回值
  Init = function(fnList, ...)
    fnList = table.copy(fnList)
    local res;
    for i, v in ipairs(fnList) do
      res = v(...)
    end
    return res
  end,
}
-- 事件参数: ItemPickUpEvent(charIndex, itemIndex)
-- 链式规则: 返回值小于 0 时拦截，其他返回值继续执行
chained.ItemPickUpEvent = makeStopOnNegativeChain(-1);

-- 事件参数: ItemDropEvent(charIndex, itemIndex)
-- 链式规则: 返回值小于 0 时拦截，其他返回值继续执行
chained.ItemDropEvent = makeStopOnNegativeChain(-1);

-- 事件参数: ItemAttachEvent(charIndex, fromItemIndex)
-- 链式规则: 返回值小于 0 时拦截，其他返回值继续执行
chained.ItemAttachEvent = makeStopOnNegativeChain(-1);

-- 事件参数: ItemUseEvent(charIndex, targetCharIndex, itemSlot)
-- 链式规则: 返回值小于 0 时拦截，其他返回值继续执行
chained.ItemUseEvent = makeStopOnNegativeChain(-1);

-- 事件参数: PreItemDropEvent(charIndex, itemIndex)
-- 链式规则: 返回值小于 0 时拦截，其他返回值继续执行
chained.PreItemDropEvent = makeStopOnNegativeChain(-1);

-- 事件参数: PreItemPickUpEvent(charIndex, itemIndex)
-- 链式规则: 返回值小于 0 时拦截，其他返回值继续执行
chained.PreItemPickUpEvent = makeStopOnNegativeChain(-1);

-- 事件参数: LoginGateEvent(charIndex)
-- 链式规则: 广播执行，不消费返回值
chained.LoginGateEvent = makeBroadcastChain(0);

-- 事件参数: LogoutEvent(charIndex)
-- 链式规则: 广播执行，不消费返回值
chained.LogoutEvent = makeBroadcastChain(0);

-- 事件参数: LoginEvent(charIndex)
-- 链式规则: 广播执行，不消费返回值
chained.LoginEvent = makeBroadcastChain(0);

-- 事件参数: ItemOverLapEvent(charIndex, fromItemIndex, targetItemIndex, num)
-- 链式规则: 任一回调返回非 0 时立即返回 1，否则返回 0
chained.ItemOverLapEvent = function(list, ...)
  for _, fn in ipairs(list) do
    local res = tonumber(fn(...)) or 0;
    if res ~= 0 then
      return 1;
    end
  end
  return 0;
end

-- 事件参数: PartyEvent(charIndex, targetCharIndex, type)
-- 链式规则: 任一回调返回 0 时立即返回 0，否则返回 1
chained.PartyEvent = function(list, ...)
  for _, fn in ipairs(list) do
    local res = tonumberEx(fn(...)) or 0;
    if res == 0 then
      return 0;
    end
  end
  return 1;
end

-- 事件参数: GetExpEvent(charIndex, exp)
-- 链式参数位置: 2，对应参数 exp
chained.GetExpEvent = makeReduceValueChain(2, acceptAnyNonNil);

-- 事件参数: ProductSkillExpEvent(charIndex, skillID, exp)
-- 链式参数位置: 3，对应参数 exp
chained.ProductSkillExpEvent = makeReduceValueChain(3, acceptAnyNonNil);

-- 事件参数: BattleSkillExpEvent(charIndex, skillID, exp)
-- 链式参数位置: 3，对应参数 exp
chained.BattleSkillExpEvent = makeReduceValueChain(3, acceptAnyNonNil);

-- 事件参数: BattleSealRateEvent(battleIndex, charIndex, enemyIndex, rate)
-- 链式参数位置: 4，对应参数 rate
chained.BattleSealRateEvent = makeReduceValueChain(4, acceptNumber);

-- 事件参数: CalcCriticalRateEvent(aIndex, fIndex, rate)
-- 链式参数位置: 3，对应参数 rate
chained.CalcCriticalRateEvent = makeReduceValueChain(3, acceptNumber);

-- 事件参数: BattleDodgeRateEvent(battleIndex, aIndex, fIndex, rate)
-- 链式参数位置: 4，对应参数 rate
chained.BattleDodgeRateEvent = makeReduceValueChain(4, acceptNumber);

-- 事件参数: BattleCounterRateEvent(battleIndex, aIndex, fIndex, rate)
-- 链式参数位置: 4，对应参数 rate
chained.BattleCounterRateEvent = makeReduceValueChain(4, acceptNumber);

-- 事件参数: BattleMagicDamageRateEvent(battleIndex, aIndex, fIndex, rate)
-- 链式参数位置: 4，对应参数 rate
chained.BattleMagicDamageRateEvent = makeReduceValueChain(4, acceptNumber);

-- 事件参数: BattleMagicRssRateEvent(battleIndex, aIndex, fIndex, rate)
-- 链式参数位置: 4，对应参数 rate
chained.BattleMagicRssRateEvent = makeReduceValueChain(4, acceptNumber);

-- 事件参数: ItemBoxEncountRateEvent(charaIndex, mapId, floor, X, Y, itemIndex, rate, boxType)
-- 链式参数位置: 7，对应参数 rate
chained.ItemBoxEncountRateEvent = makeReduceValueChain(7, acceptNumber);

-- 事件参数: BattleGetProfitEvent(battleIndex, side, pos, charaIndex, type, reward)
-- 链式参数位置: 6，对应参数 reward
chained.BattleGetProfitEvent = makeReduceValueChain(6, acceptNumber);

-- 事件参数: BattleCalcDexEvent(battleIndex, charaIndex, action, flg, dex)
-- 链式参数位置: 5，对应参数 dex
chained.BattleCalcDexEvent = makeReduceValueChain(5, acceptNumber);

-- 事件参数: StealItemEmitRateEvent(battleIndex, enemyIndex, charaIndex, itemId, rate)
-- 链式参数位置: 5，对应参数 rate
chained.StealItemEmitRateEvent = makeReduceValueChain(5, acceptNumber);

-- 事件参数: ItemDropRateEvent(battleIndex, enemyIndex, charaIndex, itemId, rate)
-- 链式参数位置: 5，对应参数 rate
chained.ItemDropRateEvent = makeReduceValueChain(5, acceptNumber);

-- 事件参数: BattlePetLeaveCheckEvent(battleIndex, charIndex, type, com1, com2, com3)
-- 链式参数位置: 3，对应参数 type
chained.BattlePetLeaveCheckEvent = makeReduceValueChain(3, acceptNumber);

-- 事件参数: BattleStatusResistanceEvent(battleIndex, aCharIndex, dCharIndex, type, rate)
-- 链式参数位置: 5，对应参数 rate
chained.BattleStatusResistanceEvent = makeReduceValueChain(5, acceptNumber);

-- 事件参数: ItemConsumeEvent(charIndex, itemIndex, slot, amount)
-- 链式参数位置: 4，对应参数 amount
chained.ItemConsumeEvent = makeReduceValueChain(4, acceptNumber);

-- 事件参数: ItemDurabilityChangedEvent(itemIndex, oldDurability, newDurability, value, mode)
-- 链式参数位置: 5，对应参数 mode
chained.ItemDurabilityChangedEvent = makeReduceValueChain(5, acceptNumber);

-- 事件参数: BattleActionTargetEvent(charIndex, battleIndex, com1, com2, com3, targetList)
-- 链式参数位置: 6，对应参数 targetList
chained.BattleActionTargetEvent = makeReduceValueChain(6, acceptTable);

-- 事件参数: BattleSkillCheckEvent(charIndex, battleIndex, arrayOfSkillEnable)
-- 链式参数位置: 3，对应参数 arrayOfSkillEnable
chained.BattleSkillCheckEvent = makeReduceValueChain(3, acceptTable);

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
---@param order number 越大越优先执行
function _G.OrderedCallback(fn, order)
  if type(fn) == 'table' and fn.type == 'OrderedCallback' then
    return fn;
  end
  local n = { fn = fn, order = order, type = 'OrderedCallback' }
  return setmetatable(n, { __call = function(self, ...)
    return fn(...);
  end })
end

--- 注册全局事件
---@param eventName string
---@param fn function|OrderedCallback
---@param moduleName string
---@param extraSign string|nil
---@return number 全局注册Index
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

--- 移除全局事件
---@param eventName string
---@param fnIndex number 全局注册Index
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