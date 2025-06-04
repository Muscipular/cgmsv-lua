local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

---@type BehaviorNodeDefine
local M = {
    name = "Index",
    type = "Action",
    children = 0,
    desc = "�������������",
    args = {
        {
            name = "index",
            type = "string",
            desc = "����",
        }
    },
    input = { "����", "����?" },
    output = { "Ԫ��" },
    doc = [[
        + �Ϸ�Ԫ�ز����� undefined �� null
        + ֻ���������кϷ�Ԫ��ʱ��Ż᷵�ء��ɹ��������򷵻ء�ʧ�ܡ�
    ]],
    run = function(node, env, arr, key)
        if not arr then
            return bret.FAIL
        end
        if not key then
            key = tonumber(node.args.index)
        end
        if type(key) ~= "number" then
            print(string.format("%s: index type error", node.info))
            return bret.FAIL
        end

        local value = arr[key + 1]
        if value == nil then
            return bret.FAIL
        end
        return bret.SUCCESS, value
    end,
}

return M