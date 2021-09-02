local function hookMagicDamage(attacker, defence, dmg)
  print('hookMagicDamage', attacker, defence, dmg)
  local aIndex = ffi.readMemoryInt32(attacker + 4)
  local dIndex = ffi.readMemoryInt32(defence + 4)
  print(aIndex, Char.GetData(aIndex, CONST.CHAR_Ãû×Ö))
  print('com1', Char.GetData(aIndex, CONST.CHAR_BattleCom1))
  print('com2', Char.GetData(aIndex, CONST.CHAR_BattleCom2))
  print('com3', Char.GetData(aIndex, CONST.CHAR_BattleCom3))
  print(dIndex, Char.GetData(dIndex, CONST.CHAR_Ãû×Ö))
  print('com1', Char.GetData(dIndex, CONST.CHAR_BattleCom1))
  print('com2', Char.GetData(dIndex, CONST.CHAR_BattleCom2))
  print('com3', Char.GetData(dIndex, CONST.CHAR_BattleCom3))
  return dmg;
end

ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, int)', hookMagicDamage, 0x0049A51F, 6,
  {
    0x8B, 0x95, 0xE0, 0xFE, 0xFF, 0xFF, --mov     edx, [ebp+a2]
    0x52, --push edx
    0x53, --push ebx
    0xff, 0x75, 0x08, -- push [ebp+8]
  },
  {
    0x89, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, --mov     [ebp+a2], eax 
    0x5b, --pop
    0x5b, --pop ebx
    0x5a, --pop edx
  }
)
ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, int)', hookMagicDamage, 0x0049A16A, 6,
  {
    0x8B, 0x95, 0xE0, 0xFE, 0xFF, 0xFF, --mov     edx, [ebp+a2]   0xE0FEFFFF
    0x50, --push eax
    0x52, --push edx
    0x53, --push ebx
    0xff, 0x75, 0x08, -- push [ebp+8]
  },
  {
    0x89, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, --mov     [ebp+a2], eax 
    0x5b, --pop
    0x5b, --pop ebx
    0x5a, --pop edx
    0x58, --pop eax
  }
)
