function log(module, level, msg, ...)
  print("[" .. level .. "][" .. module .. "]", msg, ...)
end
function logInfo(module, msg, ...)
  print("[INFO][" .. module .. "]", msg, ...)
end
function logError(module, msg, ...)
  print("[ERROR][" .. module .. "]", msg, ...)
end
function logWarn(module, msg, ...)
  print("[WARN][" .. module .. "]", msg, ...)
end
function logDebug(module, msg, ...)
  print("[DEBUG][" .. module .. "]", msg, ...)
end

function isEmpty(list)
  for i, v in pairs(list) do
    return false
  end
  return true
end

function findIndex(list, fn)
  for i, v in pairs(list) do
    if fn(v) then
      return i
    end
  end
  return nil
end

function find(list, fn)
  for i, v in pairs(list) do
    if fn(v) then
      return v
    end
  end
  return nil
end

function querySQL(sql)
  local result = SQL.Run(sql)
  if type(result) == "table" then
    local res = {}
    local field = tonumber(result.field);
    local row = tonumber(result.row);
    for i = 0, row do
      for j = 0, field do
        res[i + 1] = res[i + 1] or {}
        res[i + 1][j + 1] = result['' .. i .. '_' .. j];
      end
    end
    for i, v in pairs(result) do
      print(i,v);
      -- local r, c = table.unpack(splitString(tostring(i), "_"))
      -- r = tonumber(r) + 1
      -- c = tonumber(c) + 1
      -- res[r] = res[r] or {}
      -- res[r][c] = v
    end
    return res
  end
  return result
end

function splitString(text, delim)
  -- returns an array of fields based on text and delimiter (one character only)
  local result = {}
  local magic = "().%+-*?[]^$"

  if delim == nil then
    delim = "%s"
  elseif string.find(delim, magic, 1, true) then
    -- escape magic
    delim = "%" .. delim
  end

  local pattern = "[^" .. delim .. "]+"
  for w in string.gmatch(text, pattern) do
    table.insert(result, w)
  end
  return result
end

function listJoin(list, text)
  local n = ""
  text = text or ""
  for i, v in ipairs(list) do
    n = n .. text .. tostring(v)
  end
  return n:sub(text:len() + 1)
end

local json = dofile("lua/json.lua")

function jsonDecode(s)
  return json.decode(s)
end

function jsonEncode(s)
  return json.encode(s)
end
