-- OutRange

local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"
local abs = math.abs
local pow = math.pow

local M = {
  name = "OutRange",
  type = "Condition",
  desc = "�����ƶ���Χ",
  args = {
    {
      name = "x",
      type = "int",
      desc = "x�뾶"
    },
    {
      name = "y",
      type = "int",
      desc = "y�뾶"
    },
  },
  doc = [[
        + �����ƶ���Χ����SUCCESS
        + ���ƶ���Χ�ڷ���FAIL
    ]]
}

function M.run(node, env)
  local owner = env.owner
  local original = env.original
  local args = node.args
  local x = Char.GetData(owner, CONST.����_X)
  local y = Char.GetData(owner, CONST.����_Y)

  if x < (original.x - args.x) or x > (original.x + args.x) or y < (original.y - args.y) or y > (original.y + args.y) then
    return bret.SUCCESS
  end

  return bret.FAIL
end

return M
