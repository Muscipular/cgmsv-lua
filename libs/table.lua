function table:isEmpty()
  for i, v in pairs(self) do
    return false
  end
  return true
end

---@param fn fun(e:any, i:number, list: table):boolean
---@return number|nil
function table:findIndex(fn)
  for i, v in pairs(self) do
    if fn(v, i, self) then
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

function table:keys(fn)
  local ret = {}
  for i, v in pairs(self) do
    table.insert(ret, i);
  end
  return ret;
end

function table:values(fn)
  local ret = {}
  for i, v in pairs(self) do
    table.insert(ret, v);
  end
  return ret;
end

table.join = table.concat;

function table:filter(fn)
  local ret = {}
  for i, v in pairs(self) do
    if fn(v, i, self) then
      table.insert(ret, v);
    end
  end
  return ret;
end

table.where = table.filter;

function table.combine(...)
  local ret = {}
  local args = { ... }
  local n = 1;
  for i, v in ipairs(args) do
    if type(v) == 'table' then
      for _i, x in ipairs(v) do
        ret[n] = x;
        n = n + 1;
      end
    end
  end
  return ret;
end

function table:indexOf(value)
  for i, v in ipairs(self) do
    if v == value then
      return i
    end
  end
  return -1;
end

function table:forEach(fn)
  for i, v in ipairs(self) do
    fn(v, i, self);
  end
end

function table:map(fn)
  local res = {}
  for i, v in pairs(self) do
    res[i] = fn(v, i, self);
  end
  return res;
end

function table:copy()
  local res = {}
  for i, v in pairs(self) do
    res[i] = v;
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

function table:reduce(fn, initVal)
  for i, v in ipairs(self) do
    initVal = fn(initVal, v, i)
  end
  return initVal;
end
