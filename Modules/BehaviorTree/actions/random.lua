-- Random

local bret = require 'lua.libs.behavior3lua.behavior3.behavior_ret'

local M = {
  name = 'Random',
  type = 'Action',
  desc = '����һ�������',
  args = {
    {
      name = "min",
      type = "int",
      desc = "��Сֵ"
    },
    {
      name = "max",
      type = "int",
      desc = "���ֵ"
    }
  },
  output = { "�����" },
  doc = [[
        + ����һ�������
    ]]
}

function M.run(node, env)
  local args = node.args
  local value = math.random(args.min, args.max)
  return bret.SUCCESS,value
end

return M
