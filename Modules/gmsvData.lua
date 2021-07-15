---@class GmsvData: ModuleBase
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
GmsvData.CONST.ItemSet = {};
GmsvData.CONST.ItemSet.未鉴定 = 1;
GmsvData.CONST.ItemSet.鉴定过名称 = 2;
GmsvData.CONST.ItemSet.双击效果 = 3;
GmsvData.CONST.ItemSet.INIT_FUNCTION = 4;
GmsvData.CONST.ItemSet.WATCH_FUNC = 5;
GmsvData.CONST.ItemSet.USE_FUNC = 6;
GmsvData.CONST.ItemSet.ATTACH_FUNC = 7;
GmsvData.CONST.ItemSet.DETACH_FUNC = 8;
GmsvData.CONST.ItemSet.DROP_FUNC = 9;
GmsvData.CONST.ItemSet.PRE_PICK_UP_FUNC = 10;
GmsvData.CONST.ItemSet.PICK_UP_FUNC = 11;
GmsvData.CONST.ItemSet.Id = 12;
GmsvData.CONST.ItemSet.图档 = 13;
GmsvData.CONST.ItemSet.价格 = 14;
GmsvData.CONST.ItemSet.物品种类 = 15;
GmsvData.CONST.ItemSet.OTHERFLG其他标记 = 16;
GmsvData.CONST.ItemSet.双手使用 = 17;
GmsvData.CONST.ItemSet.能否双击 = 18;
GmsvData.CONST.ItemSet.战斗使用领域0不能1物品2装备 = 19;
GmsvData.CONST.ItemSet.TARGET目标 = 20;
GmsvData.CONST.ItemSet.得到数量下限 = 21;
GmsvData.CONST.ItemSet.得到数量上限 = 22;
GmsvData.CONST.ItemSet.重叠数 = 23;
GmsvData.CONST.ItemSet.物品等级 = 24;
GmsvData.CONST.ItemSet.BASE_FAILED_PROB失败问题 = 25;
GmsvData.CONST.ItemSet.耐久下限 = 26;
GmsvData.CONST.ItemSet.耐久上限 = 27;
GmsvData.CONST.ItemSet.普攻次数下限 = 28;
GmsvData.CONST.ItemSet.普攻次数上限 = 29;
GmsvData.CONST.ItemSet.ABLEEFFECTBETWEENHAVE之间有能够影响 = 30;
GmsvData.CONST.ItemSet.百分比加成 = 31;
GmsvData.CONST.ItemSet.攻击下限 = 32;
GmsvData.CONST.ItemSet.攻击上限 = 33;
GmsvData.CONST.ItemSet.防御下限 = 34;
GmsvData.CONST.ItemSet.防御上限 = 35;
GmsvData.CONST.ItemSet.敏捷下限 = 36;
GmsvData.CONST.ItemSet.敏捷上限 = 37;
GmsvData.CONST.ItemSet.精神下限 = 38;
GmsvData.CONST.ItemSet.精神上限 = 39;
GmsvData.CONST.ItemSet.回复下限 = 40;
GmsvData.CONST.ItemSet.回复上限 = 41;
GmsvData.CONST.ItemSet.必杀下限 = 42;
GmsvData.CONST.ItemSet.必杀上限 = 43;
GmsvData.CONST.ItemSet.反击下限 = 44;
GmsvData.CONST.ItemSet.反击上限 = 45;
GmsvData.CONST.ItemSet.命中下限 = 46;
GmsvData.CONST.ItemSet.命中上限 = 47;
GmsvData.CONST.ItemSet.闪躲下限 = 48;
GmsvData.CONST.ItemSet.闪躲上限 = 49;
GmsvData.CONST.ItemSet.生命下限 = 50;
GmsvData.CONST.ItemSet.生命上限 = 51;
GmsvData.CONST.ItemSet.魔力下限 = 52;
GmsvData.CONST.ItemSet.魔力上限 = 53;
GmsvData.CONST.ItemSet.隐藏运气下限 = 54;
GmsvData.CONST.ItemSet.隐藏运气上限 = 55;
GmsvData.CONST.ItemSet.个人魅力 = 56;
GmsvData.CONST.ItemSet.个人魅力 = 57;
GmsvData.CONST.ItemSet.魅力下限 = 58;
GmsvData.CONST.ItemSet.魅力上限 = 59;
GmsvData.CONST.ItemSet.属性1 = 60;
GmsvData.CONST.ItemSet.属性2 = 61;
GmsvData.CONST.ItemSet.属性1值 = 62;
GmsvData.CONST.ItemSet.属性2值 = 63;
GmsvData.CONST.ItemSet.隐藏耐力下限 = 64;
GmsvData.CONST.ItemSet.隐藏耐力上限 = 65;
GmsvData.CONST.ItemSet.隐藏灵巧下限 = 66;
GmsvData.CONST.ItemSet.隐藏灵巧上限 = 67;
GmsvData.CONST.ItemSet.隐藏智力下限 = 68;
GmsvData.CONST.ItemSet.隐藏智力上限 = 69;
GmsvData.CONST.ItemSet.抗毒下限 = 70;
GmsvData.CONST.ItemSet.抗毒上限 = 71;
GmsvData.CONST.ItemSet.抗睡下限 = 72;
GmsvData.CONST.ItemSet.抗睡上限 = 73;
GmsvData.CONST.ItemSet.抗石下限 = 74;
GmsvData.CONST.ItemSet.抗石上限 = 75;
GmsvData.CONST.ItemSet.抗醉下限 = 76;
GmsvData.CONST.ItemSet.抗醉上限 = 77;
GmsvData.CONST.ItemSet.抗乱下限 = 78;
GmsvData.CONST.ItemSet.抗乱上限 = 79;
GmsvData.CONST.ItemSet.抗忘下限 = 80;
GmsvData.CONST.ItemSet.抗忘上限 = 81;
GmsvData.CONST.ItemSet.特殊功能 = 82;
GmsvData.CONST.ItemSet.子参数1 = 83;
GmsvData.CONST.ItemSet.子参数2 = 84;
GmsvData.CONST.ItemSet.宝石编号_武器 = 85;
GmsvData.CONST.ItemSet.宝石编号_防具 = 86;
GmsvData.CONST.ItemSet.宝石编号_配饰 = 87;
GmsvData.CONST.ItemSet.USEACTION使用功能 = 88;
GmsvData.CONST.ItemSet.登出消失 = 89;
GmsvData.CONST.ItemSet.丢地消失 = 90;
GmsvData.CONST.ItemSet.宠邮 = 91;
GmsvData.CONST.ItemSet.抗魔下限 = 92;
GmsvData.CONST.ItemSet.抗魔上限 = 93;
GmsvData.CONST.ItemSet.能否出售 = 94;
GmsvData.CONST.ItemSet.物品说明msg = 95;
GmsvData.CONST.ItemSet.右键说明msg = 96;
GmsvData.CONST.ItemSet.鉴定概率 = 97;
GmsvData.CONST.ItemSet.白黑宝箱能开启 = 98;
GmsvData.CONST.ItemSet.宝箱中出现 = 99;
GmsvData.CONST.ItemSet.魔攻下限 = 100;
GmsvData.CONST.ItemSet.魔攻上限 = 101;
GmsvData.CONST.ItemSet.贩卖给NPC1组的数量 = 102;

