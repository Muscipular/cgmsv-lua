---背包管理 for cgmsv 24.9e以上版本
---@class BagSwitch : ModuleType
local BagSwitch = ModuleBase:createModule('bagSwitch');


local MENU = 0;
local BAG_LIST = 1;
local BAG_LIST2 = 2;
local ITEM_MOVE = 1000;
local SHOW_ITEM_LIST = 10;
local ITEM_PAGE_SIZE = 20;
local EQUIP_NUM = 8;
local IPAGE_NUM = 8;

local BAG_PAGE_LIST = {};

--- 加载模块钩子
function BagSwitch:onLoad()
    self:logInfo('load')
    self.dummyNPC = self:NPC_createNormal('DummyNPC', 10000, { x = 0, y = 0, map = 777, mapType = 0, direction = 0 });
    self:regCallback('ProtocolOnRecv', Func.bind(self.onProtoHook, self), 'SWITMM');
    self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
    self:NPC_regWindowTalkedEvent(self.dummyNPC, Func.bind(self.onWindowTalked, self));

    for i = 1, CONST.EXTBAGPAGE + 1 do
        table.insert(BAG_PAGE_LIST, NLG.c(string.format("%d号背包", i)));
    end
end

--- 卸载模块钩子
function BagSwitch:onUnload()
    self:logInfo('unload')
end

function BagSwitch:handleTalkEvent(charIndex, msg)
    if (string.lower(tostring(msg)) == "/itemswitch") then
        self:OpenMenu(charIndex)
        return 0;
    end
    return 1;
end

function BagSwitch:onProtoHook(fd)
    local charIndex = Protocol.GetCharIndexFromFd(fd);
    self:OpenMenu(charIndex);
    return 1;
end

function BagSwitch:OpenMenu(charIndex)
    local ch = self:Chara(charIndex);
    ch[CONST.对象_WindowBuffer2] = 1;
    local menu = self:NPC_buildSelectionText("背包管理", {
        "切换背包",
        "移动物品"
    })
    NLG.ShowWindowTalked(charIndex, self.dummyNPC,
        CONST.窗口_选择框, CONST.BUTTON_确定关闭,
        0, menu);
end

function BagSwitch:onWindowTalked(npc, player, seqNo, btnClick, line)
    local ch = self:Chara(player);
    line = tonumber(line)
    btnClick = tonumber(btnClick)
    if seqNo == MENU then
        self:onMenu(ch, line, btnClick);
    end
    if seqNo == BAG_LIST then
        self:onSwitchBag(ch, line, btnClick);
    end
    if seqNo == ITEM_MOVE then
        self:onMoveItem(ch, line, btnClick);
    end
    if seqNo == BAG_LIST2 then
        self:onSelectedMoveBag(ch, line, btnClick);
    end
end

---@param ch CharaWrapper
---@param selection number
---@param buttonClick number
function BagSwitch:onMenu(ch, selection, buttonClick)
    if selection == 1 then
        ch:ShowWindowTalked(self.dummyNPC,
            self:NPC_buildSelectionText(
                NLG.c("选择背包"),
                BAG_PAGE_LIST
            ),
            {
                button = CONST.BUTTON_关闭,
                type = CONST.窗口_选择框,
                seqNo = BAG_LIST,
            })
        return
    end
    if selection == 2 then
        ch[CONST.对象_WindowBuffer2] = 0;
        self:onMoveItem(ch, 10, -1);
    end
end

---@param ch CharaWrapper
---@param selection number
---@param buttonClick number
function BagSwitch:onSwitchBag(ch, selection, buttonClick)
    if buttonClick == CONST.BUTTON_关闭 or buttonClick == CONST.BUTTON_否 then
        return
    end
    selection = selection - 1;
    if selection < 0 then
        return
    end
    local cur = Char.GetBagPage(ch.charaIndex);
    if cur == selection then
        NLG.SystemMessage(ch.charaIndex, "无需切换背包")
        return
    end
    NLG.SystemMessage(ch.charaIndex, "切换到背包" .. (selection + 1))
    Char.SwitchBag(ch.charaIndex, selection)
end

---@param ch CharaWrapper
---@param selection number
---@param buttonClick number
function BagSwitch:onMoveItem(ch, selection, buttonClick)
    local iPage = ch[CONST.对象_WindowBuffer2] --[[@as number]];
    if buttonClick == CONST.BUTTON_上一页 then
        iPage = math.max(0, iPage - 1);
        selection = SHOW_ITEM_LIST;
    elseif buttonClick == CONST.BUTTON_下一页 then
        iPage = math.min(2, iPage + 1);
        selection = SHOW_ITEM_LIST;
    elseif buttonClick == -1 or selection > 0 then
        -- ignore this
    else
        return
    end

    if selection > 0 and selection ~= SHOW_ITEM_LIST then
        selection = selection - 1;
    end
    if selection < 0 then
        return
    end

    local cur = Char.GetBagPage(ch.charaIndex);

    if selection == SHOW_ITEM_LIST then
        local pageSlotMap = {
            { 1,  2,  3,  4,  5,  6,  7,  8, },
            { 9,  10, 11, 12, 13, 14, 15, 16, },
            { 17, 18, 19, 20, },
        }
        local buttonMap = {
            CONST.BUTTON_下取消,
            CONST.BUTTON_上下取消,
            CONST.BUTTON_上取消,
        }
        local menuList = {};
        for _, value in ipairs(pageSlotMap[iPage + 1]) do
            local itemIndex = Char.GetItemIndex(ch.charaIndex, cur * ITEM_PAGE_SIZE + EQUIP_NUM + value - 1);
            local itemName = "- [空] -"
            if itemIndex >= 0 then
                itemName = string.format("%s x %d",
                    Item.GetData(itemIndex, CONST.道具_名字),
                    Item.GetData(itemIndex, CONST.道具_堆叠数)
                );
            end
            table.insert(menuList, NLG.c(itemName));
        end
        ch:ShowWindowTalked(self.dummyNPC, self:NPC_buildSelectionText(
            NLG.c("选择物品"),
            menuList), {
            type = CONST.窗口_选择框,
            seqNo = ITEM_MOVE,
            windowBuffer2 = iPage,
            button = buttonMap[iPage + 1],
        })
        return
    end
    if selection >= 0 then
        ch:ShowWindowTalked(self.dummyNPC,
            self:NPC_buildSelectionText(
                NLG.c("选择背包"),
                BAG_PAGE_LIST
            ),
            {
                button = CONST.BUTTON_关闭,
                type = CONST.窗口_选择框,
                seqNo = BAG_LIST2,
                windowBuffer2 = selection + iPage * IPAGE_NUM,
            })
        return
    end
end

---@param ch CharaWrapper
---@param selection number
---@param buttonClick number
function BagSwitch:onSelectedMoveBag(ch, selection, buttonClick)
    if buttonClick == CONST.BUTTON_关闭 or buttonClick == CONST.BUTTON_否 then
        return
    end
    selection = selection - 1;
    if selection < 0 then
        return
    end
    local cur = Char.GetBagPage(ch.charaIndex);
    local itemSelection = ch[CONST.对象_WindowBuffer2];

    local ret = Char.ItemMoveBag(ch.charaIndex, EQUIP_NUM + itemSelection, selection, -1);
    if ret ~= 1 then
        NLG.SystemMessage(ch.charaIndex, "移动物品失败");
    end
end

return BagSwitch;
