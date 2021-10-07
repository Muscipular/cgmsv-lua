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
---@field absolutePath boolean

---解决兼容普通lua的问题
local function forSimpleModule()
  local callInCtx;
  local function loadFile(file, cb)
    if file then
      local moduleName;
      for i, v in pairs(Modules) do
        if v.___aPath == file then
          moduleName = i;
        end
      end
      loadModule(moduleName or file, { path = file, simpleModule = true, forceReload = true, absolutePath = true });
    end
    local key = '__callInCtx' .. cb;
    _G[key] = Func.bind(callInCtx, cb);
    return key;
  end
  local simpleModuleCtx = {
    string = {},
    table = {},
    VaildChar = Char.IsValidCharIndex,
    NL = {
      CreateNpc = function(file, cb)
        return NL.CreateNpc(nil, loadFile(file, cb));
      end
    },
    Char = {},
    Battle = {},
  };

  callInCtx = function(name, ...)
    return simpleModuleCtx[name](...)
  end

  for f, n in pairs({ Char = Char, Battle = Battle }) do
    for i, v in pairs(n) do
      if string.sub(i, 1, 3) == 'Set' and string.sub(i, #i - 4) == 'Event' then
        simpleModuleCtx[f][i] = function(file, cb, ...)
          return v(nil, loadFile(file, cb), ...)
        end
      end
    end
  end

  for i, v in pairs(NL) do
    if string.sub(i, 1, 3) == 'Reg' then
      simpleModuleCtx.NL[i] = function(file, cb, ...)
        return v(nil, loadFile(file, cb), ...)
      end
    end
  end

  simpleModuleCtx.string = setmetatable(simpleModuleCtx.string, { __index = string });
  simpleModuleCtx.table = setmetatable(simpleModuleCtx.table, { __index = table });
  simpleModuleCtx.NL = setmetatable(simpleModuleCtx.NL, { __index = NL });
  simpleModuleCtx.Char = setmetatable(simpleModuleCtx.Char, { __index = Char });
  simpleModuleCtx.Battle = setmetatable(simpleModuleCtx.Battle, { __index = Battle });
  print(simpleModuleCtx.NL, simpleModuleCtx.NL.CreateNpc, NL, NL.CreateNpc)
  local Delegate = {}
  for k, _ff in pairs(NL) do
    if string.sub(k, 1, 3) == 'Reg' then
      Delegate['RegDel' .. string.sub(k, 4)] = function(fn)
        if type(fn) == 'string' then
          if simpleModuleCtx['__delegate_tmp_' .. fn] then
            return
          end
          simpleModuleCtx['__delegate_tmp_' .. fn] = function(...)
            if simpleModuleCtx[fn] then
              return simpleModuleCtx[fn](...);
            end
          end
          regGlobalEvent(string.sub(k, 4), simpleModuleCtx['__delegate_tmp_' .. fn], 'Delegate')
        elseif type(fn) == 'function' then
          regGlobalEvent(string.sub(k, 4), fn, 'Delegate');
        end
      end
      Delegate['Reg' .. string.sub(k, 4)] = Delegate['RegDel' .. string.sub(k, 4)];
    end
  end
  simpleModuleCtx.Delegate = Delegate;
  return simpleModuleCtx;
end

local simpleModuleCtx = forSimpleModule();

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
  local ctx = opt.simpleModule and simpleModuleCtx or {}
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
    return loadfile(path, 'bt', setmetatable(ctx, { __index = G }))()
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
  module.___aPath = path;
  module.___ctx = ctx;
  module.___absolutePath = opt.absolutePath;
  module.___isSimpleModule = opt.simpleModule;
  module:load();
  return module;
end

function _G.loadSimpleModule(moduleName)
  _G.loadModule(moduleName, { simpleModule = true, forceReload = true })
end

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

function _G.getModule(moduleName)
  return Modules[moduleName];
end

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
