_G.Data = {}
local function ps(...)
  print(table.unpack(table.map({ ... }, function(e)
    if type(e) == 'number' and e > 0 then
      return string.formatNumber(e, 16)
    end
    return e;
  end)))
end
local ItemIdMax = FFI.readMemoryDWORD(0x09205BE0)
print('ItemIdMax:', ItemIdMax)
local ItemIndexTblTPR = FFI.readMemoryDWORD(0x09205584)
ps('item_index_tbl', ItemIndexTblTPR)
local ItemTableMax = FFI.readMemoryDWORD(0x00687C80)
print('ItemTableMax:', ItemTableMax)
local ItemTablePTR = FFI.readMemoryDWORD(0x09205588);
ps('item_tbl', ItemTablePTR)

function Data.ItemsetGetIndex(ItemID)
  if ItemID < 0 and ItemID >= ItemIdMax then
    return -1;
  end
  return FFI.readMemoryInt32(ItemIndexTblTPR + 4 * ItemID)
end

function Data.ItemsetGetData(ItemsetIndex, DataPos)
  if ItemsetIndex < 0 or ItemsetIndex >= ItemTableMax then
    return nil;
  end
  if DataPos >= 2000 then
    DataPos = DataPos - 2000;
    if DataPos >= 13 then
      return nil;
    end
    return FFI.readMemoryString(ItemTablePTR + ItemsetIndex * 1092 + 78 * 4 + DataPos * 32 + 4)
  end
  local p = 0;
  if DataPos >= 78 then
    if DataPos >= 92 then
      p = FFI.readMemoryInt32(ItemTablePTR + ItemsetIndex * 1092 + (DataPos - 90) * 4 + 4)
    end
    DataPos = 8 * 13 + DataPos
    if DataPos >= 273 then
      return nil
    end
  end
  return FFI.readMemoryInt32(ItemTablePTR + ItemsetIndex * 1092 + DataPos * 4 + 4) + p
end
print('index:', Data.ItemsetGetIndex(2035))
for i = 0, 273 do
  print('data', i, Data.ItemsetGetData(Data.ItemsetGetIndex(2035), i))
end

for i = 2000, 2015 do
  print('data', i, Data.ItemsetGetData(Data.ItemsetGetIndex(2035), i))
end
