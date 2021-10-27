function tonumberEx(n, base, trueValue, falseValue)
  if falseValue == nil then
    falseValue = 0;
  end
  if trueValue == nil then
    trueValue = 1;
  end
  local t = type(n);
  if t == 'number' then
    return t;
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
