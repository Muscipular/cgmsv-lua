---@meta _

---获取配方指定信息栏数据
---@param recipeNo number 配方id
---@param dataLine number CONST.ITEM_RECIPE
---@return string|number @指定信息栏信息
function Recipe.GetData(recipeNo, dataLine) end

---指定配方指定信息栏数据
---@param recipeNo number 配方id
---@param dataLine number CONST.ITEM_RECIPE
---@param val string|number 指定值
---@return number @成功返回0
function Recipe.SetData(recipeNo, dataLine,val) end

---习得配方
---@param charIndex number 对象index
---@param recipeNo number 配方id
---@return number @成功时返回 1, 失败返回 0, charIndex无效返回 -1, 配方无效返回 -2, 配方已获得返回 -3
function Recipe.GiveRecipe(charIndex, recipeNo) end

---删除配方
---@param charIndex number 对象index
---@param recipeNo number 配方id
---@return number @成功时返回 1, 失败返回 0, charIndex无效返回 -1, 配方无效返回 -2, 配方已获得返回 -3
function Recipe.RemoveRecipe(charIndex, recipeNo) end

---判断是否学会配方
---@param charIndex number 对象index
---@param recipeNo number 配方id CONST.RECIPE
---@return number @返回值 有配方时返回 1, 无配方返回 0, charIndex无效返回 -1, 配方无效返回 -2
function Recipe.HasRecipe(charIndex, recipeNo) end

