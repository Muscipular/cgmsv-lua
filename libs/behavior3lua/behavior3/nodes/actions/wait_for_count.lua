-- WaitForCount
--

local bret = require 'lua.libs.behavior3lua.behavior3.behavior_ret'

---@type BehaviorNodeDefine
local M = {
    name = 'WaitForCount',
    type = 'Action',
    desc = '�ȴ��ض�����',
    args = {
        {
            name = 'tick',
            type = 'int',
            desc = 'tick'
        }
    },
    run = function(node, env)
        local args = node.args
        local t = node:resume(env)
        if t then
            t = t - 1
            if t <= 0 then
                print('DONE')
                return bret.SUCCESS
            else
                print('CONTINUE', "node#" .. node.data.id .. "Last tick", t)
                node:yield(env, t)
                return bret.RUNNING
            end
        end
        print('WaitForCount', args.tick)
        return node:yield(env, args.tick)
    end
}

return M
