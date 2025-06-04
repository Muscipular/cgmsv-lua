-- Cmp

local bret = require 'lua.libs.behavior3lua.behavior3.behavior_ret'

local function ret(r)
    return r and bret.SUCCESS or bret.FAIL
end

---@type BehaviorNodeDefine
local M = {
    name = 'Cmp',
    type = 'Condition',
    desc = '�Ƚ�ֵ��С',
    args = {
        { name = 'value', type = 'code?', desc = 'ֵ' },
        { name = 'gt', type = 'int?', desc = '>' },
        { name = 'ge', type = 'int?', desc = '>=' },
        { name = 'eq', type = 'int?', desc = '==' },
        { name = 'le', type = 'int?', desc = '<=' },
        { name = 'lt', type = 'int?', desc = '<' }
    },
    input = { 'ֵ(int)' },
    doc = [[
        + ��ֵΪ�գ�����ʧ��
        + ���������Ϳ��ܻᱨ��
    ]],
    run = function(node, env, value)
        value = value or node:get_env_args("value", env)
        assert(type(value) == 'number')
        local args = node.args
        if args.gt then
            return ret(value > args.gt)
        elseif args.ge then
            return ret(value >= args.ge)
        elseif args.eq then
            return ret(value == args.eq)
        elseif args.lt then
            return ret(value < args.lt)
        elseif args.le then
            return ret(value <= args.le)
        else
            error('args error')
        end
    end
}

return M
