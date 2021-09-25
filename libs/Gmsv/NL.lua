---@param event string
---@param defaultRet any
---@return function
function NL.newEvent(event, defaultRet)
  local cb;
  NL['Reg' .. event] = function(luaFile, callback)
    if luaFile then
      local r, msg = pcall(dofile, luaFile)
      if not r then
        print('[LUA] NL.Reg' .. event .. ' error: ' .. (msg or ''))
      end
    end
    cb = callback;
  end
  NL['Emit' .. event] = function(...)
    if cb and _G[cb] then
      local r, msg = pcall(_G[cb], ...)
      if r then
        return msg
      else
        print('[LUA] NL.' .. event .. 'Callback error: ' .. (msg or ''))
      end
    end
    return defaultRet;
  end
  return NL['Emit' .. event];
end

local CharaDeletedCallback = NL.newEvent('CharaDeletedEvent', 0)
local ResetCharaBattleState = NL.newEvent('ResetCharaBattleState', 0)

local hookOnCharaDeleted;
hookOnCharaDeleted = ffi.hook.new('int (__cdecl*)(int a1)', function(queueIndex)
  local queuePtr = Addresses.DBQueue + 0x58 * queueIndex
  local option = ffi.readMemoryInt32(queuePtr + 0x14);
  local cdKey = ffi.readMemoryString(queuePtr + 0x28);
  CharaDeletedCallback(cdKey, option)
  return hookOnCharaDeleted(queueIndex);
end, 0x004180E0, 5)

local resetCharBattleState;
resetCharBattleState = ffi.hook.new('int (__cdecl*)(uint32_t a1)', function(charPtr)
  local ret = resetCharBattleState(charPtr);
  if Char.IsValidCharPtr(charPtr) then
    ResetCharaBattleState(ffi.readMemoryInt32(charPtr + 4))
  end
  return ret;
end, 0x0048C020, 5);

