local ItemPowerUP = ModuleBase:new('itemPowerUp')
ItemPowerUP.migrations = {
  {
    version = 1,
    name = 'add item_LuaData',
    value = function()
      querySQL('create table if not exists lua_itemData
(
    id varchar(50) not null
        primary key,
    data text null
);')
    end
  }
};

local function getItemData(itemIndex)
  local args = Item.GetData(itemIndex, CONST.道具_自用参数)
  if string.match(args, '^luaData_') then
    local data = querySQL('select data from lua_itemdata where id = \'' .. args .. '\'')
    if data and data[1] then
      data = data[1]
      data = jsonDecode(data)
      return data;
    end
  end
  return {};
end

function ItemPowerUP:new()
  local o = ModuleBase:new('itemPowerUp');
  setmetatable(o, self)
  self.__index = self
  return o;
end

function ItemPowerUP:onLoad()
  logInfo(self.name, 'load')

end

function ItemPowerUP:onUnload()
  logInfo(self.name, 'unload')
end

return ItemPowerUP;
