--模块名称
local moduleName = 'petLottery'
--模块类
local PetLottery = ModuleBase:createModule(moduleName)

local pets = {
  { 3004, 500, },
  { 41382, 500, },
  { 1009, 500, },
  { 16003, 500, },
  { 16005, 500, },
  { 206, 500, },
  { 245, 500, },
  { 246, 500, },
  { 14027, 220, '兔耳仙人掌' },
  { 10088, 220, '纯白吓人箱' },
  { 103106, 220, '爱丝波波' },
  { 103277, 220, '丝诺波波' },
  { 103278, 220, '圣诞波波' },
  { 103279, 220, '雪儿波波' },
  { 10006, 120, '影子们' },
  { 10007, 120, '影子们' },
  { 10008, 120, '影子们' },
  { 10009, 120, '影子们' },
  { 511, 150, 'x精' },
  { 512, 150, 'x精' },
  { 513, 150, 'x精' },
  { 514, 150, 'x精' },
  { 41220, 100, '鼠王' },
  { 41241, 100, '佰两招财猫' },
  { 41249, 90, '佰两招财猫' },
  { 41242, 80, '仟两招财猫' },
  { 41251, 70, '万两招财猫' },
  { 41244, 60, '十万两招财猫' },
  { 41256, 50, '亿万两招财猫' },
  { 103132, 50, '大公鸡' },
  { 103342, 30, '达斯公鸡' },
  { 103316, 20, '无头骑士' },
  { 103317, 20, '狂战将军' },
  { 103318, 20, '血腥骑士' },
  { 103319, 20, '地狱骑士' },
  { 103320, 20, '地狱将军' },
  { 103321, 15, '梅兹' },
  { 103136, 15, '海贼王' },
  { 103327, 8, '雪蕾洁' },
  { 103326, 8, '露比' },
}

local MAX_N = table.reduce(pets, function(t, e)
  return t + e[2]
end, 0);

-- 加载模块钩子
function PetLottery:onLoad()
  self:logInfo('load')
  self:read();
  self:regCallback('ItemUseEvent', function(...)
    self:onItemUsed(...)
  end)
  --59999	137	123
  self.npc = self:NPC_createNormal('PetLottery', 10000, { x = 137, y = 123, mapType = 0, map = 59999, direction = 0, })
  self:NPC_regWindowTalkedEvent(self.npc, function(...)
    self:onWindowTalked(...)
  end)
end

local data = {};
function PetLottery:read()
  local t = {}
  local file = io.open('data/enemy.txt')
  for line in file:lines() do
    if line then
      local name, enemyId, baseId = string.match(line, '^(%S+)\t%S+\t(%d+)\t(%d+)\t1\t');
      --print(name, enemyId)
      if name and enemyId and baseId then
        t[baseId] = { name, enemyId, baseId };
      end
    end
  end
  file:close();
  file = io.open('data/enemybase.txt')
  for line in file:lines() do
    if line then
      local name, baseId = string.match(line, '^(%S+)\t(%d+)\t');
      --print(name, enemyId)
      if name and baseId and t[baseId] then
        data[t[baseId][2]] = name;
      end
    end
  end
  file:close();
  --for i, v in pairs(data) do
  --  print(i, v)
  --end
  --print(MAX_N);
end

function PetLottery:onWindowTalked(npc, player, seqNo, select, data)
  if select == CONST.BUTTON_是 then
    Char.GivePet(player, tonumber(seqNo));
  end
  NLG.UpChar(player);
end

function PetLottery:onItemUsed(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex, itemSlot);
  if tonumber(Item.GetData(itemIndex, CONST.道具_ID)) == 47763 then
    --NLG.ShowWindowTalked(charIndex, charIndex, CONST.窗口_信息框, CONST.BUTTON_是否, 0, "\\n\\n    是否")
    --Char.DelItem(charIndex, 47763, 1);
    Item.Kill(charIndex, itemIndex, itemSlot);
    local n = math.random(0, MAX_N)
    local k = n;
    for i, v in ipairs(pets) do
      if n <= v[2] then
        NLG.ShowWindowTalked(charIndex, self.npc, CONST.窗口_信息框, CONST.BUTTON_是否, v[1], "\\n\\n    (" .. k .. ")奖品为： " .. (data[tostring(v[1])] or '???') .. " 一只，是否领取？")
        return 1;
      end
      n = n - v[2]
    end
    NLG.SystemMessage(charIndex, "什么都没发生？？")
    return 1;
  end
  return 1;
end

-- 卸载模块钩子
function PetLottery:onUnload()
  self:logInfo('unload')
end

return PetLottery;
