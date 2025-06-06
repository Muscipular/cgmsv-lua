---模块类
---@class BtreeModule: ModuleType
local BtreeModule = ModuleBase:createModule('btree')


--- 加载模块钩子
function BtreeModule:onLoad()
  self:logInfo('load')
  self.npc = self:NPC_createNormal("行为树", 160580, { map = 1000, x = 240, y = 88, direction = 4, mapType = 0 });
  self.LoopEventCallBack = self:regCallback(Func.bind(self.onLoopEvent, self));
  Char.SetLoopEvent(nil, self.LoopEventCallBack, self.npc, 100);
  self:init()
end

---初始化行为树
function BtreeModule:init()
  BT.reInitProcess(function()
    local process = require "lua.Modules.BehaviorTree.process"
    return process
  end)
  local env = {
    owner = self.npc,
    time_count = 0,
    original = { floor = 1000, x = 240, y = 88, map = 0 }
  }
  self.tree = BT.createTree("btree", "btree.json", env)
end

function BtreeModule:onLoopEvent(charIndex)
  self.tree:run()
end

--- 卸载模块钩子
function BtreeModule:onUnload()
  self:logInfo('unload')
end

return BtreeModule;
