---获取装备的武器 ItemIndex及位置
---@return number 装备位置 ,number 装备类型, number itemIndex
function Char.GetWeapon(charIndex)
  local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_左手);
  if ItemIndex >= 0 and Item.isWeapon(ItemIndex) then
    return ItemIndex, CONST.EQUIP_左手, Item.GetData(ItemIndex, CONST.道具_类型);
  end
  ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_右手)
  if ItemIndex >= 0 and Item.isWeapon(ItemIndex) then
    return ItemIndex, CONST.EQUIP_右手, Item.GetData(ItemIndex, CONST.道具_类型);
  end
  return -1, -1, -1;
end

---检测index是否正确
function Char.IsValidCharIndex(charIndex)
  return Char.GetData(charIndex, 0) == 1;
end

function Char.GetEmptyItemSlot(charIndex)
  if not Char.IsValidCharIndex(charIndex) then
    return -1;
  end
  if Char.GetData(charIndex, CONST.CHAR_类型) ~= CONST.对象类型_人 then
    return -1;
  end
  for i = 8, CONST.EXTITEMMAX - 1 do
    if Char.GetItemIndex(charIndex, i) == -2 then
      return i;
    end
  end
  return -2;
end

function Char.GetItemSlot(charIndex, itemIndex)
  for i = 0, CONST.EXTITEMMAX - 1 do
    if Char.GetItemIndex(charIndex, i) == itemIndex then
      return i;
    end
  end
  return -1;
end

function Char.GetEmptyPetSlot(charIndex)
  if not Char.IsValidCharIndex(charIndex) then
    return -1;
  end
  for i = 0, 4 do
    if Char.GetPet(charIndex, i) < 0 then
      return i;
    end
  end
  return -2;
end

function Char.IsPet(charIndex)
  if charIndex >= 0 then
    if Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_宠 then
      return true
    end
  end
  return false;
end

function Char.IsPlayer(charIndex)
  if charIndex >= 0 then
    if Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人 then
      return true
    end
  end
  return false;
end

function Char.IsEnemy(charIndex)
  if charIndex >= 0 then
    if Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_怪 then
      return true
    end
  end
  return false;
end

function Char.IsNpc(charIndex)
  if charIndex >= 0 then
    if Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_NPC then
      return true
    end
  end
  return false;
end
