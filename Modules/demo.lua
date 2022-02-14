---模块类
local Module = ModuleBase:createModule('demo')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('PreItemPickUpEvent', function(charIndex, itemIndex)
    local n = NLG.Rand(1, 100);
    self:logDebugF('PreItemPickUpEvent %d %s => %d %s %d%%', charIndex, Char.GetData(charIndex, CONST.CHAR_名字), itemIndex, Item.GetData(itemIndex, CONST.道具_名字), n);
    if n < 50 then
      return -1;
    end
    return 0;
  end)
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
