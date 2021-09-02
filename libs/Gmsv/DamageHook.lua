local callback;
local function callCallback(aIndex, dIndex, flag, dmg)
  if (callback and _G[callback]) then
    local battleIndex = Char.GetData(aIndex, CONST.CHAR_BattleIndex);
    local success, ret = pcall(_G[callback], aIndex, dIndex, dmg, dmg, battleIndex,
      Char.GetData(aIndex, CONST.CHAR_BattleCom1),
      Char.GetData(aIndex, CONST.CHAR_BattleCom2),
      Char.GetData(aIndex, CONST.CHAR_BattleCom3),
      Char.GetData(dIndex, CONST.CHAR_BattleCom1),
      Char.GetData(dIndex, CONST.CHAR_BattleCom2),
      Char.GetData(dIndex, CONST.CHAR_BattleCom3),
      flag
    );
    if success then
      return ret;
    else
      print('DamageCalculateCallBack err:', ret);
    end
  end
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

NL.RegBattleDamageEvent = NL.RegDamageCalculateEvent;
NL.RegDamageCalculateEvent = RegDamageCalculateEvent;

--[[
NL.RegDamageCalculateEvent(Dofile, FuncName)
DamageCalculateCallBack(CharIndex, DefCharIndex, OriDamage, Damage, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg)
]]

local function hookMagicDamage(attacker, defence, dmg)
  --print('hookMagicDamage', attacker, defence, dmg)
  local aIndex = ffi.readMemoryInt32(attacker + 4)
  local dIndex = ffi.readMemoryInt32(defence + 4)
  --print(aIndex, Char.GetData(aIndex, CONST.CHAR_Ãû×Ö))
  --print('com1', Char.GetData(aIndex, CONST.CHAR_BattleCom1))
  --print('com2', Char.GetData(aIndex, CONST.CHAR_BattleCom2))
  --print('com3', Char.GetData(aIndex, CONST.CHAR_BattleCom3))
  --print(dIndex, Char.GetData(dIndex, CONST.CHAR_Ãû×Ö))
  --print('com1', Char.GetData(dIndex, CONST.CHAR_BattleCom1))
  --print('com2', Char.GetData(dIndex, CONST.CHAR_BattleCom2))
  --print('com3', Char.GetData(dIndex, CONST.CHAR_BattleCom3))
  return callCallback(aIndex, dIndex, 5, dmg);
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

local _fpDmg;
local function hookFpDmg(attacker, defence)
  local dmg = _fpDmg(attacker, defence);
  local aIndex = ffi.readMemoryInt32(attacker + 4)
  local dIndex = ffi.readMemoryInt32(defence + 4)
  return callCallback(aIndex, dIndex, 0, dmg);
end

_fpDmg = ffi.hook.new('int (__cdecl*)(uint32_t, uint32_t)', hookFpDmg, 0x0049D5B0, 5);

local function hookBloodAttackDamage(attacker, defence, dmg)
  local aIndex = ffi.readMemoryInt32(attacker + 4)
  local dIndex = ffi.readMemoryInt32(defence + 4)
  return callCallback(aIndex, dIndex, 0, dmg);
end

ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, int)', hookBloodAttackDamage, 0x0049AF45, 6,
  {
    0x8B, 0x95, 0xC8, 0xFE, 0xFF, 0xFF, --mov     edx, [ebp+var_138]
    0x50, --push eax
    0x52, --push edx
    0xff, 0x75, 0x0c, -- push [ebp+c]
    0x53, --push ebx
  },
  {
    0x89, 0x85, 0xC8, 0xFE, 0xFF, 0xFF, --mov     [ebp+var_138], eax 
    0x5b, --pop ebx
    0x5a, --pop
    0x5a, --pop edx
    0x58, --pop eax
  }
)
ffi.hook.inlineHook('int (__cdecl *)(uint32_t, uint32_t, int)', hookBloodAttackDamage, 0x0049AA8F, 6,
  {
    0x50, --push eax
    0x52, --push edx
    0xff, 0x75, 0x0c, -- push [ebp+c]
    0xff, 0x75, 0x08, --push [ebp+c]
  },
  {
    0x50, 0x5a, --push eax , pop edx 
    0x58, --pop 
    0x58, --pop
    0x58, --pop 
    0x58, --pop eax
  }
)
