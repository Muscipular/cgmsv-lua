--local getOnlineChar = ffi.cast('uint32_t (__cdecl*)(const char* cdkey, int regId)', 0x0046D920);

-----@overload fun(cdkey: string):number
-----@param cdkey string
-----@param regId number
-----@return number charIndex
--function NLG.FindUser(cdkey, regId)
--  if regId == nil then
--    local ret = SQL.querySQL("select RegistNumber from tbl_lock where CdKey = " .. SQL.sqlValue(cdkey), true)
--    if ret == nil then
--      return -1;
--    end
--    regId = tonumber(ret[1][1])
--  end
--  local charPtr = getOnlineChar(cdkey, regId);
--  if Char.IsValidCharPtr(charPtr) then
--    return ffi.readMemoryInt32(charPtr + 4);
--  end
--  return -1;
--end

--local enablePetRandomShot = nil;
--function NLG.SetPetRandomShot(enable)
--  if enablePetRandomShot == nil then
--    ffi.hook.inlineHook("int (__cdecl *)(uint32_t a)", function(charPtr)
--      if enablePetRandomShot ~= true or Char.GetDataByPtr(charPtr, CONST.CHAR_类型) ~= 3 then
--        Char.SetDataByPtr(charPtr, CONST.CHAR_BattleCom1, CONST.BATTLE_COM.BATTLE_COM_ATTACK);
--        Char.SetDataByPtr(charPtr, CONST.CHAR_BattleCom3, -1);
--      else
--        ffi.setMemoryDWORD(0x09202B10, 4);
--      end
--      return 0;
--    end, 0x0048612D, 0x14, {
--      0x60,
--      0x52, --push edx
--    }, {
--      0x58, --pop eax
--      0x61,
--    }, { ignoreOriginCode = true })
--  end
--  enablePetRandomShot = enable == true;
--end

--local criticalDmgMode = nil;
--local criticalDmgValue = 1.5;
--
-----@param mode number|boolean 0 = 普通模式 1 = 倍率模式 2 = 无 true = 普通模式 false = 无
-----@param val number 倍率，默认1.5倍
--function NLG.SetCriticalDamageAddition(mode, val)
--  if criticalDmgMode == nil then
--    ffi.hook.inlineHook("int (__cdecl *)(int a, uint32_t b, uint32_t c)", function(dmg, attacker, defence)
--      if criticalDmgMode == 0 then
--        local lvA = Char.GetDataByPtr(attacker, CONST.CHAR_等级)
--        local def = Char.GetDataByPtr(defence, CONST.CHAR_防御力)
--        local lvD = Char.GetDataByPtr(defence, CONST.CHAR_等级)
--        dmg = dmg + math.floor(def / 2 * lvA / lvD);
--      elseif criticalDmgMode == 1 then
--        dmg = criticalDmgValue * dmg;
--      end
--      return math.floor(dmg);
--    end, 0x0049E268, 0x37, {
--      0x9C, --pushfd
--      --0x60,
--      0x51, --push ecx
--      0x56, --push esi
--      0x53, --push ebx
--      0x50, --push eax
--    }, {
--      0x59, --pop ecx
--      0x59, --pop ecx
--      0x59, --pop ecx
--      0x59, --pop ecx
--      --0x61,
--      0x9D, --popfd
--    }, { ignoreOriginCode = true })
--  end
--  if type(mode) == 'boolean' then
--    if mode then
--      criticalDmgMode = 0;
--    else
--      criticalDmgMode = 2;
--    end
--  else
--    criticalDmgMode = tonumber(mode) or 0;
--  end
--  if criticalDmgMode == 1 then
--    criticalDmgValue = tonumber(val) or 1.5;
--  end
--end

local bankManTalked = ffi.cast('int (__cdecl*) (uint32_t a1, uint32_t a2)', 0x0052DE40);

function NLG.OpenBank(npcOrPlayer, player)
  if Char.IsValidCharIndex(npcOrPlayer) and Char.IsPlayer(player) then
    return bankManTalked(Char.GetCharPointer(npcOrPlayer), Char.GetCharPointer(player));
  end
  return -1;
end

