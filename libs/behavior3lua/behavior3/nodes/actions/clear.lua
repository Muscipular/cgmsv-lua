local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

---@type BehaviorNodeDefine
local M = {
    name = "Clear",
    type = "Action",
    desc = "�������",
    output = { "����ı�����" },
    run = function(node, env)
        return bret.SUCCESS, nil
    end
}

return M
