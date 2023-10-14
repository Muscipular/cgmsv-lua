---@meta _

---获取迷宫Id
---@param floor number
---@return number @迷宫id
function Map.GetDungeonId(floor) end

---获取迷宫入口
---@param dungeonId number 迷宫id
---@return number mapType
---@return number floor
---@return number @x
---@return number @y
function Map.FindDungeonEntry(dungeonId) end

---获取迷宫的过期时间
---@param dungeonId number 迷宫id
---@return number @过期时间，单位秒
function Map.GetDungeonExpireAtByDungeonId(dungeonId) end

---根据迷宫Id设置迷宫重置时间
---@param dungeonId number 迷宫id
---@param time number UnixTime
---@return number @过期时间，单位秒
function Map.SetDungeonExpireAtByDungeonId(dungeonId, time) end

---获得地图位置的图档
---@param Map number 地图类型
---@param Floor number 地图
---@param Xpos number X坐标
---@param Ypos number Y坐标
---@return number @地板图档
---@return number @建筑物图档
function Map.GetImage(Map, Floor, Xpos, Ypos) end

---设定地图位置的图档
---@param Map number 地图类型
---@param Floor number 地图
---@param Xpos number X坐标
---@param Ypos number Y坐标
---@param Tile number 地板图档 可以为null
---@param Obj number 建筑物图档 可以为null
---@return number @成功返回0
function Map.SetImage(Map, Floor, Xpos, Ypos, Tile, Obj) end

---获得地图大小
---@param Map number 地图类型
---@param Floor number 地图
---@return number @长
---@return number @宽
function Map.GetMapSize(Map, Floor) end

---创建复制地图。新地图的mapid为CONST.地图类型_LUAMAP
---@param mapid  number 要复制的地图的Map ID。
---@param floor  number 要复制的地图的Floor ID。
---@return number @成功返回新的FloorID，失败返回-1。
function Map.MakeCopyMap(mapid, floor) end

---删除Lua生成的地图，释放地图编号。
---@param floor  number 地图的Floor ID。
---@return number @成功返回0，失败返回-1。
function Map.DelLuaMap(floor) end

---创建随机地图。
---@param Dofile? string 回调函数所在文件 字符串
---@param InitFuncName? string 回调函数名，当随机地图生成成功以后，会触发定义的回调函数 MakeMazeMapCallBack 字符串
---@param Xsize number 地图x坐标最大值
---@param Ysize number 地图y坐标最大值
---@param MapName string 地图名
---@return number @成功返回新的FloorID，失败返回-1。
function Map.MakeMazeMap(Dofile, InitFuncName, Xsize, Ysize, MapName) end

---创建随机地图。
---@param Dofile? string 回调函数所在文件 字符串
---@param InitFuncName? string 回调函数名，当随机地图生成成功以后，会触发定义的回调函数 MakeMazeMapCallBack 字符串
---@param Xsize number 地图x坐标最大值
---@param Ysize number 地图y坐标最大值
---@param MapName string 地图名
---@param pal number 调色板ID [定义地图调色板号]
---@param roomSize number 随机地图块大小 [定义随机生成地图的一些变量]
---@param roomSizeMinX number 随机地图块x坐标最小值 [定义随机生成地图的一些变量]
---@param roomSizeMinY number 随机地图块y坐标最小值 [定义随机生成地图的一些变量]
---@param roomSizeMaxX number 随机地图块x坐标最大值 [定义随机生成地图的一些变量]
---@param roomSizeMaxY number 随机地图块y坐标最大值 [定义随机生成地图的一些变量]
---@param tile number 地图地板图档编号 [定义地图图档信息]
---@param obj number 地图其他图档编号[定义地图图档信息]
---@param other number 地图其他物件编号[定义地图图档信息] 
---@param wallH number 墙横向图档编号 [定义地图墙面，如果全部写0，则会自动生成洞窟墙面]  
---@param wallHX number 墙横向反向图档编号  [定义地图墙面，如果全部写0，则会自动生成洞窟墙面] 
---@param wallV number 墙纵向图档编号 [定义地图墙面，如果全部写0，则会自动生成洞窟墙面]  
---@param wallVX number 墙纵向反向图档编号  [定义地图墙面，如果全部写0，则会自动生成洞窟墙面]  
---@param wallcross number 墙相交反向图档编号  [定义地图墙面，如果全部写0，则会自动生成洞窟墙面]  
---@return number @成功返回新的FloorID，失败返回-1。
function Map.MakeMazeMap(Dofile, InitFuncName, Xsize, Ysize, MapName, pal, roomSize, roomSizeMinX, roomSizeMinY, roomSizeMaxX, roomSizeMaxY, tile, obj, other, wallH, wallHX, wallV, wallVX, wallcross) end

