local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

---@type BehaviorNodeDefine
local M = {
    name = "Now",
    type = "Action",
    desc = "��ȡ��ǰʱ��",
    output = { "��ǰʱ��" },
    run = function(node, env)
        return bret.SUCCESS, env.ctx.time
    end
}

return M
