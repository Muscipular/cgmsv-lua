---@alias 字符串 string
---@alias 数值型 number


---获取Msg
---@param msgId number
---@return any @msg
function Data.GetMessage(msgId) end

---设置Msg
---@param msgId number
---@param val string
---@return any @
function Data.SetMessage(msgId, val) end

---设置种族伤害比率
---@param a number 进攻种族 支持 0 ~ 19
---@param b number 防守种族 支持 0 ~ 19
---@param rate number 克制比率支持 -128 ~ 127
---@return any @
function Data.SetTribeMapValue(a, b, rate) end

---获取EnemyDataIndex
---@param enemyId number
---@return number @EnemyDataIndex
function Data.EnemyGetDataIndex(enemyId) end

---获取Enemy数据
---@param enemyIndex number
---@param DataPos number CONST.DATA_ENEMY
---@return any @Enemy数据
function Data.EnemyGetData(enemyIndex, DataPos) end

---指定Enemy数据
---@param enemyIndex number
---@param DataPos number CONST.DATA_ENEMY
---@param val 指定信息
---@return any @
function Data.EnemySetData(enemyIndex, DataPos, val) end

---获取EnemyBaseDataIndex
---@param enemyIndex number
---@return number @EnemyBaseDataIndex
function Data.EnemyBaseGetDataIndex(enemyBaseId) end

---获取EnemyBase数据
---@param enemybaseIndex number
---@param DataPos number CONST.DATA_ENEMYBASE
---@return any @EnemyBase数据
function Data.EnemyBaseGetData(enemyBaseIndex, DataPos) end

---指定EnemyBase数据
---@param enemybaseIndex number
---@param DataPos number CONST.DATA_ENEMYBASE
---@param val 指定信息
---@return any @
function Data.EnemyBaseSetData(enemyBaseIndex, DataPos, val) end

---获取ItemsetIndex
---@param ItemID number
---@return number @ItemsetIndex
function Data.ItemsetGetIndex(ItemID) end

---获取Itemset数据
---@param ItemsetIndex number
---@param DataPos number CONST.ITEMSET
---@return any @Itemset数据
function Data.ItemsetGetData(ItemsetIndex, DataPos) end

---指定Itemset数据
---@param ItemsetIndex number
---@param DataPos number CONST.ITEMSET
---@param val 指定信息
---@return any @
function Data.ItemsetSetData(ItemsetIndex, DataPos, val) end

---获取encountIndex
---@param encountID number
---@return number @encountIndex
function Data.GetEncountIndex(encountId) end

---获取encount数据
---@param encountIndex number
---@param DataPos number CONST.ENCOUNT_* 
---@return any @encount数据
function Data.GetEncountData(encountIndex,DataPos) end

---指定encount数据
---@param encountIndex number
---@param DataPos number CONST.ENCOUNT_* 
---@param val 指定信息
---@return any @
function Data.SetEncountData(encountIndex,DataPos,val) end

