local Module = ModuleBase:new('autoStack')

function Module:new()
  local o = ModuleBase:new('autoStack');
  setmetatable(o, self)
  self.__index = self
  return o;
end

function Module:onLoad()
  logInfo(self.name, 'load')
end

function Module:onUnload()
  logInfo(self.name, 'unload')
end

return Module;
