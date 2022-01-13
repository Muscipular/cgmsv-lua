local callback;
local callbackHeal;

---@generic T
---@param s T|nil
---@param v T
local function ifNil(s, v)
  if type(s) == 'nil' then
    return v;
  end
  return s;
end

local function callCallback(aIndex, dIndex, flag, dmg, cType)
  --print('CalcDamageCallback:', aIndex, dIndex, flag, dmg, cType or '-');
  --[[  
  print('CalcDamageCallback:', aIndex, dIndex, flag, dmg, cType or 'damage');
  if _G.type(aIndex) == 'number' then
    print(aIndex, Char.GetData(aIndex, CONST.CHAR_名字))
    print('com1', Char.GetData(aIndex, CONST.CHAR_BattleCom1))
    print('com2', Char.GetData(aIndex, CONST.CHAR_BattleCom2))
    print('com3', Char.GetData(aIndex, CONST.CHAR_BattleCom3))
  elseif type(aIndex) == 'table' then
    for i, v in ipairs(aIndex) do
      print('COMBO: ', i)
      print(v, Char.GetData(v, CONST.CHAR_名字))
      print('com1', Char.GetData(v, CONST.CHAR_BattleCom1))
      print('com2', Char.GetData(v, CONST.CHAR_BattleCom2))
      print('com3', Char.GetData(v, CONST.CHAR_BattleCom3))
    end
  end
  print(dIndex, Char.GetData(dIndex, CONST.CHAR_名字))
  print('com1', Char.GetData(dIndex, CONST.CHAR_BattleCom1))
  print('com2', Char.GetData(dIndex, CONST.CHAR_BattleCom2))
  print('com3', Char.GetData(dIndex, CONST.CHAR_BattleCom3))
  dmg = 2;
  --]]
  local nCallback = callback;
  if cType == 'heal' then
    nCallback = callbackHeal;
  end
  --print(nCallback, _G[nCallback])
  if (nCallback and _G[nCallback]) then
    local battleIndex = Char.GetData(aIndex or dIndex, CONST.CHAR_BattleIndex);
    local success, ret = pcall(_G[nCallback], ifNil(aIndex, -1), ifNil(dIndex, -1), dmg, dmg, ifNil(battleIndex, -1),
      ifNil(Char.GetData(aIndex, CONST.CHAR_BattleCom1), -1),
      ifNil(Char.GetData(aIndex, CONST.CHAR_BattleCom2), -1),
      ifNil(Char.GetData(aIndex, CONST.CHAR_BattleCom3), -1),
      ifNil(Char.GetData(dIndex, CONST.CHAR_BattleCom1), -1),
      ifNil(Char.GetData(dIndex, CONST.CHAR_BattleCom2), -1),
      ifNil(Char.GetData(dIndex, CONST.CHAR_BattleCom3), -1),
      flag
    );
    if success then
      --print('dmg', ret);
      --print(battleIndex, aIndex, dIndex, dmg, ret, ffi.cast('int',ffi.cast('int32_t', math.floor(ret))));
      if type(ret) == 'number' then
        return ret;
        --return math.floor(ret);
      end
      return dmg;
    else
      print((cType == 'heal' and 'BattleHealCalculateCallBack' or 'DamageCalculateCallBack') .. ' ERROR:', ret);
    end
  end
  --print('dmg', dmg);
  return dmg;
end

local function RegDamageCalculateEvent(Dofile, FuncName)
  if Dofile then
    local success, err = pcall(dofile, Dofile);
    if not success then
      print('RegDamageCalculateEvent dofile err:', err);
      return
    end
  end
  callback = FuncName;
end

local function RegBattleHealCalculateEvent(Dofile, FuncName)
  if Dofile then
    local success, err = pcall(dofile, Dofile);
    if not success then
      print('RegBattleHealCalculateEvent dofile err:', err);
      return
    end
  end
  callbackHeal = FuncName;
end

NL.RegBattleDamageEvent = NL.RegDamageCalculateEvent;
NL.RegDamageCalculateEvent = RegDamageCalculateEvent;
NL.RegBattleHealCalculateEvent = RegBattleHealCalculateEvent;

--[[
NL.RegDamageCalculateEvent(Dofile, FuncName)
DamageCalculateCallBack(CharIndex, DefCharIndex, OriDamage, Damage, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg)
]]

