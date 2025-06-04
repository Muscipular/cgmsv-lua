BT = {}
_G.BT = BT

local behavior_tree = require "lua.libs.behavior3lua.behavior3.behavior_tree"
local behavior_node = require "lua.libs.behavior3lua.behavior3.behavior_node"
local sample_process = require "lua.libs.behavior3lua.behavior3.sample_process"

local function loadTree(path)
    local file, err = io.open('lua/Modules/BehaviorTree/trees/' .. path, 'r')
    assert(file, err)
    local str = file:read('*a')
    file:close()
    return JSON.decode(str)
end

---创建行为树
---@param name string 行为树名字
---@param path string 行为树名字
---@param env table 行为树环境变量
---@return table @行为树
function BT.createTree(name, path, env)
    return behavior_tree.new(name, loadTree(path), env)
end

---重置节点列表
---@param func function 重置函数，用于生成新的节点列表
function BT.reInitProcess(func)
  local proc = func(sample_process)
  behavior_node.process(proc)
end
