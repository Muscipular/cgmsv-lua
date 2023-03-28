_G.Map = {} or _G.Map;

---获取迷宫的剩余时间
function Map.GetDungeonExpireTimeByDungeonId(dungeonId)
  local t = Map.GetDungeonExpireAtByDungeonId(dungeonId);
  if t < 0 then
    return t;
  end
  t = t - os.time()
  if t <= 0 then
    return 0;
  end
  return t
end

---获取迷宫地图的剩余时间
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

---获取迷宫的过期时间
function Map.GetDungeonExpireAtByDungeonId(dungeonId)
  for i = 0, Addresses.ActiveDungeon_TBL_SIZE - 1 do
    --if dSize >= Addresses.DungeonConf_SIZE then
    --  return -1;
    --end
    local ptr = Addresses.ActiveDungeon_TBL + 0x68 * i
    if ffi.readMemoryInt32(ptr) == 1 then
      --dSize = dSize + 1;
      if ffi.readMemoryInt32(ptr + 0x4) == dungeonId then
        local t = ffi.readMemoryInt32(ptr + 0xc)
        return t
      end
    end
  end
  return -1;
end

---获取迷宫地图的过期时间
function Map.GetDungeonExpireAt(floor)
  --local dSize = 0;
  local cfgId = Map.GetDungeonId(floor)
  if cfgId < 0 then
    return -1;
  end
  return Map.GetDungeonExpireAtByDungeonId(cfgId);
end

---根据floor设置迷宫重置时间
function Map.SetDungeonExpireAt(floor, time)
  --local dSize = 0;
  local cfgId = Map.GetDungeonId(floor)
  if cfgId < 0 then
    return -1;
  end
  return Map.SetDungeonExpireAtByDungeonId(cfgId, time)
end

---根据迷宫Id设置迷宫重置时间
function Map.SetDungeonExpireAtByDungeonId(dungeonId, time)
  for i = 0, Addresses.ActiveDungeon_TBL_SIZE - 1 do
    --if dSize >= Addresses.DungeonConf_SIZE then
    --  return -1;
    --end
    local ptr = Addresses.ActiveDungeon_TBL + 0x68 * i
    if ffi.readMemoryInt32(ptr) == 1 then
      --dSize = dSize + 1;
      if ffi.readMemoryInt32(ptr + 0x4) == dungeonId then
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

---获取迷宫Id
function Map.GetDungeonId(floor)
  if floor < 0 then
    return -1;
  end
  local mapIndex = ffi.readMemoryDWORD(Addresses.MapIndexMapping[1] + floor * 4)
  if mapIndex < 0 or mapIndex >= Addresses.MapTableSize[1] then
    return -1;
  end
  local cfgId = ffi.readMemoryDWORD(Addresses.MapTable[1] + 0x80 * mapIndex + 0x4)
  return cfgId;
end

---获取迷宫入口
---@param dungeonId integer dungeonId
---@return number mapType, number floor, number x, number y
function Map.FindDungeonEntry(dungeonId)
  for i = 0, Addresses.ActiveDungeon_TBL_SIZE - 1 do
    --if dSize >= Addresses.DungeonConf_SIZE then
    --  return -1;
    --end
    local ptr = Addresses.ActiveDungeon_TBL + 0x68 * i
    if ffi.readMemoryInt32(ptr) == 1 then
      --dSize = dSize + 1;
      if ffi.readMemoryInt32(ptr + 0x4) == dungeonId then
        return ffi.readMemoryInt32(ptr + 0x10), ffi.readMemoryInt32(ptr + 0x14), ffi.readMemoryInt32(ptr + 0x18), ffi.readMemoryInt32(ptr + 0x1C)
      end
    end
  end
  return -1;
end
