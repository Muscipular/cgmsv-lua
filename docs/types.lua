---@meta _


---@alias CharIndex integer
---@alias ItemIndex integer
---@alias BattleIndex integer
---@alias void nil

---@generic T
---@param s string
---@return T
function JSON.decode(s) end

---@generic T
---@param s T
---@return string
function JSON.encode(s) end

---@param n any
---@return number
function tonumberEx(n) end

---@param n any
---@param base number
---@return number
function tonumberEx(n, base) end

---@param n any
---@param base number
---@param trueValue number
---@param falseValue number
---@return number
function tonumberEx(n, base, trueValue, falseValue) end

---绑定参数
---@param fn any
---@vararg any
---@return any
function Func.bind(fn, ...) end

---@class fs

---读取文件，tab分割
---@param filePath string
---@return string[][]
function fs.parseFile(filePath) end;

---@param a number
---@param b number
---@return number
function math.div(a,b) end

---@param a number
---@param b number
---@return number
function math.mod(a,b) end
