_G.Item = Item or {}
function Item.GetSlot(charIndex, itemIndex)
  for i = 0, 27 do
    if Char.GetItemIndex(charIndex, i) == itemIndex then
      return i;
    end
  end
  return -1;
end

Item.Types = {}

Item.Types.WeaponType = {
  CONST.ITEM_TYPE_剑,
  CONST.ITEM_TYPE_斧,
  CONST.ITEM_TYPE_枪,
  CONST.ITEM_TYPE_杖,
  CONST.ITEM_TYPE_弓,
  CONST.ITEM_TYPE_小刀,
  CONST.ITEM_TYPE_回力镖,
};

Item.Types.RangerWeaponType = {
  CONST.ITEM_TYPE_弓,
  CONST.ITEM_TYPE_小刀,
  CONST.ITEM_TYPE_回力镖,
};

Item.Types.ArmourType = {
  CONST.ITEM_TYPE_盾,
  CONST.ITEM_TYPE_盔,
  CONST.ITEM_TYPE_帽,
  CONST.ITEM_TYPE_铠,
  CONST.ITEM_TYPE_衣,
  CONST.ITEM_TYPE_袍,
  CONST.ITEM_TYPE_靴,
  CONST.ITEM_TYPE_鞋,
};

Item.Types.AccessoryType = {
  CONST.ITEM_TYPE_手环,
  CONST.ITEM_TYPE_乐器,
  CONST.ITEM_TYPE_项链,
  CONST.ITEM_TYPE_戒指,
  CONST.ITEM_TYPE_头带,
  CONST.ITEM_TYPE_耳环,
  CONST.ITEM_TYPE_护身符,
};

Item.Types.CrystalType = CONST.ITEM_TYPE_水晶;

function Item.Types.isWeapon(type)
  return table.indexOf(Item.Types.WeaponType, type) > 0
end

function Item.Types.isArmour(type)
  return table.indexOf(Item.Types.ArmourType, type) > 0
end

function Item.Types.isAccessory(type)
  return table.indexOf(Item.Types.AccessoryType, type) > 0
end

function Item.Types.isCrystal(type)
  return Item.Types.CrystalType == type
end

function Item.isWeapon(itemIndex)
  return table.indexOf(Item.Types.WeaponType, Item.GetData(itemIndex, CONST.道具_类型)) > 0
end

function Item.isArmour(itemIndex)
  return table.indexOf(Item.Types.ArmourType, Item.GetData(itemIndex, CONST.道具_类型)) > 0
end

function Item.isAccessory(itemIndex)
  return table.indexOf(Item.Types.AccessoryType, Item.GetData(itemIndex, CONST.道具_类型)) > 0
end

function Item.isCrystal(itemIndex)
  return Item.Types.CrystalType == Item.GetData(itemIndex, CONST.道具_类型)
end

local function hookGetItemText(itemIndex, _type, msg)
  local newMsg = NL.EmitItemExpansionEvent(itemIndex, _type, ffi.string(msg));
  if type(newMsg) == 'string' then
    return newMsg;
  end
  return msg;
end

ffi.hook.inlineHook('const char* (__cdecl *)(int itemIndex, int type, const char* s)', hookGetItemText, 0x004CD3EE, 9, {
  0x89, 0x44, 0x24, 0x08, -- mov [esp + 8], eax
  0xC7, 0x44, 0x24, 0x04, 0x01, 0x00, 0x00, 0x00, -- mov [esp + 8], 1
  0x8B, 0x85, 0x10, 0x00, 0x00, 0x00, -- mov eax, [ebp + 0x10]
  0x89, 0x04, 0x24, -- arg itemIndex
}, {})
ffi.hook.inlineHook('const char* (__cdecl *)(int itemIndex, int type, const char* s)', hookGetItemText, 0x004CD5BD, 6, {
  0x89, 0x44, 0x24, 0x08, -- mov [esp + 8], eax
  0xC7, 0x44, 0x24, 0x04, 0x02, 0x00, 0x00, 0x00, -- mov [esp + 8], 1
  0x8B, 0x85, 0x10, 0x00, 0x00, 0x00, -- mov eax, [ebp + 0x10]
  0x89, 0x04, 0x24, -- arg itemIndex
}, {})

function Item.SetTimeLimit(CharIndex, ItemIndex, Time)
  if Time < 0 then
    Item.SetData(ItemIndex, 44, 0);
    Item.SetData(ItemIndex, 45, 0);
  else
    Item.SetData(ItemIndex, 44, 1);
    Item.SetData(ItemIndex, 44, Time + os.time());
  end
  local slot = Item.GetSlot(CharIndex, ItemIndex)
  Item.UpItem(CharIndex, slot);
end

function Item.GetTimeLimit(CharIndex, ItemIndex)
  local mode = Item.SetData(ItemIndex, 44);
  local slot = Item.GetSlot(CharIndex, ItemIndex)
  if slot < 0 then
    return nil;
  end
  if mode == 2 then
    Item.UpItem(CharIndex, slot);
    mode = Item.SetData(ItemIndex, 44);
  end
  if mode == 1 then
    local Time = Item.SetData(ItemIndex, 45);
    return Time - os.time();
  end
  return nil;
end
