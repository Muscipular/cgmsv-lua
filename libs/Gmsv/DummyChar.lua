local takeBufferedChar = ffi.cast('uint32_t (__cdecl*)(int type)', 0x0042BC00);
local clearCharData = ffi.cast('int (__cdecl*)(uint32_t a1)', 0x0042BDE0);
local newChar = ffi.cast('int (__cdecl*)(uint32_t a1, int a2, int a3)', 0x00438D80);
local addCharaToMap = ffi.cast('int (__cdecl*)(int type, uint32_t charAddr, int mapId, int floor, int x, int y)', 0x00414930);
local Broadcast_ObjectState = ffi.cast('int (__cdecl*)(int objIndex)', 0x0043FEF0);
--local GetCharWorkFlag = ffi.cast('uint8_t (__cdecl*)(const char *a2, int a3, uint32_t a4, int a5)', 0x00427F10);
local dummyChar = { nilIndex = nil }

--[[
local hookedQueueSave;
local hookedQueueSave2;

local function hookQueueSaveInner(charPtr, fn)
  if charPtr > 0 then
    local charIndex = ffi.readMemoryInt32(charPtr + 4);
    if Char.IsDummy(charIndex) then
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
]]

--local function hookGetCharWorkFlag(a, b, charPtr, flag)
--  local f = GetCharWorkFlag(a, b, charPtr, flag);
--  if f ~= 0 then
--    if Char.IsDummy(ffi.readMemoryInt32(charPtr + 4)) then
--      return 0;
--    end
--  end
--  return f;
--end

--ffi.hook.hooks[tostring(0x00422991 + 1)] = hookGetCharWorkFlag;
--local hookGetCharWorkFlagPtr = ffi.cast('uint8_t (__cdecl*)(const char *a2, int a3, uint32_t a4, int a5)', hookGetCharWorkFlag)
--ffi.hook.hooks[tostring(0x00422991 + 1) .. '_1'] = hookGetCharWorkFlagPtr;
--ffi.patch(0x00422991 + 1, ffi.uint32ToArray(ffi.fnOffset(0x00422991 + 5, hookGetCharWorkFlagPtr, 'uint8_t (__cdecl*)(const char *a2, int a3, uint32_t a4, int a5)')));

-- ---@param charIndex number
--function Char.IsDummy(charIndex)
--  return Char.GetData(charIndex, CONST.CHAR_类型) == 1 and dummyChar[charIndex] ~= nil;
--end

local initCharaFn1 = ffi.cast('int (__cdecl*)(uint32_t a1, int a3)', 0x00432FE0);

---@class DummyCreateOptions
---@field mapType number
---@field floor number
---@field x number
---@field y number
---@field image number
---@field name string
---@param options DummyCreateOptions|nil
function Char.CreateDummy(options)
  local charPtr = takeBufferedChar(0)
  if charPtr < Addresses.CharaTablePTR then
    return -1;
  end
  options = options or {}
  --printAsHex('charPtr', charPtr);
  clearCharData(charPtr)
  --printAsHex('clearCharData', charPtr);
  newChar(charPtr, 11, 1)
  --printAsHex('newChar', charPtr);
  local charIndex = ffi.readMemoryInt32(charPtr + 4);
  --printAsHex('charPtr2', Addresses.CharaTablePTR + charIndex * 0x21EC);
  ffi.setMemoryInt32(charPtr + 0x5e8 + 0x12c, 1);
  ffi.setMemoryInt32(charPtr + 4 * CONST.CHAR_PlayerFD, -1);
  ffi.setMemoryInt32(charPtr, 1);
  ffi.setMemoryInt32(charPtr + 4 * CONST.CHAR_类型, 1);
  ffi.setMemoryInt32(charPtr + 4 * CONST.CHAR_地图类型, options.mapType or 0);
  ffi.setMemoryInt32(charPtr + 4 * CONST.CHAR_地图, options.floor or 777);
  ffi.setMemoryInt32(charPtr + 4 * CONST.CHAR_X, options.x or 20);
  ffi.setMemoryInt32(charPtr + 4 * CONST.CHAR_Y, options.y or 90);
  --Char.SetData(charIndex, CONST.CHAR_图类, image);
  ffi.setMemoryInt32(charPtr + 4 * CONST.CHAR_原形, options.image or 100000);
  ffi.setMemoryInt32(charPtr + 4 * CONST.CHAR_原始图档, options.image or 100000);
  ffi.setMemoryInt32(charPtr + 4 * CONST.CHAR_形象, options.image or 100000);
  ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188, -1);
  ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0xC, -1);
  ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0x18, 100);   --walkSpeed
  ffi.setMemoryInt32(charPtr + 0x7bc + 0xac, -1);
  initCharaFn1(charPtr, 1);
  local objectIndex = addCharaToMap(1, charPtr, 0, 777, 20, 90);
  ffi.setMemoryInt32(charPtr + 4 * CONST.CHAR_OBJ, objectIndex);
  Broadcast_ObjectState(objectIndex);
  dummyChar[charIndex] = charIndex;
  Char.SetDummy(charIndex);
  Char.SetData(charIndex, CONST.CHAR_名字, options.name or string.formatNumber(charPtr, 62))
  return charIndex;
end

local delCallback = NL.newEvent('DeleteDummyEvent', 0);

local function deleteDummy(charIndex)
  if Char.GetData(charIndex, CONST.CHAR_BattleIndex) >= 0 then
    Battle.ExitBattle(charIndex);
  end
  if Char.PartyNum(charIndex) > 0 then
    Char.LeaveParty(charIndex);
  end
  for i = 0, 27 do
    Char.DelItemBySlot(charIndex, i);
  end
  for i = 0, 4 do
    Char.DelSlotPet(charIndex, i);
  end
  return NL.DelNpc(charIndex)
end

local function ShutdownCallback()
  for i, charIndex in pairs(dummyChar) do
    if charIndex >= 0 then
      delCallback(charIndex);
      deleteDummy(charIndex);
    end
  end
  return 0;
end

function Char.DelDummy(charIndex)
  delCallback(charIndex);
  dummyChar[charIndex] = nil;
  return deleteDummy(charIndex)
end

local battleDataDummy = {};
--local resetCharBattleState = ffi.cast('int (__cdecl*)(uint32_t a1)', 0x0048C020);

local function battleExitEventCallback(charIndex, battleIndex, type)
  if Char.IsDummy(charIndex) then
    battleDataDummy[charIndex] = charIndex;
  end
end

local battleLoop;
battleLoop = ffi.hook.new('void (__cdecl*)()', function()
  battleLoop();
  local resetCharBattleState = ffi.cast('int (__cdecl*)(uint32_t a1)', 0x0048C020);
  for i, v in pairs(battleDataDummy) do
    if Char.GetCharPointer(i) > 0 then
      resetCharBattleState(Char.GetCharPointer(i));
    end
  end
  battleDataDummy = {}
end, 0x00487790, 5);

local function beforeCharaSaveCallback(charIndex)
  if Char.IsDummy(charIndex) then
    return 1;
  end
  return 0;
end

regGlobalEvent('ShutDownEvent', ShutdownCallback, 'DummyChar');
regGlobalEvent('BattleExitEvent', battleExitEventCallback, 'DummyChar');
regGlobalEvent('BeforeCharaSaveEvent', beforeCharaSaveCallback, 'DummyChar');
