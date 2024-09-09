---@class CharPart: ModulePart
local CharPart = ModuleBase:createPart('CharPart');


---@class CharaWrapper
local CharaWrapper = {};

local CharaWrapperM = {
    __index = function(self, key)
        if (CharaWrapper[key]) then
            return CharaWrapper[key];
        end
        local charaIndex = rawget(self, 'charaIndex');
        if key == 'charaIndex' then
            return charaIndex;
        end
        if type(key) == "number" then
            return Char.GetData(charaIndex, key);
        end
        error('dateLine参数错误');
    end,
    __newindex = function(self, key, value)
        local charaIndex = rawget(self, 'charaIndex');
        if type(key) == "number" then
            return Char.SetData(charaIndex, key, value);
        end
        error('dateLine参数错误');
    end,
};

---@param field string
---@return string|number|nil
function CharaWrapper:getTmpData(field)
    local charaIndex = self.charaIndex;
    return Char.GetTempData(charaIndex, field);
end

---@param field string
---@param value number|string|nil
---@return number
function CharaWrapper:setTmpData(field, value)
    local charaIndex = self.charaIndex;
    return Char.SetTempData(charaIndex, field, value);
end

---@param field string
---@return string|number|nil
function CharaWrapper:getExtData(field)
    local charaIndex = self.charaIndex;
    return Char.GetExtData(charaIndex, field);
end

---@param field string
---@param value number|string|nil
---@return number
function CharaWrapper:setExtData(field, value)
    local charaIndex = self.charaIndex;
    return Char.SetExtData(charaIndex, field, value);
end

---@param npc number
---@param data string
---@param opt? {type?:number, button?:number, seqNo?: number, windowBuffer1?:number, windowBuffer2?:number, windowBuffer3?:number}
---@return number
function CharaWrapper:ShowWindowTalked(npc, data, opt)
    local charaIndex = self.charaIndex;
    if type(opt) ~= 'table' then
        opt = {
            type = CONST.窗口_信息框,
            button = CONST.BUTTON_确认,
            seqNo = 0,
            windowBuffer1 = 0,
            windowBuffer2 = 0,
            windowBuffer3 = 0,
        }
    end
    self[CONST.对象_WindowBuffer1] = opt.windowBuffer1 or 0;
    self[CONST.对象_WindowBuffer2] = opt.windowBuffer2 or 0;
    self[CONST.对象_WindowBuffer3] = opt.windowBuffer3 or 0;
    return NLG.ShowWindowTalked(charaIndex,
        npc,
        opt.type or CONST.窗口_信息框,
        opt.button or CONST.BUTTON_确认,
        opt.seqNo or 0,
        data or "");
end

---@param msg string
---@param ... string|number
function CharaWrapper:SystemMessage(msg, ...)
    return NLG.SystemMessage(self.charaIndex, string.format(msg, ...));
end

---包装CharaIndex
---@param charaIndex number
---@return CharaWrapper
function CharPart:Chara(charaIndex)
    return setmetatable({ charaIndex = charaIndex }, CharaWrapperM);
end

return CharPart;
