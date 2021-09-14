local Modules = {};
local _initialed = false

function _G.moduleInitial()
  if _initialed then
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

local simpleModuleCtx = {}

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
  path = 'lua/Modules/' .. path;
  log('ModuleSystem', 'INFO', 'load module ', moduleName, path, forceReload)
  if Modules[moduleName] and not forceReload then
    return Modules[moduleName];
  end
  if Modules[moduleName] then
    Modules[moduleName]:unload();
  end
  Modules[moduleName] = nil;
  local ctx = opt.simpleModule and simpleModuleCtx or {}
  local result, module = pcall(function()
    return loadfile(path, 'bt', setmetatable(ctx, { __index = _G }))()
  end)
  if not result then
    log('ModuleSystem', 'ERROR', 'load module failed.', moduleName, path, forceReload, '\n', module)
    return nil;
  end
  if opt.simpleModule then
    module = ModuleBase:createModule(moduleName, {});
  end
  module = module:new();
  --logInfo('ModuleSystem', 'new object', moduleName, module)
  Modules[moduleName] = module;
  module.___path = oPath;
  module.___ctx = ctx;
  module.___isSimpleModule = opt.simpleModule;
  module:load();
  return module;
end

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
    return loadModule(moduleName, { path = path, forceReload = true, simpleModule = module.___isSimpleModule });
  end
  return nil;
end

function _G.getModule(moduleName)
  return Modules[moduleName];
end
