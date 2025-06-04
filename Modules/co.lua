---ģ����
---@class CoModule: ModuleType
local CoModule = ModuleBase:createModule('co')


--- ����ģ�鹳��
function CoModule:onLoad()
    _G.loggerLevel = 99;
    self:SetLogLevel(99);
    self:logInfo('load')
    self.co = self:NPC_CreateCo("CO!", 104863,
        { map = 1000, mapType = 0, x = 229, y = 88, direction = 6 },
        Func.bind(self.CO_Func, self));
end

---@param co CO
---@param npc number
---@param player number
---@param msg string
---@param color number
---@param size number
function CoModule:CO_Func(co, npc, player, msg, color, size)
    self:logDebug("start co", co, npc, player, msg, color, size)
    local n = SQL.QueryEx("select X from cgmsv.tbl_character where CdKey = ? and RegistNumber = ?;",
        Char.GetData(player, CONST.CHAR_CDK),
        Char.GetData(player, CONST.����_RegistNumber));
    npc, player, seqno, select, data = co:next(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�Ƿ�, 0,
        self:NPC_buildSelectionText("Text", { "A", "B", n.rows[1].X }));
    self:logDebug("co1", co, npc, player, seqno, select, data)
    n = SQL.QueryEx("select X from cgmsv.tbl_character where CdKey = ? and RegistNumber = ?;",
        Char.GetData(player, CONST.CHAR_CDK),
        Char.GetData(player, CONST.����_RegistNumber));
    npc, player, seqno, select, data = co:next(player, npc, CONST.����_ѡ���, CONST.BUTTON_�Ƿ�, 0,
        self:NPC_buildSelectionText("Text2", { "C", "D", n.rows[1].X }));
    self:logDebug("co2", co, npc, player, seqno, select, data)

    npc, player, seqno, select, data = co:next(player, npc, CONST.����_ѡ���, CONST.BUTTON_�Ƿ�, 0,
        self:NPC_buildSelectionText("Text3", { "E", "F" }));
    self:logDebug("co3", co, npc, player, seqno, select, data)
end

--- ж��ģ�鹳��
function CoModule:onUnload()
    self:logInfo('unload')
end

return CoModule;
