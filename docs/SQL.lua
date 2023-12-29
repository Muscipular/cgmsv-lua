---@meta _

---执行指定的Mysql查询。
---@param QueryString  string 要执行的Mysql查询语句。
---@return number|table @如果查询的语句为INSERT, DELETE等，则返回0为成功，其他失败 | 如果查询的语句为SELECT, 则返回nil为无结果，返回Table为成功 | Table中即查询的结果 table[a_b]a为行数，b为列数
function SQL.Run(QueryString) end

---执行指定的Mysql查询。
---@param QueryString  string 要执行的Mysql查询语句。
---@return number|table @如果查询的语句为INSERT, DELETE等，则返回0为成功，其他失败 | 如果查询的语句为SELECT, 则返回nil为无结果，返回Table为成功 | Table中即查询的结果 table[a_b]a为行数，b为列数
function SQL.Query(QueryString) end

---执行指定的Mysql查询。
---@param sql string sql
---@vararg string|number 绑定参数，最多40个
---@return {status:number,effectRows:number,rows:table} @返回查询内容
function SQL.QueryEx(sql, ...) end

---获取Mysql连接对象，PS：用完必须释放，否则Mysql连接已经用完
---@return MysqlConn @Mysql连接对象
function SQL.GetConn() end

---@class MysqlConn
MysqlConn = {}

---执行指定的Mysql查询。
---@param sql string sql
---@vararg string|number 绑定参数，最多40个
---@return {status:number,effectRows:number,rows:table} @返回查询内容
function MysqlConn:Query(sql, ...) end

---释放连接
function MysqlConn:Release() end

---开启事务
function MysqlConn:BeginTrans() end

---回滚事务
function MysqlConn:Rollback() end

---提交事务
function MysqlConn:Commit() end

