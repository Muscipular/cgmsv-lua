---模块类
---@class CronModule: ModuleType
local CronModule = ModuleBase:createModule('cron')


--- 加载模块钩子
function CronModule:onLoad()
    _G.loggerLevel = 99;
    self:SetLogLevel(99);
    self:logInfo('load ')
    self:regCallback("Init", function()
        self:logInfo('start cron ' .. os.date("%Y-%m-%d %H:%M:%S", os.time()))
        self:AddCron({ minute = -1, hour = -1, day = -1, month = -1, week = -1 }, function()
            self:logInfo(os.date("分钟报时 %Y-%m-%d %H:%M:%S", os.time()))
        end, 1)
        local n = self:AddInterval(15 * 1000, function()
            self:logInfo(os.date("15秒间隔 %Y-%m-%d %H:%M:%S", os.time()))
        end, 1)
        self:AddInterval(10 * 1000, function()
            self:logInfo(os.date("10秒间隔 %Y-%m-%d %H:%M:%S", os.time()))
        end, 0)
        self:RunAt(os.time() + 5, function()
            self:logInfo(os.date("5秒后执行 %Y-%m-%d %H:%M:%S", os.time()))
        end)
        self:RunAt(os.time() + 90, function()
            self:logInfo(os.date("90秒后执行 %Y-%m-%d %H:%M:%S", os.time()))
            self:RemoveTask(n);
        end)
        self:RunAt(os.time() + 120, function()
            self:logInfo(os.date("120秒后执行 %Y-%m-%d %H:%M:%S", os.time()))
            unloadModule('cron');
        end)
    end);
end

--- 卸载模块钩子
function CronModule:onUnload()
    self:logInfo('unload')
end

return CronModule;
