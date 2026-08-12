---@type {[string]:ModuleBase|unknown}
local Modules = {};

local NpcManager = {
  moduleNpcs = {},
  globalNpcs = {}
};

_G.NpcManager = NpcManager;

function NpcManager.trackNpc(npcIndex)
  if not npcIndex or npcIndex < 0 then return end
  local curMod = _G.currentExecutingModule;
  if curMod then
    local modName = type(curMod) == 'table' and curMod.name or tostring(curMod);
    if not NpcManager.moduleNpcs[modName] then
      NpcManager.moduleNpcs[modName] = {};
    end
    NpcManager.moduleNpcs[modName][npcIndex] = true;
    if type(curMod) == 'table' then
      curMod.npcList = curMod.npcList or {};
      table.insert(curMod.npcList, npcIndex);
    end
    logInfo('NpcManager', '自动托管 NPC:', npcIndex, '-> 归属模块:', modName);
  else
    NpcManager.globalNpcs[npcIndex] = true;
    logInfo('NpcManager', '自动托管全局 NPC:', npcIndex);
  end
end

function NpcManager.untrackNpc(npcIndex)
  if not npcIndex then return end
  for modName, npcs in pairs(NpcManager.moduleNpcs) do
    npcs[npcIndex] = nil;
  end
  NpcManager.globalNpcs[npcIndex] = nil;
end

function NpcManager.unloadModuleNpcs(modName)
  local npcs = NpcManager.moduleNpcs[modName];
  if npcs then
    for npcIndex, _ in pairs(npcs) do
      pcall(function() NL.DelNpc(npcIndex) end);
      logInfo('NpcManager', '自动回收模块 NPC:', npcIndex, '模块:', modName);
    end
    NpcManager.moduleNpcs[modName] = nil;
  end
end

-- Hook 底层 NL 创建/删除 NPC 接口，实现全自动拦截托管
if _G.NL then
  local raw_CreateNpc = NL.CreateNpc;
  local raw_CreateArgNpc = NL.CreateArgNpc;
  local raw_DelNpc = NL.DelNpc;

  if raw_CreateNpc and not NL.___isHooked then
    NL.CreateNpc = function(...)
      local npc = raw_CreateNpc(...);
      if npc and npc >= 0 then
        NpcManager.trackNpc(npc);
      end
      return npc;
    end

    NL.CreateArgNpc = function(...)
      local npc = raw_CreateArgNpc(...);
      if npc and npc >= 0 then
        NpcManager.trackNpc(npc);
      end
      return npc;
    end

    NL.DelNpc = function(npcIndex, ...)
      NpcManager.untrackNpc(npcIndex);
      return raw_DelNpc(npcIndex, ...);
    end

    NL.___isHooked = true;
  end
end

local _initialed = false

regGlobalEvent("ShutDownEvent", OrderedCallback(function()
  for i, v in pairs(Modules) do
    pcall(function () v:unload() end);
  end
  logInfo("System", "Unload all module done.");
end, -9999999999), 'System');

function _G.moduleInitial()
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
  local prevCtx = _G.currentExecutingModule;
  _G.currentExecutingModule = module;
  local r1, e1 = pcall(module.load, module);
  _G.currentExecutingModule = prevCtx;
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

local ModuleProxies = {};

local function createModuleProxy(moduleName)
  local proxy = {};
  setmetatable(proxy, {
    __index = function(t, k)
      local m = Modules[moduleName];
      if not m then
        return nil;
      end
      local val = m[k];
      if type(val) == "function" then
        return function(self, ...)
          if self == t then
            return val(m, ...);
          else
            return val(self, ...);
          end
        end;
      end
      return val;
    end,
    __newindex = function(t, k, v)
      local m = Modules[moduleName];
      if m then
        m[k] = v;
      end
    end,
    __tostring = function(t)
      local m = Modules[moduleName];
      return tostring(m or ("Proxy(" .. tostring(moduleName) .. ")"));
    end
  });
  return proxy;
end

---就地热替换模块函数逻辑 (无宿主生命周期销毁与重新注册副作用)
---@param moduleName string
---@return ModuleBase|any
function _G.hotswapModule(moduleName)
  local oldModule = Modules[moduleName];
  if not oldModule then
    logWarn('ModuleSystem', 'hotswapModule: 模块未加载，回退到 loadModule:', moduleName);
    return loadModule(moduleName, { forceReload = true });
  end

  local aPath = oldModule.___aPath;
  local isSimple = oldModule.___isSimpleModule;

  if isSimple then
    return reloadModule(moduleName);
  end

  logInfo('ModuleSystem', 'hotswap module:', moduleName, aPath);
  local newModule, newCtx = loadModuleFile(aPath, moduleName, true);
  if not newModule then
    logError('ModuleSystem', 'hotswapModule 加载失败:', moduleName);
    return nil;
  end

  -- 就地更新属性与函数句柄
  for k, v in pairs(newModule) do
    if type(v) == 'function' or (k ~= 'callbacks' and k ~= 'npcList' and k ~= '___ctx') then
      rawset(oldModule, k, v);
    end
  end

  local mt = getmetatable(newModule);
  if mt then
    local oldMt = getmetatable(oldModule);
    if oldMt then
      for k, v in pairs(mt) do
        if k ~= '__index' then
          rawset(oldMt, k, v);
        end
      end
    end
  end

  oldModule.___ctx = newCtx;
  logInfo('ModuleSystem', 'hotswapModule 成功:', moduleName);
  return oldModule;
end

function _G.reloadModule(moduleName)
  logInfo('ModuleSystem', moduleName, Modules[moduleName]);
  local module = Modules[moduleName];
  if module then
    module:unload();
    local path = module.___path;
    return loadModule(moduleName, { path = path, forceReload = true, simpleModule = module.___isSimpleModule, absolutePath = module.___absolutePath });
  end
  return nil;
end

---获取模块 (返回动态代理对象，保持实时热更新能力)
---@param moduleName string
---@param raw boolean|nil 是否返回原始模块对象
---@return ModuleBase|any
function _G.getModule(moduleName, raw)
  if not moduleName then return nil; end
  if raw then
    return Modules[moduleName];
  end
  if not ModuleProxies[moduleName] then
    ModuleProxies[moduleName] = createModuleProxy(moduleName);
  end
  return ModuleProxies[moduleName];
end

---获取原始模块对象 (非 Proxy)
function _G.getRawModule(moduleName)
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
