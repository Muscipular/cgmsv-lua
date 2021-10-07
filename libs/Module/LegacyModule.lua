---@class LegacyModule: ModuleBase
local LegacyModule = ModuleBase:createModule('Legacy');
LegacyModule.sharedContext = {
  string = {},
  table = {},
  VaildChar = Char.IsValidCharIndex,
  NL = {},
  Char = {},
  Battle = {},
};
local simpleModuleCtx = LegacyModule.sharedContext;

function LegacyModule:loadFile(file, cb)
  if file then
    local moduleName = findLegacyModuleName(file);
    loadModule(moduleName or file, { path = file, simpleModule = true, forceReload = true, absolutePath = true });
  end
  local key = '__callInCtx' .. cb;
  _G[key] = function(...)
    self:callInCtx(cb, ...);
  end
  return key;
end

function LegacyModule:callInCtx(name, ...)
  return self.sharedContext[name](...)
end

NL.CreateNpc = function(file, cb)
  return NL.CreateNpc(nil, LegacyModule:loadFile(file, cb));
end

for f, n in pairs({ Char = Char, Battle = Battle }) do
  for i, v in pairs(n) do
    if string.sub(i, 1, 3) == 'Set' and string.sub(i, #i - 4) == 'Event' then
      simpleModuleCtx[f][i] = function(file, cb, ...)
        return v(nil, LegacyModule:loadFile(file, cb), ...)
      end
    end
  end
end

for i, v in pairs(NL) do
  if string.sub(i, 1, 3) == 'Reg' then
    simpleModuleCtx.NL[i] = function(file, cb, ...)
      return v(nil, LegacyModule:loadFile(file, cb), ...)
    end
  end
end

simpleModuleCtx.string = setmetatable(simpleModuleCtx.string, { __index = string });
simpleModuleCtx.table = setmetatable(simpleModuleCtx.table, { __index = table });
simpleModuleCtx.NL = setmetatable(simpleModuleCtx.NL, { __index = NL });
simpleModuleCtx.Char = setmetatable(simpleModuleCtx.Char, { __index = Char });
simpleModuleCtx.Battle = setmetatable(simpleModuleCtx.Battle, { __index = Battle });

function LegacyModule:new(name)
  local o = {};
  setmetatable(o, self)
  o.name = self.name .. ':' .. name;
  o.rawName = name;
  o.callbacks = {};
  o.lastIx = 0;
  return o;
end

function LegacyModule:createDelegate()
  local Delegate = {};
  self.Delegate = Delegate;
  for k, _ff in pairs(NL) do
    if string.sub(k, 1, 3) == 'Reg' then
      Delegate['RegDel' .. string.sub(k, 4)] = function(fn)
        if type(fn) == 'string' then
          self:regCallback(string.sub(k, 4), function(...)
            return self:callInCtx(fn, ...);
          end)
        elseif type(fn) == 'function' then
          self:regCallback(string.sub(k, 4), fn);
        end
      end
      Delegate['Reg' .. string.sub(k, 4)] = Delegate['RegDel' .. string.sub(k, 4)];
    end
  end
  return Delegate;
end

function LegacyModule:createContext()
  self.context = {};
  setmetatable(self.context, {
    __index = self.sharedContext,
    __newindex = function(table, key, value)
      self.sharedContext[key] = value;
    end
  })
  self.context.Delegate = self:createDelegate();
end

function LegacyModule:onLoad()
  self:logInfo('onLoad');
  self:createContext();
  local r, msg = pcall(function()
    loadfile(self.___aPath, 'bt', self.context)();
  end)
  if r == false then
    self:logError('load error', msg);
  end
end

function LegacyModule:onUnload()
  self:logInfo('onUnload');
end
