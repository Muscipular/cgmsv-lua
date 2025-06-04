-- Selector
--

local bret = require 'lua.libs.behavior3lua.behavior3.behavior_ret'

---@type BehaviorNodeDefine
local M = {
    name = 'Selector',
    type = 'Composite',
    desc = 'ѡ��ִ��',
    doc = [[
        + һֱ����ִ�У����ӽڵ㷵�سɹ��򷵻سɹ�����ȫ���ڵ㷵��ʧ���򷵻�ʧ��
        + �ӽڵ��ǻ� (OR) �Ĺ�ϵ
    ]],
    run = function(node, env)
        local last_idx, last_ret = node:resume(env)
        if last_idx then
            if last_ret == bret.SUCCESS then
                return last_ret
            elseif last_ret == bret.FAIL then
                last_idx = last_idx + 1
            else
                error(string.format("%s->${%s}#${$d}: unexpected status error",
                    node.tree.name, node.name, node.id))
            end
        else
            last_idx = 1
        end

        for i = last_idx, #node.children do
            local child = node.children[i]
            local r = child:run(env)
            if r == bret.RUNNING then
                return node:yield(env, i)
            end
            if r == bret.SUCCESS then
                return r
            end
        end
        return bret.FAIL
    end
}

return M
