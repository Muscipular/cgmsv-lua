--ffi.patch(0x00572A12, { 0x7D });
--ffi.patch(0x004618D1 + 1, { 0x42 });
--ffi.patch(0x005836FD, { 0x3B, 0x7D, 0x1C });

local Pve = Battle.PVE
---@param CharIndex number
---@param CreatePtr number
---@param DoFunc string
---@param EnemyIdAr number[]
---@param BaseLevelAr number[]
---@param RandLv? number[]
Battle.PVE = function(CharIndex, CreatePtr, DoFunc, EnemyIdAr, BaseLevelAr, RandLv)
  if #EnemyIdAr < 1 then
    return -1;
  end
  for i = 1, 10 do
    if EnemyIdAr[i] == nil then
      EnemyIdAr[i] = -1;
    end
    if BaseLevelAr[i] == nil then
      BaseLevelAr[i] = 1;
    end
    if RandLv and RandLv[i] == nil then
      RandLv[i] = 0;
    end
  end
  return Pve(CharIndex, CreatePtr, DoFunc, EnemyIdAr, BaseLevelAr, RandLv)
end

print('[DEBUG] BATTLE_PVE_PATCH done')
