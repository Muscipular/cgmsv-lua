-- Random

local bret = require 'lua.libs.behavior3lua.behavior3.behavior_ret'

local M = {
  name = 'Random',
  type = 'Action',
  desc = '返回一个随机数',
  args = {
    {
      name = "min",
      type = "int",
      desc = "最小值"
    },
    {
      name = "max",
      type = "int",
      desc = "最大值"
    }
  },
  output = { "随机数" },
  doc = [[
        + 返回一个随机数
    ]]
}

function M.run(node, env)
  local args = node.args
  local value = math.random(args.min, args.max)
  return bret.SUCCESS,value
end

return M
