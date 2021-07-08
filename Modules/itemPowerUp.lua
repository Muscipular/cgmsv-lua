local ItemPowerUP = ModuleBase:createModule('itemPowerUp')
ItemPowerUP.migrations = {
  { version = 1, name = 'add item_LuaData', value = function()
    SQL.querySQL([[create table if not exists lua_itemData
(
    id varchar(50) not null
        primary key,
    data text null
) engine innodb;
]])
  end },
  { version = 2, name = 'add item_LuaData_create_time', value = function()
    SQL.querySQL([[alter table lua_itemData add create_time int default now() not null;]])
  end }
};

local MAX_CACHE_SIZE = 1000;

local WeaponType = {
  CONST.ITEM_TYPE_剑,
  CONST.ITEM_TYPE_斧,
  CONST.ITEM_TYPE_枪,
  CONST.ITEM_TYPE_杖,
  CONST.ITEM_TYPE_弓,
  CONST.ITEM_TYPE_小刀,
  CONST.ITEM_TYPE_回力镖,
}

local ArmourType = {
  CONST.ITEM_TYPE_盾,
  CONST.ITEM_TYPE_盔,
  CONST.ITEM_TYPE_帽,
  CONST.ITEM_TYPE_铠,
  CONST.ITEM_TYPE_衣,
  CONST.ITEM_TYPE_袍,
  CONST.ITEM_TYPE_靴,
  CONST.ITEM_TYPE_鞋,
}

local AccessoryType = {
  CONST.ITEM_TYPE_手环,
  CONST.ITEM_TYPE_乐器,
  CONST.ITEM_TYPE_项链,
  CONST.ITEM_TYPE_戒指,
  CONST.ITEM_TYPE_头带,
  CONST.ITEM_TYPE_耳环,
  CONST.ITEM_TYPE_护身符,
}

local CrystalType = CONST.ITEM_TYPE_水晶
local MAX_LEVEL = 20;
local SAVE_LEVEL2 = 10;
local SAVE_LEVEL = 7;
local LevelRate = { 0, 0, 0, 10, 20, 30, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 93, 93, 96, 96, 97, 97, 98, 98, 99, 99, 99, 99, 99, 99, 99, 99 }

local function isWeapon(type)
  return table.indexOf(WeaponType, type) > 0
end

local function isArmour(type)
  return table.indexOf(ArmourType, type) > 0
end

local function isAccessory(type)
  return table.indexOf(AccessoryType, type) > 0
end

function ItemPowerUP:setItemData(itemIndex, value)
  local args = Item.GetData(itemIndex, CONST.道具_自用参数)
  if not string.match(args, '^luaData_') then
    local t = formatNumber(os.time(), 36) .. formatNumber(math.random(1, 36 * 36), 36);
    args = 'luaData_' .. t;
    Item.SetData(itemIndex, CONST.道具_自用参数, args);
  end
  local sql = 'replace into lua_itemData (id, data) VALUES (' .. SQL.sqlValue(args) .. ',' .. SQL.sqlValue(JSON.encode(value)) .. ')';
  local r = SQL.querySQL(sql)
  --print(r, sql);
  self.cache.set(args, value);
end

function ItemPowerUP:getItemData(itemIndex)
  local args = Item.GetData(itemIndex, CONST.道具_自用参数)
  if string.match(args, '^luaData_') then
    local data = self.cache.get(args)
    if not data then
      data = SQL.querySQL('select data from lua_itemdata where id = ' .. SQL.sqlValue(args))
      if type(data) == 'table' and data[1] then
        data = data[1][1]
        data = JSON.decode(data)
        self.cache.set(args, data);
        return data;
      end
    end
  end
  return { };
end

function ItemPowerUP:onLoad()
  logInfo(self.name, 'load')
  self.cache = LRU.new(MAX_CACHE_SIZE);
  self:regCallback('ItemOverLapEvent', function(...)
    return self:onItemOverLapEvent(...)
  end)
  --print(NL.RegDamageCalculateEvent)
  local fnName = self:regCallback('DamageCalculateEvent', function(...)
    return self:onDamageCalculateEvent(...)
  end)
  --NL.RegDamageCalculateEvent(nil, fnName);
end

local function getItemSlot(charIndex, itemIndex)
  local itemSlot = -1;
  for i = 0, 27 do
    if Char.GetItemIndex(charIndex, i) == itemIndex then
      itemSlot = i;
      break
    end
  end
  return itemSlot;
end

--CharIndex: 数值型 响应事件的对象index（攻击者），该值由Lua引擎传递给本函数。
--DefCharIndex: 数值型 响应事件的对象index（防御者），该值由Lua引擎传递给本函数。
--OriDamage: 数值型 未修正伤害，该值由Lua引擎传递给本函数。
--Damage: 数值型 修正伤害（真实伤害），该值由Lua引擎传递给本函数。
--BattleIndex: 数值型 当前战斗index，该值由Lua引擎传递给本函数。
--Com1: 数值型 攻击者使用的動作編號，该值由Lua引擎传递给本函数。
--Com2: 数值型 攻击者攻击動作的目標對象的位置，该值由Lua引擎传递给本函数。
--Com3: 数值型 攻击者使用的所對應的tech的ID，该值由Lua引擎传递给本函数。
--DefCom1: 数值型 防御者使用的動作編號，该值由Lua引擎传递给本函数。
--DefCom2: 数值型 防御者攻击動作的目標對象的位置，该值由Lua引擎传递给本函数。
--DefCom3: 数值型 防御者使用的所對應的tech的ID，该值由Lua引擎传递给本函数。
--Flg: 数值型 伤害模式，具体查看下面的值说明，该值由Lua引擎传递给本函数。
--Flg 值说明
--0: 普通命中伤害
--1: 暴击伤害
--2: 无伤害
--3: 闪躲
--4: 防御
--5: 魔法伤害

