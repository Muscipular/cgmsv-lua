local Module = ModuleBase:createModule('autoStack')

function Module:onLoad()
  self:logInfo('load')
end

function Module:onUnload()
  self:logInfo('unload')
end

return Module;
