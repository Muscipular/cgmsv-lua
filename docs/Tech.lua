---@meta _

---获取Tech指定数据
---@param techIndex number
---@param dataLine number 指定信息栏CONST.TECH
---@return string|number @Tech指定信息栏数据
function Tech.GetData(techIndex, dataLine) end

---设置Tech指定数据
---@param techIndex number
---@param dataLine number 指定信息栏 CONST.TECH
---@param val string|number 指定信息
---@return number @成功返回0
function Tech.SetData(techIndex, dataLine, val) end

---获取TechIndex
---@param techId number
---@return number @TechIndex
function Tech.GetTechIndex(techId) end

