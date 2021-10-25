local emitter = NL.newEvent('ScriptCall', nil);

local function OnCallBlock(textPtr, npcPtr, playerPtr)
  local text = ffi.string(textPtr)
  local npcIndex = ffi.readMemoryInt32(npcPtr + 4);
  local playerIndex = ffi.readMemoryInt32(playerPtr + 4);
  printAsHex(text, npcPtr, npcIndex, playerPtr, playerIndex)
  if string.lower(string.sub(text, 1, 4)) == 'luac' then
    local s = string.sub(text, 5)
    print('ScriptCall', s, Char.GetData(npcIndex, CONST.CHAR_名字), Char.GetData(playerIndex, CONST.CHAR_名字));
    if s then
      emitter(npcIndex, playerIndex, s);
    end
    return string.len(text);
  end
  return 0;
end

ffi.hook.inlineHook('int (__cdecl *)(char* text, uint32_t npc, uint32_t player)', OnCallBlock, 0x0051C9AD, 7,
  {
    0x51,
    0x52,
    0x53,
    0x54,
    0x55,
    0x56,
    0x57,
    0x9c,
    0x57, --push edi
    0x8B, 0x85, 0x3C, 0xFB, 0xFF, 0xFF, --mov     eax, [ebp-0x4C4]
    0x50, --push eax
    0x56, --push esi
  },
  {
    0x59,
    0x59,
    0x59,
    0x9d,
    0x57 + 8,
    0x56 + 8,
    0x55 + 8,
    0x54 + 8,
    0x53 + 8,
    0x52 + 8,
    0x51 + 8,
    0x85, 0xC0, -- test eax, eax
    0x74, 0x0D, -- je EIP + 0x0D
    0x01, 0x85, 0x44, 0xFB, 0xFF, 0xFF, -- add  [ebp-0x4bc], eax
    0xB8, 0xD1, 0x9A, 0x51, 0x00, -- mov eax, 0x00519AD1
    0xff, 0xE0, --jmp eax
  }
)
--[[
local function OnCallInline(textPtr, npcPtr, playerPtr)
  local text = ffi.string(textPtr)
  local npcIndex = ffi.readMemoryInt32(npcPtr + 4);
  local playerIndex = ffi.readMemoryInt32(playerPtr + 4);
  printAsHex('inline', text, npcPtr, npcIndex, playerPtr, playerIndex)
  if string.lower(string.sub(text, 1, 4)) == 'luac' then
    local s = string.sub(text, 5)
    print('ScriptCall 2', s, Char.GetData(npcIndex, CONST.CHAR_名字), Char.GetData(playerIndex, CONST.CHAR_名字));
    if s then
      return emitter(npcIndex, playerIndex, s) or 0;
    end
    return 1;
  end
  return 1;
end

ffi.hook.inlineHook('int (__cdecl *)(char* text, uint32_t npc, uint32_t player)', OnCallInline, 0x00516155, 7,
  {
    0x51,
    0x52,
    0x53,
    0x54,
    0x55,
    0x56,
    0x57,
    0x9c,
    0x8B, 0x85, 0x70, 0xFF, 0xFF, 0xFF, --mov     eax, [ebp-0x4C4]
    0x50, --push eax
    0x8B, 0x85, 0x64, 0xFF, 0xFF, 0xFF, --mov     eax, [ebp-0x4C4]
    0x50, --push eax
    0x8B, 0x85, 0x74, 0xFF, 0xFF, 0xFF, --mov     eax, [ebp-0x4C4]
    0x50, --push eax
  },
  {
    0x59,
    0x59,
    0x59,
    0x9d,
    0x57 + 8,
    0x56 + 8,
    0x55 + 8,
    0x54 + 8,
    0x53 + 8,
    0x52 + 8,
    0x51 + 8,
    0x85, 0xC0, -- test eax, eax
    0x74, 0x0D, -- je EIP + 0x0D
    0x01, 0x85, 0x44, 0xFB, 0xFF, 0xFF, -- add  [ebp-0x4bc], eax
    0xB8, 0xD1, 0x9A, 0x51, 0x00, -- mov eax, 0x00519AD1
    0xff, 0xE0, --jmp [eax]
  }
)
--]]