local function hookMagicDamage(attacker, defence, dmg)
  --print('hookMagicDamage', attacker, defence, dmg)
  local aIndex = ffi.readMemoryInt32(attacker + 4)
  local dIndex = ffi.readMemoryInt32(defence + 4)
  return callCallback(aIndex, dIndex, 5, dmg);
end

ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, int)', hookMagicDamage, 0x0049A51F, 6,
  {
    0x8B, 0x95, 0xE0, 0xFE, 0xFF, 0xFF, --mov     edx, [ebp+a2]
    0x9c, --pushfd
    0x60, --pushad
    0x52, --push edx
    0x53, --push ebx
    0xff, 0x75, 0x08, -- push [ebp+8]
  },
  {
    0x89, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, --mov     [ebp+a2], eax 
    0x5b, --pop
    0x5b, --pop ebx
    0x5a, --pop edx
    0x61, --popad
    0x9d, --popfd
  }
)

ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, int)', hookMagicDamage, 0x0049A16A, 6,
  {
    0x8B, 0x95, 0xE0, 0xFE, 0xFF, 0xFF, --mov     edx, [ebp+a2]   0xE0FEFFFF
    0x9c, --pushfd
    0x60, --pushad
    0x52, --push edx
    0x53, --push ebx
    0xff, 0x75, 0x08, -- push [ebp+8]
  },
  {
    0x89, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, --mov     [ebp+a2], eax 
    0x5b, --pop
    0x5b, --pop ebx
    0x5a, --pop edx
    0x61, --popad
    0x9d, --popfd
  }
)

--魔吸
ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, int)', hookMagicDamage, 0x0049A432, 6,
  {
    0xff, 0xB5, 0xE0, 0xFE, 0xFF, 0xFF, --push [ebp+a2]
    0xD9, 0xAD, 0xDC, 0xFE, 0xFF, 0xFF, -- fldcw   [ebp+var_124]
    0xDB, 0x9D, 0xE0, 0xFE, 0xFF, 0xFF, -- fistp   [ebp+a2]
    0xD9, 0xAD, 0xDE, 0xFE, 0xFF, 0xFF, -- fldcw   [ebp+var_122]
    0x9c, --pushfd
    0x60, --pushad
    0xff, 0xB5, 0xE0, 0xFE, 0xFF, 0xFF, --push [ebp+a2]
    0xff, 0x75, 0x0C, -- push [ebp+C]
    0xff, 0x75, 0x08, -- push [ebp+8]
  },
  {
    0x89, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, --mov     [ebp+a2], eax 
    0x5b, --pop
    0x5b, --pop ebx
    0x5a, --pop edx
    0x61, --popad
    0x9d, --popfd
    0xDB, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, -- fild   [ebp+a2]
    0x8F, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, -- pop   [ebp+a2]
  }
)

--魔反1
ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, int)', hookMagicDamage, 0x0049A38F, 6,
  {
    0x9c, --pushfd
    0x60, --pushad
    0xff, 0xB5, 0xE0, 0xFE, 0xFF, 0xFF, --push [ebp+a2]
    0xff, 0x75, 0x0C, -- push [ebp+C]
    0xff, 0x75, 0x08, -- push [ebp+8]
  },
  {
    0x89, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, --mov     [ebp+a2], eax 
    0x5b, --pop
    0x5b, --pop ebx
    0x5a, --pop edx
    0x61, --popad
    0x9d, --popfd
  }
)

--魔反2
ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, int)', hookMagicDamage, 0x00499FB9, 6,
  {
    0x9c, --pushfd
    0x60, --pushad
    0xff, 0xB5, 0xE0, 0xFE, 0xFF, 0xFF, --push [ebp+a2]
    0xff, 0x75, 0x0C, -- push [ebp+C]
    0xff, 0x75, 0x08, -- push [ebp+8]
  },
  {
    0x89, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, --mov     [ebp+a2], eax 
    0x5b, --pop
    0x5b, --pop ebx
    0x5a, --pop edx
    0x61, --popad
    0x9d, --popfd
  }
)

local function hookHeal(flag, attacker, defence, dmg)
  local aIndex = ffi.readMemoryInt32(attacker + 4)
  local dIndex = ffi.readMemoryInt32(defence + 4)
  return callCallback(aIndex, dIndex, flag, dmg, 'heal');
end

