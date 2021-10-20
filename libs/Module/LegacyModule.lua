---@class LegacyModule: ModuleBase
local LegacyModule = ModuleBase:createModule('Legacy');
LegacyModule.sharedContext = {
  string = {},
  table = {},
  VaildChar = Char.IsValidCharIndex,
  NL = {},
  Char = {},
  Battle = {},
  Item = {},
  Pet = {},
  Recipe = {},
  Field = {},
  Data = {},
  NLG = {},
  Protocol = {},
  Obj = {},
  SQL = {},
};
local sharedContext = LegacyModule.sharedContext;

function LegacyModule:loadFile(file, cb, name)
  if not cb then
    self:logError('callback is null', name, file, cb);
    error('callback is null');
  end
  if file then
    local moduleName = findLegacyModuleName(file);
    if not moduleName then
      loadModule(moduleName or file, { path = file, simpleModule = true, forceReload = true, absolutePath = true });
    end
  end
  local key = '__callInCtx' .. cb;
  _G[key] = function(...)
    return self:callInCtx(cb, ...);
  end
  return key;
end

function LegacyModule:callInCtx(name, ...)
  return self.sharedContext[name](...)
end

sharedContext.NL.CreateNpc = function(file, cb)
  return NL.CreateNpc(nil, LegacyModule:loadFile(file, cb, 'NL.CreateNpc'));
end

sharedContext.Protocol.OnRecv = function(file, cb, header)
  return Protocol.OnRecv(nil, LegacyModule:loadFile(file, cb, 'Protocol.OnRecv'), header);
end

for f, n in pairs({ Char = Char, Battle = Battle }) do
  for i, v in pairs(n) do
    if string.sub(i, 1, 3) == 'Set' and string.sub(i, #i - 4) == 'Event' then
      sharedContext[f][i] = function(file, cb, ...)
        return v(nil, LegacyModule:loadFile(file, cb, string.format('%s.%s', f, i)), ...)
      end
    end
  end
end

for i, v in pairs(NL) do
  if string.sub(i, 1, 3) == 'Reg' then
    sharedContext.NL[i] = function(file, cb, ...)
      return v(nil, LegacyModule:loadFile(file, cb, string.format('NL.%s', i)), ...)
    end
  end
end

sharedContext.string = setmetatable(sharedContext.string, { __index = string });
sharedContext.table = setmetatable(sharedContext.table, { __index = table });
sharedContext.NL = setmetatable(sharedContext.NL, { __index = NL });
sharedContext.Char = setmetatable(sharedContext.Char, { __index = Char });
sharedContext.Battle = setmetatable(sharedContext.Battle, { __index = Battle });
sharedContext.Item = setmetatable(sharedContext.Item, { __index = Item });
sharedContext.Pet = setmetatable(sharedContext.Pet, { __index = Pet });
sharedContext.Recipe = setmetatable(sharedContext.Recipe, { __index = Recipe });
sharedContext.Field = setmetatable(sharedContext.Field, { __index = Field });
sharedContext.Data = setmetatable(sharedContext.Data, { __index = Data });
sharedContext.NLG = setmetatable(sharedContext.NLG, { __index = NLG });
sharedContext.Protocol = setmetatable(sharedContext.Protocol, { __index = Protocol });
sharedContext.Obj = setmetatable(sharedContext.Obj, { __index = Obj });
sharedContext.SQL = setmetatable(sharedContext.SQL, { __index = SQL });

setmetatable(sharedContext, { __index = _G })

---@return LegacyModule
function LegacyModule:new(name)
  ---@type LegacyModule
  local o = {};
  setmetatable(o, LegacyModule)
  o.name = LegacyModule.name .. ':' .. name;
  o.rawName = name;
  o.callbacks = {};
  o.lastIx = 0;
  o:createContext();
  return o;
end

function LegacyModule:createDelegate()
  local Delegate = {};
  self.Delegate = Delegate;
  for k, _ff in pairs(NL) do
    if string.sub(k, 1, 3) == 'Reg' then
      local key = string.sub(k, 4);
      Delegate['RegDel' .. key] = function(fn)
        if type(fn) == 'string' then
          if self['_t_' .. key] then
            return
          end
          self['_t_' .. key] = fn;
          self:regCallback(key, function(...)
            return self:callInCtx(fn, ...);
          end)
        elseif type(fn) == 'function' then
          self:regCallback(key, fn);
        end
      end
      Delegate['Reg' .. key] = Delegate['RegDel' .. key];
    end
  end
  return Delegate;
end

function LegacyModule:createContext()
  self.context = {};
  setmetatable(self.context, {
    __index = self.sharedContext,
    __newindex = function(table, key, value)
      if rawget(table, key) then
        rawset(table, key, value)
        return
      end
      self.sharedContext[key] = value;
    end
  })
  self.context.dofile = function(path)
    return loadfile(path, 'bt', self.context)();
  end
  self.context.load = function(path, name, mode, env)
    return load(path, name, mode or 'bt', env or self.context);
  end
  self.context.loadfile = function(path, mode, env)
    return loadfile(path, mode or 'bt', env or self.context);
  end
  self.context.currentModule = self;
  self.context.print = function(msg, ...)
    if msg == nil then
      msg = ''
    end
    self:logInfo(msg, ...)
  end
  self.context.Delegate = self:createDelegate();
end

function LegacyModule:onLoad()
  self:logInfo('onLoad');
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

_G.LegacyModule = LegacyModule; 
