---@meta _

---读取目标玩家的 对象index 指定Field的值。
---@param CharIndex  number 目标的 对象index。
---@param Field  string 数据栏名称。
---@return string @指定数据栏保存的数值。
function Field.Get(CharIndex, Field) end

---设置目标玩家的 对象index 指定Field的值。
---@param CharIndex  number 目标的 对象index。
---@param Field  string 数据栏名称。
---@param Value  string 要定义的值。
---@return number @
function Field.Set(CharIndex, Field, Value) end

