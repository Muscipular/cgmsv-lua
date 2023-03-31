Func = {}
_G.Func = Func

---°ó¶¨²ÎÊý
---@generic T : function
---@param fn T
---@vararg any
---@return T
function Func.bind(fn, ...)
  local args = { ... }
  return function(...)
    local args2 = table.combine(args, { ... })
    return fn(table.unpack(args2))
  end
end
