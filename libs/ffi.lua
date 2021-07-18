local ffi = require "ffi";
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
  if type(value) ~= 'number'  then
    return false;
  end
  ffi.cast("int32_t*", addr)[0] = value;
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
  ffi.copy(org_bytes, hookFnPtr, _size)
  org_bytes[_size] = 0xE9;
  ffi.cast('uint32_t*', org_bytes + _size + 1)[0] = hook_addr - (ffi.cast('uint32_t', org_bytes) + _size);
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
--HOOKS

ffi.hook = hook;
_G.FFI = ffi;
_G.ffi = ffi;
