local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"
local butil = require "lua.libs.behavior3lua.behavior3.behavior_util"

---@type BehaviorNodeDefine
local M = {
    name = "Let",
    type = "Action",
    desc = "�����µı�����",
    input = { "�Ѵ��ڱ�����?" },
    args = {
        {
            name= "value",
            type= "json?",
            desc= "ֵ(value)",
            oneof= "�Ѵ��ڱ�����",
        }
    },
    output = { "�±�����" },
    doc = [[
        + ��������������������б������¶���һ������
        +  ���`ֵ(value)`Ϊ `null`�����������
    ]],
    run = function(node, env, value)
        local args = node.args
        value = butil.check_oneof(node, 1, value, args.value, butil.NIL)
        return bret.SUCCESS, value
    end
}

return M