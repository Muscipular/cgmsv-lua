local sBase62 = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
local dBase62 = {}
for i = 1, 62 do
  dBase62[string.sub(sBase62, i, i)] = i - 1;
end

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
  if base < 2 or base > 62 then
    error('base取值为2-62')
  end
  if base == 10 or n == 0 then
    return tostring(n)
  end
  local r = ''
  while n > 0 do
    if n == 0 then
      break ;
    end
    local k = math.fmod(n, base);
    r = string.sub(sBase62, k + 1, k + 1) .. r;
    n = math.floor(n / base)
  end
  return r;
end

function string.decodeNumber(s, base)
  local ret = 0;
  for i = 1, string.len(s) do
    print(string.sub(s, i, i), dBase62[string.sub(s, i, i)], ret);
    ret = ret * base + dBase62[string.sub(s, i, i)]
  end
  return ret;
end

function string.split(str, separator)
  local str = tostring(str)
  local separator = tostring(separator)
  local strB, arrayIndex = 1, 1
  local targetArray = {}
  if (separator == nil)
  then
    return false
  end
  local condition = true
  while (condition)
  do
    local si, sd = string.find(str, separator, strB)
    if (si)
    then
      targetArray[arrayIndex] = string.sub(str, strB, si - 1)
      arrayIndex = arrayIndex + 1
      strB = sd + 1
    else
      targetArray[arrayIndex] = string.sub(str, strB, string.len(str))
      condition = false
    end
  end
  return targetArray
end
