local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

---@type BehaviorNodeDefine
local M = {
    name = "IsNull",
    type = "Condition",
    desc = "判断变量是否不存在",
    input = { "判断的变量" },
    run = function(node, env, value)
        return value == nil and bret.SUCCESS or bret.FAIL
    end
}
return M