ffi.hook.inlineHook('int (__cdecl *)(int, uint32_t, uint32_t, int)', hookHeal, 0x004BB6E9, 6,
  {
    0x9c, --pushfd
    0x60, --pushad
    0x8B, 0x85, 0x78, 0xFD, 0xFF, 0xFF, --mov     eax, [ebp+a288]
    0x50, --push eax
    0x53, --push ebx
    0xff, 0xB5, 0x7C, 0xFD, 0xFF, 0xFF, -- push [ebp+a284]
    0x6A, 0x00, -- push 0
  },
  {
    0x89, 0x85, 0x78, 0xFD, 0xFF, 0xFF, --mov     [ebp+a288], eax 
    0x5b, --pop
    0x5b, --pop
    0x5b, --pop ebx
    0x5a, --pop edx
    0x61, --popad
    0x9d, --popfd
  }
)

ffi.hook.inlineHook('int (__cdecl *)(int, uint32_t, uint32_t, int)', hookHeal, 0x004BB199, 5,
  {
    0x9c, --pushfd
    0x60, --pushad
    0x53, --push ebx
    0x56, --push esi
    0xff, 0xB5, 0x7C, 0xFD, 0xFF, 0xFF, -- push [ebp+a284]
    0x6A, 0x02, -- push 0x02
  },
  {
    0x89, 0x85, 0x78, 0xFD, 0xFF, 0xFF, --mov     [ebp+a288], eax 
    0x5b, --pop
    0x5b, --pop
    0x5b, --pop
    0x5a, --pop
    0x61, --popad
    0x9d, --popfd
    0x8B, 0x9D, 0x78, 0xFD, 0xFF, 0xFF, --mov     ebx, [ebp+a288]
  }
)

--气绝回复
ffi.hook.inlineHook('int (__cdecl *)(int, uint32_t, uint32_t, int)', hookHeal, 0x004BC314, 6,
  {
    0xff, 0xB5, 0xE0, 0xFE, 0xFF, 0xFF, --push [ebp+var_120]
    0x9c, --pushfd
    0x60, --pushad
    0x56, --push esi
    0x53, --push ebx
    0xff, 0xB5, 0x78, 0xFD, 0xFF, 0xFF, -- push [ebp+var_288]
    0x6A, 0x03, -- push 3
  },
  {
    0x89, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, --mov     [ebp+var_120], eax 
    0x5b, --pop
    0x5b, --pop
    0x5b, --pop ebx
    0x5a, --pop edx
    0x61, --popad
    0x9d, --popfd
    0x8B, 0xB5, 0xE0, 0xFE, 0xFF, 0xFF, -- mov   esi, [ebp+var_120]
    0x8F, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, -- pop   [ebp+var_120]
  }
)

--明镜止水
ffi.hook.inlineHook('int (__cdecl *)(int, uint32_t, uint32_t, int)', hookHeal, 0x004BC9A6, 6,
  {
    0x9c, --pushfd
    0x60, --pushad
    0xff, 0xB5, 0x78, 0xFD, 0xFF, 0xFF, -- push [ebp+var_288]
    0x53, --push ebx
    0x53, --push ebx
    0x6A, 0x04, -- push 4
  },
  {
    0x89, 0x85, 0x78, 0xFD, 0xFF, 0xFF, --mov     [ebp+var_288], eax 
    0x5b, --pop
    0x5b, --pop
    0x5b, --pop ebx
    0x5a, --pop edx
    0x61, --popad
    0x9d, --popfd
  }
)

local function hookHealRecovery(defence, dmg)
  local aIndex = -1
  local dIndex = ffi.readMemoryInt32(defence + 4)
  return callCallback(aIndex, dIndex, 1, dmg, 'heal');
end

