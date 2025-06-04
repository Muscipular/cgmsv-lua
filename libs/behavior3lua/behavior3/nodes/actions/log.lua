-- Log
--

local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

---@type BehaviorNodeDefine
local M = {
    name = "Log",
    type = "Action",
    desc = "��ӡ��־",
    args = {
        {
            name = "message",
            type = "string",
            desc = "��־"
        }
    },
    run = function(node, env)
        print(node.args.message)
        return bret.SUCCESS
    end
}



return M
