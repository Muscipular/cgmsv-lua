local ffi = require "ffi";
function ffi.readMemoryDWORD(addr)
  if addr == 0 then
    return 0;
  end
  return ffi.cast("uint32_t*", addr)[0]
end
function ffi.readMemoryInt32(addr)
  if addr == 0 then
    return 0;
  end
  return ffi.cast("int32_t*", addr)[0]
end
function ffi.readMemoryWORD(addr)
  if addr == 0 then
    return 0;
  end
  return ffi.cast("uint16_t*", addr)[0]
end
function ffi.readMemoryBYTE(addr)
  if addr == 0 then
    return 0;
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
_G.FFI = ffi;
