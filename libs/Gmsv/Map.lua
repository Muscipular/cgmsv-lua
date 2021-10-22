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
  local dSize = 0;
  for i = 0, Addresses.ActiveDungeon_TBL_SIZE - 1 do
    if dSize >= Addresses.DungeonConf_SIZE then
      return -1;
    end
    local ptr = Addresses.ActiveDungeon_TBL + 0x68 * i
    if ffi.readMemoryInt32(ptr) == 1 then
      dSize = dSize + 1;
      if ffi.readMemoryInt32(ptr + 0x14) == floor then
        local t = ffi.readMemoryInt32(ptr + 0xc)
        return t
      end
    end
  end
  return -1;
end 
