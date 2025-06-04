local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

---@type BehaviorNodeDefine
local M = {
    name = "ForEach",
    type = 'Action',
    desc = "��������",
    input = { "[{����}]" },
    output = { "{����}" },
    doc = [[
        + ֻ����һ���ӽڵ㣬�����ִ�е�һ��
        + ÿ��ִ���ӽڵ�ǰ�����õ�ǰ�������ı���
        + ���ӽڵ㷵��ʧ��ʱ���˳�����������ʧ��״̬
        + ����������سɹ�/��������
    ]],
    run = function(node, env, arr)
        local last_i, resume_ret = node:resume(env)
        if last_i then
            if resume_ret == bret.RUNNING then
                error(string.format("%s->${%s}#${$d}: unexpected status error",
                    node.tree.name, node.name, node.id))
            elseif resume_ret == bret.FAIL then
                return bret.FAIL
            end
            last_i = last_i + 1
        else
            last_i = 1
        end

        for i = last_i, #arr do
            local var = arr[i]
            env:set_var(node.data.output[1], var)
            local r = node.children[1]:run(env)
            if r == bret.RUNNING then
                return node:yield(env, i)
            elseif r == bret.FAIL then
                return bret.FAIL
            end
        end
        return bret.SUCCESS
    end
}


return M
