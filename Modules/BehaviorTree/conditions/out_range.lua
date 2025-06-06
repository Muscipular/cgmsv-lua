-- OutRange

local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"
local abs = math.abs
local pow = math.pow

local M = {
  name = "OutRange",
  type = "Condition",
  desc = "超过移动范围",
  args = {
    {
      name = "x",
      type = "int",
      desc = "x半径"
    },
    {
      name = "y",
      type = "int",
      desc = "y半径"
    },
  },
  doc = [[
        + 超过移动范围返回SUCCESS
        + 在移动范围内返回FAIL
    ]]
}

function M.run(node, env)
  local owner = env.owner
  local original = env.original
  local args = node.args
  local x = Char.GetData(owner, CONST.对象_X)
  local y = Char.GetData(owner, CONST.对象_Y)

  if x < (original.x - args.x) or x > (original.x + args.x) or y < (original.y - args.y) or y > (original.y + args.y) then
    return bret.SUCCESS
  end

  return bret.FAIL
end

return M
