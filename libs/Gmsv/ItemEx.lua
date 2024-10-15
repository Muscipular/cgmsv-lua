function Item.GetSlot(charIndex, itemIndex)
  for i = 8, Char.GetData(charIndex, CONST.对象_道具栏) - 1 do
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
      Item.SetData(ItemIndex, CONST.道具_TIMELIMIT, 0);
      Item.SetData(ItemIndex, CONST.道具_ENDTIME, 0);
    else
      Item.SetData(ItemIndex, CONST.道具_TIMELIMIT, 1);
      Item.SetData(ItemIndex, CONST.道具_ENDTIME, Time + os.time());
    end
    local slot = Item.GetSlot(CharIndex, ItemIndex)
    Item.UpItem(CharIndex, slot);
  end
end

if Item.GetTimeLimit == nil then
  ---获取限时道具剩余时间
  ---@param CharIndex number
  ---@param ItemIndex number
  function Item.GetTimeLimit(CharIndex, ItemIndex)
    local mode = Item.GetData(ItemIndex, CONST.道具_TIMELIMIT);
    local slot = Item.GetSlot(CharIndex, ItemIndex)
    if slot < 0 then
      return nil;
    end
    if mode == 2 then
      Item.UpItem(CharIndex, slot);
      mode = Item.GetData(ItemIndex, CONST.道具_TIMELIMIT);
    end
    if mode == 1 then
      local Time = Item.GetData(ItemIndex, CONST.道具_ENDTIME);
      return Time - os.time();
    end
    return nil;
  end
end