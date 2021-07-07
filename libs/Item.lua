function Item.GetSlot(charIndex, itemIndex)
  for i = 0, 27 do
    if Char.GetItemIndex(charIndex, i) == itemIndex then
      return i;
    end
  end
  return -1;
end
