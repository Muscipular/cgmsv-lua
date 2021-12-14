_G.Item = Item or {}

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
    Item.SetData(ItemIndex, 45, Time + os.time());
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
    mode = Item.GetData(ItemIndex, 44);
  end
  if mode == 1 then
    local Time = Item.SetData(ItemIndex, 45);
    return Time - os.time();
  end
  return nil;
end

---@param itemIndex number µÀ¾ßIndex
---@param charIndex number ½ÇÉ«Index
function Item.SetCharPointer(itemIndex, charIndex)
  local ch = Char.GetCharPointer(charIndex)
  if ch <= 0 then
    return -1;
  end
  if itemIndex < 0 then
    return -2;
  end
  if Addresses.ItemExistsTableSize <= itemIndex then
    return -2;
  end
  local itemPtr = Addresses.ItemExistsTablePTR + itemIndex * 0x318;
  if ffi.readMemoryDWORD(itemPtr) ~= 1 then
    return -2;
  end
  ffi.setMemoryDWORD(itemPtr + 0x2e8, ch);
  return 1;
end
