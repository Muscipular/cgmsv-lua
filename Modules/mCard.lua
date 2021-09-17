---装备插卡模块
local ModuleCard = ModuleBase:createModule('mCard')

local NormalRate = 2;
local BossRate = 1;

function ModuleCard:onBattleStartEvent(battleIndex)
  local type = Battle.GetType(battleIndex)
  self:logDebug('battle start', battleIndex, type, CONST.战斗_普通)
  if type == CONST.战斗_普通 then
    local enemyDataList = {};
    self.cache[tostring(battleIndex)] = enemyDataList;
    for i = 10, 19 do
      local charIndex = Battle.GetPlayer(battleIndex, i);
      if charIndex >= 0 then
        local enemyId = Char.GetData(charIndex, CONST.CHAR_ENEMY_ID);
        self:logDebug('enemy', battleIndex, i, charIndex, enemyId,
          Char.GetData(charIndex, CONST.CHAR_EnemyBaseId),
          Char.GetData(charIndex, CONST.CHAR_名字)
        );
        if enemyId and enemyId > 0 then
          enemyDataList[tostring(i)] = {
            EnemyBaseId = Char.GetData(charIndex, CONST.CHAR_EnemyBaseId),
            EnemyId = enemyId,
            Level = Char.GetData(charIndex, CONST.CHAR_等级),
            Name = Char.GetData(charIndex, CONST.CHAR_名字),
            Ethnicity = Char.GetData(charIndex, CONST.CHAR_种族),
          };
        end
      end
    end
  end
end

function ModuleCard:onBattleOverEvent(battleIndex)
  local type = Battle.GetType(battleIndex)
  self:logDebug('battle over', battleIndex, type, CONST.战斗_普通)
  if type == CONST.战斗_普通 then
    local enemyDataList = self.cache[tostring(battleIndex)];
    self.cache[tostring(battleIndex)] = nil;
    local winSide = Battle.GetWinSide(battleIndex);
    --self:logDebug('enemyDataList', battleIndex, enemyDataList, winSide);
    if enemyDataList == nil then
      return
    end
    --for i, v in pairs(enemyDataList) do
    --  print(i, v);
    --end
    local chars = {}
    for i = 0, 9 do
      local charIndex = Battle.GetPlayer(battleIndex, i);
      if charIndex >= 0 and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人 and Char.ItemSlot(charIndex) < 20 then
        table.insert(chars, charIndex)
      end
    end
    --self:logDebug('chars', #chars);
    ---@type GmsvData
    local gmsvData = getModule('gmsvData');
    -- ---@type ItemExt
    --local itemExt = getModule('itemExt');
    if winSide == 0 then
      for i, enemy in pairs(enemyDataList) do
        local enemyData = gmsvData.enemy[tostring(enemy.EnemyId)];
        if enemyData == nil then
          self:logDebug('enemy data not found', enemy.EnemyId);
          goto continue;
        end
        local rate = NormalRate;
        if enemyData[gmsvData.CONST.Enemy.IsBoss] then
          rate = BossRate;
        end
        --if Char.GetData(charIndex, CONST.CHAR_CDK) == 'u01' then
        --rate = 1000;
        --end
        if #chars > 0 and math.random(0, 100) < rate then
          local n = math.random(1, #chars);
          --print(n, chars[n])
          local charIndex = chars[n];
          local itemIndex = Char.GiveItem(charIndex, 606627, 1);
          if itemIndex >= 0 then
            Item.SetData(itemIndex, CONST.道具_名字, gmsvData:getEnemyName(enemy.EnemyId) .. '的装备卡片');
            Item.SetData(itemIndex, CONST.道具_Func_UseFunc, '');
            Item.SetData(itemIndex, CONST.道具_Func_AttachFunc, '');
            Item.SetData(itemIndex, CONST.道具_自用参数, tostring(enemy.EnemyId));
            Item.SetData(itemIndex, CONST.道具_Explanation1, 0);
            Item.SetData(itemIndex, CONST.道具_Explanation2, 0);
            Item.UpItem(charIndex, itemIndex);
          end
          if Char.ItemSlot(charIndex) >= 20 then
            table.remove(chars, n)
          end
        end
        ::continue::
      end
    end
  end
end

--- 加载模块钩子
function ModuleCard:onLoad()
  self:logInfo('load')
  self.cache = { }
  self:regCallback('BattleStartEvent', Func.bind(self.onBattleStartEvent, self))
  self:regCallback('BattleOverEvent', Func.bind(self.onBattleOverEvent, self))
end

--- 卸载模块钩子
function ModuleCard:onUnload()
  self:logInfo('unload')
end

return ModuleCard;
