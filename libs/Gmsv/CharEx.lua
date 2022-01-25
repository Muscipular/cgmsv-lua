---获取装备的武器 ItemIndex及位置
---@return number,number,number itemIndex, 装备位置, 装备类型
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

function Char.UnsetWalkPostEvent(charIndex)
  Char.SetData(charIndex, 1588, 0)
  Char.SetData(charIndex, 1663, 0)
  Char.SetData(charIndex, 1985, 0)
end

function Char.UnsetWalkPreEvent(charIndex)
  Char.SetData(charIndex, 1587, 0)
  Char.SetData(charIndex, 1631, 0)
  Char.SetData(charIndex, 1984, 0)
end

function Char.UnsetPostOverEvent(charIndex)
  Char.SetData(charIndex, 1759, 0)
  Char.SetData(charIndex, 1988, 0)
  Char.SetData(charIndex, 1598, 0)
end

function Char.UnsetLoopEvent(charIndex)
  Char.SetData(charIndex, 1823, 0)
  Char.SetData(charIndex, 1990, 0)
  Char.SetData(charIndex, 1995, 0)
  Char.SetData(charIndex, 1996, 0)
  Char.SetData(charIndex, 1597, 0)
end

function Char.UnsetTalkedEvent(charIndex)
  Char.SetData(charIndex, 1887, 0)
  Char.SetData(charIndex, 1992, 0)
  Char.SetData(charIndex, 1592, 0)
end

function Char.UnsetWindowTalkedEvent(charIndex)
  Char.SetData(charIndex, 1951, 0)
  Char.SetData(charIndex, 1994, 0)
  Char.SetData(charIndex, 1596, 0)
end

function Char.UnsetItemPutEvent(charIndex)
  Char.SetData(charIndex, 1855, 0)
  Char.SetData(charIndex, 1991, 0)
  Char.SetData(charIndex, 1594, 0)
end

function Char.UnsetWatchEvent(charIndex)
  Char.SetData(charIndex, 1695, 0)
  Char.SetData(charIndex, 1986, 0)
  Char.SetData(charIndex, 1589, 0)
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
  for i = 8, 27 do
    if Char.GetItemIndex(charIndex, i) == -2 then
      return i;
    end
  end
  return -2;
end

function Char.GetItemSlot(charIndex, itemIndex)
  for i = 0, 27 do
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
