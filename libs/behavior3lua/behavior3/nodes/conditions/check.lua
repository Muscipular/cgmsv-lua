local bret = require 'lua.libs.behavior3lua.behavior3.behavior_ret'

---@type BehaviorNodeDefine
local M = {
    name = "Check",
    type = "Condition",
    desc = "���True��False",
    args = {
        {
            name = "value",
            type = "code?",
            desc = "ֵ"
        },
    },
    doc = [[
        + ������ֵ��ʽ�ж������سɹ���ʧ��
    ]],
    run = function(node, env)
        return node:get_env_args("value", env) and bret.SUCCESS or bret.FAIL
    end
}

return M