ffi.hook.inlineHook('int (__cdecl *)(uint32_t, int)', hookHealRecovery, 0x0049C8FD, 9,
  {
    --0x0F, 0xB7, 0x85, 0xDE, 0xFE, 0xFF, 0xFF, -- movzx   eax, [ebp+var_122]
    --0xB4, 0x0C, -- mov     ah, 0Ch
    --0x66, 0x89, 0x85, 0xDC, 0xFE, 0xFF, 0xFF, -- mov     [ebp+var_124], ax
    0xff, 0xB5, 0xE0, 0xFE, 0xFF, 0xFF, -- push [ebp+var_120]
    0x60, --pushad
    0x9c, --pushfd
    0xC7, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, 0x7F, 0x0E, 0x00, 0x00, -- mov  [ebp+var_120], 0x0E7F
    0xD9, 0xAD, 0xE0, 0xFE, 0xFF, 0xFF, -- fldcw  [ebp+var_120]
    0xDB, 0x9D, 0xE0, 0xFE, 0xFF, 0xFF, -- fistp   [ebp+var_120]
    --0xD9, 0xAD, 0xDE, 0xFE, 0xFF, 0xFF, -- fldcw   [ebp+var_122]
    0xff, 0xB5, 0xE0, 0xFE, 0xFF, 0xFF, -- push [ebp+var_120]
    0x53, --push ebx
  },
  {
    0x89, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, -- mov     [ebp+var_120], eax 
    0x5b, --pop
    0x5b, --pop
    0x9d, --popfd
    0x61, --popad
    --0xff, 0xB5, 0xE0, 0xFE, 0xFF, 0xFF, -- push [ebp+var_120]
    --0xC7, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, 0x7F, 0x0E, 0x00, 0x00, -- mov  [ebp+var_120], 0x0E7F
    --0xD9, 0xAD, 0xE0, 0xFE, 0xFF, 0xFF, -- fldcw  [ebp+var_120]
    --0x8F, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, -- pop [ebp+var_120]
    0xff, 0xB5, 0xE0, 0xFE, 0xFF, 0xFF, -- push [ebp+var_120]
    0xDB, 0x9D, 0xE0, 0xFE, 0xFF, 0xFF, -- fistp   [ebp+var_120]
    0x8F, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, -- pop [ebp+var_120]
    0xDB, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, -- fild    [ebp+var_120]
    0x8F, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, -- pop [ebp+var_120]
  }
)

local _fpDmg;
local function hookFpDmg(attacker, defence)
  local dmg = _fpDmg(attacker, defence);
  local aIndex = ffi.readMemoryInt32(attacker + 4)
  local dIndex = ffi.readMemoryInt32(defence + 4)
  return callCallback(aIndex, dIndex, CONST.DamageFlags.FpDamage, dmg);
end

_fpDmg = ffi.hook.new('int (__cdecl*)(uint32_t, uint32_t)', hookFpDmg, 0x0049D5B0, 5);

local function hookAttackDamage(ebp, attacker, defence, dmg)
  local flag = 0;
  local ret = ffi.readMemoryDWORD(ebp + 4);
  local comboFlag = ffi.readMemoryDWORD(ebp + 0x18);
  local ebpOld = ffi.readMemoryDWORD(ebp);
  if comboFlag == 2 then
    --print(ret);
    --flag = 10;
    --local dIndex = ffi.readMemoryInt32(defence + 4)
    --local pList = ffi.readMemoryDWORD(ebpOld + 0xC);
    --local list = {};
    --local battleIndex = Char.GetBattleIndex(dIndex)
    --for i = 0, 9 do
    --  local x = ffi.readMemoryDWORD(pList + i);
    --  if x >= 0 then
    --    local charIndex = Battle.GetPlayer(battleIndex, x);
    --    if charIndex >= 0 then
    --      table.insert(list, charIndex)
    --    end
    --  end
    --end
    --dmg = callCallback(list, dIndex, flag, dmg);
    --ffi.setMemoryInt32(ebpOld - 0x65C, dmg);
    return dmg;
  elseif ret == 0x004A59D3 then
    flag = ffi.readMemoryDWORD(ebpOld - 0x554);
  elseif ret == 0x0049E456 then
    flag = ffi.readMemoryDWORD(ebpOld - 0x234);
  elseif ret == 0x0049FD86 then
    flag = ffi.readMemoryDWORD(ebpOld - 0x64c);
  elseif ret == 0x0049FDEB then
    flag = ffi.readMemoryDWORD(ebpOld - 0x64c);
  elseif ret == 0x0049FF86 then
    flag = ffi.readMemoryDWORD(ebpOld - 0x64c);
  elseif ret == 0x004A0791 then
    flag = ffi.readMemoryDWORD(ebpOld - 0x64c);
  elseif ret == 0x004A0EE4 then
    flag = ffi.readMemoryDWORD(ebpOld - 0x77C);
  elseif ret == 0x004A200B then
    flag = ffi.readMemoryDWORD(ebpOld - 0x550);
  elseif ret == 0x004A85AE then
    flag = ffi.readMemoryDWORD(ebpOld - 0x220);
  elseif ret == 0x004A4623 then
    flag = ffi.readMemoryDWORD(ebpOld - 0x274);
  elseif ret == 0x004A88BE then
    flag = 0;
  end
  --printAsHex('hookAttackDamage', attacker, defence, dmg, flag)
  --printAsHex('ebp', ebp)
  --printAsHex('ret', ret)
  --printAsHex('ebpOld', ebpOld)
  local aIndex = ffi.readMemoryInt32(attacker + 4)
  local dIndex = ffi.readMemoryInt32(defence + 4)
  return callCallback(aIndex, dIndex, flag, dmg);
