local Warp = ModuleBase:new('warp')

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

local function calcwarp()
    local page = math.modf(#warpPoints / 8) + 1
    local remainder = math.fmod(#warpPoints, 8)
    return page, remainder
end

function Warp:new()
    local o = ModuleBase:new('warp');
    setmetatable(o, self)
    self.__index = self
    return o;
end

function Warp:onLoad()
    logInfo(self.name, 'load')
    self.npc = {}
    local initFn = self:regCallback(function()
        return true;
    end)
    local warpNPC = NL.CreateNpc(nil, initFn);
    Char.SetData(warpNPC, CONST.CHAR_形象, 103010);
    Char.SetData(warpNPC, CONST.CHAR_原形, 103010);
    Char.SetData(warpNPC, CONST.CHAR_X, 242);
    Char.SetData(warpNPC, CONST.CHAR_Y, 88);
    Char.SetData(warpNPC, CONST.CHAR_地图, 1000);
    Char.SetData(warpNPC, CONST.CHAR_方向, 6);
    Char.SetData(warpNPC, CONST.CHAR_名字, "传送门");
    NLG.UpChar(warpNPC);
    table.insert(self.npc, warpNPC);

    local warpNPCWinTalked = self:regCallback(function(npc, player, _seqno, _select, _data)
        local column = tonumber(_data)
        local page = tonumber(_seqno)
        local warppage = page;
        local winmsg = "1\\n请问你想去哪里\\n"
        local winbutton = CONST.BUTTON_关闭;
        local totalpage, remainder = calcwarp()
        --上页16 下页32 关闭/取消2
        if _select > 0 then
            if _select == CONST.BUTTON_下一页 then
                warppage = warppage + 1
                if (warppage == totalpage) or ((warppage == (totalpage - 1) and remainder == 0)) then
                    winbutton = CONST.BUTTON_上取消
                else
                    winbutton = CONST.BUTTON_上下取消
                end
            elseif _select == CONST.BUTTON_上一页 then
                warppage = warppage - 1
                if warppage == 1 then
                    winbutton = CONST.BUTTON_下取消
                else
                    winbutton = CONST.BUTTON_下取消
                end
            elseif _select == 2 then
                warppage = 1
                return
            end
            local count = 8 * (warppage - 1)
            if warppage == totalpage then
                for i = 1 + count, remainder + count do
                    winmsg = winmsg .. warpPoints[i][1] .. "\\n"
                end
            else
                for i = 1 + count, 8 + count do
                    winmsg = winmsg .. warpPoints[i][1] .. "\\n"
                end
            end
            NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winbutton, warppage, winmsg);
        else
            local count = 8 * (warppage - 1) + column
            local short = warpPoints[count]
            Char.Warp(player, short[2], short[3], short[4], short[5])
        end
    end)
    Char.SetWindowTalkedEvent(nil, warpNPCWinTalked, warpNPC);

    local talkedFn = self:regCallback(function(npc, player)
        if (NLG.CanTalk(npc, player) == true) then
            local msg = "1\\n请问你想去哪里\\n";
            for i = 1, 8 do
                msg = msg .. warpPoints[i][1] .. "\\n"
            end
            NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_下取消, 1, msg);
        end
        return
    end)
    Char.SetTalkedEvent(nil, talkedFn, warpNPC);
end

function Warp:onUnload()
    logInfo(self.name, 'unload')

    for i, v in pairs(self.npc) do
        NL.DelNpc(v)
    end
end

return Warp;
