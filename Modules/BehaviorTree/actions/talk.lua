-- Talk

local bret = require 'lua.libs.behavior3lua.behavior3.behavior_ret'

local M = {
  name = 'Talk',
  type = 'Action',
  desc = '����ϵͳ��Ϣ',
  args = {
    {
      name = 'msg',
      type = 'string',
      desc = '��Ϣ����'
    },
  },
  doc = [[
        + ����ϵͳ��Ϣ
    ]]
}

function M.run(node, env)
  NLG.SystemMessage(-1, node.args.msg)
  return bret.SUCCESS
end

return M
