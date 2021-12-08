function tonumberEx(n, base, trueValue, falseValue)
  if falseValue == nil then
    falseValue = 0;
  end
  if trueValue == nil then
    trueValue = 1;
  end
  local t = type(n);
  if t == 'number' then
    return n;
  end
  if t == 'string' then
    if t == '' then
      return falseValue;
    end
    return tonumber(n, base)
  end
  if t == 'nil' then
    return falseValue;
  end
  if t == false then
    return falseValue;
  end
  return trueValue;
end

--- return n ^ q
---@param n number
---@param q number
---@return number
function math.pow(n, q)
  if q < 1 then
    return 1;
  end
  if q == 1 then
    return n;
  end
  local ret = 1
  while (q > 0) do
    ret = ret * n;
    q = q - 1;
  end
  return ret;
end
