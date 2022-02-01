_G.Item = Item or {}
--
--local function hookGetItemText(itemIndex, _type, msg)
--  local newMsg = NL.EmitItemExpansionEvent(itemIndex, _type, ffi.string(msg));
--  if type(newMsg) == 'string' then
--    return newMsg;
--  end
--  return msg;
--end
--
--ffi.hook.inlineHook('const char* (__cdecl *)(int itemIndex, int type, const char* s)', hookGetItemText, 0x004CD3EE, 9, {
--  0x89, 0x44, 0x24, 0x08, -- mov [esp + 8], eax
--  0xC7, 0x44, 0x24, 0x04, 0x01, 0x00, 0x00, 0x00, -- mov [esp + 8], 1
--  0x8B, 0x85, 0x10, 0x00, 0x00, 0x00, -- mov eax, [ebp + 0x10]
--  0x89, 0x04, 0x24, -- arg itemIndex
--}, {})
--ffi.hook.inlineHook('const char* (__cdecl *)(int itemIndex, int type, const char* s)', hookGetItemText, 0x004CD5BD, 6, {
--  0x89, 0x44, 0x24, 0x08, -- mov [esp + 8], eax
--  0xC7, 0x44, 0x24, 0x04, 0x02, 0x00, 0x00, 0x00, -- mov [esp + 8], 2
--  0x8B, 0x85, 0x10, 0x00, 0x00, 0x00, -- mov eax, [ebp + 0x10]
--  0x89, 0x04, 0x24, -- arg itemIndex
--}, {})

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

---获取限时道具剩余时间
---@param CharIndex number
---@param ItemIndex number
function Item.GetTimeLimit(CharIndex, ItemIndex)
  local mode = Item.SetData(ItemIndex, 0x44);
  local slot = Item.GetSlot(CharIndex, ItemIndex)
  if slot < 0 then
    return nil;
  end
  if mode == 2 then
    Item.UpItem(CharIndex, slot);
    mode = Item.GetData(ItemIndex, 0x44);
  end
  if mode == 1 then
    local Time = Item.SetData(ItemIndex, 0x45);
    return Time - os.time();
  end
  return nil;
end

---@param itemIndex number 道具Index
---@param charIndex number 角色Index
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

---@param itemIndex number 道具Index
function Item.GetCharPointer(itemIndex)
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
  return ffi.readMemoryInt32(itemPtr + 0x2e8);
end

---@param itemIndex number 道具Index
function Item.RemoveCharPointer(itemIndex)
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
  ffi.setMemoryDWORD(itemPtr + 0x2e8, 0);
  return 1;
end

local makeItem = ffi.cast('int (__cdecl *)(int number)', 0x004CA750);
local setWorkInt = ffi.cast('int (__cdecl*) (int itemIndex, int dataLine, int value)', 0x004C89B0);

function Item.MakeItem(itemId)
  local itemIndex = makeItem(itemId)
  if itemIndex >= 0 then
    setWorkInt(itemIndex, 0, -1);
  end
  return itemIndex;
end

local removeItem = ffi.cast('void (__cdecl *)(int itemIndex, const char *a4, int a5)', 0x004C8370);

function Item.UnlinkItem(itemIndex)
  local charPtr = Item.GetCharPointer(itemIndex);
  if charPtr > 0 then
    local charIndex = ffi.readMemoryInt32(charPtr + 4);
    for i = 0, 27 do
      if Char.GetItemIndex(charIndex, i) == itemIndex then
        return Char.DelItemBySlot(charIndex, i)
      end
    end
    Item.RemoveCharPointer(itemIndex);
  end
  removeItem(itemIndex, "Item.lua UnlinkItem", 0);
  return 0;
end

---移除深蓝九号等级限制
---@param value boolean
function Item.TohelosIgnoreEnemyLv(value)
  if value then
    ffi.patch(0x004890B3, { 0x90, 0x90 });
  else
    ffi.patch(0x004890B3, { 0x7F, 0x22 });
  end
end 
