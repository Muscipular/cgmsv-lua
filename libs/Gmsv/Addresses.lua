_G.Addresses = {}

local callbacks = {
  load = {}
}

function Addresses.onLoad(fn)
  table.insert(callbacks.load, fn);
end

function Addresses.load()
  local ItemIdMax = FFI.readMemoryDWORD(0x09205BE0);
  Addresses.ItemIdMax = ItemIdMax;
  local ItemIndexTblTPR = FFI.readMemoryDWORD(0x09205584);
  Addresses.ItemIndexTblTPR = ItemIndexTblTPR;
  local ItemTableMax = FFI.readMemoryDWORD(0x00687C80);
  Addresses.ItemTableMax = ItemTableMax;
  local ItemTablePTR = FFI.readMemoryDWORD(0x09205588);
  Addresses.ItemTablePTR = ItemTablePTR;
  local CharaTablePTR = FFI.readMemoryDWORD(0x091A6E54);
  Addresses.CharaTablePTR = CharaTablePTR;
  local CharaTableSize = FFI.readMemoryDWORD(0x091A6E58);
  Addresses.CharaTableSize = CharaTableSize;
  Addresses.CharaTablePTRMax = CharaTablePTR + (CharaTableSize - 1) * 0x21EC;
  local ConnectionTable = FFI.readMemoryDWORD(0x1125704);
  Addresses.ConnectionTable = ConnectionTable;
  local EncountTable = FFI.readMemoryDWORD(0x091A916C);
  Addresses.EncountTable = EncountTable;
  local EncountTableSize = FFI.readMemoryDWORD(0x091A9168);
  Addresses.EncountTableSize = EncountTableSize;
  local BattleTable = FFI.readMemoryDWORD(0x09202B14);
  Addresses.BattleTable = BattleTable;
  local BattleMax = FFI.readMemoryDWORD(0x09203B80);
  Addresses.BattleMax = BattleMax;
  local DBQueue = FFI.readMemoryDWORD(0x091A575C);
  Addresses.DBQueue = DBQueue;
  for i, v in ipairs(callbacks.load) do
    v();
  end
end
