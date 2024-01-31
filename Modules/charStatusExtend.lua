---@class CharStatusExtend:ModuleBase
local CharStatusExtend = ModuleBase:createModule('charStatusExtend')

local Allow = {
  ['' .. CONST.CHAR_最大血] = 1,
  ['' .. CONST.CHAR_最大魔] = 1,
  ['' .. CONST.CHAR_攻击力] = 1,
  ['' .. CONST.Char_防御力] = 1,
  ['' .. CONST.Char_敏捷] = 1,
  ['' .. CONST.CHAR_精神] = 1,
  ['' .. CONST.CHAR_回复] = 1,
};

function CharStatusExtend:onLoad()
  self:logInfo('load');
  self:regCallback('AfterCalcCharaStatusEvent', Func.bind(self.onStatusUpdate, self));
end

function CharStatusExtend:addCharStatus(charIndex, t, val)
  if (Allow[t .. ''] ~= 1) then
    return false;
  end
  Char.SetTempData(charIndex, 'CSE:Enable', 1);
  Char.SetTempData(charIndex, "CSE:" .. t, tonumber(val));
  return true;
end

function CharStatusExtend:clearCharStatus(charIndex)
  Char.SetTempData(charIndex, 'CSE:Enable', nil);
  for i, v in pairs(Allow) do
    Char.SetTempData(charIndex, 'CSE:' .. i, nil);
  end
end

function CharStatusExtend:onStatusUpdate(charIndex)
  if (Char.GetTempData(charIndex, "CSE:Enable") == 1) then
    local fullFp = Char.GetData(charIndex, CONST.CHAR_最大魔) == Char.GetData(charIndex, CONST.CHAR_魔);
    local t = { CONST.CHAR_攻击力, CONST.Char_防御力, CONST.Char_敏捷, CONST.CHAR_精神, CONST.CHAR_回复 };
    for i, v in ipairs(t) do
      local vx = tonumber(Char.GetTempData(charIndex, "CSE:" .. v)) or 0;
      if (vx ~= 0 and vx ~= nil) then
        Char.SetData(charIndex, v, Char.GetData(charIndex, v) + vx);
      end
    end
    local t2 = { { CONST.CHAR_最大血, CONST.CHAR_血 }, { CONST.CHAR_最大魔, CONST.CHAR_魔 } }
    for i, v in ipairs(t2) do
      local vx = tonumber(Char.GetTempData(charIndex, "CSE:" .. v[1])) or 0;
      if (vx ~= 0 and vx ~= nil) then
        local full = Char.GetData(charIndex, v[1]) == Char.GetData(charIndex, v[2]);
        local val = Char.GetData(charIndex, v[1]) + vx;
        Char.SetData(charIndex, v[1], val);
        if full then
          Char.GetData(charIndex, v[2], val);
        end
      end
    end
  end
end

function CharStatusExtend:onUnload()
  self:logInfo('unload');
end
