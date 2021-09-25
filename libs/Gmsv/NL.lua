local hookOnCharaDeleted;
local _CharaDeletedEventCallback;
local function CharaDeletedCallback(cdKey, regNum)
  print('onCharaDeletedCallback', cdKey, regNum);
  if _G and _G[_CharaDeletedEventCallback] then
    local r, msg = pcall(_G[_CharaDeletedEventCallback], cdKey, regNum);
    if not r then
      print('[LUA] CharaDeletedEventCallback error: ' .. (msg or ''))
    end
  end
end

hookOnCharaDeleted = ffi.hook.new('int (__cdecl*)(int a1)', function(queueIndex)
  local queuePtr = Addresses.DBQueue + 0x58 * queueIndex
  local option = ffi.readMemoryInt32(queuePtr + 0x14);
  local cdKey = ffi.readMemoryString(queuePtr + 0x28);
  CharaDeletedCallback(cdKey, option)
  return hookOnCharaDeleted(queueIndex);
end, 0x004180E0, 5)

function NL.RegCharaDeletedEvent(luaFile, callback)
  if luaFile then
    local r, msg = pcall(dofile, luaFile)
    if not r then
      print('[LUA] NL.RegCharaDeletedEvent error: ' .. (msg or ''))
    end
  end
  _CharaDeletedEventCallback = callback;
end 
