--- AutoWalk测试模块
---@class AutoWalkTestModule : ModuleType
local AutoWalkTestModule = ModuleBase:createModule('autoWalkTest')

--- 处理聊天命令
---@param charIndex number 玩家索引
---@param msg string 聊天消息
function AutoWalkTestModule:onTalked(charIndex, msg)
    if msg == '/testAutoWalk' then
        -- 获取玩家当前位置信息
        local playerX = Char.GetData(charIndex, CONST.CHAR_X)
        local playerY = Char.GetData(charIndex, CONST.CHAR_Y)
        local playerMap = Char.GetData(charIndex, CONST.CHAR_地图)
        local playerMapType = Char.GetData(charIndex, CONST.CHAR_地图类型)

        local npcIndex = self:NPC_createNormal("TestAutoWalk", 103010, {
            x = playerX,
            y = playerY,
            map = playerMap,
            mapType = playerMapType,
            direction = 0,
        })

        if npcIndex >= 0 then
            -- 设置自动行走参数
            -- 在玩家周围3x3范围内移动
            local fromX = playerX - 5
            local toX = playerX + 5
            local fromY = playerY - 5
            local toY = playerY + 5

            -- 启用自动行走: NPC索引, 允许移动, 移动距离3, 间隔2000ms, 移动范围
            Char.SetAutoWalk(npcIndex, true, 3, 1000, fromX, toX, fromY, toY)
            Char.Warp(npcIndex, playerMapType, playerMap, playerX, playerY);

            NLG.SystemMessage(charIndex, "已创建AutoWalk测试NPC，将在您周围区域移动")
        else
            NLG.SystemMessage(charIndex, "创建NPC失败")
        end

        return 0
    end
    return 1
end

--- 模块加载时注册回调
function AutoWalkTestModule:onLoad()
    self:logInfo('AutoWalkTest module loaded')
    self:regCallback('TalkEvent', Func.bind(self.onTalked, self))
end

--- 模块卸载时的操作
function AutoWalkTestModule:onUnload()
    self:logInfo('AutoWalkTest module unloaded')
end

return AutoWalkTestModule
