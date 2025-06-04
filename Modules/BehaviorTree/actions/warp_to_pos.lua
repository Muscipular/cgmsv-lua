-- WarpToPos

local bret = require 'lua.libs.behavior3lua.behavior3.behavior_ret'

local M = {
  name = 'WarpToPos',
  type = 'Action',
  desc = '���͵�����',
  args = {
    {
      name = 'map',
      type = 'int',
      desc = '��ͼ����'
    },
    {
      name = 'floor',
      type = 'int',
      desc = '��ͼ'
    },
    {
      name = 'x',
      type = 'int',
      desc = 'x����'
    },
    {
      name = 'y',
      type = 'int',
      desc = 'y����'
    },
  },
  doc = [[
        + ���ﴫ�͵�ָ��λ��
    ]]
}

function M.run(node, env)
  local args = node.args
  local owner = env.owner
  Char.SetData(owner, CONST.����_��ͼ����, args.map)
  Char.SetData(owner, CONST.����_��ͼ, args.floor)
  Char.SetData(owner, CONST.����_X, args.x)
  Char.SetData(owner, CONST.����_Y, args.y)
  NLG.UpChar(owner)
  return bret.SUCCESS
end

return M
