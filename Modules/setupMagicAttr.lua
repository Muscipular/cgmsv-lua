---模块类
local Module = ModuleBase:createModule('setupMagicAttr')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  if Tech.SetTechMagicAttribute then
    local magicMap = {
      { 1950, 1951, 1952, 2353, 2354, 2355, 2756, 2757, 2758, 2759, 1949, 2749 },
      { 2050, 2051, 2052, 2453, 2454, 2455, 2856, 2857, 2858, 2859, 2049, 2849 },
      { 2150, 2151, 2152, 2553, 2554, 2555, 2956, 2957, 2958, 2959, 2149, 2949 },
      { 2250, 2251, 2252, 2653, 2654, 2655, 3056, 3057, 3058, 3059, 2249, 3049 },
    }
    local attr = {
      { 100, 0,   0,   0 },
      { 0,   100, 0,   0 },
      { 0,   0,   100, 0 },
      { 0,   0,   0,   100 },
    }
    for i, v in ipairs(magicMap) do
      for _, techId in ipairs(v) do
        Tech.SetTechMagicAttribute(techId, table.unpack(attr[i]))
      end
    end
  end
  --Tech.SetTechMagicAttribute(2050, 100, 100, 100, 100); --全10属性魔法
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
