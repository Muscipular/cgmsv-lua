local Modules = {};

local function init()
  local sql = [[create table if not exists lua_migration
(
    id     int          not null,
    module varchar(100) not null,
    name   varchar(255) not null,
    constraint lua_migration_pk
        primary key (module, id)
);
']]
  querySQL(sql);
end

---@param forceReload boolean
---@param moduleName string
---@param path string
function loadModule(moduleName, path, forceReload)
  local oPath = path;
  path = 'lua/Modules/' .. path;
  log('ModuleSystem', 'INFO', 'load module ', moduleName, path, forceReload)
  if Modules[moduleName] and not forceReload then
    return Modules[moduleName];
  end
  if Modules[moduleName] then
    Modules[moduleName]:unload();
  end
  Modules[moduleName] = nil;
  local result, module = pcall(function()
    return loadfile(path, 'bt', setmetatable({}, { __index = _G }))()
  end)
  if not result then
    log('ModuleSystem', 'ERROR', 'load module failed.', moduleName, path, forceReload, '\n', module)
    return nil;
  end
  module = module:new();
  --logInfo('ModuleSystem', 'new object', moduleName, module)
  Modules[moduleName] = module;
  module.___path = oPath;
  module:load();
  return module;
end

function unloadModule(moduleName)
  if Modules[moduleName] then
    Modules[moduleName]:unload();
    Modules[moduleName] = nil;
  end
end

function reloadModule(moduleName)
  for i, v in pairs(Modules) do
    print(i, v);
  end
  logInfo('ModuleSystem', moduleName, Modules[moduleName])
  local module = Modules[moduleName];
  if module then
    module:unload();
    local path = module.___path;
    return loadModule(moduleName, path, true);
  end
  return nil;
end

function getModule(moduleName)
  return Modules[moduleName];
end

local function makeEventHandle()
  local list = {}
  local fn = function(...)
    --logDebug('ModuleSystem', 'callback', ...)
    local res;
    for i, v in pairs(list) do
      res = v(...)
    end
    return res
  end
  return fn, list
end
local eventCallbacks = {}
local ix = 0;
function regGlobalEvent(eventName, fn, moduleName, extraSign)
  extraSign = extraSign or ''
  logInfo('ModuleSystem', 'regGlobalEvent', eventName, moduleName, ix + 1, eventCallbacks[eventName .. extraSign])
  if eventCallbacks[eventName .. extraSign] == nil then
    --logInfo('ModuleSystem', 'Reg2' .. eventName, NL['Reg' .. eventName])
    local fn1, list = makeEventHandle()
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
    return result;
  end
  return ix;
end
function unRegGlobalEvent(eventName, fnIndex, moduleName, extraSign)
  extraSign = extraSign or ''
  log('ModuleSystem', 'INFO', 'unRegGlobalEvent', eventName .. extraSign, moduleName, fnIndex)
  if not eventCallbacks[eventName .. extraSign] then
    return true;
  end
  eventCallbacks[eventName .. extraSign][fnIndex] = nil
  if isEmpty(eventCallbacks[eventName .. extraSign]) then
    if not NL['Reg' .. eventName] then
      eventCallbacks[eventName .. extraSign] = nil;
      _G[eventName .. extraSign] = nil;
    end
  end
  return true;
end

local ModuleBase = { name = '', callbacks = {}, lastIx = 0, migrations = nil };

_G["ModuleBase"] = ModuleBase;

function ModuleBase:new(name)
  local o = {};
  setmetatable(o, self)
  self.__index = self
  o.name = name;
  o.callbacks = {};
  o.lastIx = 0;
  return o;
end

function ModuleBase:createModule(name)
  local SubModule = ModuleBase:new(name)
  function SubModule:new()
    local o = ModuleBase:new(name);
    setmetatable(o, self)
    self.__index = self;
    return o;
  end

  return SubModule;
end

---@param eventNameOrCallbackKeyOrFn string|nil|function
---@param fn function|nil
function ModuleBase:regCallback(eventNameOrCallbackKeyOrFn, fn)
  self.lastIx = self.lastIx + 1;
  if type(eventNameOrCallbackKeyOrFn) == 'function' then
    fn = eventNameOrCallbackKeyOrFn;
    eventNameOrCallbackKeyOrFn = '_' .. self.name .. '_cb_' .. self.lastIx;
  end
  local fnIndex = regGlobalEvent(eventNameOrCallbackKeyOrFn, fn, self.name);
  logInfo(self.name, 'regCallback', eventNameOrCallbackKeyOrFn, self.lastIx, fnIndex, fn);
  self.callbacks[self.lastIx] = { key = eventNameOrCallbackKeyOrFn, fnIndex = fnIndex, fn = fn };
  return eventNameOrCallbackKeyOrFn, self.lastIx, fnIndex;
end

---@param eventNameOrCallbackKey string
---@param fnOrFnIndex function|number
function ModuleBase:unRegCallback(eventNameOrCallbackKey, fnOrFnIndex)
  local cbIndex = fnOrFnIndex;
  if type(fnOrFnIndex) == 'function' then
    cbIndex = findIndex(self.callbacks, function(e)
      return fnOrFnIndex == e.fn
    end)
  end
  local fnCb = self.callbacks[cbIndex];
  if not fnCb then
    logWarn(self.name, 'cannot find callback of ' .. eventNameOrCallbackKey, fnOrFnIndex)
    return
  end
  logInfo(self.name, 'unRegGlobalEvent', fnCb.key, fnCb.fnIndex, fnCb.fn);
  unRegGlobalEvent(fnCb.key, fnCb.fnIndex, self.name);
  self.callbacks[cbIndex] = nil;
end

function ModuleBase:onUnload()

end

function ModuleBase:unload()
  self:onUnload()
  for i, fnCb in pairs(self.callbacks) do
    unRegGlobalEvent(fnCb.key, fnCb.fnIndex, self.name);
  end
  self.callbacks = {};
end

function ModuleBase:migrate()
  if self.migrations then
    local ret = querySQL('select ifnull(max(id), 0) version from lua_migration where module = \'' .. self.name .. '\';');
    local version = tonumber(ret[1][1]);
    table.sort(self.migrations, function(a, b)
      return a.version - b.version
    end)
    for i, migration in ipairs(self.migrations) do
      if migration.version > version then
        self:logInfo('run migration: ' .. migration.version)
        version = migration.version;
        if type(migration.value) == 'function' then
          migration.value();
        elseif type(migration.value) == 'string' then
          querySQL(migration.value);
        end
        querySQL('insert into lua_migration (id, name, module) values (' .. migration.version .. ', \'' .. migration.name .. '\', \'' .. self.name .. '\');')
      end
    end
  end
end

function ModuleBase:log(level, msg, ...)
  log(self.name, level, msg, ...)
end

function ModuleBase:logInfo(msg, ...)
  logInfo(self.name, msg, ...)
end

function ModuleBase:logDebug(msg, ...)
  logDebug(self.name, msg, ...)
end

function ModuleBase:logWarn(msg, ...)
  logWarn(self.name, msg, ...)
end

function ModuleBase:logError(msg, ...)
  logError(self.name, msg, ...)
end

function ModuleBase:load()
  self:migrate();
  self:onLoad()
end

function ModuleBase:onLoad()

end

init();
