---黄金迷宫模块
---@class GoldMazeModule: ModuleType
local GoldMazeModule = ModuleBase:createModule('gold_maze')

local MAX_LEVEL = 99;
local ENCOUNT_RATE = 6.66;
local MIN_SIZE = 40;
local MAX_SIZE = 70;
local BOSS_MAP = CONST.地图类型_普通;
local BOSS_FLOOR = 592;
local BOSS_FLOOR_X = 592;
local BOSS_FLOOR_Y = 592;
local ENTRY_MAPID = CONST.地图类型_普通;
local ENTRY_FLOOR = 11015;
local ENTRY_X = 9;
local ENTRY_Y = 21;
local ENTRY_NPC = 10000;
local ENTRY_DIR = 0;
local ENTRY_ITEMID = 1;
local BOSS = 880048;
local ENEMY = { 880014, 880015, 880016, 880017, 880018 };

function GoldMazeModule:onLoad()
    -- self:SetLogLevel(888);
    -- _G.loggerLevel = 888;
    self:logInfo('加载黄金迷宫模块')
    self.MapList = {} -- 存储所有生成的地图floor
    -- 创建入口NPC
    self:createEntranceNPC()
    -- 注册事件
    self:regCallback("ItemBoxLootEvent", Func.bind(self.onItemBoxLoot, self))
    self:regCallback("ItemBoxEncountRateEvent", Func.bind(self.onItemBoxEncountRate, self))
    self:regCallback("WarpEvent", Func.bind(self.onWarpEvent, self))

    -- 创建地图清理循环
    local onEliteWin = self:regCallback(Func.bind(self.onEliteWin, self))
    self.onEliteWinKey = onEliteWin;
end

function GoldMazeModule:onUnload()
    self:logInfo('unload')
    -- NL.DelNpc(self.npc);
    for floor, _ in pairs(self.MapList) do
        self:logDebug("clear up", floor)
        local players = NLG.GetMapPlayer(CONST.地图类型_LUAMAP, floor)
        if type(players) == "table" then
            for _, charIndex in pairs(players) do
                Char.Warp(charIndex, ENTRY_MAPID, ENTRY_FLOOR, ENTRY_X, ENTRY_Y);
            end
        end
        -- Map.SetExtData(CONST.地图类型_LUAMAP, floor, "GoldMapVar", nil)
        Map.DelLuaMap(floor)
    end
end

function GoldMazeModule:createEntranceNPC()
    local position = {
        x = ENTRY_X,
        y = ENTRY_Y,
        map = ENTRY_FLOOR,
        mapType = ENTRY_MAPID,
        direction = ENTRY_DIR
    }
    local charIndex = self:NPC_createNormal("黄金迷宫守卫", ENTRY_NPC, position)

    -- 注册对话事件
    self:NPC_regTalkedEvent(charIndex, function(npc, player)
        self:startAdventure(player)
    end)
    self.npc = charIndex;
    local loopFnIndex = self:regCallback(Func.bind(self.onMapCleanLoop, self))
    Char.SetLoopEvent(nil, loopFnIndex, charIndex, 1000) -- 全局循环
end

function GoldMazeModule:createMap(level)
    -- 创建新地图
    local w = NLG.Rand(MIN_SIZE, MAX_SIZE)
    local h = NLG.Rand(MIN_SIZE, MAX_SIZE)
    local floor = -1;
    for i = 1, 5 do
        floor = Map.MakeMazeMap(nil, nil,
            w, h,
            "黄金迷宫" .. level .. "层",
            -- 307
            10,
            10,
            10, 20,
            10, 20,
            9682, 100, 0,
            0, 0, 0, 0, 0,
            215
        )
        if floor >= 0 then
            break;
        end
    end
    if floor == -1 then return -1 end
    self:logDebug("create floor", floor)

    -- 设置地图变量
    Map.SetExtData(CONST.地图类型_LUAMAP, floor, "GoldMapVar", 1)
    self.MapList[floor] = true


    -- 创建传送点
    local tx, ty = Map.GetAvailablePos(CONST.地图类型_LUAMAP, floor)
    Obj.AddWarp(CONST.地图类型_LUAMAP, floor, tx, ty,
        CONST.地图类型_LUAMAP, floor, tx, ty)
    --    local tile = Map.GetImage(CONST.地图类型_LUAMAP, floor, tx, ty)
    Map.SetImage(CONST.地图类型_LUAMAP, floor, tx, ty, nil, 17990)

    -- 随机放置宝箱
    local max = NLG.Rand(0, 5);
    for i = 1, max do
        local type = self:getBoxType()
        local itemIndex = Item.MakeItem(type)
        local x, y = Map.GetAvailablePos(CONST.地图类型_LUAMAP, floor)
        Obj.AddItem(CONST.地图类型_LUAMAP, floor, x, y, itemIndex)
        self:logInfo("BOX", floor, x, y, itemIndex)
    end
    return floor;
