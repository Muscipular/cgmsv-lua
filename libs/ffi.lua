local ffi = require "ffi";
ffi.cdef [[
    void Sleep(int ms);
    char *strstr(const char *str1, const char *str2);
]];
function ffi.readMemoryDWORD(addr)
  if addr == 0 then
    return nil;
  end
  return ffi.cast("uint32_t*", addr)[0]
end
function ffi.readMemoryInt32(addr)
  if addr == 0 then
    return nil;
  end
  return ffi.cast("int32_t*", addr)[0]
end
function ffi.setMemoryInt32(addr, value)
  if addr == 0 then
    return false;
  end
  if type(value) ~= 'number' then
    return false;
  end
  ffi.cast("int32_t*", addr)[0] = value;
  return true;
end
function ffi.setMemoryDWORD(addr, value)
  if addr == 0 then
    return false;
  end
  if type(value) ~= 'number' then
    return false;
  end
  ffi.cast("uint32_t*", addr)[0] = value;
  return true;
end
function ffi.setMemoryByte(addr, value)
  if addr == 0 then
    return false;
  end
  if type(value) ~= 'number' then
    return false;
  end
  ffi.cast("uint8_t*", addr)[0] = value;
  return true;
end
function ffi.readMemoryWORD(addr)
  if addr == 0 then
    return nil;
  end
  return ffi.cast("uint16_t*", addr)[0]
end
function ffi.readMemoryBYTE(addr)
  if addr == 0 then
    return nil;
  end
  return ffi.cast("uint8_t*", addr)[0]
end
function ffi.readMemoryString(addr)
  if addr <= 0 or addr >= 0xffffffff then
    return nil;
  end
  local d = ffi.cast("char*", addr);
  if d == nil then
    return nil;
  end
  return ffi.string(ffi.cast("char*", addr))
end

--HOOKS
local hook = { hooks = {} }
ffi.cdef [[
    int VirtualProtect(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect);
]]
function hook.new(cast, callback, hook_addr, size)
  local _size = size or 5
  local new_hook = {}
  local detour_addr = tonumber(ffi.cast('intptr_t', ffi.cast('void*', ffi.cast(cast, callback))))
  local hookFnPtr = ffi.cast('void*', hook_addr)
  local old_prot = ffi.new('unsigned long[1]')
  local old_prot2 = ffi.new('unsigned long[1]')
  local org_bytes = ffi.new('uint8_t[?]', _size + 10)
  ffi.C.VirtualProtect(org_bytes, _size + 10, 0x40, old_prot)
  ffi.copy(org_bytes, hookFnPtr, _size)
  org_bytes[_size] = 0xE9;
  ffi.cast('uint32_t*', org_bytes + _size + 1)[0] = hook_addr + size - (ffi.cast('uint32_t', org_bytes) + _size + 5);
  local hook_bytes = ffi.new('uint8_t[?]', _size, 0x90)
  hook_bytes[0] = 0xE9
  ffi.cast('uint32_t*', hook_bytes + 1)[0] = detour_addr - hook_addr - 5
  ffi.C.VirtualProtect(hookFnPtr, _size, 0x40, old_prot)
  ffi.copy(hookFnPtr, hook_bytes, _size)
  ffi.C.VirtualProtect(hookFnPtr, _size, old_prot[0], old_prot2)
  --local orgHookedPtr = ffi.cast(cast, ffi.cast('void*', ffi.cast('uint32_t', org_bytes)));
  --ffi.C.VirtualProtect(org_bytes, _size, old_prot[0], old_prot2)
  new_hook.uninstall = function()
    ffi.C.VirtualProtect(hookFnPtr, _size, 0x40, old_prot)
    ffi.copy(hookFnPtr, org_bytes, _size)
    ffi.C.VirtualProtect(hookFnPtr, _size, old_prot[0], old_prot2)
    hook.hooks[tostring(hook_addr)] = nil;
  end
  new_hook.call = ffi.cast(cast, org_bytes)
  new_hook.org_bytes = org_bytes;
  new_hook.callback = callback;
  hook.hooks[tostring(hook_addr)] = new_hook;
  return setmetatable(new_hook, {
    __call = function(self, ...)
      local res = self.call(...)
      return res
    end
  })
end

