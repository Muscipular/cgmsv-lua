---背包管理 for cgmsv 24.9e以上版本
---@class BagSwitch : ModuleType
local BagSwitch = ModuleBase:createModule('bagSwitch');


local MENU = 0;
local BAG_LIST = 1;
local ITEM_MOVE = 1000;

--- 加载模块钩子
function BagSwitch:onLoad()
    self:logInfo('load')
    self.dummyNPC = self:NPC_createNormal('DummyNPC', 10000, { x = 0, y = 0, map = 777, mapType = 0, direction = 0 });
    self:regCallback('ProtocolOnRecv', Func.bind(self.onProtoHook, self), 'SWITMM');
    self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
    self:NPC_regWindowTalkedEvent(self.dummyNPC, Func.bind(self.onWindowTalked, self));
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
    local menu = self:NPC_buildSelectionText("背包管理 ", {
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
end

---@param ch CharaWrapper
---@param selection number
---@param buttonClick number
function BagSwitch:onMenu(ch, selection, buttonClick)
    if selection == 1 then
        ch:ShowWindowTalked(self.dummyNPC,
            self:NPC_buildSelectionText("选择背包", { "1", "2", "3", "4" }),
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
    if buttonClick == CONST.BUTTON_关闭 or buttonClick == CONST.BUTTON_否 then
        return
    end
    selection = selection - 1;
    if selection < 0 then
        return
    end
    
    if selection == 10 then
        local iPage = ch[CONST.对象_WindowBuffer2];
        Char.GetItemIndex()
    end
end

return BagSwitch;
