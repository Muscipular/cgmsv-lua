function table:isEmpty()
  for i, v in pairs(self) do
    return false
  end
  return true
end

function table:findIndex(fn)
  for i, v in pairs(self) do
    if fn(v) then
      return i
    end
  end
  return nil
end

function table:find(fn)
  for i, v in pairs(self) do
    if fn(v) then
      return v
    end
  end
  return nil
end

function table:join(text)
  local n = ""
  text = text or ""
  for i, v in ipairs(self) do
    n = n .. text .. tostring(v)
  end
  return n:sub(text:len() + 1)
end

function table:indexOf(value)
  for i, v in ipairs(self) do
    if v == value then
      return i
    end
  end
  return -1;
end

function table:map(fn)
  local res = {}
  for i, v in pairs(self) do
    res[i] = fn(v);
  end
  return res;
end

function table.range(startNum, endNum, fn)
  local ret = {};
  local v;
  for i = startNum, endNum do
    if fn then
      v = fn(i)
    else
      v = i
    end
    table.insert(ret, v);
  end
end

function table:slice(startIx, endIx)
  return { table.unpack(self, startIx, endIx) };
end

table.unpack = _G.unpack or table.unpack;
table.pack = function(...)
  return { ... }
end
