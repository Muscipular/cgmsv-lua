---@class GmsvData
local GmsvData = ModuleBase:createModule('gmsvData')

GmsvData.CONST = {};
--[["最低等级"	"最高等级"	"最低出现数量"	"最高出现数量"	"enemyai代码"	"战斗经验"	"战绩经验"	"攻击模式"	"1可捉0不可捉"	"掉落物品item代码1"
--	"掉落物品item代码2"	"掉落物品item代码3"	"掉落物品item代码4"	"掉落物品item代码5"	"掉落物品item代码6"	"掉落物品item代码7"	"掉落物品item代码8"
--	"掉落物品item代码9"	"掉落物品item代码10"	"物品掉率1"	"物品掉率2"	"物品掉率3"	"物品掉率4"	"物品掉率5"	"物品掉率6"	"物品掉率7"	
--	"物品掉率8"	"物品掉率9"	"物品掉率10"	偷到物品item代码1	偷到物品item代码2	偷到物品item代码3	偷到物品item代码4	偷到物品item代码5	
--	"偷到概率1"	"偷到概率2"	"偷到概率3"	"偷到概率4"	"偷到概率5"	"0是怪1是BOSS"	"0为1动1为2动"	"召唤魔法召唤的代码（enemy）"	
--	"召唤魔法召唤的代码（enemy）"	"enemytalk代码"
--]]
GmsvData.CONST.Enemy = {};
GmsvData.CONST.Enemy.Name = 1;
GmsvData.CONST.Enemy.Param = 2;
GmsvData.CONST.Enemy.EnemyId = 3;
GmsvData.CONST.Enemy.BaseId = 4;
GmsvData.CONST.Enemy.MinLevel = 5;
GmsvData.CONST.Enemy.MaxLevel = 6;
GmsvData.CONST.Enemy.MinCount = 7;
GmsvData.CONST.Enemy.MaxCount = 8;
GmsvData.CONST.Enemy.EnemyAI = 9;
GmsvData.CONST.Enemy.Exp = 10;
GmsvData.CONST.Enemy.Dp = 11;
GmsvData.CONST.Enemy.AttackMode = 12;
GmsvData.CONST.Enemy.CanSeal = 13;
GmsvData.CONST.Enemy.DropItemId1 = 14;
GmsvData.CONST.Enemy.DropItemId2 = 15;
GmsvData.CONST.Enemy.DropItemId3 = 16;
GmsvData.CONST.Enemy.DropItemId4 = 17;
GmsvData.CONST.Enemy.DropItemId5 = 18;
GmsvData.CONST.Enemy.DropItemId6 = 19;
GmsvData.CONST.Enemy.DropItemId7 = 20;
GmsvData.CONST.Enemy.DropItemId8 = 21;
GmsvData.CONST.Enemy.DropItemId9 = 22;
GmsvData.CONST.Enemy.DropItemId10 = 23;
GmsvData.CONST.Enemy.DropItemPercent1 = 24;
GmsvData.CONST.Enemy.DropItemPercent2 = 25;
GmsvData.CONST.Enemy.DropItemPercent3 = 26;
GmsvData.CONST.Enemy.DropItemPercent4 = 27;
GmsvData.CONST.Enemy.DropItemPercent5 = 28;
GmsvData.CONST.Enemy.DropItemPercent6 = 29;
GmsvData.CONST.Enemy.DropItemPercent7 = 30;
GmsvData.CONST.Enemy.DropItemPercent8 = 31;
GmsvData.CONST.Enemy.DropItemPercent9 = 32;
GmsvData.CONST.Enemy.DropItemPercent10 = 33;
GmsvData.CONST.Enemy.StealItemId1 = 34;
GmsvData.CONST.Enemy.StealItemId2 = 35;
GmsvData.CONST.Enemy.StealItemId3 = 36;
GmsvData.CONST.Enemy.StealItemId4 = 37;
GmsvData.CONST.Enemy.StealItemId5 = 38;
GmsvData.CONST.Enemy.StealItemPercent1 = 39;
GmsvData.CONST.Enemy.StealItemPercent2 = 40;
GmsvData.CONST.Enemy.StealItemPercent3 = 41;
GmsvData.CONST.Enemy.StealItemPercent4 = 42;
GmsvData.CONST.Enemy.StealItemPercent5 = 43;
GmsvData.CONST.Enemy.IsBoss = 44;
GmsvData.CONST.Enemy.IsDoubleAction = 45;
GmsvData.CONST.Enemy.SummonEnemyId1 = 46;
GmsvData.CONST.Enemy.SummonEnemyId2 = 47;
GmsvData.CONST.Enemy.EnemyTalkId = 48;
--名称	编号	基础BP	"浮动范围"	种族	"体力BP"	"力量BP"	"防御BP"	"速度BP"	"魔法BP"	"捕捉难度"	"图鉴等级"	"魅力要求"	
--命中	闪躲	地属性	水属性	火属性	风属性	毒抗	酒抗	石抗	混抗	睡抗	忘抗	"图鉴种类"	? 必杀	反击	"技能栏位"	图档编号	"经验倍率"	?	
--"图鉴编号"	?	"0可捉1不可捉"	"1技能栏位tech编号"	"2技能栏位tech编号"	"3技能栏位tech编号"	"4技能栏位tech编号"	
--"5技能栏位tech编号"	"6技能栏位tech编号"	"7技能栏位tech编号"	"8技能栏位tech编号"	"9技能栏位tech编号"
--"10技能栏位tech编号"
GmsvData.CONST.EnemyBase = {};
GmsvData.CONST.EnemyBase.Name = 1;
GmsvData.CONST.EnemyBase.EnemyBaseId = 2;
GmsvData.CONST.EnemyBase.BaseBP = 3;
GmsvData.CONST.EnemyBase.BP浮动范围 = 4;
GmsvData.CONST.EnemyBase.种族 = 5;
GmsvData.CONST.EnemyBase.体力BP = 6;
GmsvData.CONST.EnemyBase.力量BP = 7;
GmsvData.CONST.EnemyBase.防御BP = 8;
GmsvData.CONST.EnemyBase.速度BP = 9;
GmsvData.CONST.EnemyBase.魔法BP = 10;
GmsvData.CONST.EnemyBase.捕捉难度 = 11;
GmsvData.CONST.EnemyBase.图鉴等级 = 12;
GmsvData.CONST.EnemyBase.魅力要求 = 13;
GmsvData.CONST.EnemyBase.命中 = 14;
GmsvData.CONST.EnemyBase.闪躲 = 15;
GmsvData.CONST.EnemyBase.地属性 = 16;
GmsvData.CONST.EnemyBase.水属性 = 17;
GmsvData.CONST.EnemyBase.火属性 = 18;
GmsvData.CONST.EnemyBase.风属性 = 19;
GmsvData.CONST.EnemyBase.毒抗 = 20;
GmsvData.CONST.EnemyBase.酒抗 = 21;
GmsvData.CONST.EnemyBase.石抗 = 22;
GmsvData.CONST.EnemyBase.混抗 = 23;
GmsvData.CONST.EnemyBase.睡抗 = 24;
GmsvData.CONST.EnemyBase.忘抗 = 25;
GmsvData.CONST.EnemyBase.图鉴种类 = 26;
GmsvData.CONST.EnemyBase.必杀 = 28;
GmsvData.CONST.EnemyBase.反击 = 29;
GmsvData.CONST.EnemyBase.技能栏位 = 30;
GmsvData.CONST.EnemyBase.图档编号 = 31;
GmsvData.CONST.EnemyBase.经验倍率 = 32;
GmsvData.CONST.EnemyBase.图鉴编号 = 34;
GmsvData.CONST.EnemyBase.不可捉 = 36;
GmsvData.CONST.EnemyBase.TechId1 = 37;
GmsvData.CONST.EnemyBase.TechId2 = 38;
GmsvData.CONST.EnemyBase.TechId3 = 39;
GmsvData.CONST.EnemyBase.TechId4 = 40;
GmsvData.CONST.EnemyBase.TechId5 = 41;
GmsvData.CONST.EnemyBase.TechId6 = 42;
GmsvData.CONST.EnemyBase.TechId7 = 43;
GmsvData.CONST.EnemyBase.TechId8 = 44;
GmsvData.CONST.EnemyBase.TechId9 = 45;
GmsvData.CONST.EnemyBase.TechId10 = 46;

