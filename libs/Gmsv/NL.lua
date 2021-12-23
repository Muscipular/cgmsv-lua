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
local ResetCharaBattleState = NL.newEvent('ResetCharaBattleStateEvent', 0)
NL.newEvent('ItemExpansionEvent', nil)
NL.newEvent('Init', 0)

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

local emitBeforeCharaSave = NL.newEvent('BeforeCharaSaveEvent', 0)
local hookedQueueSave;
local hookedQueueSave2;
local function hookQueueSaveInner(charPtr, fn)
  if charPtr > 0 then
    local charIndex = ffi.readMemoryInt32(charPtr + 4);
    if emitBeforeCharaSave(charIndex) == 1 then
      return 1;
    end
  end
  return fn(charPtr);
end
local function hookQueueSave(charPtr)
  return hookQueueSaveInner(charPtr, hookedQueueSave);
end
local function hookQueueSave2(charPtr)
  return hookQueueSaveInner(charPtr, hookedQueueSave2);
end
hookedQueueSave = ffi.hook.new('int (__cdecl*)(uint32_t charAddr)', hookQueueSave, 0x0043B290, 9);
hookedQueueSave2 = ffi.hook.new('int (__cdecl*)(uint32_t charAddr)', hookQueueSave2, 0x0043B390, 7);

local emitCharaSaved = NL.newEvent('CharaSavedEvent', 0);
local hookOnCharaSaved;
hookOnCharaSaved = ffi.hook.new('int (__cdecl*)(int a1)', function(queueIndex)
  local queuePtr = Addresses.DBQueue + 0x58 * queueIndex
  local success = ffi.readMemoryInt32(queuePtr + 0x18) ~= 0;
  local playerPtr = ffi.readMemoryDWORD(queuePtr + 0x48);
  emitCharaSaved(ffi.readMemoryInt32(playerPtr + 4), success);
  return hookOnCharaSaved(queueIndex);
end, 0x004183E0, 5)

