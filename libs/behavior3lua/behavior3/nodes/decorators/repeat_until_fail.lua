local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

---@type BehaviorNodeDefine
local M = {
    name = "RepeatUntilFailure",
    type = "Decorator",
    desc = "һֱ����ֱ���ӽڵ㷵��ʧ��",
    input = { "���ѭ������?" },
    args = {
        {
            name = "maxLoop",
            type = "int?",
            desc = "���ѭ������"
        }
    },
    doc = [[
        + ֻ����һ���ӽڵ㣬�����ִ�е�һ��
        + ֻ�е��ӽڵ㷵��ʧ��ʱ���ŷ��سɹ��������������������״̬
        + ����趨�˳��Դ���������ָ�������򷵻�ʧ��
    ]],
    run = function(node, env, max_loop)
        max_loop = max_loop or node.args.maxLoop or math.maxinteger

        local count, resume_ret = node:resume(env)
        if count then
            if resume_ret == bret.FAIL then
                return bret.SUCCESS
            elseif count >= max_loop then
                return bret.FAIL
            else
                count = count + 1
            end
        else
            count = 1
        end

        local r = node.children[1]:run(env)
        if r == bret.FAIL then
            return bret.SUCCESS
        else
            return node:yield(env, count)
        end
    end
}

return M
