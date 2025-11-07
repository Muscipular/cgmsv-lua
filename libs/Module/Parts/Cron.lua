---@class CronPart: ModulePart
local CronPart = ModuleBase:createPart('CronPart');

function CronPart:onLoad()
    self._cronTasks = {};
end

function CronPart:onUnload()
    for i, v in pairs(self._cronTasks) do
        Cron.RemoveTask(v);
    end
end

---添加定时任务
---@param cron string|integer[]|{minute:number,hour:number,day:number,month:number,week:number} 参考linux cron定义: 分 时 日 月 星期
---@param fn function 回调函数
---@param _repeat integer 是否重复,1为重复，0为执行一次
---@return number @id 返回0为失败
function CronPart:AddCron(cron, fn, _repeat)
    if type(cron) == "table" && cron.minute ~= nil then
        cron = { cron.minute, cron.hour or -1, cron.day or -1, cron.month or -1, cron.week or -1 };
    end
    if type(cron) == "table" then
        local vx = "";
        for i = 1, 5 do
            if type(cron[i]) == "number" && cron[i] < 0 then
                vx = vx .. "*"
            else
                vx = vx .. (cron[i] or "*")
            end
            if i < 5 then
                vx = vx .. " "
            end
        end
        cron = vx;
    end
    local r = Cron.AddCron(cron, fn, _repeat);
    table.insert(self._cronTasks, r);
    return r;
end

---添加定时任务
---@param interval number 重复间隔，毫秒
---@param fn function 回调函数
---@param _repeat integer 是否重复,1为重复，0为执行一次
---@return number @id 返回0为失败
function CronPart:AddInterval(interval, fn, _repeat)
    local r = Cron.AddInterval(interval, fn, _repeat);
    table.insert(self._cronTasks, r);
    return r;
end

---添加定时任务
---@param timestamp number 指定时间
---@param fn function 回调函数
---@return number @id 返回0为失败
function CronPart:RunAt(timestamp, fn)
    local r = Cron.RunAt(timestamp, fn);
    table.insert(self._cronTasks, r);
    return r;
end

---移除定时任务
---@param id number 任务Id
---@return number @移除的数量
function CronPart:RemoveTask(id)
    Cron.RemoveTask(id);
    for key, value in ipairs(self._cronTasks) do
        if (value == id) then
            table.remove(self._cronTasks, key);
            return;
        end
    end
end

return CronPart;
