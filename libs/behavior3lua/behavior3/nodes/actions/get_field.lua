local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"
local butil = require "lua.libs.behavior3lua.behavior3.behavior_util"

---@type BehaviorNodeDefine
return {
    name = "GetField",
    type = "Action",
    children = 0,
    status = {"success", "failure"},
    desc = "��ȡ������ֶ�ֵ",
    args = {
        {
            name = "field",
            type = "string?",
            desc = "�ֶ�(field)",
            oneof = "�ֶ�(field)",
        },
    },
    input = {"����", "�ֶ�(field)?"},
    output = {"�ֶ�ֵ(value)"},
    doc = [[
        + �Ϸ�Ԫ�ز����� \`undefined\` �� \`null\`
        + ֻ�л�ȡ���Ϸ�Ԫ��ʱ��Ż᷵�� \`success\`�����򷵻� \`failure\`
    ]],

    run = function(node, env, obj, field)
        if type(obj) ~= "table" then
            butil.warn(node, "invalid obj")
            return bret.FAIL
        end
        local args = node.args
        local key = butil.check_oneof(node, 2, field, args.field)
        local value = obj[key]
        if value == nil then
            return bret.FAIL
        end
        return bret.SUCCESS, value
    end
}