---@alias 字符串 string
---@alias 数值型 number


---初始化Http服务器
---@param 
---@return any 
function Http.Init() end

---开启Http服务
---@param addr string 监听IP,例如  "0.0.0.0"
---@param port integer 端口 建议10000以上
---@return any integer ret @1：成功，其他为失败
function Http.Start(addr, port) end

---关闭Http服务器，需要注意，在请求中停止会导致请求响应502并且强制关闭所有未处理的请求
---@param 
---@return any 
function Http.Stop() end

---获取Http服务器状态
---@param 
---@return any 0|1|2 status  @0=未初始化 1=未启动 2=运行中
function Http.GetStatus() end

---绑定静态资源
---@param path string url地址
---@param dir string 本地目录
---@return any 
function Http.AddMountPoint(path, dir) end

---移除静态资源
---@param path string url地址
---@return any 
function Http.RemoveMountPoint(path) end

