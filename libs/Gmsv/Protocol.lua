_G.Protocol = { Hooks = {}, _hooked = false }

local _ProtocolOnDispatch, _mlsvOnDispatch;
local _proto_send = FFI.cast('int (__cdecl *)(int fd, const char *str)', 0x00559370);
local _makeEscapeStringBuff = FFI.cast('char*', 0x006818C0);
local _makeEscapeString = FFI.cast("char *(__cdecl *)(const char *Str, char *target, int len)", 0x00407E80);
local _makeStringFromEscaped = FFI.cast('char* (__cdecl *)(const char* str)', 0x00407DD0);
local _nrproto_escapeString = FFI.cast('char* (__cdecl *)(const char* str)', 0x000558F00);
local _nrproto_unescapeString = FFI.cast('char* (__cdecl *)(const char* str)', 0x00559040);

---编码内容字符串，如消息封包的内容
function Protocol.makeEscapeString(str)
  return FFI.string(_makeEscapeString(str, _makeEscapeStringBuff, 2048));
end

---解码内容字符串，如消息封包的内容
function Protocol.makeStringFromEscaped(str)
  return FFI.string(_makeStringFromEscaped(str));
end

---封包字符串编码
function Protocol.nrprotoEscapeString(str)
  return FFI.string(_nrproto_escapeString(str));
end

---封包字符串解密
function Protocol.nrprotoUnescapeString(str)
  return FFI.string(_nrproto_unescapeString(str));
end

local split = string.split;
local formatNumber = string.formatNumber;

---发送封包到客户端
---@param charIndex number
---@param header string 封包头
---@vararg number|string data，根据封包内容而定，数字及字符串无须进行封包编码，会默认处理
---@return number 返回少于0为失败，其他可视为成功
function Protocol.Send(charIndex, header, ...)
  local ptr = Char.GetCharPointer(charIndex)
  if ptr <= 0 then
    return -1;
  end
  local fd = FFI.readMemoryInt32(ptr + 0x7BC);
  if fd < 0 then
    return -1;
  end
  local data = { ... }
  local package = header .. ' ';
  for i, v in ipairs(data) do
    if type(v) == 'number' then
      package = package .. formatNumber(v, 62) .. ' '
    elseif type(v) == 'string' then
      package = package .. Protocol.nrprotoEscapeString(v) .. ' '
    else
      return -2;
    end
  end
  return _proto_send(fd, package);
end

local function ProtocolOnDispatch(fd, str)
  local s, e = pcall(function()
    local s = FFI.string(str);
    local list = split(s, ' ');
    local head = list[1];
    table.remove(list, 1);
    for i = 1, #list do
      list[i] = Protocol.nrprotoUnescapeString(list[i]);
    end
    --print('[Protocol]收到[' .. (head or 'nil') .. ']封包,内容: ', unpack(list))
    if Protocol.Hooks[head] and _G[Protocol.Hooks[head]] then
      local ret = _G[Protocol.Hooks[head]](fd, head, list);
      if type(ret) == 'number' and ret < 0 then
        return -1;
      end
    end
    return nil;
  end)
  if s and type(e) == 'number' then
    return e;
  end
  return _ProtocolOnDispatch(fd, str);
end

---根据fd获取角色Index
function Protocol.GetCharIndexFromFd(fd)
  local charAddr = FFI.readMemoryDWORD(Addresses.ConnectionTable + 0x221E0 * fd + 0x22108);
  if not Char.IsValidCharPtr(charAddr) then
    return -1;
  end
  return FFI.readMemoryInt32(charAddr + 4);
end

---拦截封包回调
---@param Dofile string 加载文件
---@param FuncName string 回调名字
---@param PacketID string 封包头
function Protocol.OnRecv(Dofile, FuncName, PacketID)
  if Dofile and _G[FuncName] == nil then
    dofile(Dofile)
  end
  Protocol.Hooks[PacketID] = FuncName;
  if Protocol._hooked == false then
    Protocol._hooked = true;
    --00551800 ; int __cdecl nrproto_ServerDispatchMessage(int fd, char *encoded)
    _ProtocolOnDispatch = FFI.hook.new('int (__cdecl *)(uint32_t fd, const char *encoded)', ProtocolOnDispatch, 0x00551800, 5);
  end
end

--[[
---@param fd number
---@param head string 封包头
---@param data string[] 封包内容
---@return number 返回少于0为拦截封包, 0为封包正常通过 
local function DumpPackageCallback(fd, head, data)
  print(fd, '收到', head, '封包，内容: ', unpack(data))
  return 0;
end
_G.DumpPackageCallback = DumpPackageCallback;

Protocol.OnRecv(nil, 'DumpPackageCallback', 'zA')
]]