end
--BloodAttack
ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, uint32_t, int)', hookAttackDamage, 0x0049AF45, 6,
  {
    0x8B, 0x95, 0xC8, 0xFE, 0xFF, 0xFF, --mov     edx, [ebp+var_138]
    0x60, --pushad
    0x9C, --pushfd
    0x52, --push edx
    0xff, 0x75, 0x0c, -- push [ebp+c]
    0xff, 0x75, 0x08, -- push [ebp+8]
    0x55, --push ebp
  },
  {
    0x89, 0x85, 0xC8, 0xFE, 0xFF, 0xFF, --mov     [ebp+var_138], eax 
    0x5a, --pop
    0x5a, --pop
    0x5a, --pop
    0x5a, --pop edx
    0x9D, --popfd
    0x61, --popad
  }
)

ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, uint32_t, int)', hookAttackDamage, 0x0049AA87, 6,
  {
    0xDB, 0x9D, 0xE0, 0xFE, 0xFF, 0xFF, -- fistp   [ebp+var_120]
    0x9C, --pushfd
    0x50, --push eax
    0x51, --push eax
    0x53, --push eax
    0x54, --push eax
    0x55, --push eax
    0x56, --push eax
    0x57, --push eax
    0x52, --push edx
    0xff, 0x75, 0x0c, -- push [ebp+c]
    0xff, 0x75, 0x08, -- push [ebp+8]
    0x55, --push ebp
  },
  {
    0x50, 0x5a, --push eax , pop edx 
    0x89, 0x95, 0xE0, 0xFE, 0xFF, 0xFF, -- mov     [ebp+var_120], edx
    0x58, --pop 
    0x58, --pop 
    0x58, --pop
    0x58, --pop 
    0x5f, --pop eax
    0x5e, --pop eax
    0x5d, --pop eax
    0x5c, --pop eax
    0x5b, --pop eax
    0x59, --pop eax
    0x58, --pop eax
    0x9D, --popfd
    0xDB, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, -- fild    [ebp+var_120]
  }
)
--NormalAttack
ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, uint32_t, int)', hookAttackDamage, 0x0049B1CA, 6,
  {
    0x8B, 0x95, 0xE0, 0xFE, 0xFF, 0xFF, --mov     edx, [ebp+var_120]
    0x60, --pushad
    0x9C, --pushfd
    0x52, --push edx
    0xff, 0x75, 0x0c, -- push [ebp+c]
    0xff, 0x75, 0x08, -- push [ebp+8]
    0x55, --push ebp
  },
  {
    0x89, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, --mov     [ebp+var_120], eax 
    0x58, --pop 
    0x58, --pop 
    0x58, --pop 
    0x58, --pop 
    0x9d, --popfd
    0x61, --popad
  }
)

ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, uint32_t, int)', hookAttackDamage, 0x0049B66C, 6,
  {
    0x8B, 0xBD, 0xE0, 0xFE, 0xFF, 0xFF, --mov     edi, [ebp+var_120]
    0x60, --pushad
    0x9C, --pushfd
    0x57, --push edi
    0xff, 0x75, 0x0c, -- push [ebp+c]
    0xff, 0x75, 0x08, -- push [ebp+8]
    0x55, --push ebp
  },
  {
    0x89, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, --mov     [ebp+var_120], eax 
    0x58, --pop 
    0x58, --pop 
    0x58, --pop 
    0x58, --pop 
    0x9d, --popfd
    0x61, --popad
  }
)

--ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, uint32_t, int)', hookAttackDamage, 0x0049B4DF, 6,
--  {
--    0x9C, --pushfd
--    0x50, --push eax
--    0x51, --push eax
--    0x53, --push eax
--    0x54, --push eax
--    0x55, --push eax
--    0x56, --push eax
--    0x57, --push eax
--    0x52, --push edx
--    0xff, 0x75, 0x0c, -- push [ebp+c]
--    0xff, 0x75, 0x08, -- push [ebp+8]
--    0x55, --push ebp
--  },
--  {
--    0x50, 0x5a, --push eax , pop edx 
--    0x58, --pop 
--    0x58, --pop 
--    0x58, --pop 
--    0x58, --pop 
--    0x5f, --pop eax
--    0x5e, --pop eax
--    0x5d, --pop eax
--    0x5c, --pop eax
--    0x5b, --pop eax
--    0x59, --pop eax
--    0x58, --pop eax
--    0x9D, --popfd
--  }
--)

ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, uint32_t, int)', hookAttackDamage, 0x0049B406, 6,
  {
    0xD9, 0xAD, 0xDC, 0xFE, 0xFF, 0xFF, -- fldcw   [ebp+var_124]
    0xDB, 0x9D, 0xE0, 0xFE, 0xFF, 0xFF, -- fistp   [ebp+var_120]
    0xD9, 0xAD, 0xDE, 0xFE, 0xFF, 0xFF, -- fldcw   [ebp+var_122]
    0x60, --pushad
    0x9C, --pushfd
    0xff, 0xB5, 0xE0, 0xFE, 0xFF, 0xFF, -- push [ebp+var_120]
    0xff, 0x75, 0x0c, -- push [ebp+c]
    0xff, 0x75, 0x08, -- push [ebp+8]
    0x55, --push ebp
  },
  {
    0x89, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, -- mov     [ebp+var_120], eax
    0x58, --pop 
    0x58, --pop 
    0x58, --pop 
    0x58, --pop 
    0x9D, --popfd
    0x61, --popad
    0xDB, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, -- fild    [ebp+var_120]
    0x89, 0xB5, 0xE0, 0xFE, 0xFF, 0xFF, -- mov     [ebp+var_120], esi
  }
)

ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, uint32_t, int)', hookAttackDamage, 0x0049B779, 6,
  {
    0x8B, 0x95, 0xE0, 0xFE, 0xFF, 0xFF, --mov     edx, [ebp+var_120]
    0x60, --pushad
    0x9C, --pushfd
    0x52, --push edx
    0xff, 0x75, 0x0c, -- push [ebp+c]
    0xff, 0x75, 0x08, -- push [ebp+8]
    0x55, --push ebp
  },
  {
    0x89, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, --mov     [ebp+var_120], eax 
    0x58, --pop 
    0x58, --pop 
    0x58, --pop 
    0x58, --pop 
    0x9D, --popfd
    0x61, --popad
  }
)

local function hookComboAttackDamage(flag, attacker, defence, dmg)
  local aIndex = ffi.readMemoryInt32(attacker + 4)
  local dIndex = ffi.readMemoryInt32(defence + 4)
  return callCallback(aIndex, dIndex, (flag == 1 and 1 or 0) + 8, dmg);
end

ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, uint32_t, int)', hookComboAttackDamage, 0x0049F6DA, 6,
  {
    0x60, --pushad
    0x9C, --pushfd
    0xff, 0xB5, 0xA4, 0xF9, 0xFF, 0xFF, -- push [ebp+var_65C]
    0xff, 0xB5, 0xC8, 0xF9, 0xFF, 0xFF, -- push [ebp+var_638]
    0x53, --push ebx
    0xff, 0xB5, 0xB4, 0xF9, 0xFF, 0xFF, -- push [ebp+var_64C]
  },
  {
    0x89, 0x85, 0xA4, 0xF9, 0xFF, 0xFF, --mov     [ebp+var_65C], eax 
    0x58, --pop 
    0x58, --pop 
    0x58, --pop 
    0x58, --pop 
    0x9D, --popfd
    0x61, --popad
  }
)

local function hookPoisonDamage(charAddr, dmg)
  local aIndex = -1
  local dIndex = ffi.readMemoryInt32(charAddr + 4)
  return callCallback(aIndex, dIndex, 6, dmg);
end

