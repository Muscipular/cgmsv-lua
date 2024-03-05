---@meta _

---转为utf8编码
---@param str string
---@return string
function Iconv.ToUtf8(str) end

---转为当前运行时编码(GBK/BIG5/其他)
---@param str string
---@return string
function Iconv.ToLocale(str) end
