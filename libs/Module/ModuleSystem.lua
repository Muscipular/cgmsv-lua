local Modules = {};
local _initialed = false

function _G.moduleInitial()
  regGlobalEvent("ShutdownEvent", OrderedCallback(function()
    for i, v in pairs(Modules) do
      pcall(function () v:unload() end);
    end
  end, -9999999999), 'System');
  if _initialed or _HookFunc == false then
    return
  end
  _initialed = true;
  local sql = [[
create table if not exists lua_migration
(
    id     int          not null,
    module varchar(100) not null,
    name   varchar(255) not null,
    constraint lua_migration_pk
        primary key (module, id)
);
]]
  logInfo('ModuleSystem', 'initial:', SQL.querySQL(sql));
end

---@class loadModuleOpt
---@field path string 路径默认moduleName.lua
---@field forceReload boolean 强制重新加载
---@field simpleModule boolean 是否兼容老的luaModule
---@field absolutePath boolean
local function loadModuleFile(path, moduleName, forceReload)
  local ctx = {}
  local rG = {
    print = function(msg, ...)
      if msg == nil then
        msg = ''
      end
      logInfo(moduleName, msg, ...)
    end,
  };
  local G = setmetatable(rG, { __index = _G })
  local result, module = pcall(function()
    local fn, m = loadfile(path, 'bt', setmetatable(ctx, { __index = G }))
    if m then
      error(m)
    end
    return fn()
  end)
  if not result then
    logError('ModuleSystem', 'load module failed.', 'name=', moduleName, 'path=', path, 'forceReload=', forceReload, '\n', module)
    return nil;
  end
  module = module:new();
  return module, ctx;
end

---@param opt loadModuleOpt
---@param moduleName string
function _G.loadModule(moduleName, opt)
  local path, forceReload
  if not opt then
    opt = {}
  end
  path = opt.path;
  forceReload = opt.forceReload;
  if not path then
    path = moduleName .. '.lua'
  end
  local oPath = path;
  if not opt.absolutePath then
    if opt.simpleModule then
      path = 'lua/Module/' .. path;
    else
      path = 'lua/Modules/' .. path;
    end
  end
  log('ModuleSystem', 'INFO', 'load module ', moduleName, path, forceReload)
  if Modules[moduleName] and not forceReload then
    return Modules[moduleName];
  end
  if Modules[moduleName] then
    Modules[moduleName]:unload();
  end
  Modules[moduleName] = nil;
  local ctx, module;
  if opt.simpleModule then
    module = LegacyModule:new(moduleName);
    ctx = module.context;
  else
    module, ctx = loadModuleFile(path, moduleName, forceReload);
  end
  if not module then
    return nil;
  end
  --logInfo('ModuleSystem', 'new object', moduleName, module)
  Modules[moduleName] = module;
  module.___path = oPath;
  ---@diagnostic disable-next-line: invisible
  module.___aPath = path;
  module.___ctx = ctx;
  module.___absolutePath = opt.absolutePath;
  module.___isSimpleModule = opt.simpleModule;
  local r1, e1 = pcall(module.load, module);
  if e1 then
    logError(moduleName, "load module error: " .. e1);
  end
  return module;
end

---加载普通Module
function _G.loadSimpleModule(moduleName)
  _G.loadModule(moduleName, { simpleModule = true, forceReload = true })
end

---加载普通Module
_G.useModule = loadSimpleModule;

function _G.unloadModule(moduleName)
  if Modules[moduleName] then
    Modules[moduleName]:unload();
    Modules[moduleName] = nil;
  end
end

function _G.reloadModule(moduleName)
  logInfo('ModuleSystem', moduleName, Modules[moduleName])
  local module = Modules[moduleName];
  if module then
    module:unload();
    local path = module.___path;
    return loadModule(moduleName, { path = path, forceReload = true, simpleModule = module.___isSimpleModule, absolutePath = module.___absolutePath });
  end
  return nil;
end

---@return ModuleBase|any
function _G.getModule(moduleName)
  return Modules[moduleName];
end

---@return string|nil
function _G.findLegacyModuleName(path)
  if path then
    local moduleName;
    for i, v in pairs(Modules) do
      if v.___isSimpleModule and
        (
          v.___aPath == path
            or string.sub(v.name, string.len(LegacyModule.name) + 2) == path
        ) then
        moduleName = i;
      end
    end
    return moduleName;
  end
  return nil;
end 
