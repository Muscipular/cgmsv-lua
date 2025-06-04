-- Idle
--

local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

local M = {
    name = "Idle",
    type = "Action",
    desc = "´ý»ú",
}

function M.run(node, env)
    print "Do Idle"
    return bret.SUCCESS
end

return M