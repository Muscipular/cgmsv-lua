---@meta _

---创建行为树
---@param name string 行为树名字
---@param path string 行为树名字
---@param env table 行为树环境变量
---@return table @行为树
function BT.createTree(name, path, env) end

---重置节点列表
---@param func function 重置函数，用于生成新的节点列表
function BT.reInitProcess(func) end
