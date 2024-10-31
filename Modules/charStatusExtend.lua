---@class CharStatusExtend : ModuleType
local CharStatusExtend = ModuleBase:createModule('charStatusExtend')

local Allow = {
  [CONST.CHAR_最大血] = CONST.CHAR_最大血,
  [CONST.CHAR_最大魔] = CONST.CHAR_最大魔,
  [CONST.CHAR_攻击力] = CONST.CHAR_攻击力,
  [CONST.CHAR_防御力] = CONST.CHAR_防御力,
  [CONST.CHAR_敏捷] = CONST.CHAR_敏捷,
  [CONST.CHAR_精神] = CONST.CHAR_精神,
  [CONST.CHAR_回复] = CONST.CHAR_回复,
  [CONST.CHAR_实际反击] = CONST.CHAR_实际反击,
  [CONST.CHAR_实际必杀] = CONST.CHAR_实际必杀,
  [CONST.CHAR_实际命中] = CONST.CHAR_实际命中,
  [CONST.CHAR_实际闪躲] = CONST.CHAR_实际闪躲,
  [CONST.CHAR_实际抗毒] = CONST.CHAR_实际抗毒,
  [CONST.CHAR_实际抗乱] = CONST.CHAR_实际抗乱,
  [CONST.CHAR_实际抗忘] = CONST.CHAR_实际抗忘,
  [CONST.CHAR_实际抗睡] = CONST.CHAR_实际抗睡,
  [CONST.CHAR_实际抗石] = CONST.CHAR_实际抗石,
  [CONST.CHAR_实际抗醉] = CONST.CHAR_实际抗醉,
  [CONST.CHAR_反击] = CONST.CHAR_实际反击,
  [CONST.CHAR_必杀] = CONST.CHAR_实际必杀,
  [CONST.CHAR_命中] = CONST.CHAR_实际命中,
  [CONST.CHAR_闪躲] = CONST.CHAR_实际闪躲,
  [CONST.CHAR_抗毒] = CONST.CHAR_实际抗毒,
  [CONST.CHAR_抗乱] = CONST.CHAR_实际抗乱,
  [CONST.CHAR_抗忘] = CONST.CHAR_实际抗忘,
  [CONST.CHAR_抗睡] = CONST.CHAR_实际抗睡,
  [CONST.CHAR_抗石] = CONST.CHAR_实际抗石,
  [CONST.CHAR_抗醉] = CONST.CHAR_实际抗醉,
};

function CharStatusExtend:onLoad()
  self:logInfo('load');
  self:regCallback('AfterCalcCharaStatusEvent', Func.bind(self.onStatusUpdate, self));
end

---增加临时属性
---@param charIndex number
---@param t number 对应CONST.对象_*
---@param val number 调整值
---@return boolean 是否成功
function CharStatusExtend:addCharStatus(charIndex, t, val)
  t = Allow[t];
  if (t == nil) then
    return false;
  end
  Char.SetTempData(charIndex, 'CSE:Enable', 1);
  Char.SetTempData(charIndex, "CSE:" .. t, tonumber(val));
  if (t == CONST.CHAR_最大血 or t == CONST.CHAR_最大魔) then
    Char.SetTempData(charIndex, "CSE:L" .. t, Char.GetData(charIndex, t));
  end
  return true;
end

---移除临时属性
---@param charIndex number
function CharStatusExtend:clearCharStatus(charIndex)
  Char.SetTempData(charIndex, 'CSE:Enable', nil);
  for i, v in pairs(Allow) do
    Char.SetTempData(charIndex, 'CSE:' .. v, nil);
    if (tonumber(v) == CONST.CHAR_最大血 or tonumber(v) == CONST.CHAR_最大魔) then
      Char.SetTempData(charIndex, "CSE:L" .. v, nil);
    end
  end
end

function CharStatusExtend:onStatusUpdate(charIndex)
  if (Char.GetTempData(charIndex, "CSE:Enable") == 1) then
    local t = { CONST.CHAR_攻击力, CONST.CHAR_防御力, CONST.CHAR_敏捷, CONST.CHAR_精神, CONST.CHAR_回复,
      CONST.CHAR_实际反击, CONST.CHAR_实际必杀, CONST.CHAR_实际命中, CONST.CHAR_实际闪躲, CONST.CHAR_实际抗毒, CONST.CHAR_实际抗乱,
      CONST.CHAR_实际抗忘, CONST.CHAR_实际抗睡, CONST.CHAR_实际抗石, CONST.CHAR_实际抗醉 };
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
        local vxL = tonumber(Char.GetTempData(charIndex, "CSE:L" .. v[1])) or -1;
        Char.SetTempData(charIndex, "CSE:L" .. v[1], nil);
        local vo = Char.GetData(charIndex, v[1]);
        local full = vo == Char.GetData(charIndex, v[2]) and vo == vxL;
        Char.SetData(charIndex, v[1], vo + vx);
        if full then
          Char.SetData(charIndex, v[2], vo + vx);
        end
      end
    end
  end
end

function CharStatusExtend:onUnload()
  self:logInfo('unload');
end

return CharStatusExtend;
