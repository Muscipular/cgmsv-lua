---@alias 字符串 string
---@alias 数值型 number


---获取Tech指定数据
---@param techIndex
---@param dataLine number 指定信息栏CONST.TECH
---@return any Tech指定信息栏数据
function Tech.GetData(techIndex, dataLine) end

---设置Tech指定数据
---@param techIndex
---@param dataLine number 指定信息栏 CONST.TECH
---@param val 指定信息
---@return any 
function Tech.SetData(techIndex, dataLine, val) end

---获取TechIndex
---@param techId
---@return number TechIndex
function Tech.GetTechIndex(techId) end

