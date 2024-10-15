---模块类
---@class NoBattleInjury : ModuleType
local NoBattleInjury = ModuleBase:createModule('noBattleInjury.lua')

--- 加载模块钩子
function NoBattleInjury:onLoad()
  self:logInfo('load')
  self:regCallback("BattleInjuryEvent", function(charIndex, battleIndex, injectOrigin, inject)
    if Char.GetData(charIndex, CONST.CHAR_血) > 0 then
      -- 拦截暴击导致受伤
      return 0;
    end
    return inject;
  end)
end

--- 卸载模块钩子
function NoBattleInjury:onUnload()
  self:logInfo('unload')
end

return NoBattleInjury;
