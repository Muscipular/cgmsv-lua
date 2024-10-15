---模块类
---@class Welcome: ModuleType
local Welcome = ModuleBase:createModule('welcome')
---迁移定义
Welcome:addMigration(1, 'initial module', function()
  print('run migration version: 1');
end);

--- 加载模块钩子
function Welcome:onLoad()
  self:logInfo('load')
end

--- 卸载模块钩子
function Welcome:onUnload()
  self:logInfo('unload')
end

return Welcome;
