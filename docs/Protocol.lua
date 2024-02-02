---@meta _

---创建一个指定封包接受到后触发的函数
---[@group Protocol.OnRecv]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[OnRecvCallBack]
---@param PacketID  string 封包头
---@return any @
function Protocol.OnRecv(Dofile, FuncName, PacketID) end

---OnRecv的回调函数
---[@group Protocol.OnRecv]
---@param Fd  number 响应事件的对象的网络套接字ID，该值由Lua引擎传递给本函数，可以通过Protocol.GetCharByFd获取对应的玩家对象。
---@param Head  string 封包头
---@param Packet  string[] 封包内容。
---@return number @返回0则不拦截该封包，返回1则拦截该封包（服务端将不会进一步处理该封包，等同于中转封包过滤）。
function OnRecvCallBack(Fd, Head, Packet) end

---根据玩家客户端连接号获取玩家对象
---@param Fd  number 网络套接字ID。
---@return number @成功返回对象index，失败返回-1。
function Protocol.GetCharByFd(Fd) end

---根据玩家客户端连接号获取玩家对象
---@param fd  number 网络套接字ID。
---@return number @成功返回对象index，失败返回-1。
function Protocol.GetCharIndexFromFd(fd) end

---自定义发送封包。
---@param CharIndex  number 目标的 对象index。
---@param header  string 封包头
---@param ...string|number 封包内容
---@return number @返回0失败，返回1成功。
function Protocol.Send(CharIndex, header, ...) end

---自定义发送封包。
---@param fd  number 网络套接字ID。
---@param header  number 封包头
---@param ...string|number 封包内容
---@return number @返回0失败，返回1成功。
function Protocol.SendToFd(fd, header, ...) end

---获取客户端IP
---@param fd  number 网络套接字ID。
---@return any @ip
function Protocol.GetIp(fd) end

---根据charIndex获取fd
---@param charIndex number
---@return number @Fd: 数值型 网络套接字ID。
function Protocol.GetFdByCharIndex(charIndex) end

---编码内容字符串，如消息封包的内容
---@param str string
---@return string @编码后字符串
function Protocol.makeEscapeString(str) end

---解码内容字符串，如消息封包的内容
---@param str string
---@return string @解码后字符串
function Protocol.makeStringFromEscaped(str) end

---封包字符串编码
---@param str string
---@return string @编码后字符串
function Protocol.nrprotoEscapeString(str) end

---封包字符串解密
---@param str string
---@return string @解码后字符串
function Protocol.nrprotoUnescapeString(str) end

