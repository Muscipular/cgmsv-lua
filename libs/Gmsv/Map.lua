_G.Map = {} or _G.Map;

function Map.GetDungeonExpireTime(floor)
  local t = Map.GetDungeonExpireAt(floor);
  if t < 0 then
    return t;
  end
  t = t - os.time()
  if t <= 0 then
    return 0;
  end
  return t
end

function Map.GetDungeonExpireAt(floor)
  --local dSize = 0;
  local mapIndex = ffi.readMemoryDWORD(Addresses.MapIndexMapping[1] + floor * 4)
  local cfgId = ffi.readMemoryDWORD(Addresses.MapTable[1] + 0x80 * mapIndex + 0x4)
  for i = 0, Addresses.ActiveDungeon_TBL_SIZE - 1 do
    --if dSize >= Addresses.DungeonConf_SIZE then
    --  return -1;
    --end
    local ptr = Addresses.ActiveDungeon_TBL + 0x68 * i
    if ffi.readMemoryInt32(ptr) == 1 then
      --dSize = dSize + 1;
      if ffi.readMemoryInt32(ptr + 0x4) == cfgId then
        local t = ffi.readMemoryInt32(ptr + 0xc)
        return t
      end
    end
  end
  return -1;
end

function Map.SetDungeonExpireAt(floor, time)
  --local dSize = 0;
  local mapIndex = ffi.readMemoryDWORD(Addresses.MapIndexMapping[1] + floor * 4)
  local cfgId = ffi.readMemoryDWORD(Addresses.MapTable[1] + 0x80 * mapIndex + 0x4)
  for i = 0, Addresses.ActiveDungeon_TBL_SIZE - 1 do
    --if dSize >= Addresses.DungeonConf_SIZE then
    --  return -1;
    --end
    local ptr = Addresses.ActiveDungeon_TBL + 0x68 * i
    if ffi.readMemoryInt32(ptr) == 1 then
      --dSize = dSize + 1;
      if ffi.readMemoryInt32(ptr + 0x4) == cfgId then
        if time - os.time() < 181 then
          ffi.setMemoryInt32(ptr + 0x24, 1)
        end
        ffi.setMemoryInt32(ptr + 0xc, time)
        return 0
      end
    end
  end
  return -1;
end 
