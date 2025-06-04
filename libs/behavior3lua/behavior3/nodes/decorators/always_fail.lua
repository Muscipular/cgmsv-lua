-- AlwaysSuccess
--

local bret = require 'lua.libs.behavior3lua.behavior3.behavior_ret'

---@type BehaviorNodeDefine
local M = {
    name = 'AlwaysFail',
    type = 'Decorator',
    desc = 'ʼ�շ���ʧ��',
    doc = [[
        + ֻ����һ���ӽڵ�,�����ִ�е�һ��
        + �����ӽڵ��Ƿ�ɹ�������ʧ��
    ]],
    run = function(node, env, enemy)
        local yeild, last_ret = node:resume(env)
        if yeild then
            if last_ret == bret.RUNNING then
                error(string.format("%s->${%s}#${$d}: unexpected status error",
                    node.tree.name, node.name, node.id))
            end
            return bret.FAIL
        end

        local child = node.children[1]
        if not child then
            return bret.FAIL
        end
        local r = child:run(env)
        if r == bret.RUNNING then
            return node:yield(env)
        end
        return bret.FAIL
    end
}

return M
