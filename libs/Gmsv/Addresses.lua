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
  local ItemExistsTablePTR = FFI.readMemoryDWORD(0x09205BE4);
  Addresses.ItemExistsTablePTR = ItemExistsTablePTR;
  local ItemExistsTableSize = FFI.readMemoryDWORD(0x00688F80);
  Addresses.ItemExistsTableSize = ItemExistsTableSize;
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
  local EnemyTableSize = FFI.readMemoryDWORD(0x006858E0);
  Addresses.EnemyTableSize = EnemyTableSize;
  local EnemyTableTPR = FFI.readMemoryDWORD(0x091A9160);
  Addresses.EnemyTableTPR = EnemyTableTPR;
  local EnemyBaseSize = FFI.readMemoryDWORD(0x006858EC);
  Addresses.EnemyBaseSize = EnemyBaseSize;
  local EnemyBaseTableTPR = FFI.readMemoryDWORD(0x091A9164);
  Addresses.EnemyBaseTableTPR = EnemyBaseTableTPR;
  local EnemyBase_JMP_Size = FFI.readMemoryDWORD(0x006858F0);
  Addresses.EnemyBase_JMP_Size = EnemyBase_JMP_Size;
  local EnemyBase_JMP = FFI.readMemoryDWORD(0x006858F4);
  Addresses.EnemyBase_JMP = EnemyBase_JMP;
  local Enemy_JMP_Size = FFI.readMemoryDWORD(0x006858E4);
  Addresses.Enemy_JMP_Size = Enemy_JMP_Size;
  local Enemy_JMP = FFI.readMemoryDWORD(0x006858E8);
  Addresses.Enemy_JMP = Enemy_JMP;
  local DungeonConf_SIZE = FFI.readMemoryDWORD(0x006CE030);
  Addresses.DungeonConf_SIZE = DungeonConf_SIZE;
  local DungeonConf_TBL = FFI.readMemoryDWORD(0x09205D9C);
  Addresses.DungeonConf_TBL = DungeonConf_TBL;
  local ActiveDungeon_TBL_SIZE = FFI.readMemoryDWORD(0x011238C0 + 0x188);
  Addresses.ActiveDungeon_TBL_SIZE = ActiveDungeon_TBL_SIZE;
  local ActiveDungeon_TBL = FFI.readMemoryDWORD(0x0960B070);
  Addresses.ActiveDungeon_TBL = ActiveDungeon_TBL;
  Addresses.MapTable = {}
  Addresses.MapTableSize = {}
  Addresses.MapIndexMapping = {}
  Addresses.MapCount = {}
  for i = 0, 3 do
    Addresses.MapTable[i] = FFI.readMemoryDWORD(0x092060DC + i * 4);
    Addresses.MapTableSize[i] = FFI.readMemoryDWORD(0x092060C8 + i * 4);
    Addresses.MapIndexMapping[i] = FFI.readMemoryDWORD(0x092060AC + i * 4);
    Addresses.MapCount[i] = FFI.readMemoryDWORD(0x09205D88 + i * 4);
  end

  for i, v in ipairs(callbacks.load) do
    v();
  end
end
