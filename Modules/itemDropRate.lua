---模块类
---@class ItemDropRate: ModuleType
local ItemDropRate = ModuleBase:createModule('itemDropRate')

local rateItems = {
    [9090] = 1000000
}


local stealItems = {
    [9090] = 1000000
}

function ItemDropRate:OnDropRate(battleIndex, enemyIndex, charaIndex, itemId, rate)
    if rateItems[itemId] then
        return rateItems[itemId];
    end
    return rate * 2;
end

function ItemDropRate:OnStealRate(battleIndex, enemyIndex, charaIndex, itemId, rate)
    if stealItems[itemId] then
        return stealItems[itemId];
    end
    return rate * 20;
end

--- 加载模块钩子
function ItemDropRate:onLoad()
    self:logInfo('load')
    self:regCallback("ItemDropRateEvent", Func.bind(self.OnDropRate, self))
    self:regCallback("StealItemEmitRateEvent", Func.bind(self.OnStealRate, self))
end

--- 卸载模块钩子
function ItemDropRate:onUnload()
    self:logInfo('unload')
end

return ItemDropRate;
