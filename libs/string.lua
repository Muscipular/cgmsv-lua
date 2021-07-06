---@param base number
---@param n number
---@return string
function string.formatNumber(n, base)
  n = math.floor(n);
  if n == nil then
    error('n不是数字')
  end
  if n < 0 then
    error('n不能少于0')
  end
  if base < 2 or base > 36 then
    error('base取值为2-36')
  end
  if base == 10 or n == 0 then
    return tostring(n)
  end
  local s = '0123456789abcdefghijklmnopqrstuvwxyz'
  local r = ''
  while n > 0 do
    if n == 0 then
      break ;
    end
    local k = math.fmod(n, base);
    r = string.sub(s, k + 1, k + 1) .. r;
    n = math.floor(n / base)
  end
  return r;
end

function string.split(text, delim)
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
