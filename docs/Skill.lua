---@alias 字符串 string
---@alias 数值型 number


---获取技能指定信息
---@param skillIndex
---@param dataLine CONST.SKILL
---@return any @指定技能信息栏信息
function Skill.GetData(skillIndex, dataLine) end

---设置技能指定信息
---@param skillIndex
---@param dataLine CONST.SKILL
---@param val 指定信息
---@return any @
function Skill.SetData(skillIndex, dataLine, val) end

---获取skillIndex
---@param id number skillId
---@return number @skillIndex
function Skill.GetSkillIndex(id) end

---获取职业最高技能等级
---@param skillIndex
---@param job 职业ID
---@return any @职业最高技能等级
function Skill.GetMaxSkillLevelOfJob(skillIndex, job) end

