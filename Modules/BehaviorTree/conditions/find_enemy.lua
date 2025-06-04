-- FindEnemy

local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"
local abs = math.abs
local pow = math.pow

local M = {
  name = "FindEnemy",
  type = "Condition",
  desc = "查找敌人",
  args = {
    {
      name = "distance",
      type = "int",
      desc = "追踪距离"
    }
  },
  output = { "目标" },
  doc = [[
        + 找到返回目标CharIndex
        + 没找到返回失败
    ]]
}

local function ret(r)
  return r and bret.SUCCESS or bret.FAIL
end

function M.run(node, env)
  local owner = env.owner
  local map = Char.GetData(owner, CONST.对象_地图类型)
  local floor = Char.GetData(owner, CONST.对象_地图)
  local x = Char.GetData(owner, CONST.对象_X)
  local y = Char.GetData(owner, CONST.对象_Y)
  -- print("find enemy no player")
  local players = NLG.GetMapPlayer(map, floor)
  if type(players) ~= "table" then
    return bret.FAIL, nil
  end

  table.sort(players, function(a, b)
    dxa = Char.GetData(a, CONST.对象_X) - x
    dya = Char.GetData(a, CONST.对象_Y) - y
    dxb = Char.GetData(b, CONST.对象_X) - x
    dyb = Char.GetData(b, CONST.对象_Y) - y
    return (dxa * dxa + dya * dya) < (dxb * dxb + dyb * dyb)
  end)

  local target = players[1]
  local distance = pow(Char.GetData(target, CONST.对象_X) - x, 2) + pow(Char.GetData(target, CONST.对象_Y) - y, 2)
  print("find enemy distance", distance, pow(node.args.distance, 2))
  return ret(distance < pow(node.args.distance, 2)), target
end

return M
