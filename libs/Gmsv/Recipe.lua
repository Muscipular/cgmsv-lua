local hasRecipe = ffi.cast('int (__cdecl *)(uint32_t a1, uint32_t a2)', 0x0042B560)
local getRecipeIndexByNumber = ffi.cast('int (__cdecl *)(int a1)', 0x004DACF0)
local setRecipeFlag = ffi.cast('int (__cdecl *)(uint32_t a1, int a2)', 0x0042B500)
local unsetRecipeFlag = ffi.cast('int (__cdecl *)(uint32_t a1, int a2)', 0x0042B530)
local getRecipeIntData = ffi.cast('int (__cdecl *)(int recipeIndex, int a2)', 0x004DA170)
local getRecipeStrData = ffi.cast('const char *(__cdecl *)(int a1, int a2)', 0x004DA1B0)
local sendRecipeDataToClient = ffi.cast('int (__cdecl *)(uint32_t charAddr1, int skillSlot)', 0x00442DE0)

_G.Recipe = _G.Recipe or {}

---@return number 成功时返回 1, 失败返回 0, charIndex无效返回 -1, 配方无效返回 -2, 配方已获得返回 -3
function Recipe.GiveRecipe(charIndex, recipeNo)
  if charIndex < 0 then
    return -1;
  end
  if type(recipeNo) ~= 'number' or recipeNo >= 2048 then
    return -2;
  end
  local ptr = Char.GetCharPointer(charIndex);
  if ptr <= 0 then
    return -1;
  end
  local recipeIndex = getRecipeIndexByNumber(recipeNo);
  if recipeIndex < 0 then
    return -2;
  end
  if hasRecipe(ptr, recipeNo) ~= 0 then
    return -3;
  end
  setRecipeFlag(ptr, recipeNo);
  local skillId = getRecipeIntData(recipeIndex, 2);
  for i = 0, 14 do
    local skillId2 = Char.GetSkillID(charIndex, i);
    if skillId2 == skillId then
      sendRecipeDataToClient(ptr, i);
    end
  end
  return 1;
end

---@return number 成功时返回 1, 失败返回 0, charIndex无效返回 -1, 配方无效返回 -2, 配方未获得返回 -3
function Recipe.RemoveRecipe(charIndex, recipeNo)
  if charIndex < 0 then
    return -1;
  end
  if type(recipeNo) ~= 'number' or recipeNo >= 2048 then
    return -2;
  end
  local ptr = Char.GetCharPointer(charIndex);
  if ptr <= 0 then
    return -1;
  end
  local recipeIndex = getRecipeIndexByNumber(recipeNo);
  if recipeIndex < 0 then
    return -2;
  end
  if hasRecipe(ptr, recipeNo) ~= 1 then
    return -3;
  end
  unsetRecipeFlag(ptr, recipeNo);
  local skillId = getRecipeIntData(recipeIndex, 2);
  for i = 0, 14 do
    local skillId2 = Char.GetSkillID(charIndex, i);
    if skillId2 == skillId then
      sendRecipeDataToClient(ptr, i);
    end
  end
  return 1;
end

---@return number 返回值 有配方时返回 1, 无配方返回 0, charIndex无效返回 -1, 配方无效返回 -2
function Recipe.HasRecipe(charIndex, recipeNo)
  if charIndex < 0 then
    return -1;
  end
  if type(recipeNo) ~= 'number' or recipeNo >= 2048 then
    return -2;
  end
  local ptr = Char.GetCharPointer(charIndex);
  if ptr <= 0 then
    return -1;
  end
  local recipeIndex = getRecipeIndexByNumber(recipeNo);
  if recipeIndex < 0 then
    return -2;
  end
  return hasRecipe(ptr, recipeNo);
end

function Recipe.GetData(recipeNo, dataLine)
  if type(recipeNo) ~= 'number' or recipeNo >= 2048 then
    return nil;
  end
  local recipeIndex = getRecipeIndexByNumber(recipeNo);
  if recipeIndex < 0 then
    return nil;
  end
  if type(dataLine) ~= 'number' or dataLine > 14 or dataLine < 0 then
    return nil
  end
  if dataLine == 14 then
    return ffi.string(getRecipeStrData(recipeNo, 0))
  end
  return getRecipeIntData(recipeNo, dataLine)
end 
