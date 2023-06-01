---@alias 字符串 string
---@alias 数值型 number


---获取迷宫Id
---@param floor integer
---@return number 迷宫id
function Map.GetDungeonId(floor) end

---获取迷宫入口
---@param dungeonId 迷宫id
---@return any number mapType, number floor, number x, number y
function Map.FindDungeonEntry(dungeonId) end

---获取迷宫的过期时间
---@param dungeonId 迷宫id
---@return any 
function Map.GetDungeonExpireAtByDungeonId(dungeonId) end

---根据迷宫Id设置迷宫重置时间 
---@param dungeonId 迷宫id
---@param time UnixTime
---@return any 
function Map.SetDungeonExpireAtByDungeonId(dungeonId, time) end

---获得地图位置的图档
---@param Map number 地图类型
---@param Floor number 地图
---@param Xpos number X坐标
---@param Ypos number Y坐标
---@return any 返回地板图档，建筑物图档
function Map.GetImage(Map,Floor,Xpos,Ypos) end

---设定地图位置的图档
---@param Map number 地图类型
---@param Floor number 地图
---@param Xpos number X坐标
---@param Ypos number Y坐标
---@param Tile number 地板图档 可以为null
---@param Obj number 建筑物图档 可以为null
---@return any 
function Map.SetImage(Map,Floor,Xpos,Ypos,Tile,Obj) end

---获得地图大小
---@param Map number 地图类型
---@param Floor number 地图
---@return any 返回地图大小  长，宽
function Map.GetMapSize(Map,Floor) end

---创建复制地图。新地图的mapid为CONST.地图类型_LUAMAP
---@param mapid  数值型 要复制的地图的Map ID。
---@param floor  数值型 要复制的地图的Floor ID。
---@return number 成功返回新的FloorID，失败返回-1。
function Map.MakeCopyMap(mapid, floor) end

---删除Lua生成的地图，释放地图编号。
---@param floor  数值型 地图的Floor ID。
---@return number 成功返回0，失败返回-1。
function Map.DelLuaMap(floor) end

---创建随机地图。
---@param Dofile 回调函数所在文件 字符串
---@param InitFuncName 回调函数名，当随机地图生成成功以后，会触发定义的回调函数 MakeMazeMapCallBack 字符串
---@param Xsize地图x坐标最大值 数值型
---@param Ysize 地图y坐标最大值 数值型
---@param MapName 地图名 字符串
---@return number 成功返回新的FloorID，失败返回-1。
function Map.MakeMazeMap(Dofile, InitFuncName,Xsize,Ysize,MapName) end

---这个是Map.MakeMazeMap生成随机地图结果的回调函数
---@param FloodID  数值型 生成的地图的编号
---@param Doneflg  数值型 生成地图的结果，如果该值为1则生成成功，如果为0则生成失败。
---@return any 
function MapCallBack(FloorID, Doneflg) end

---获取随机地图可用的坐标。
---@param mapid number 地图类型
---@param floor number 地图
---@return number 返回x坐标和y坐标，如果失败则x与y都为-1。
function Map.GetAvailablePos(mapid, floor) end

---设置地图坐标是否可以通行
---@param Map number 地图类型
---@param Floor number 地图
---@param Xpos number X坐标
---@param Ypos number Y坐标
---@param Able number 是否通行
---@return any 
function Map.SetWalkable(Map,Floor,Xpos,Ypos,Able) end

---查看地图坐标是否可以通行
---@param Map number 地图类型
---@param Floor number 地图
---@param Xpos number X坐标
---@param Ypos number Y坐标
---@return number 可通行返回1，不可通行返回0
function Map.IsWalkable(Map,Floor,Xpos,Ypos) end

