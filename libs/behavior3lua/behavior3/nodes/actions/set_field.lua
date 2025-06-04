local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"
local butil = require "lua.libs.behavior3lua.behavior3.behavior_util"

---@type BehaviorNodeDefine
return {
    name = "SetField",
    type = "Action",
    children = 0,
    status = {"success", "failure"},
    desc = "���ö����ֶ�ֵ",
    input = {"�������", "�ֶ�(field)?", "ֵ(value)?"},
    args = {
        { name = "field", type = "string?", desc = "�ֶ�(field)", oneof = "�ֶ�(field)" },
        { name = "value", type = "json?", desc = "ֵ(value)", oneof = "ֵ(value)" },
    },
    doc = [[
        + ������������� \`field\` �� \`value\`
        + �������1����Ϊ���󣬷��򷵻� \`failure\`
        + ��� \`field\` ��Ϊ \`string\`, Ҳ���� \`failure\`
        + ��� \`value\` Ϊ \`undefined\` �� \`null\`, ��ɾ�� \`field\` ��ֵ
    ]],

    run = function(node, env, obj, field, value)
        if type(obj) ~= "table" then
            butil.warn(node, "invalid obj")
            return bret.FAIL
        end

        local args = node.args
        field = butil.check_oneof(node, 2, field, args.field)
        value = butil.check_oneof(node, 3, value, args.value, butil.NIL)
        obj[field] = value
        return bret.SUCCESS
    end
}