local DmgType = {
  Normal = 0,
  Crit = 1,
  NoDmg = 2,
  Miss = 3,
  Defence = 4,
  Magic = 5,
}

function ItemPowerUP:onDamageCalculateEvent(
  charIndex, defCharIndex, oriDamage, damage,
  battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
  if Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人 then
    for i = 0, 7 do
      local itemIndex = Char.GetItemIndex(charIndex, i);
      if itemIndex >= 0 then
        local data = self:getItemData(itemIndex)
        if (data.level or 0) > 0 then
          local itemType = Item.GetData(itemIndex, CONST.道具_类型);
          if isWeapon(itemType) then
            local weaponDmg = Item.GetData(itemIndex, CONST.道具_攻击);
            if Item.GetData(itemIndex, CONST.道具_魔攻) > 0 and flg == DmgType.Magic then
              weaponDmg = weaponDmg + tonumber(Item.GetData(itemIndex, CONST.道具_魔攻));
            end
            local dmg = math.ceil((data.level * data.level / 100 + data.level / 100) * weaponDmg);
            self:logDebug('add damage' .. dmg)
            damage = damage + dmg;
          end
        end
      end
    end
  end
  if Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_人 then
    for i = 0, 7 do
      local itemIndex = Char.GetItemIndex(defCharIndex, i);
      if itemIndex >= 0 then
        local data = self:getItemData(itemIndex)
        if (data.level or 0) > 0 then
          local itemType = Item.GetData(itemIndex, CONST.道具_类型);
          if isArmour(itemType) then
            self:logDebug('dec damage' .. (data.level * 2))
            damage = damage - data.level * 3;
          end
        end
      end
    end
  end
  if damage < 1 then
    return 1;
  end
  return damage;
end

function ItemPowerUP:onItemOverLapEvent(charIndex, fromItemIndex, targetItemIndex, num)
  if Item.GetData(fromItemIndex, CONST.道具_名字) == '魔石' then
    self:logDebug('onItemOverLapEvent', charIndex, fromItemIndex, targetItemIndex, num);
    --if not Item.GetData(targetItemIndex, CONST.道具_已装备) then
    --  return 0
    --end
    --local fromSlot = getItemSlot(charIndex, fromItemIndex);
    local type = Item.GetData(targetItemIndex, CONST.道具_类型);
    local data = self:getItemData(targetItemIndex);
    if not (isArmour(type) or isWeapon(type)) then
      return 0
    end
    local rate = math.random(0, 100);
    local rawLv = data.level or 0;
    if rate < LevelRate[rawLv + 1] then
      if (data.level or 0) > 0 then
        if data.level >= SAVE_LEVEL2 then
          if math.random(0, 2) == 1 then
            data.level = 0;
          else
            data.level = data.level - math.random(1, data.level / 2)
          end
        elseif data.level > SAVE_LEVEL then
          data.level = data.level - 1;
        end
        self:setItemData(targetItemIndex, data);
      end
      NLG.SystemMessage(charIndex, "[系统] 强化【" .. Item.GetData(targetItemIndex, CONST.道具_名字) .. "】失败。【" .. rate .. '/' .. LevelRate[rawLv + 1] .. "】");
      if data.level > 0 then
        Item.SetData(targetItemIndex, CONST.道具_名字, data.name .. ' +' .. data.level);
      else
        Item.SetData(targetItemIndex, CONST.道具_名字, data.name);
      end
      Char.DelItem(charIndex, Item.GetData(fromItemIndex, CONST.道具_ID), 1);
      Item.UpItem(charIndex, -1);
      return 0;
    end
    data.level = rawLv + 1;
    if data.level > MAX_LEVEL then
      data.level = MAX_LEVEL;
    end
    data.name = data.name or Item.GetData(targetItemIndex, CONST.道具_名字);
    Item.SetData(targetItemIndex, CONST.道具_名字, data.name .. ' +' .. data.level);
    if isWeapon(type) then
    elseif isArmour(type) then
    end
    NLG.SystemMessage(charIndex, "[系统] 强化【" .. Item.GetData(targetItemIndex, CONST.道具_名字) .. "】成功。【" .. rate .. '/' .. LevelRate[rawLv + 1] .. "】");
    self:setItemData(targetItemIndex, data);
    Char.DelItem(charIndex, Item.GetData(fromItemIndex, CONST.道具_ID), 1);
    Item.UpItem(charIndex, -1);
    return 1;
  end
end

function ItemPowerUP:onUnload()
  logInfo(self.name, 'unload')
end

return ItemPowerUP;