---创建随机地图。
---@param Dofile? string 回调函数所在文件 字符串
---@param InitFuncName? string 回调函数名，当随机地图生成成功以后，会触发定义的回调函数 MakeMazeMapCallBack 字符串
---@param Xsize number 地图x坐标最大值
---@param Ysize number 地图y坐标最大值
---@param MapName string 地图名
---@param pal number 调色板ID [定义地图调色板号]
---@param roomSize number 随机地图块大小 [定义随机生成地图的一些变量]
---@param roomSizeMinX number 随机地图块x坐标最小值 [定义随机生成地图的一些变量]
---@param roomSizeMinY number 随机地图块y坐标最小值 [定义随机生成地图的一些变量]
---@param roomSizeMaxX number 随机地图块x坐标最大值 [定义随机生成地图的一些变量]
---@param roomSizeMaxY number 随机地图块y坐标最大值 [定义随机生成地图的一些变量]
---@param tile number 地图地板图档编号 [定义地图图档信息]
---@param obj number 地图其他图档编号[定义地图图档信息]
---@param other number 地图其他物件编号[定义地图图档信息] 
---@param wallH number 墙横向图档编号 [定义地图墙面，如果全部写0，则会自动生成洞窟墙面]  
---@param wallHX number 墙横向反向图档编号  [定义地图墙面，如果全部写0，则会自动生成洞窟墙面] 
---@param wallV number 墙纵向图档编号 [定义地图墙面，如果全部写0，则会自动生成洞窟墙面]  
---@param wallVX number 墙纵向反向图档编号  [定义地图墙面，如果全部写0，则会自动生成洞窟墙面]  
---@param wallcross number 墙相交反向图档编号  [定义地图墙面，如果全部写0，则会自动生成洞窟墙面]  
---@param bgm number 背景音乐
---@return number @成功返回新的FloorID，失败返回-1。
function Map.MakeMazeMap(Dofile, InitFuncName, Xsize, Ysize, MapName, pal, roomSize, roomSizeMinX, roomSizeMinY, roomSizeMaxX, roomSizeMaxY, tile, obj, other, wallH, wallHX, wallV, wallVX, wallcross, bgm) end

---这个是Map.MakeMazeMap生成随机地图结果的回调函数
---@param FloorID  number 生成的地图的编号
---@param Doneflg  number 生成地图的结果，如果该值为1则生成成功，如果为0则生成失败。
---@return any @
function MapCallBack(FloorID, Doneflg) end

---获取随机地图可用的坐标。
---@param mapid number 地图类型
---@param floor number 地图
---@return number @x坐标，如果失败则x与y都为-1。
---@return number @y坐标，如果失败则x与y都为-1。
function Map.GetAvailablePos(mapid, floor) end

---设置地图坐标是否可以通行
---@param Map number 地图类型
---@param Floor number 地图
---@param Xpos number X坐标
---@param Ypos number Y坐标
---@param Able number 是否通行
---@return number @
function Map.SetWalkable(Map, Floor, Xpos, Ypos, Able) end

---查看地图坐标是否可以通行
---@param Map number 地图类型
---@param Floor number 地图
---@param Xpos number X坐标
---@param Ypos number Y坐标
---@return number @可通行返回1，不可通行返回0
function Map.IsWalkable(Map, Floor, Xpos, Ypos) end

---获取地图扩展信息
---@param mapId number 地图类型
---@param floor number 地图
---@param field string field
---@return number|string|nil
function Map.GetExtData(mapId, floor, field) end

---设置地图扩展信息
---@param mapId number 地图类型
---@param floor number 地图
---@param field string field
---@param val number|string|nil 内容
---@return number @返回0为成功，其他失败
function Map.SetExtData(mapId, floor, field, val) end