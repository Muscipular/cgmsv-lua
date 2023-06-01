---@alias 字符串 string
---@alias 数值型 number


---执行指定的Mysql查询。
---@param QueryString  字符串 要执行的Mysql查询语句。
---@return number @如果查询的语句为INSERT, DELETE等，则返回0为成功，其他失败 | 如果查询的语句为SELECT, 则返回nil为无结果，返回Table为成功 | Table中即查询的结果 table[a_b]a为行数，b为列数
function SQL.Run(QueryString) end

---执行指定的Mysql查询。
---@param QueryString  字符串 要执行的Mysql查询语句。
---@return number @如果查询的语句为INSERT, DELETE等，则返回0为成功，其他失败 | 如果查询的语句为SELECT, 则返回nil为无结果，返回Table为成功 | Table中即查询的结果 table[a_b]a为行数，b为列数
function SQL.Query(QueryString) end

---执行指定的Mysql查询。
---@param param sql string sql
---@param ...  string|number 绑定参数，最多40个
---@return any @{status:number, effectRows:number, rows: table} 返回查询内容
function SQL.QueryEx(sql, ...) end

---将内容转换成string格式，带识别转义符功能
---@param s string|number
---@return any @string格式内容 失败返回'null'
function SQL.sqlValue(s) end

---执行指定的Mysql查询。
---@param sql  字符串 要执行的Mysql查询语句。
---@return any @string格式内容 table[a][b]a为行数，b为列数
function SQL.querySQL(sql, returnNil) end

