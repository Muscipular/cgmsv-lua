local _G = _G
local Util = {}
_G.Utils = Util;
setmetatable(Util, { __index = _G });
setfenv(1, Util);

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

function indexOf(table, value)
  for i, v in ipairs(table) do
    if v == value then
      return i
    end
  end
  return -1;
end

local json = dofile("lua/libs/json.lua")

function jsonDecode(s)
  return json.decode(s)
end

function jsonEncode(s)
  return json.encode(s)
end

_G.LRU = dofile('lua/libs/lru.lua');

---@param base number
---@param n number
---@return string
function formatNumber(n, base)
  n = math.tointeger(n);
  if n == nil then
    error('n不是数字')
  end
  if n < 0 then
    error('n不能少于0')
  end
  if base < 2 or base > 36 then
    error('base取值为2-36')
  end
  local s = '0123456789abcdefghijklmnopqrstuvwxyz'
  local r = ''
  while (not n == 0) do
    local k = math.floor(n / base);
    r = r .. string.sub(s, k + 1, k + 2);
    n = math.fmod(n, base)
  end
  return r;
end

function sqlValue(s)
  if s == nil then
    return 'null'
  end
  if type(s) == 'number' then
    return tostring(s)
  end
  if type(s) == 'string' then
    local r = "'"
    for i = 1, string.len(s) do
      local v = string.sub(s, i, i + 1);
      if v == '\\' or v == '\'' then
        r = r .. '\\'
      end
      r = r .. v;
    end
    return r .. "'";
  end
end

for i, v in pairs(Util) do
  _G[i] = v;
end