end

function GoldMazeModule:startAdventure(leaderIndex)
    -- 检查队伍是否已挑战
    local partyMembers = self:getPartyMembers(leaderIndex)

    for _, member in ipairs(partyMembers) do
        local lastDate = Char.GetExtData(member, "GoldMapDate") or 0
        if tonumber(lastDate) >= tonumber(os.date("%Y%m%d")) then
            self:logInfo(lastDate, os.date("%Y%m%d"))
            -- Char.SetExtData(member, "GoldMapDate", nil)
            NLG.SystemMessage(member, "今天已经挑战过黄金迷宫！")
            return
        end
    end

    local floor = self:createMap(1);
    if floor < 0 then
        for _, member in ipairs(partyMembers) do
            NLG.SystemMessage(member, "生成迷宫失败")
        end
        return
    end

    -- 设置玩家数据
    for _, member in ipairs(partyMembers) do
        Char.SetTempData(member, "GoldMapLevel", 1)
        Char.SetTempData(member, "GoldMapMembers", #partyMembers)
        Char.SetExtData(member, "GoldMapDate", os.date("%Y%m%d"))
        -- 给予道具
        Char.GiveItem(member, ENTRY_ITEMID, 1, true)
    end

    -- 传送玩家
    local x, y = Map.GetAvailablePos(CONST.地图类型_LUAMAP, floor)
    Char.Warp(partyMembers[1], CONST.地图类型_LUAMAP, floor, x, y)
end

function GoldMazeModule:onItemBoxLoot(charIndex, mapId, floor, x, y, boxType)
    if Map.GetExtData(mapId, floor, "GoldMapVar") ~= 1 then return 0 end
    local partyMode = Char.GetData(charIndex, CONST.对象_组队模式)
    if partyMode == CONST.组队模式_队长 or partyMode == CONST.组队模式_无 then
        local level = tonumber(Char.GetTempData(charIndex, "GoldMapLevel")) or 1

        local lootType = self:getBoxLootType(boxType)
        if lootType == "encounter" then
            self:startEncounter(charIndex, level, "normal")
        elseif lootType == "elite" then
            self:startEncounter(charIndex, level + 50, "elite")
        elseif lootType == "next" then
            self:nextLevel(charIndex)
        end
        return 1 -- 拦截默认物品
    end
    return 0;
end

function GoldMazeModule:onItemBoxEncountRate(charIndex, mapId, floor, X, Y, rate, boxType)
    if Map.GetExtData(mapId, floor, "GoldMapVar") == 1 then
        return 0 -- 关闭默认遇敌
    end
    return rate
end

function GoldMazeModule:onWarpEvent(charIndex, sMapId, sFloor, sX, sY, targetMap, targetFloor, tX, tY)
    local mapVar = Map.GetExtData(sMapId, sFloor, "GoldMapVar")
    if mapVar ~= 1 then return end
    local mapVar2 = Map.GetExtData(targetMap, targetFloor, "GoldMapVar")
    if mapVar2 ~= 1 then return end
    if sFloor ~= targetFloor then return end
    local partyMode = Char.GetData(charIndex, CONST.对象_组队模式)
    if partyMode == CONST.组队模式_队长 or partyMode == CONST.组队模式_无 then
        local allPresent = self:validateParty(charIndex);

        if allPresent then
            local level = tonumber(Char.GetTempData(charIndex, "GoldMapLevel")) or 1
            if level < MAX_LEVEL then
                local ret = { targetMap, targetFloor, tX, tY }
                self:startNextMap(charIndex, function(c, ...)
                    ret = { ... }
                end)
                return ret;
            end
        else
            NLG.SystemMessage(charIndex, "等等你可怜的队友吧");
            Char.Warp(charIndex, sMapId, sFloor, sX, sY);
        end
    end
end

function GoldMazeModule:onMapCleanLoop()
    for floor, _ in pairs(table.copy(self.MapList)) do
        local players = NLG.GetMapPlayer(CONST.地图类型_LUAMAP, floor)
        if type(players) ~= "table" or #players == 0 then
            -- 地图无人则删除
            self:logDebug("delete", floor)
            Map.SetExtData(CONST.地图类型_LUAMAP, floor, "GoldMapVar", nil)
            Map.DelLuaMap(floor)
            self.MapList[floor] = nil
            goto continue
        end

        -- 检测玩家移动触发遇敌
        for _, charIndex in ipairs(players) do
            local currentX = Char.GetData(charIndex, CONST.对象_X)
            local currentY = Char.GetData(charIndex, CONST.对象_Y)
            local lastX = tonumber(Char.GetTempData(charIndex, "GoldMapLastX")) or currentX
            local lastY = tonumber(Char.GetTempData(charIndex, "GoldMapLastY")) or currentY
            -- 更新上一次坐标
            Char.SetTempData(charIndex, "GoldMapLastX", currentX)
            Char.SetTempData(charIndex, "GoldMapLastY", currentY)

            local dx = math.abs(currentX - lastX)
            local dy = math.abs(currentY - lastY)
            local totalDistance = dx + dy

            if totalDistance >= 1 then
                local partyMode = Char.GetData(charIndex, CONST.对象_组队模式)
                if partyMode == CONST.组队模式_队长 or partyMode == CONST.组队模式_无 then
                    local chance = totalDistance * ENCOUNT_RATE -- 每格10%概率
                    if NLG.Rand(1, 100) <= chance then
                        self:startEncounter(charIndex, Char.GetTempData(charIndex, "GoldMapLevel"), "normal")
                    end
                end
            end
        end

        ::continue::
    end
end

-- 辅助函数
function GoldMazeModule:getPartyMembers(leaderIndex)
    local members = {}
    local partyMode = Char.GetData(leaderIndex, CONST.对象_组队模式)
    if partyMode == CONST.组队模式_队长 then
        for i = 0, 4 do
            local member = Char.GetPartyMember(leaderIndex, i)
            if member ~= -1 then table.insert(members, member) end
        end
    else
        members = { leaderIndex }
    end
    return members
end

function GoldMazeModule:validateParty(leaderIndex)
    local recordedNum = tonumber(Char.GetTempData(leaderIndex, "GoldMapMembers") or 0)
    local actualNum = #self:getPartyMembers(leaderIndex)
    return recordedNum == actualNum
end

function GoldMazeModule:getBoxType()
    local rand = NLG.Rand(1, 100)
    if rand <= 60 then return 18002 end -- 普通宝箱
    if rand <= 90 then return 18003 end -- 黑宝箱
    return 18004                        -- 白宝箱
end

function GoldMazeModule:getBoxLootType(boxType)
    local rand = NLG.Rand(1, 100)
    if boxType == 18002 then -- 普通
        if rand <= 80 then return "encounter" end
        if rand <= 95 then return "elite" end
        return "next"
    elseif boxType == 18003 then -- 黑
        if rand <= 50 then return "encounter" end
        if rand <= 90 then return "elite" end
        return "next"
    else -- 白
        if rand <= 50 then return "encounter" end
        if rand <= 80 then return "elite" end
        return "next"
    end
end

function GoldMazeModule:startEncounter(charIndex, level, type)
    local partyMembers = self:getPartyMembers(charIndex)
    local hasItem = true
    for _, member in ipairs(partyMembers) do
        if Char.HaveItem(member, ENTRY_ITEMID) < 0 then
            hasItem = false
            break
        end
    end
    local enemies, lvList = {}, {}
    if not hasItem or type == "boss" then
        for i = 1, 10 do
            table.insert(enemies, BOSS)
            table.insert(lvList, 999)
        end
    else
        if type == "elite" then
            level = math.floor((level + 50) * (1 + level / 100));
        end
        local count = NLG.Rand(1, 10)
        for i = 1, count do
            table.insert(enemies, ENEMY[math.random(#ENEMY)])
            table.insert(lvList, level)
        end
    end

    local battleIndex = Battle.PVE(charIndex, charIndex, nil, enemies, lvList)

    if type == "elite" or type == "精英" then
        Battle.SetWinEvent(nil, self.onEliteWinKey, battleIndex)
    end
end

function GoldMazeModule:nextLevel(charIndex)
    local currentMapId = Char.GetData(charIndex, CONST.对象_地图类型)
    local currentFloor = Char.GetData(charIndex, CONST.对象_地图)
    if currentMapId == CONST.地图类型_LUAMAP and self.MapList[currentFloor] then
        local allPresent = self:validateParty(charIndex);
        if allPresent then
            self:startNextMap(charIndex, Char.Warp)
        else
            NLG.SystemMessage(charIndex, "等等你可怜的队友吧");
        end
    end
end

function GoldMazeModule:startNextMap(leaderIndex, warpFn)
    local level = tonumber(Char.GetTempData(leaderIndex, "GoldMapLevel")) + 1;
    local newFloor = self:createMap(level)
    local partyMembers = self:getPartyMembers(leaderIndex)
    local x, y = Map.GetAvailablePos(CONST.地图类型_LUAMAP, newFloor)
    for _, member in ipairs(partyMembers) do
        Char.SetTempData(member, "GoldMapLevel", level);
    end
    -- self:logDebug("warp to ", CONST.地图类型_LUAMAP, newFloor, x, y)
    warpFn(partyMembers[1], CONST.地图类型_LUAMAP, newFloor, x, y)
end

function GoldMazeModule:onEliteWin(battleIndex, charIndex)
    local add = NLG.Rand(0, 5);
    if add > 0 then
        local level = tonumber(Char.GetTempData(charIndex, "GoldMapLevel") or 1) + add;
        Char.SetTempData(charIndex, "GoldMapLevel", level);
    end

    self:nextLevel(charIndex);
end

return GoldMazeModule
