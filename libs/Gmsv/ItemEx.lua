function Item.GetSlot(charIndex, itemIndex)
  for i = 8, 27 do
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

if Item.SetTimeLimit == nil then
  ---设置限时道具
  ---@param CharIndex number
  ---@param ItemIndex number
  ---@param Time number 时间秒
  function Item.SetTimeLimit(CharIndex, ItemIndex, Time)
    if Time < 0 then
      Item.SetData(ItemIndex, 0x44, 0);
      Item.SetData(ItemIndex, 0x45, 0);
    else
      Item.SetData(ItemIndex, 0x44, 1);
      Item.SetData(ItemIndex, 0x45, Time + os.time());
    end
    local slot = Item.GetSlot(CharIndex, ItemIndex)
    Item.UpItem(CharIndex, slot);
  end
end