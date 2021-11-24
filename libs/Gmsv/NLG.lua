local getOnlineChar = ffi.cast('uint32_t (__cdecl*)(const char* cdkey, int regId)', 0x0046D920);

---@param cdkey string
---@param regId number
function NLG.FindUser(cdkey, regId)
  if regId == nil then
    local ret = SQL.querySQL("select RegistNumber from tbl_lock where CdKey = " .. SQL.sqlValue(cdkey), true)
    regId = tonumber(ret[1][1])
  end
  local charPtr = getOnlineChar(cdkey, regId);
  if Char.IsValidCharPtr(charPtr) then
    return ffi.readMemoryInt32(charPtr + 4);
  end
  return -1;
end

local enablePetRandomShot = nil;
function NLG.SetPetRandomShot(enable)
  if enablePetRandomShot == nil then
    ffi.hook.inlineHook("int (__cdecl *)(uint32_t a)", function(charPtr)
      if enablePetRandomShot ~= true or Char.GetDataByPtr(charPtr, CONST.CHAR_类型) ~= 3 then
        Char.SetDataByPtr(charPtr, CONST.CHAR_BattleCom1, CONST.BATTLE_COM.BATTLE_COM_ATTACK);
        Char.SetDataByPtr(charPtr, CONST.CHAR_BattleCom3, -1);
      end
      return 0;
    end, 0x0048612D, 14, {
      0x60,
      0x52, --push edx
    }, {
      0x58, --pop eax
      0x61,
    })
  end
  enablePetRandomShot = enable == true;
end

local disableCriticalDmg = nil;
---@param enable boolean
function NLG.SetCriticalDamageAddition(enable)
  if disableCriticalDmg == nil then
    ffi.hook.inlineHook("int (__cdecl *)(int a, uint32_t b, uint32_t c)", function(dmg, attacker, defence)
      if disableCriticalDmg ~= true then
        local lvA = Char.GetDataByPtr(attacker, CONST.CHAR_等级)
        local def = Char.GetDataByPtr(defence, CONST.CHAR_防御力)
        local lvD = Char.GetDataByPtr(defence, CONST.CHAR_等级)
        dmg = dmg + tonumber(tostring(math.floor(def / 2 * lvA / lvD)));
      end
      return dmg;
    end, 0x0049E26B, 0x2e, {
      --0x60,
      0x51, --push ecx
      0x56, --push esi
      0x53, --push ebx
      0x50, --push eax
    }, {
      0x59, --pop ecx
      0x59, --pop ecx
      0x59, --pop ecx
      0x59, --pop ecx
      --0x61,
    })
  end
  disableCriticalDmg = enable == true;
end 
