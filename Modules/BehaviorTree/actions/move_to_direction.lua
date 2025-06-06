-- MoveToDirection

local bret = require 'lua.libs.behavior3lua.behavior3.behavior_ret'

local M = {
  name = 'MoveToDirection',
  type = 'Action',
  desc = '向指定方向移动一格',
  input = { "direction" },
  doc = [[
        + 向指定方向移动一格
    ]]
}

function M.run(node, env, direction)
  local owner = env.owner
  NLG.WalkMove(owner, direction)
  return bret.SUCCESS
end

return M
