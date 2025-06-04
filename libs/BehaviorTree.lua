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

---������Ϊ��
---@param name string ��Ϊ������
---@param path string ��Ϊ������
---@param env table ��Ϊ����������
---@return table @��Ϊ��
function BT.createTree(name, path, env)
    return behavior_tree.new(name, loadTree(path), env)
end

---���ýڵ��б�
---@param func function ���ú��������������µĽڵ��б�
function BT.reInitProcess(func)
  local proc = func(sample_process)
  behavior_node.process(proc)
end