ffi.hook.inlineHook('int (__cdecl *)(uint32_t, int)', hookPoisonDamage, 0x0049CB14, 5,
  {
    0x9C, --pushfd
    0x50, --push eax
    0x51, --push eax
    0x54, --push eax
    0x55, --push eax
    0x56, --push eax
    0x57, --push eax
    0x52, --push edx
    0x53, --push ebx
  },
  {
    0x50, 0x5a, --push eax , pop edx 
    0x5b, --pop ebx 
    0x5f, --pop
    0x5f, --pop eax
    0x5e, --pop eax
    0x5d, --pop eax
    0x5c, --pop eax
    0x59, --pop eax
    0x58, --pop eax
    0x9D, --popfd
    0xff, 0xB5, 0xE0, 0xFE, 0xFF, 0xFF, -- push [ebp+var_120]
    0xDB, 0x9D, 0xE0, 0xFE, 0xFF, 0xFF, -- fistp   [ebp+var_120]
    0x89, 0x95, 0xE0, 0xFE, 0xFF, 0xFF, -- mov     [ebp+var_120], edx
    0xDB, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, -- fild    [ebp+var_120]
    0x8F, 0x85, 0xE0, 0xFE, 0xFF, 0xFF, -- pop [ebp+var_120]
  }
)

local function hookDrunkDamage(charAddr, dmg)
  local aIndex = -1
  local dIndex = ffi.readMemoryInt32(charAddr + 4)
  return callCallback(aIndex, dIndex, 7, dmg);
end
ffi.hook.inlineHook('int (__cdecl *)(uint32_t, int)', hookDrunkDamage, 0x0049D170, 9,
  {
    0x9C, --pushfd
    0x50, --push eax
    0x51, --push ecx
    0x52, --push edx
    0x54, --push esp
    0x55, --push ebp
    0x56, --push esi
    0x57, --push edi
    0x53, --push ebx
  },
  {
    0x50, 0x5f, --push eax , pop edi 
    0x5b, --pop ebx
    0x5e, --pop  
    0x5e, --pop esi
    0x5d, --pop ebp
    0x5c, --pop esp
    0x5a, --pop edx
    0x59, --pop ecx
    0x58, --pop eax
    0x9D, --popfd
  }
)

local hookMagicMissile = function(attacker, defence, dmg)
  --printAsHex(attacker, defence, dmg)
  local aIndex = ffi.readMemoryInt32(attacker + 4)
  local dIndex = ffi.readMemoryInt32(defence + 4)
  --print(aIndex, dIndex)
  return callCallback(aIndex, dIndex, CONST.DamageFlags.Normal, dmg);
end

---精神冲击波
ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, int)', hookMagicMissile, 0x004B9C61, 5, {
  0x9C, --pushfd
  0x50, --push eax
  0x51, --push ecx
  0x52, --push edx
  0x53, --push ebx
  0x54, --push esp
  0x55, --push ebp
  0x57, --push edi
  -- protect
  0x56, --push esi
  0x53, --push ebx
  0x8B, 0x55, 0x0C, --mov edx, [ebp+0xC]
  0x52, --push edx
}, {
  0x50, --push eax
  0x58 + 6, --pop esi
  0x58, --pop eax
  0x58, --pop eax
  0x58, --pop eax
  --restore
  0x58 + 7, --pop edi
  0x58 + 5, --pop ebp
  0x58 + 4, --pop esp
  0x58 + 3, --pop ebx
  0x58 + 2, --pop edx
  0x58 + 1, --pop ecx
  0x58, --pop eax
  0x9D, --popfd
})

ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, int)', hookMagicMissile, 0x004B9D5B, 7, {
  0x9C, --pushfd
  0x50, --push eax
  0x51, --push ecx
  0x52, --push edx
  0x53, --push ebx
  0x54, --push esp
  0x55, --push ebp
  0x57, --push edi
  -- protect
  0x56, --push esi
  0x53, --push ebx
  0x8B, 0x55, 0x0C, --mov edx, [ebp+0xC]
  0x52, --push edx
}, {
  0x50, --push eax
  0x58 + 6, --pop esi
  0x58, --pop eax
  0x58, --pop eax
  0x58, --pop eax
  --restore
  0x58 + 7, --pop edi
  0x58 + 5, --pop ebp
  0x58 + 4, --pop esp
  0x58 + 3, --pop ebx
  0x58 + 2, --pop edx
  0x58 + 1, --pop ecx
  0x58, --pop eax
  0x9D, --popfd
})


--修正攻击溢出 stage 1a
ffi.patch(0x0049E207, {
  0xF7, 0xDA, 0x89, 0x7D, 0xDC, 0xDB, 0x45, 0xDC, 0xDC, 0xC8, 0x90, 0x90, 0x90,
})
--修正攻击溢出 stage 1b
ffi.patch(0x0049E0F4, {
  0x89, 0x7D, 0xDC, 0xDB, 0x45, 0xDC, 0xDC, 0xC8, 0x90, 0x90, 0x90,
})
