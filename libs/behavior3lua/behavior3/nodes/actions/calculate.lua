local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

---@type BehaviorNodeDefine
local M = {
    name = "Calculate",
    type = "Action",
    desc = "���㹫ʽ",
    args = {
        {
            name = "value",
            type = "code?",
            desc = "��ʽ"
        },
    },
    doc = [[
        + ������ֵ��ʽ����
    ]],
    run = function(node, env)
        local value = node:get_env_args("value", env)
        return bret.SUCCESS, value
    end,
}

return M