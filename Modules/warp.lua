---@class Warp:ModuleType
local Warp = ModuleBase:createModule('warp')

--坐标可以在下面自行添加
local warpPoints = {
  { "圣拉鲁卡村", 0, 100, 134, 218 },
  { "伊尔村", 0, 100, 681, 343 },
  { "亚留特村", 0, 100, 587, 51 },
  { "维诺亚村", 0, 100, 330, 480 },
  { "奇利村", 0, 300, 273, 294 },
  { "加纳村", 0, 300, 702, 147 },
  { "杰诺瓦镇", 0, 400, 217, 455 },
  { "蒂娜村", 0, 400, 570, 274 },
  { "阿巴尼斯村", 0, 400, 248, 247 },
  { "阿凯鲁法村", 0, 33200, 99, 165 },
  { "坎那贝拉村", 0, 33500, 17, 76 },
  { "哥拉尔镇", 0, 43100, 120, 107 },
  { "鲁米那斯村", 0, 43000, 322, 883 },
  { "米诺基亚村", 0, 43000, 431, 823 },
  { "雷克塔尔镇", 0, 43000, 556, 313 },
  { "汉米顿村", 0, 32205, 127, 138 },
  { "亚纪城", 0, 322277, 33, 56 },
  { "圣十字勇者殿堂", 0, 32699, 50, 50 },
  { "宠物技能屋", 0, 32104, 48, 16 },
  { "采集传送门", 0, 32130, 11, 8 },
}

local function calcWarp()
  local page = math.modf(#warpPoints / 8) + 1
  local remainder = math.fmod(#warpPoints, 8)
  return page, remainder
end

function Warp:onLoad()
  self:logInfo('load');
  local warpNPC = self:NPC_createNormal('传送门', 103010, { x = 242, y = 88, mapType = 0, map = 1000, direction = 6 });
  self:NPC_regWindowTalkedEvent(warpNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "1\\n请问你想去哪里\\n"
    local winButton = CONST.BUTTON_关闭;
    local totalPage, remainder = calcWarp()
    --上页16 下页32 关闭/取消2
    if _select > 0 then
      if _select == CONST.BUTTON_下一页 then
        warpPage = warpPage + 1
        if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
          winButton = CONST.BUTTON_上取消
        else
          winButton = CONST.BUTTON_上下取消
        end
      elseif _select == CONST.BUTTON_上一页 then
        warpPage = warpPage - 1
        if warpPage == 1 then
          winButton = CONST.BUTTON_下取消
        else
          winButton = CONST.BUTTON_下取消
        end
      elseif _select == 2 then
        warpPage = 1
        return
      end
      local count = 8 * (warpPage - 1)
      if warpPage == totalPage then
        for i = 1 + count, remainder + count do
          winMsg = winMsg .. warpPoints[i][1] .. "\\n"
        end
      else
        for i = 1 + count, 8 + count do
          winMsg = winMsg .. warpPoints[i][1] .. "\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, warpPage, winMsg);
    else
      local count = 8 * (warpPage - 1) + column
      local short = warpPoints[count]
      Char.Warp(player, short[2], short[3], short[4], short[5])
    end
  end)
  self:NPC_regTalkedEvent(warpNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "1\\n请问你想去哪里\\n";
      for i = 1, 8 do
        msg = msg .. warpPoints[i][1] .. "\\n"
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_下取消, 1, msg);
    end
    return
  end)
end

function Warp:onUnload()
  self:logInfo('unload')
end

return Warp;
