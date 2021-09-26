_G.SQL = _G.SQL or {}
local SQL = _G.SQL;

function SQL.sqlValue(s)
  if s == nil then
    return 'null'
  end
  if type(s) == 'number' then
    return tostring(s)
  end
  if type(s) == 'string' then
    local r = "'"
    for i = 1, string.len(s) do
      local v = string.sub(s, i, i);
      if v == '\\' or v == '\'' then
        r = r .. '\\'
      end
      if not (v == '\n' or v == '\r') then
        r = r .. v;
      end
    end
    return r .. "'";
  end
  return 'null';
end

function SQL.querySQL(sql, returnNil)
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
  if result == SQL.CONST_RET_NO_ROW and returnNil then
    return nil;
  end
  return result
end
SQL.CONST_RET_NO_ROW = -3;
