---添加定时任务
---@param cron string 参考linux cron定义: 分 时 日 月 星期
---@param fn function 回调函数
---@param _repeat integer 是否重复,1为重复，0为执行一次
---@return number @id 返回0为失败
function Cron.AddCron(cron, fn, _repeat) end

---添加定时任务
---@param interval number 重复间隔，毫秒
---@param fn function 回调函数
---@param _repeat integer 是否重复,1为重复，0为执行一次
---@return number @id 返回0为失败
function Cron.AddInterval(interval, fn, _repeat) end

---添加定时任务
---@param timestamp number 指定时间
---@param fn function 回调函数
---@return number @id 返回0为失败
function Cron.RunAt(timestamp, fn) end

---移除定时任务
---@param id number 任务Id
---@return number @移除的数量
function Cron.RemoveTask(id) end
