---获取角色的指针
function Char.GetCharPointer(charIndex)
  if Char.GetData(charIndex, 0) == 1 then
    return Addresses.CharaTablePTR + charIndex * 0x21EC;
  end
  return 0;
end

---获取装备的武器 ItemIndex及位置
---@return number,number itemIndex, 装备位置
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

local giveItem = Char.GiveItem;
Char.GiveItem = function(CharIndex, ItemID, Amount, ShowMsg)
  ShowMsg = type(ShowMsg) ~= 'boolean' and true or ShowMsg;
  if not ShowMsg then
    ffi.patch(0x0058223B, { 0x90, 0x90, 0x90, 0x90, 0x90, });
  end
  local ret = giveItem(CharIndex, ItemID, Amount)
  if not ShowMsg then
    ffi.patch(0x0058223B, { 0xE8, 0x90, 0x46, 0xEB, 0xFF, });
  end
  return ret;
end

local delItem = Char.DelItem;
Char.DelItem = function(CharIndex, ItemID, Amount, ShowMsg)
  ShowMsg = type(ShowMsg) ~= 'boolean' and true or ShowMsg;
  if not ShowMsg then
    ffi.patch(0x0058281B, { 0x90, 0x90, 0x90, 0x90, 0x90, });
  end
  local ret = delItem(CharIndex, ItemID, Amount)
  if not ShowMsg then
    ffi.patch(0x0058281B, { 0xE8, 0xB0, 0x40, 0xEB, 0xFF, });
  end
  return ret;
end

local cDeleteCharItem = ffi.cast('int (__cdecl*)(const char * str1, int lineNo, uint32_t charAddr, uint32_t slot)', 0x00428390)
local cRemoveItem = ffi.cast('void (__cdecl *)(int itemIndex, const char * str, int lineNo)', 0x004C8370)
---根据位置删除物品
function Char.DelItemBySlot(CharIndex, Slot)
  local charPtr = Char.GetCharPointer(CharIndex);
  if charPtr < Addresses.CharaTablePTR then
    return -1;
  end
  local itemIndex = Char.GetItemIndex(CharIndex, Slot);
  if itemIndex < 0 then
    return -2;
  end
  cDeleteCharItem('LUA cDeleteCharItem', 0, charPtr, Slot);
  cRemoveItem(itemIndex, 'LUA cDeleteCharItem', 0);
  Item.UpItem(CharIndex, Slot)
  return 0;
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
  Char.SetData(charIndex, 0x1F10 / 4, 0)
  Char.SetData(charIndex, (0x18C8 + 0x30) / 4, 0)
end

function Char.UnsetLoopEvent(charIndex)
  Char.SetData(charIndex, 0x1C7C / 4, 0)
  Char.SetData(charIndex, 0x1F18 / 4, 0)
  Char.SetData(charIndex, 0x1F2C / 4, 0)
  Char.SetData(charIndex, 0x1F30 / 4, 0)
  Char.SetData(charIndex, (0x18C8 + 0x2C) / 4, 0)
end

function Char.UnsetTalkedEvent(charIndex)
  Char.SetData(charIndex, 0x1D7C / 4, 0)
  Char.SetData(charIndex, 0x1F20 / 4, 0)
  Char.SetData(charIndex, (0x18C8 + 0x18) / 4, 0)
end

function Char.UnsetWindowTalkedEvent(charIndex)
  Char.SetData(charIndex, 0x1E7C / 4, 0)
  Char.SetData(charIndex, 0x1F28 / 4, 0)
  Char.SetData(charIndex, (0x18C8 + 0x28) / 4, 0)
end

function Char.UnsetItemPutEvent(charIndex)
  Char.SetData(charIndex, 0x1CFC / 4, 0)
  Char.SetData(charIndex, 0x1F1C / 4, 0)
  Char.SetData(charIndex, (0x18C8 + 0x20) / 4, 0)
end

function Char.UnsetWatchEvent(charIndex)
  Char.SetData(charIndex, 0x1A7C / 4, 0)
  Char.SetData(charIndex, 0x1F08 / 4, 0)
  Char.SetData(charIndex, (0x18C8 + 0xC) / 4, 0)
