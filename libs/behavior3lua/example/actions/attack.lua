-- Attack
--

local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"
local M = {
    name = "Attack",
    type = "Action",
    desc = "¹¥»÷",
    input = {"{Ä¿±ê}"},
}

function M.run(node, env, enemy)
    if not enemy then
        return bret.FAIL
    end
    local owner = env.owner

    print "Do Attack"
    enemy.hp = enemy.hp - 100

    env.vars.ATTACKING = true

    return bret.SUCCESS
    -- return bret.ABORT
end

return M