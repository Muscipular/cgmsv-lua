-- FindEnemy

local bret = require "lua.libs.behavior3lua.behavior3.behavior_ret"
local abs = math.abs
local pow = math.pow

local M = {
  name = "FindEnemy",
  type = "Condition",
  desc = "���ҵ���",
  args = {
    {
      name = "distance",
      type = "int",
      desc = "׷�پ���"
    }
  },
  output = { "Ŀ��" },
  doc = [[
        + �ҵ�����Ŀ��CharIndex
        + û�ҵ�����ʧ��
    ]]
}

local function ret(r)
  return r and bret.SUCCESS or bret.FAIL
end

function M.run(node, env)
  local owner = env.owner
  local map = Char.GetData(owner, CONST.����_��ͼ����)
  local floor = Char.GetData(owner, CONST.����_��ͼ)
  local x = Char.GetData(owner, CONST.����_X)
  local y = Char.GetData(owner, CONST.����_Y)
  -- print("find enemy no player")
  local players = NLG.GetMapPlayer(map, floor)
  if type(players) ~= "table" then
    return bret.FAIL, nil
  end

  table.sort(players, function(a, b)
    dxa = Char.GetData(a, CONST.����_X) - x
    dya = Char.GetData(a, CONST.����_Y) - y
    dxb = Char.GetData(b, CONST.����_X) - x
    dyb = Char.GetData(b, CONST.����_Y) - y
    return (dxa * dxa + dya * dya) < (dxb * dxb + dyb * dyb)
  end)

  local target = players[1]
  local distance = pow(Char.GetData(target, CONST.����_X) - x, 2) + pow(Char.GetData(target, CONST.����_Y) - y, 2)
  print("find enemy distance", distance, pow(node.args.distance, 2))
  return ret(distance < pow(node.args.distance, 2)), target
end

return M