---@param config {ignoreOriginCode:boolean}
function hook.inlineHook(cast, callback, hookAddr, size, prefixCode, postCode, config)
  if config == nil then
    config = {
      ignoreOriginCode = false,
    }
  end
  local callbackAddr = type(callback) == 'function' and tonumber(ffi.cast('intptr_t', ffi.cast('void*', ffi.cast(cast, callback)))) or 0;
  if type(callback) ~= 'function' and callback then
    callbackAddr = callback;
  end
  local hookFnPtr = ffi.cast('void*', hookAddr)
  local oldProtectFlag = ffi.new('unsigned long[1]')
  local tmpProtectFlag = ffi.new('unsigned long[1]')
  local detourBytes = ffi.new('uint8_t[?]', 2048)
  local backup = ffi.new('uint8_t[?]', size)
  ffi.C.VirtualProtect(backup, size, 0x40, oldProtectFlag)
  -- make backup
  ffi.copy(backup, hookFnPtr, size);
  -- prefixCode
  for i, v in ipairs(prefixCode) do
    detourBytes[i - 1] = v;
  end
  --call callback
  if callback then
    detourBytes[#prefixCode] = 0xE8;
    ffi.cast('uint32_t*', detourBytes + #prefixCode + 1)[0] = callbackAddr - (ffi.cast('uint32_t', detourBytes) + #prefixCode + 5);
  else
    detourBytes[#prefixCode] = 0x90;
    detourBytes[#prefixCode + 1] = 0x90;
    detourBytes[#prefixCode + 2] = 0x90;
    detourBytes[#prefixCode + 3] = 0x90;
    detourBytes[#prefixCode + 4] = 0x90;
  end
  -- postCode
  for i, v in ipairs(postCode) do
    detourBytes[i - 1 + 5 + #prefixCode] = v;
  end
  --origin code
  if config.ignoreOriginCode then
    for i = 1, size do
      detourBytes[#prefixCode + 5 + #postCode + i - 1] = 0x90;
    end
  else
    ffi.copy(detourBytes + #prefixCode + 5 + #postCode, hookFnPtr, size);
  end
  --jmp to origin code
  detourBytes[#prefixCode + 5 + size + #postCode] = 0xE9;
  ffi.cast('int32_t*', detourBytes + #prefixCode + 5 + size + #postCode + 1)[0] = ffi.cast('int32_t', (hookAddr + size) - (ffi.cast('int32_t', detourBytes) + size + #postCode + #prefixCode + 10));
  --mark memory executable
  ffi.C.VirtualProtect(detourBytes, 2048, 0x40, tmpProtectFlag);
  --mark memory writable
  ffi.C.VirtualProtect(hookFnPtr, size, 0x40, oldProtectFlag)
  --jmp to hook code
  ffi.cast('uint8_t*', hookAddr)[0] = 0xE9;
  ffi.cast('uint32_t*', hookAddr + 1)[0] = ffi.cast('uint32_t', detourBytes) - (hookAddr + 5);
  for i = 5, size - 1 do
    ffi.cast('uint8_t*', hookAddr + i)[0] = 0x90;
  end
  --restore memory protect 
  ffi.C.VirtualProtect(hookFnPtr, size, oldProtectFlag[0], tmpProtectFlag)
  local new_hook = {}
  new_hook.uninstall = function()
    ffi.C.VirtualProtect(hookFnPtr, size, 0x40, oldProtectFlag)
    ffi.copy(hookFnPtr, backup, size)
    ffi.C.VirtualProtect(hookFnPtr, size, oldProtectFlag[0], tmpProtectFlag)
    hook.hooks[tostring(hookAddr)] = nil;
  end
  --new_hook.call = ffi.cast(cast, detourBytes)
  new_hook.detourBytes = detourBytes;
  new_hook.backup = backup;
  new_hook.callback = callback;
  hook.hooks[tostring(hookAddr)] = new_hook;
  return new_hook;
  --return setmetatable(new_hook, {
  --  __call = function(self, ...)
  --    local res = self.call(...)
  --    return res
  --  end
  --})
end
--HOOKS

---@param hookFnPtr number
---@param value number[]
function ffi.patch(hookFnPtr, value)
  local old_prot = ffi.new('unsigned long[1]')
  local old_prot2 = ffi.new('unsigned long[1]')
  ffi.C.VirtualProtect(ffi.cast('void*', hookFnPtr), #value, 0x40, old_prot);
  for i = 1, #value do
    ffi.cast('uint8_t*', hookFnPtr)[i - 1] = value[i];
  end
  ffi.C.VirtualProtect(ffi.cast('void*', hookFnPtr), #value, old_prot[0], old_prot2);
end

function ffi.fnOffset(addr, fn, typeName)
  local fnPtr = ffi.cast('uint32_t', ffi.cast('void*', ffi.cast(typeName, fn)));
  return fnPtr - addr;
end

function ffi.uint32ToArray(n)
  local v = ffi.new('uint8_t[4]')
  ffi.cast('uint32_t*', v)[0] = n;
  return { v[0], v[1], v[2], v[3] };
end

function printAsHex(...)
  print(table.unpack(table.map({ ... }, function(e)
    if type(e) == 'number' and e > 0 then
      return string.formatNumber(e, 16)
    end
    return e;
  end)))
end

ffi.hook = hook;
_G.FFI = ffi;
_G.ffi = ffi;
