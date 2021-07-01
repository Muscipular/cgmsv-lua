--模块名称
local moduleName = 'welcome'
--模块类
local Welcome = ModuleBase:new()
--迁移定义
Welcome.migrations = {
  {
    --版本号
    version = 1,
    --说明名称
    name = 'initial module',
    --迁移具体工作
    value = function()
      print('run migration version: 1');
    end
  }
};


--构造函数
function Welcome:new()
    local o = ModuleBase:new(moduleName);
    setmetatable(o, self)
    self.__index = self
    return o;
end

-- 加载模块钩子
function Welcome:onLoad()
    logInfo(self.name, 'load')
end

-- 卸载模块钩子
function Welcome:onUnload()
    logInfo(self.name, 'unload')
end

return Welcome;
