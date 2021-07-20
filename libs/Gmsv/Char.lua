---获取角色的指针
function Char.GetCharPointer(charIndex)
  if Char.GetData(charIndex, CONST.CHAR_类型) == 1 then
    return Addresses.CharaTablePTR + charIndex * 0x21EC;
  end
  return 0;
end
