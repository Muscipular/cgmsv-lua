-- WaitCount

local bret = require 'lua.libs.behavior3lua.behavior3.behavior_ret'

local M = {
  name = 'WaitCount',
  type = 'Action',
  desc = '�ȴ�����',
  args = {
    {
      name = 'count',
      type = 'int',
      desc = '����'
    },
  },
  doc = [[
        + �ȴ�count��
    ]]
}

function M.run(node, env)
  env.time_count = env.time_count + 1
  if env.time_count >= node.args.count then
    -- print("wait count done")
    env.time_count = 0
    return bret.SUCCESS
  end
  return bret.RUNNING
end

return M
