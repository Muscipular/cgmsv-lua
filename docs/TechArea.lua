---@meta _

---创建采集区域
---@param mapId number 地图类型
---@param floor number 地图floor
---@param x number x坐标
---@param y number y坐标
---@param w number 宽
---@param h number 高
---@param name string 名称
---@param skillId number 技能id
---@param zOrder number z轴优先级
---@param failedProb number 失败概率
---@param needItem number 需要的物品id
---@param itemId1 number 物品1Id
---@param rate1 number 物品1概率
---@param itemId2 number 物品2Id
---@param rate2 number 物品2概率
---@param itemId3 number 物品3Id
---@param rate3 number 物品3概率
---@param itemId4 number 物品4Id
---@param rate4 number 物品4概率
---@param itemId5 number 物品5Id
---@param rate5 number 物品5概率
---@param itemId6 number 物品6Id
---@param rate6 number 物品6概率
---@param itemId7 number 物品7Id
---@param rate7 number 物品7概率
---@param itemId8 number 物品8Id
---@param rate8 number 物品8概率
---@param itemId9 number 物品9Id
---@param rate9 number 物品9概率
---@param itemId10 number 物品10Id
---@param rate10 number 物品10概率
---@return number index @区域Index，当大于或等于0时为成功，其他为失败
function TechArea.CreateTechArea(mapId, floor, x, y, w, h, name, skillId, zOrder, failedProb, needItem, itemId1, rate1, itemId2, rate2, itemId3, rate3, itemId4, rate4, itemId5, rate5, itemId6, rate6, itemId7, rate7, itemId8, rate8, itemId9, rate9, itemId10, rate10) end

---移除采集区域
---@param index number 区域Index
---@return number ret @0为成功，其他失败。
function TechArea.RemoveTechArea(index) end

---获取指定坐标的所有采集区域index
---@param mapId number 地图类型
---@param floor number 地图floor
---@param x number   x坐标
---@param y number   y坐标
---@param skillId number 技能编号
---@return number count @数量,大于或等于0为成功，其他失败。
---@return {index:number,zOrder:number}[] list @采集区域Index及zOrder
function TechArea.GetIndexList(mapId, floor, x, y, skillId) end

---获取TechArea指定数据
---@param areaIndex number
---@param dataLine number 指定信息栏CONST.TechArea
---@return string|number @Tech指定信息栏数据
function TechArea.GetData(areaIndex, dataLine) end

---设置TechArea指定数据
---@param areaIndex number
---@param dataLine number 指定信息栏CONST.TechArea
---@param value string|number @Tech指定信息栏数据
---@return number ret @0为成功，其他失败。
function TechArea.SetData(areaIndex, dataLine, value) end