function GmsvData:loadData()
  self.enemy = {}
  self.enemyBase = {}
  local file = io.open('data/enemy.txt')
  for line in file:lines() do
    if line then
      if string.match(line, '^(%s*(#|$))') then
        goto continue;
      end
      local enemy = string.split(line, '\t');
      if enemy and #enemy == 48 then
        self.enemy[enemy[self.CONST.Enemy.EnemyId]] = enemy;
      end
    end
    :: continue ::
  end
  file:close();
  file = io.open('data/enemybase.txt')
  for line in file:lines() do
    if line then
      if string.match(line, '^(%s*(#|$))') then
        goto continue;
      end
      local enemyBase = string.split(line, '\t');
      if enemyBase and #enemyBase == 46 then
        self.enemyBase[enemyBase[self.CONST.EnemyBase.EnemyBaseId]] = enemyBase;
      end
    end
    :: continue ::
  end
  file:close();
  --for i, v in pairs(data) do
  --  print(i, v)
  --end
  --print(MAX_N);
end

---@param enemyId string|number
---@return string
function GmsvData:getEnemyName(enemyId)
  local enemy = self.enemy[tostring(enemyId)];
  if enemy then
    local base = self.enemyBase[enemy[GmsvData.CONST.Enemy.BaseId]];
    if base then
      return base[GmsvData.CONST.EnemyBase.Name];
    end
  end
  return nil
end

--- 加载模块钩子
function GmsvData:onLoad()
  self:logInfo('load')
  self:loadData();
end

--- 卸载模块钩子
function GmsvData:onUnload()
  self:logInfo('unload')
end

return GmsvData;
