---@class CharPart: ModulePart
local CharPart = ModuleBase:createPart('CharPart');


---@class CharaWrapper
---@field charaIndex CharIndex
local CharaWrapper = {};

local CharaWrapperM = {
    __index = function(self, key)
        if (CharaWrapper[key]) then
            return CharaWrapper[key];
        end
        local charaIndex = rawget(self, 'charaIndex');
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

---包装CharaIndex
---@param charaIndex CharIndex
---@return CharaWrapper|{[number]:string|number|nil}
function CharPart:Chara(charaIndex)
    return setmetatable({ charaIndex = charaIndex }, CharaWrapperM);
end

return CharPart;
