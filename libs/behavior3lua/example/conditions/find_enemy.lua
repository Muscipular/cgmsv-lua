-- FindEnemy

local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

local M = {
    name = "FindEnemy",
    type = "Condition",
    desc = "���ҵ���",
    args = {
        {
            name = 'x',
            type = 'int?',
            desc = 'x'
        },
        {
            name = 'y',
            type = 'int?',
            desc = 'y'
        },
        {
            name = 'w',
            type = 'int?',
            desc = '��'
        },
        {
            name = 'h',
            type = 'int?',
            desc = '��'
        },
        {
            name = 'count',
            type = 'string?',
            desc = '��������'
        },
    },
    output = {"Ŀ�굥λ"},
    doc = [[
        + û�ҵ�����ʧ��
    ]]
}

local function ret(r)
    return r and bret.SUCCESS or bret.FAIL
end

function M.run(node, env)
    local args = node.args
    local x, y = env.owner.x, env.owner.y
    local w, h = args.w, args.h
    local list = env.ctx:find(function(t)
        if t == env.owner then
            return false
        end
        local tx, ty = t.x, t.y
        return math.abs(x - tx) <= w and math.abs(y - ty) <= h
    end, args.count)

    local enemy = list[1]
    return ret(enemy), enemy
end

return M