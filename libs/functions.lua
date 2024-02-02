Func = {}
_G.Func = Func

---°ó¶¨²ÎÊý
---@param fn any
---@vararg any
---@return any
function Func.bind(fn, ...)
  local args = { ... }
  return function(...)
    local args2 = table.combine(args, { ... })
    return fn(table.unpack(args2))
  end
end
