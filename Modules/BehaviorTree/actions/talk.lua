-- Talk

local bret = require 'lua.libs.behavior3lua.behavior3.behavior_ret'

local M = {
  name = 'Talk',
  type = 'Action',
  desc = '发送系统信息',
  args = {
    {
      name = 'msg',
      type = 'string',
      desc = '信息内容'
    },
  },
  doc = [[
        + 发送系统信息
    ]]
}

function M.run(node, env)
  NLG.SystemMessage(-1, node.args.msg)
  return bret.SUCCESS
end

return M
