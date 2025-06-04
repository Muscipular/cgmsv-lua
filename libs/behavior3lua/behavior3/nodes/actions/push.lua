local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

---@type BehaviorNodeDefine
local M = {
    name = "Push",
    type = "Action",
    desc = "�����������Ԫ��",
    input = { "����", "Ԫ��" },
    doc = [[
        + ������ġ����顱������������ʱ���ء�ʧ�ܡ�
        + ���෵�ء��ɹ�����
    ]],
    run = function(node, env, arr, value)
        if not arr then
            return bret.FAIL
        end
        arr[#arr+1] = value
        return bret.SUCCESS
    end
}

return M