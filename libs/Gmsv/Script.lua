local emitter = NL.newEvent('ScriptCallEvent', nil);

local function OnCallBlock(msgPtr, textPtr, npcPtr, playerPtr)
  local c = ffi.cast('uint32_t*', textPtr)[0];
  if c == 0x6361756c then
    local text = ffi.string(textPtr + 4)
    local msg = ffi.string(msgPtr)
    local npcIndex = ffi.readMemoryInt32(npcPtr + 4);
    local playerIndex = ffi.readMemoryInt32(playerPtr + 4);
    print('ScriptCall', text, Char.GetData(npcIndex, CONST.CHAR_名字), msg, Char.GetData(playerIndex, CONST.CHAR_名字));
    if text then
      emitter(npcIndex, playerIndex, text, msg);
    end
    return string.len(text) + 4;
  end
  return 0;
end

ffi.hook.inlineHook('int (__cdecl *)(char* msg, char* text, uint32_t npc, uint32_t player)', OnCallBlock, 0x0051C9AD, 7,
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
    0x8B, 0x85, 0x08, 0x00, 0x00, 0x00, --mov     eax, [ebp+0x8]
    0x50, --push eax
  },
  {
    0x59,
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

local npc_script_op_list = ffi.new('uint32_t[256]')
for i = 0, 79 do
  npc_script_op_list[i] = ffi.readMemoryDWORD(0x006288E0 + i * 4);
end
for i = 80, 255 do
  npc_script_op_list[i] = 0;
end
_G.___script_buffer_npc_script_op_list = npc_script_op_list;
npc_script_op_list[254] = 0x6361756c;
npc_script_op_list[80] = ffi.cast('uint32_t', ffi.cast('void*', npc_script_op_list)) + 4 * 254;
npc_script_op_list[253] = ffi.cast('uint32_t', ffi.cast('void*', npc_script_op_list));
local ops = ffi.cast('uint8_t*', ffi.cast('uint32_t', npc_script_op_list) + 253 * 4);
ops = { ops[0], ops[1], ops[2], ops[3] }
ffi.patch(0x0050EBC9 + 3, ops);
ffi.patch(0x0050EC0B + 3, ops);
ffi.patch(0x00516168 + 3, ops);
ffi.patch(0x00516822 + 3, ops);
ffi.patch(0x00518C80 + 3, ops);
ffi.patch(0x0051624B + 2, { 0x51 });
ffi.patch(0x0050EC06 + 2, { 0x51 });
ffi.patch(0x0051688A + 2, { 0x51 });
ffi.patch(0x00518DB1 + 2, { 0x51 });

local function setResult(value)
  ffi.setMemoryInt32(0x0111CC00, tonumber(value));
  ffi.setMemoryInt32(0x0111CC60, 1);
end

local function OnCallInline(msgPtr, textPtr, npcPtr, playerPtr, type)
  if type == 0x3a then
    local text = ffi.string(textPtr)
    local msg = ffi.string(msgPtr)
    local npcIndex = ffi.readMemoryInt32(npcPtr + 4);
    local playerIndex = ffi.readMemoryInt32(playerPtr + 4);
    local offset = string.find(text, '[><|&=!]');
    local cmd = string.sub(text, 1, offset - 1);
    print('ScriptCall Inline', cmd, Char.GetData(npcIndex, CONST.CHAR_名字), msg, Char.GetData(playerIndex, CONST.CHAR_名字));
    local n = tonumber(emitter(npcIndex, playerIndex, cmd, msg)) or 0;
    --printAsHex('result', n)
    setResult(n);
    if offset > 1 then
      return offset - 1;
    end
    return 0;
  end
  return 0;
end

ffi.hook.inlineHook('int (__cdecl *)(char* msg, char* text, uint32_t npc, uint32_t player, int type)', OnCallInline, 0x005135E8, 6,
  {
    --esi ebx eax ecx
    0x81, 0xEC, 0xAC, 0x00, 0x00, 0x00, --sub     esp, 0x0AC
    0x50, --push eax
    0x52,
    0x53,
    0x54,
    0x55,
    0x56,
    0x57,
    0x9c,
    0x50, --push eax -type
    0x51, --push ecx -player
    0x52, --push edx -npc
    0x8B, 0x85, 0x08, 0x00, 0x00, 0x00, --mov     eax, [ebp+0x8]
    0x8B, 0x00, --mov eax, [eax]
    0x50, --push eax -text    
    0x8B, 0x85, 0x0C, 0x00, 0x00, 0x00, --mov     eax, [ebp+0xC]
    0x50, --push eax -msg
  },
  {
    0x59,
    0x59,
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
    0x74, 0x11, -- je EIP + 0x13
    0x8B, 0xB5, 0x08, 0x00, 0x00, 0x00, --mov  esi, [ebp+0x8]
    0x8B, 0x36, --mov ecx, [ecx]
    0x01, 0xC6, --add  esi, eax
    0xB9, 0x47, 0x36, 0x51, 0x00, -- mov eax, 0x00513647
    0xff, 0xE1, --jmp [eax]
    0x81, 0xC4, 0xAC, 0x00, 0x00, 0x00, --add     esp, 0x0AC
    0x51, --push ecx
    0x50 + 8, --pop eax
  }
)
--]]
