local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

---@type BehaviorNodeDefine
local M = {
    name = "Repeat",
    type = 'Action',
    desc = "ѭ��ִ��",
    doc = [[
        + ֻ����һ���ӽڵ㣬�����ִ�е�һ��
        + ���ӽڵ㷵�ء�ʧ�ܡ�ʱ���˳����������ء�ʧ�ܡ�״̬
        + ����������سɹ�/��������
    ]],
    args = {
        {
            name = "count",
            type = "int?",
            desc = "����"
        },
    },
    input = { "����(int)?" },
    run = function(node, env, count)
        count = count or node.args.count
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

        for i = last_i, count do
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
