local Welcome = ModuleBase:new('welcome')

function Welcome:new()
    local o = ModuleBase:new('welcome');
    setmetatable(o, self)
    self.__index = self
    return o;
end

function Welcome:onLoad()
    logInfo(self.name, 'load')
end

function Welcome:onUnload()
    logInfo(self.name, 'unload')
end

return Welcome;
