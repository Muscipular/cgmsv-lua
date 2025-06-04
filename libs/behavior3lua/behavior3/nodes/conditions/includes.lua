local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

---@type BehaviorNodeDefine
local M = {
    name = "Includes",
    type = "Condition",
    desc = "�ж�Ԫ���Ƿ���������",
    input = { "����", "Ԫ��" },
    doc = [[
        + �������Ԫ�ز��Ϸ������ء�ʧ�ܡ�
        + ֻ���������Ԫ��ʱ���ء��ɹ��������򷵻ء�ʧ�ܡ�
    ]],
    run = function(node, env, arr, obj)
        if not arr or #arr == 0 then
            return bret.FAIL
        end
        for _, v in ipairs(arr) do
            if v == obj then
                return bret.SUCCESS
            end
        end
        return bret.FAIL
    end,
}

return M