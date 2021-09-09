---获取角色的指针
function Char.GetCharPointer(charIndex)
  if Char.GetData(charIndex, CONST.CHAR_类型) == 1 then
    return Addresses.CharaTablePTR + charIndex * 0x21EC;
  end
  return 0;
end

function Char.GetWeapon(charIndex)
  local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_左手);
  if ItemIndex >= 0 and Item.isWeapon(Item.GetData(ItemIndex, CONST.道具_类型)) then
    return ItemIndex, CONST.EQUIP_左手;
  end
  ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_右手)
  if ItemIndex >= 0 and Item.isWeapon(Item.GetData(ItemIndex, CONST.道具_类型)) then
    return ItemIndex, CONST.EQUIP_右手;
  end
  return -1, -1;
end