function GmsvData:loadData()
  self.enemy = {}
  local count = 0;
  local file = io.open('data/enemy.txt')
  for line in file:lines() do
    if line then
      if string.match(line, '^(%s*(#|$))') then
        goto continue;
      end
      local enemy = string.split(line, '\t');
      if enemy and #enemy == 48 then
        self.enemy[enemy[self.CONST.Enemy.EnemyId]] = enemy;
        count = count + 1;
      end
    end
    :: continue ::
  end
  self:logInfo('loaded enemy', count);
  self.enemyBase = {}
  count = 0;
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
        count = count + 1;
      end
    end
    :: continue ::
  end
  self:logInfo('loaded enemyBase', count);
  file:close();
  count = 0;
  self.itemSet = {}
  file = io.open('data/itemset.txt')
  for line in file:lines() do
    if line then
      if string.match(line, '^(%s*(#|$))') then
        goto continue;
      end
      local itemSet = string.split(line, '\t');
      if itemSet and #itemSet == 102 then
        self.itemSet[itemSet[self.CONST.ItemSet.Id]] = itemSet;
        count = count + 1;
      end
    end
    :: continue ::
  end
  self:logInfo('loaded itemSet', count);
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
  self:logInfo('enemy', enemyId, enemy, self.enemy);
  if enemy then
    self:logInfo('enemy', enemy[GmsvData.CONST.Enemy.BaseId]);
    local base = self.enemyBase[enemy[GmsvData.CONST.Enemy.BaseId]];
    self:logInfo('base', base);
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
