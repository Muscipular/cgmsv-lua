--[[
    override get descriptor(): NodeDef {
        return {
            name: "Concat",
            type: "Action",
            status: ["success", "failure"],
            desc: "����������ϲ�Ϊһ�����飬������������",
            input: ["����1", "����2"],
            output: ["������"],
            doc: `
                + ������벻�����飬�򷵻�\`ʧ��\`
            `,
        };
    }
]]

local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"

---@type BehaviorNodeDefine
local M = {
    name = "Concat",
    type = "Action",
    desc = "����������ϲ�Ϊһ�����飬������������",
    input = { "����1", "����2" },
    output = { "������" },
    run = function(node, env, arr1, arr2)
        if not arr1 or not arr2 then
            return bret.FAIL
        end
        local arr = {}
        for _, v in ipairs(arr1) do
            arr[#arr+1] = v
        end
        for _, v in ipairs(arr2) do
            arr[#arr+1] = v
        end
        return bret.SUCCESS, arr
    end
}

return M