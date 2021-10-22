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
