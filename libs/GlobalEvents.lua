local chained = {
  TalkEvent = function(list, ...)
    local res = 1;
    for i, v in pairs(list) do
      res = v(...)
      if res ~= 1 then
        return res;
      end
    end
    return res
  end,
  BattleDamageEvent = function(list, CharIndex, DefCharIndex, OriDamage, Damage, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg)
    local dmg = Damage;
    for i, v in pairs(list) do
      dmg = v(CharIndex, DefCharIndex, OriDamage, dmg, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg)
      if type(dmg) ~= 'number' or dmg <= 0 then
        dmg = 1
      end
    end
    return dmg
  end
}

local function makeEventHandle(name)
  local list = {}
  local fn = function(list, ...)
    local res;
    for i, v in pairs(list) do
      res = v(...)
    end
    --logDebug('ModuleSystem', 'callback', name, res, ...)
    return res
  end
  return Func.bind(chained[name] or fn, list), list
end

local eventCallbacks = {}
local ix = 0;
function _G.regGlobalEvent(eventName, fn, moduleName, extraSign)
  extraSign = extraSign or ''
  logInfo('ModuleSystem', 'regGlobalEvent', eventName, moduleName, ix + 1, eventCallbacks[eventName .. extraSign])
  if eventCallbacks[eventName .. extraSign] == nil then
    --logInfo('ModuleSystem', 'Reg2' .. eventName, NL['Reg' .. eventName])
    local fn1, list = makeEventHandle(eventName);
    eventCallbacks[eventName .. extraSign] = list;
    _G[(eventName .. extraSign)] = fn1;
    if NL['Reg' .. eventName] then
      logInfo('ModuleSystem', 'NL.Reg' .. eventName, extraSign)
      if extraSign == '' then
        NL['Reg' .. eventName](nil, eventName .. extraSign);
      else
        NL['Reg' .. eventName](nil, eventName .. extraSign, extraSign);
      end
    end
  end
  ix = ix + 1;
  eventCallbacks[eventName .. extraSign][ix] = function(...)
    --logDebug('ModuleSystem', 'callback', eventName .. extraSign, fn, ...)
    local success, result = pcall(fn, ...)
    if not success then
      log(moduleName, 'ERROR', eventName .. extraSign .. ' event callback error: ', result)
      return nil;
    end
    --logDebug('ModuleSystem', 'callback', eventName .. extraSign, fn, result, ...)
    return result;
  end
  return ix;
end

function _G.removeGlobalEvent(eventName, fnIndex, moduleName, extraSign)
  extraSign = extraSign or ''
  log('ModuleSystem', 'INFO', 'removeGlobalEvent', eventName .. extraSign, moduleName, fnIndex)
  if not eventCallbacks[eventName .. extraSign] then
    return true;
  end
  eventCallbacks[eventName .. extraSign][fnIndex] = nil
  if table.isEmpty(eventCallbacks[eventName .. extraSign]) then
    if not NL['Reg' .. eventName] then
      eventCallbacks[eventName .. extraSign] = nil;
      _G[eventName .. extraSign] = nil;
    end
  end
  return true;
end
