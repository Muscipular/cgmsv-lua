local ItemPowerUP = ModuleBase:createModule('itemPowerUp')


local MAX_LEVEL = 20;
local SAVE_LEVEL2 = 10;
local SAVE_LEVEL = 7;
local LevelRate = { 0, 0, 0, 10, 20, 30, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 93, 93, 96, 96, 97, 97, 98, 98, 99, 99, 99, 99, 99, 99, 99, 99 }

function ItemPowerUP:setItemData(itemIndex, value)
  ---@type ItemExt
  local itemExt = getModule('itemExt')
  return itemExt:setItemData(itemIndex, value)
end

function ItemPowerUP:getItemData(itemIndex)
  ---@type ItemExt
  local itemExt = getModule('itemExt')
  return itemExt:getItemData(itemIndex)
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
  if damage <= 0 or flg == DmgType.Miss or flg == NoDmg then
    return damage;
  end
  if Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人 then
    for i = 0, 7 do
      local itemIndex = Char.GetItemIndex(charIndex, i);
      if itemIndex >= 0 then
        local data = self:getItemData(itemIndex)
        if (data.level or 0) > 0 then
          local itemType = Item.GetData(itemIndex, CONST.道具_类型);
          if Item.Types.isWeapon(itemType) then
            local weaponDmg = Item.GetData(itemIndex, CONST.道具_攻击);
            if Item.GetData(itemIndex, CONST.道具_魔攻) > 0 and flg == DmgType.Magic then
              weaponDmg = weaponDmg + tonumber(Item.GetData(itemIndex, CONST.道具_魔攻));
            end
            local dmg = math.ceil((data.level * data.level / 100 + data.level / 100) * weaponDmg);
            --self:logDebug('add damage' .. dmg)
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
          if Item.Types.isArmour(itemType) then
            --self:logDebug('dec damage' .. (data.level * 2))
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
    if not (Item.Types.isArmour(type) or Item.Types.isWeapon(type)) then
      return 0
    end
    local data = self:getItemData(targetItemIndex);
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
    if Item.Types.isWeapon(type) then
    elseif Item.Types.isArmour(type) then
    end
    NLG.SystemMessage(charIndex, "[系统] 强化【" .. Item.GetData(targetItemIndex, CONST.道具_名字) .. "】成功。【" .. rate .. '/' .. LevelRate[rawLv + 1] .. "】");
    self:setItemData(targetItemIndex, data);
    Char.DelItem(charIndex, Item.GetData(fromItemIndex, CONST.道具_ID), 1);
    Item.UpItem(charIndex, -1);
    return 1;
  end
end

function ItemPowerUP:onLoad()
  self:logInfo('load')
  self:regCallback('ItemOverLapEvent', Func.bind(self.onItemOverLapEvent, self));
  self:regCallback('DamageCalculateEvent', Func.bind(self.onDamageCalculateEvent, self))
end

function ItemPowerUP:onUnload()
  self:logInfo('unload')
end

return ItemPowerUP;
