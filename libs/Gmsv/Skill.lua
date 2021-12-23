_G.Skill = _G.Skill or {}

local getSkillExpDataInt;
local expTable = {}

local MAX_SKill_Lv = 15;

local function hookGetSkillExpDataInt(index, lvIndex)
  print(index, lvIndex);
  if expTable[index] and expTable[index][lvIndex] then
    return expTable[index][lvIndex]
  end
  return getSkillExpDataInt(index, lvIndex)
end

getSkillExpDataInt = ffi.hook.new('int (__cdecl*)(int a1, int a2)', hookGetSkillExpDataInt, 0x004F5420, 6);
local getSkillExpIndex = ffi.cast('int (__cdecl*)(int a)', 0x004F5490);

function Skill.SetExpForLv(expId, lv, exp)
  if expId < 0 then
    return -1;
  end
  if lv < 1 then
    return -2;
  end
  local index = getSkillExpIndex(expId);
  if index < 0 then
    return -3;
  end
  if exp <= 0 then
    exp = nil
  else
    exp = math.floor(exp);
  end
  expTable[index] = expTable[index] or {}
  expTable[index][lv - 1] = exp;
end
ffi.patch(0x00442533 + 2, { MAX_SKill_Lv - 1 });
ffi.patch(0x00442811 + 2, { MAX_SKill_Lv - 1 });
ffi.patch(0x004F9426 + 3, { MAX_SKill_Lv - 2 });
--ffi.patch(0x0042A69D + 3, { 0x0F });
--ffi.patch(0x0042A844 + 3, { 0x0F });
ffi.patch(0x0044222F + 6, { MAX_SKill_Lv - 2 });
--ffi.patch(0x00430A8F + 6, { 0x10 });
----expand stack size
--ffi.patch(0x00430EBE + 2, { 0x0C, 0x02, 0x00, 0x00 });
--ffi.patch(0x0043090B + 2, { 0x0C, 0x02, 0x00, 0x00 });

--TODO HOOK

ffi.hook.new('int (__cdecl*)(uint32_t charPtr, int isNotify)', function(charPtr, isNotify)
  local MaxSkillSlot = Char.GetDataByPtr(charPtr, CONST.CHAR_¼¼ÄÜÀ¸);
  if MaxSkillSlot > 15 then
    MaxSkillSlot = 15;
  end
  
end, 0x00430900, 6)

Skill.SetExpForLv(2, 11, 3300);
Skill.SetExpForLv(2, 12, 3400);
Skill.SetExpForLv(2, 13, 3500);
Skill.SetExpForLv(2, 14, 3500);
Skill.SetExpForLv(2, 15, 3600);
