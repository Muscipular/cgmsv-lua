_G.Data = {}
Protocol = { Hooks = {}, _hooked = false }
FFI.cdef [[
    typedef int __cdecl (*proto_send)(int fd, char *str);
]];

local function ps(...)
  print(table.unpack(table.map({ ... }, function(e)
    if type(e) == 'number' and e > 0 then
      return string.formatNumber(e, 16)
    end
    return e;
  end)))
end

local _proto_send = FFI.cast('proto_send', 0x00559370)

function Protocol.send(charIndex, header, data)
  local ptr = Char.GetCharPointer(charIndex)
  if ptr <= 0 then
    return -1;
  end
  local fd = FFI.readMemoryDWORD(ptr + 0x7DC);
  if fd > 0 then
    return _proto_send(fd, header .. ' ' .. data)
  end
  return -1;
end

local _OnDispatch = nil;
--local nrprotoSplitString = FFI.cast('void (__cdecl *)(char *src)', 0x00559180);
--local token_list = FFI.cast('char**', 0x00606D80 + 0x2c);

local function OnDispatch(fd, str)
  local s, e = pcall(function()
    print(fd, FFI.string(str));
    local s = FFI.string(str);
    local pack = string.split(FFI.string(str), ' ')
    if Protocol.Hooks[pack[1]] and _G[Protocol.Hooks[pack[1]]] then
      if _G[Protocol.Hooks[pack[1]]](fd, pack[0], s) < 0 then
        --print('reject')
        return -1;
      end
    end
    return _OnDispatch(fd, str);
  end)
  --print(s, e, a)
  return s and e or _OnDispatch(fd, str);
end

function Protocol.GetCharIndexFromFd(fd)
  --TODO 这个地址不对
  return FFI.readMemoryInt32(FFI.readMemoryDWORD(0x1125704) + 139744 * fd + 139528 + 8);
  --dword_1125704 + 34936 * a1 + 34882
end

function Protocol.OnRecv(Dofile, FuncName, PacketID)
  if Dofile and _G[FuncName] == nil then
    dofile(Dofile)
  end
  Protocol.Hooks[PacketID] = FuncName;
  if Protocol._hooked == false then
    Protocol._hooked = true;
    --00551800 ; int __cdecl nrproto_ServerDispatchMessage(int fd, char *encoded)
    _OnDispatch = FFI.hook.new('int (__cdecl *)(int fd, char *encoded)', OnDispatch, 0x00551800, 5);
  end
end

_G.aaa = function()
  return -1;
end

Protocol.OnRecv(nil, 'aaa', 'JFVf11')

local CharaTablePTR = FFI.readMemoryDWORD(0x091A6E54);
ps('CharaTable', CharaTablePTR)
function Char.GetCharPointer(charIndex)
  if Char.GetData(charIndex, CONST.CHAR_类型) == 1 then
    return CharaTablePTR + charIndex * 0x21EC;
  end
  return 0;
end

local ItemIdMax = FFI.readMemoryDWORD(0x09205BE0);
print('ItemIdMax:', ItemIdMax)
local ItemIndexTblTPR = FFI.readMemoryDWORD(0x09205584);
ps('item_index_tbl', ItemIndexTblTPR)
local ItemTableMax = FFI.readMemoryDWORD(0x00687C80);
print('ItemTableMax:', ItemTableMax)
local ItemTablePTR = FFI.readMemoryDWORD(0x09205588);
ps('item_tbl', ItemTablePTR)

function Data.ItemsetGetIndex(ItemID)
  if ItemID < 0 and ItemID >= ItemIdMax then
    return -1;
  end
  return FFI.readMemoryInt32(ItemIndexTblTPR + 4 * ItemID)
end

function Data.ItemsetGetData(ItemsetIndex, DataPos)
  if ItemsetIndex < 0 or ItemsetIndex >= ItemTableMax then
    return nil;
  end
  if DataPos >= 2000 then
    --string32 * 13 
    DataPos = DataPos - 2000;
    if DataPos >= 13 then
      return nil;
    end
    return FFI.readMemoryString(ItemTablePTR + ItemsetIndex * 1092 + 78 * 4 + DataPos * 32 + 4)
  end
  local p = 0;
  if DataPos >= 78 then
    --ext data & function ptr
    if DataPos >= 92 then
      --random data
      p = FFI.readMemoryInt32(ItemTablePTR + ItemsetIndex * 1092 + (DataPos - 90) * 4 + 4)
    end
    DataPos = 8 * 13 + DataPos
    if DataPos >= 273 then
      return nil
    end
  end
  return FFI.readMemoryInt32(ItemTablePTR + ItemsetIndex * 1092 + DataPos * 4 + 4) + p
end
