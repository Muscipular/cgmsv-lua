---@meta _

---获取技能指定信息
---@param skillIndex number
---@param dataLine number CONST.SKILL
---@return string|number @指定技能信息栏信息
function Skill.GetData(skillIndex, dataLine) end

---设置技能指定信息
---@param skillIndex number
---@param dataLine number CONST.SKILL
---@param val string|number 指定信息
---@return number @成功返回0
function Skill.SetData(skillIndex, dataLine, val) end

---获取skillIndex
---@param id number skillId
---@return number @skillIndex
function Skill.GetSkillIndex(id) end

---获取职业最高技能等级
---@param skillIndex number
---@param job number 职业ID
---@return number @职业最高技能等级
function Skill.GetMaxSkillLevelOfJob(skillIndex, job) end