end

local checkPartyMemberCount = ffi.cast('int (__cdecl*)(uint32_t a1)', 0x00437C10);
local joinParty_A = ffi.cast('uint32_t (__cdecl*)(uint32_t source, uint32_t target)', 0x00438140);
local sendJoinPartyResult = ffi.cast('int (__cdecl*)(uint32_t fd, int a2, int a3)', 0x005564D0);

---加入组队，无视组队开关及距离
function Char.JoinParty(sourceIndex, targetIndex)
  if Char.GetData(targetIndex, CONST.CHAR_类型) ~= CONST.对象类型_人 then
    return -1;
  end
  if Char.GetData(sourceIndex, CONST.CHAR_类型) ~= CONST.对象类型_人 then
    return -2;
  end

  if checkPartyMemberCount(Char.GetCharPointer(targetIndex)) < 0 then
    return -3;
  end
  joinParty_A(Char.GetCharPointer(sourceIndex), Char.GetCharPointer(targetIndex));
  return sendJoinPartyResult(Char.GetData(sourceIndex, CONST.CHAR_PlayerFD), 1, 1);
end

local _moveChara = ffi.cast('int (__cdecl *)(uint32_t charAddr, int x, int y, const char *walkArray, int leader_mb)', 0x00447370)
local walkDirection = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'e' }

---移动角色、NPC
---@param charIndex number
---@param walkArray number[] 移动列表，取值0-7对应 CONST里面的方向，不建议超过5次移动
function Char.MoveArray(charIndex, walkArray)
  if Char.GetData(charIndex, 0) ~= 1 then
    return -1;
  end
  local charPtr = Char.GetCharPointer(charIndex);
  if Char.PartyNum(charIndex) > 0 and Char.GetPartyMember(charIndex, 0) ~= charIndex then
    return -2;
  end
  if type(walkArray) ~= 'table' then
    walkArray = '';
  else
    walkArray = table.join(table.map(walkArray, function(n)
      n = tonumber(n)
      if n == nil then
        return ''
      end
      return walkDirection[tonumber(n) + 1] or ''
    end), '')
  end
  _moveChara(charPtr, Char.GetData(charIndex, CONST.CHAR_X), Char.GetData(charIndex, CONST.CHAR_Y), walkArray, 1);
  return 1;
end

local leaveParty = ffi.cast('int (__cdecl*)(uint32_t a1)', 0x00438B70);

---离开队伍
function Char.LeaveParty(charIndex)
  if Char.GetData(charIndex, 0) ~= 1 then
    return -1;
  end
  local charPtr = Char.GetCharPointer(charIndex);
  return leaveParty(charPtr);
end

local _moveItem = ffi.cast('int (__cdecl*)(uint32_t a1, int itemSlot, int targetSlot, int amount)', 0x00449E80)

---移动物品
---@param charIndex number
---@param fromSlot number 移动那个物品，取值0-27
---@param toSlot number 移动到那个位置, 取值0-27
---@param amount number 数量，整体移动取值可为-1
function Char.MoveItem(charIndex, fromSlot, toSlot, amount)
  local charPtr = Char.GetCharPointer(charIndex)
  if charPtr <= 0 then
    return -1;
  end
  return _moveItem(charPtr, fromSlot, toSlot, amount)
end

---检测ptr是否正确
function Char.IsValidCharPtr(charPtr)
  return charPtr >= Addresses.CharaTablePTR and charPtr <= Addresses.CharaTablePTRMax and ffi.readMemoryInt32(charPtr) == 1
end

---检测index是否正确
function Char.IsValidCharIndex(charIndex)
  return Char.GetData(charIndex, 0) == 1;
end

---通过ptr获取数据
function Char.GetDataByPtr(charPtr, dataLine)
  if Char.IsValidCharPtr(charPtr) then
    return Char.GetData(ffi.readMemoryInt32(charPtr + 4), dataLine);
  end
  return nil
end
