local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

---@type BehaviorNodeDefine
local M = {
    name = "IsNull",
    type = "Condition",
    desc = "�жϱ����Ƿ񲻴���",
    input = { "�жϵı���" },
    run = function(node, env, value)
        return value == nil and bret.SUCCESS or bret.FAIL
    end
}
return M