-- Once
--

local bret = require 'lua.libs.behavior3lua.behavior3.behavior_ret'

local sformat = string.format

---@type BehaviorNodeDefine
local M = {
    name = "Once",
    type = "Decorator",
    desc = "ִֻ��һ��",
    doc = [[
        + ֻ����һ���ӽڵ�,�����ִ�е�һ��
        + ����Ϻ�ýڵ����ӽڵ����ɲ���ִ��
        + �ýڵ�ִ�к���Զ���سɹ�
    ]],
    run = function(node, env)
        local key = sformat("%s#%d_once", node.name, node.id)
        if env:get_var(key) == true then
            return bret.FAIL
        end

        local yeild, last_ret = node:resume(env)
        if yeild then
            if last_ret == bret.RUNNING then
                error(string.format("%s->${%s}#${$d}: unexpected status error",
                    node.tree.name, node.name, node.id))
            end
            env:set_var(key, true)
            return bret.SUCCESS
        end

        local child = node.children[1]
        if not child then
            env:set_var(key, true)
            return bret.SUCCESS
        end

        local r = child:run(env)
        if r == bret.RUNNING then
            return node:yield(env)
        end

        env:set_var(key, true)
        return bret.SUCCESS
    end
}

return M
