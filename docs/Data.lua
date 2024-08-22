---@meta _

---获取Msg
---@param msgId number @消息id
---@return string @消息内容
function Data.GetMessage(msgId) end

---设置Msg
---@param msgId number 消息id
---@param val string 消息内容
function Data.SetMessage(msgId, val) end

---设置种族伤害比率
---@param a number 进攻种族 支持 0 ~ 19
---@param b number 防守种族 支持 0 ~ 19
---@param rate number 克制比率支持 -128 ~ 127
---@return number @伤害比率
function Data.SetTribeMapValue(a, b, rate) end

---获取EnemyDataIndex
---@param enemyId number
---@return number @EnemyDataIndex
function Data.EnemyGetDataIndex(enemyId) end

---获取Enemy数据
---@param enemyIndex number
---@param DataPos number CONST.DATA_ENEMY
---@return number|string @Enemy数据
function Data.EnemyGetData(enemyIndex, DataPos) end

---指定Enemy数据
---@param enemyIndex number
---@param DataPos number CONST.DATA_ENEMY
---@param val string|number 指定信息
---@return number @成功返回0
function Data.EnemySetData(enemyIndex, DataPos, val) end

---获取EnemyBaseDataIndex
---@param enemyBaseId number
---@return number @EnemyBaseDataIndex
function Data.EnemyBaseGetDataIndex(enemyBaseId) end

---获取EnemyBase数据
---@param enemyBaseIndex number
---@param DataPos number CONST.DATA_ENEMYBASE
---@return number|string @EnemyBase数据
function Data.EnemyBaseGetData(enemyBaseIndex, DataPos) end

---指定EnemyBase数据
---@param enemyBaseIndex number
---@param DataPos number CONST.DATA_ENEMYBASE
---@param val number|string 指定信息
---@return number @成功返回0
function Data.EnemyBaseSetData(enemyBaseIndex, DataPos, val) end

---获取ItemsetIndex
---@param ItemID number
---@return number @ItemsetIndex
function Data.ItemsetGetIndex(ItemID) end

---获取Itemset数据
---@param ItemsetIndex number
---@param DataPos number CONST.ITEMSET
---@return number|string @Itemset数据
function Data.ItemsetGetData(ItemsetIndex, DataPos) end

---指定Itemset数据
---@param ItemsetIndex number
---@param DataPos number CONST.ITEMSET
---@param val number|string 指定信息
---@return number @成功返回0
function Data.ItemsetSetData(ItemsetIndex, DataPos, val) end

---获取encountIndex
---@param encountId number
---@return number @encountIndex
function Data.GetEncountIndex(encountId) end

---获取encount数据
---@param encountIndex number
---@param DataPos number CONST.ENCOUNT_* 
---@return number|string @encount数据
function Data.GetEncountData(encountIndex,DataPos) end

---指定encount数据
---@param encountIndex number
---@param DataPos number CONST.ENCOUNT_* 
---@param val number|string 指定信息
---@return number @成功返回0
function Data.SetEncountData(encountIndex,DataPos,val) end

---获取JobIndex
---@param jobId number 职业Id
---@return number @JobIndex
function Data.GetJobIndex(jobId) end

---获取Job数据
---@param jobIndex number JobIndex 
---@param dataPos number CONST.JOBS_*
---@return number|string @数据 
function Data.GetJobData(jobIndex, dataPos) end

---设置Job数据
---@param jobIndex number JobIndex 
---@param dataPos number CONST.JOBS_*
---@param data number|string @数据 
---@return number @成功返回0
function Data.SetJobData(jobIndex, dataPos, data) end

---获取职系Index
---@param jobAncestryId number 职系Id
---@return number @JobAncestryIndex
function Data.GetJobAncestryIndex(jobAncestryId) end

---获取职系数据
---@param jobAncestryIndex number JobAncestryIndex 
---@param dataPos number CONST.JOBS_Ancestry_*
---@return number|string @数据 
function Data.GetJobAncestryData(jobAncestryIndex, dataPos) end

---设置职系数据
---@param jobAncestryIndex number JobAncestryIndex 
---@param dataPos number CONST.JOBS_Ancestry_*
---@param data number|string @数据 
---@return number @成功返回0
function Data.SetJobAncestryData(jobAncestryIndex, dataPos, data) end


---获得groupIndex
---@param groupId number group.txt中的id
---@return number @groupIndex
function Data.GetEncountGroupIndex(groupId) end


---获得group数据
---@param groupIndex number groupIndex
---@param dataline number CONST.ENCOUNT_GROUP_*
---@return number|string @数据 
function Data.GetEncountGroupData(groupIndex, dataline) end


---设置group数据
---@param groupIndex number groupIndex
---@param dataline number CONST.ENCOUNT_GROUP_*
---@param val number|string 数据
---@return number @成功返回0
function Data.SetEncountGroupData(groupIndex, dataline, val) end

