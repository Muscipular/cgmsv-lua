---@meta _

---获取指定地图位置的Object Index列表。
---@param MapId  number 坐标地图id。
---@param FloorId  number 坐标Floor id。
---@param X  number 坐标x。
---@param Y  number 坐标y。
---@return number @返回值为2个，第一个返回值为数量，第二个返回值是lua的table，包含所有对象的对象index。
function Obj.GetObject(MapId, FloorId, X, Y) end

---根据ObjIndex获得 人物/宠物/物品等 的索引。
---@param ObjectIndex  number 目标的 物件index。
---@return number @对象index
function Obj.GetCharIndex(ObjectIndex) end

---获取指定Object Index的Object类型。
---@param ObjectIndex  number 目标的 物件index。
---@return number @-1：非法 | 0：未使用 | 1：角色 | 2：道具 | 3：金币 | 4：传送点 | 5：船 | 6：载具
function Obj.GetType(ObjectIndex) end

---获取指定Object Index的X坐标。
---@param ObjectIndex  number 目标的 物件index。
---@return number @x坐标
function Obj.GetX(ObjectIndex) end

---获取指定Object Index的Y坐标。
---@param ObjectIndex  number 目标的 物件index。
---@return number @y坐标
function Obj.GetY(ObjectIndex) end

---获取指定Object Index的Floor ID。
---@param ObjectIndex  number 目标的 物件index。
---@return number @Floor ID
function Obj.GetFloor(ObjectIndex) end

---获取指定Object Index的Map ID。
---@param ObjectIndex  number 目标的 物件index。
---@return number @Map ID
function Obj.GetMap(ObjectIndex) end

---获取指定Object Index的Map ID。
---@param ObjectIndex  number 目标的 物件index。
---@return number @Map ID
function Obj.GetMapId(ObjectIndex) end

---获取指定Object Index的Warp X坐标。
---@param ObjectIndex  number 目标的 物件index。
---@return number @x坐标
function Obj.GetWarpX(ObjectIndex) end

---获取指定Object Index的Warp Y坐标。
---@param ObjectIndex  number 目标的 物件index。
---@return number @y坐标
function Obj.GetWarpY(ObjectIndex) end

---获取指定Object Index的Warp Floor ID。
---@param ObjectIndex  number 目标的 物件index。
---@return number @Floor ID
function Obj.GetWarpFloor(ObjectIndex) end

---获取指定Object Index的Warp Map ID。
---@param ObjectIndex  number 目标的 物件index。
---@return number @Map ID
function Obj.GetWarpMap(ObjectIndex) end

---获取指定Object Index的Warp Map ID。
---@param ObjectIndex  number 目标的 物件index。
---@return number @Map ID
function Obj.GetWarpMapId(ObjectIndex) end

---获取指定Objec对象的开始时间(宠物开始丢地的时间)。
---@param ObjectIndex  number 目标的 物件index。
---@return number @开始时间的timestamp。
function Obj.GetDelTime(ObjectIndex) end

---设置指定Object Index的Object类型。
---@param ObjectIndex  number 目标的 物件index。
---@param Value  number 取值0~6 <br>
--- 0：未使用 <br>
--- 1：角色 <br>
--- 2：道具 <br>
--- 3：金币 <br>
--- 4：传送点 <br>
--- 5：船 <br>
--- 6：载具
---@return number @设置前的类型
function Obj.SetType(ObjectIndex, Value) end

---设置指定Object Index的X坐标。
---@param ObjectIndex  number 目标的 物件index。
---@param Value  number 新的X坐标
---@return number @设置前的x坐标
function Obj.SetX(ObjectIndex, Value) end

---设置指定Object Index的Y坐标。
---@param ObjectIndex  number 目标的 物件index。
---@param Value  number 新的Y坐标
---@return number @设置前的Y坐标
function Obj.SetY(ObjectIndex, Value) end

---设置指定Object Index的Floor ID。
---@param ObjectIndex  number 目标的 物件index。
---@param Value  number 新的FloorID
---@return number @设置前的Floor ID
function Obj.SetFloor(ObjectIndex, Value) end

---设置指定Object Index的Map ID。
---@param ObjectIndex  number 目标的 物件index。
---@param Value  number 新的MapID
---@return number @设置前的Map ID
function Obj.SetMap(ObjectIndex, Value) end

---设置指定Object Index的Map ID。
---@param ObjectIndex  number 目标的 物件index。
---@param Value  number 新的MapID
---@return number @设置前的Map ID
function Obj.SetMapId(ObjectIndex, Value) end

---设置指定Object Index的Warp X坐标。
---@param ObjectIndex  number 目标的 物件index。
---@param Value  number 新的X坐标
---@return number @设置前的x坐标
function Obj.SetWarpX(ObjectIndex, Value) end

---设置指定Object Index的Warp Y坐标。
---@param ObjectIndex  number 目标的 物件index。
---@param Value  number 新的Y坐标
---@return number @设置前的Y坐标
function Obj.SetWarpY(ObjectIndex, Value) end

---设置指定Object Index的Warp Floor ID。
---@param ObjectIndex  number 目标的 物件index。
---@param Value  number 新的FloorID
---@return number @设置前的Floor ID
function Obj.SetWarpFloor(ObjectIndex, Value) end

---设置指定Object Index的Warp Map ID。
---@param ObjectIndex  number 目标的 物件index。
---@param Value  number 新的MapID
---@return number @设置前的Map ID
function Obj.SetWarpMap(ObjectIndex, Value) end

---设置指定Object Index的Warp Map ID。
---@param ObjectIndex  number 目标的 物件index。
---@param Value  number 新的MapID
---@return number @设置前的Map ID
function Obj.SetWarpMapId(ObjectIndex, Value) end

---设置指定Objec对象的开始时间(宠物开始丢地的时间)。
---@param ObjectIndex  number 目标的 物件index。
---@param Value  number 时间timestamp
---@return number @设置前的时间
function Obj.SetDelTime(ObjectIndex, Value) end

---移除指定obj
---@param objectIndex number object的index
---@return number @成功返回0
function Obj.RemoveObject(objectIndex) end

---在指定的地图坐标上设置传送点
---@param Map number 传送点地图类型
---@param Floor number 传送点地图
---@param Xpos number 传送点X坐标
---@param Ypos number 传送点Y坐标
---@param toMap number 传送后地图类型
---@param toFloor number 传送后地图
---@param toXpos number 传送后X坐标
---@param toYpos number 传送后Y坐标
---@return number @成功返回ObjectIndex
function Obj.AddWarp(Map,Floor,Xpos,Ypos,toMap,toFloor,toXpos,toYpos) end

---在指定的地图坐标上放金币
---@param Map number 地图类型
---@param Floor number 地图
---@param Xpos number X坐标
---@param Ypos number Y坐标
---@param gold number 金币数量
---@return number @成功返回ObjectIndex
function Obj.AddGold(Map,Floor,Xpos,Ypos,gold) end

---在指定的地图坐标上放物品
---@param Map number 地图类型
---@param Floor number 地图
---@param Xpos number X坐标
---@param Ypos number Y坐标
---@param itemIndex number 由Item.MakeItem(itemId)返回值
---@return number @成功返回ObjectIndex
function Obj.AddItem(Map,Floor,Xpos,Ypos,itemIndex) end

