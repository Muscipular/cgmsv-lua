local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

---@type BehaviorNodeDefine
local M = {
    name = "Random",
    type = "Action",
    desc = "����һ�������",
    input = { "��Сֵ?", "���ֵ?" },
    output = { "�����" },
    args = {
        {
            name = "min",
            type = "float?",
            desc = "��Сֵ"
        },
        {
            name = "max",
            type = "float?",
            desc = "���ֵ"
        },
        {
            name = "floor",
            type = "bool?",
            desc = "�Ƿ�����ȡ��"
        }
    },
    run = function(node, env, min, max)
        min = min or node.args.min
        max = max or node.args.max
        local value = min + math.random() * (max - min)
        if node.args.floor then
            value = math.floor(value)
        end
        return bret.SUCCESS, value
    end
}

return M