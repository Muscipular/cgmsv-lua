local ItemPowerUP = ModuleBase:createModule('itemPowerUp')
ItemPowerUP.migrations = {
  {
    version = 1,
    name = 'add item_LuaData',
    value = function()
      querySQL([[create table if not exists lua_itemData
(
    id varchar(50) not null
        primary key,
    data text null
) engine innodb;
]])
    end
  }
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

local function isWeapon(type)
  return indexOf(WeaponType, type) > 0
end

local function isArmour(type)
  return indexOf(ArmourType, type) > 0
end

local function isAccessory(type)
  return indexOf(AccessoryType, type) > 0
end

function ItemPowerUP:setItemData(itemIndex, value)
  local args = Item.GetData(itemIndex, CONST.道具_自用参数)
  if not string.match(args, '^luaData_') then
    local t = formatNumber(os.time(), 36) .. formatNumber(math.random(1, 36 * 36), 36);
    args = luaData_ .. t;
    querySQL('replace into lua_itemData (id, data) VALUES (' .. sqlValue(args) .. ',' .. sqlValue(jsonEncode(value)) .. ')')
    Item.SetData(itemIndex, CONST.道具_自用参数, args);
  end
end

function ItemPowerUP:getItemData(itemIndex)
  local args = Item.GetData(itemIndex, CONST.道具_自用参数)
  if string.match(args, '^luaData_') then
    local data = self.cache.get(args)
    if not data then
      data = querySQL('select data from lua_itemdata where id = \'' .. args .. '\'')
      if data and data[1] then
        data = data[1]
        data = jsonDecode(data)
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
    self:onItemOverLapEvent(...)
  end)
  self:regCallback('')
end

local function getItemSlot(charIndex, itemIndex)
  local itemSlot = -1;
  for i = 0, 27 do
    if Char.getItemIndex(charIndex, i) == itemIndex then
      itemSlot = i;
      break
    end
  end
  return itemSlot;
end

function ItemPowerUP:onItemOverLapEvent(charIndex, fromItemIndex, targetItemIndex, num)
  if Item.getData(fromItemIndex, CONST.道具_名字) == '魔石' then
    self:logDebug('onItemOverLapEvent', charIndex, fromItemIndex, targetItemIndex, num);
    if not Item.getData(targetItemIndex, CONST.道具_已装备) then
      return 0
    end
    local fromSlot = getItemSlot(charIndex, fromItemIndex);
    local type = Item.getData(targetItemIndex, CONST.道具_类型);
    local data = self:getItemData(targetItemIndex);
    if not (isArmour(type) and isArmour(type)) then
      return 0
    end
    data.level = (data.level or 0) + 1;
    data.name = data.name or Item.getData(targetItemIndex, CONST.道具_名字);
    Item.setData(targetItemIndex, CONST.道具_名字, data.name .. ' +' .. data.level);
    if isWeapon(type) then
    elseif isArmour(type) then
    end
    self:setItemData(targetItemIndex, data);
    Char.DelItem(charIndex, Item.getData(fromItemIndex, CONST.道具_ID), 1);
    Item.UpItem(charIndex, fromSlot);
    return 1;
  end
end

function ItemPowerUP:onUnload()
  logInfo(self.name, 'unload')
end

return ItemPowerUP;
