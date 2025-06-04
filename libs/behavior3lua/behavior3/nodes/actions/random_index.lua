local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

---@type BehaviorNodeDefine
local M = {
    name = "RandomIndex",
    type = "Action",
    desc = "����������������һ��",
    input = { "����" },
    output = { "���Ŀ��" },
    doc = [[
        + �Ϸ�Ԫ�ز����� nil
        + �����������У������������һ��
        + ����������Ϊ��ʱ������û�кϷ�Ԫ�أ����ء�ʧ�ܡ�
    ]],
    run = function(node, env, arr)
        if not arr or #arr == 0 then
            return bret.FAIL
        end
        local idx = math.random(1, #arr)
        return bret.SUCCESS, arr[idx]
    end
}

return M