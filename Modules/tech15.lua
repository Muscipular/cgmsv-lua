---模块类, 15级技能设定
local Tech15 = ModuleBase:createModule('tech15')

--- 加载模块钩子
function Tech15:onLoad()
  self:logInfo('load')
  if Skill.SetMaxLevel then
    Skill.SetMaxLevel(15)
    local skillExpTable = {
      { 0, 1100000, 1200000, 1300000, 1400000, 1500000 },
      { 1, 1100000, 1200000, 1300000, 1400000, 1500000 },
      { 2, 1100000, 1200000, 1300000, 1400000, 1500000 },
      { 3, 1100000, 1200000, 1300000, 1400000, 1500000 },
      { 4, 1100000, 1200000, 1300000, 1400000, 1500000 },
      { 5, 1100000, 1200000, 1300000, 1400000, 1500000 },
      { 6, 1100000, 1200000, 1300000, 1400000, 1500000 },
    }
    for i, v in pairs(skillExpTable) do
      for i = 1, 5 do
        Skill.SetExpForLv(v[1], 10 + i, v[i + 1])
      end
    end
  end
end

--- 卸载模块钩子
function Tech15:onUnload()
  self:logInfo('unload')
end

return Tech15;
