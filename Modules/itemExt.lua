---@class ItemExt:ModuleBase
local ItemExt = ModuleBase:createModule('itemExt')
local MAX_CACHE_SIZE = 1000;

ItemExt:addMigration(1, 'add item_LuaData', function()
  SQL.querySQL([[create table if not exists lua_itemData
(
    id varchar(50) not null
        primary key,
    data text null
) engine innodb;
]])
end);
ItemExt:addMigration(2, 'add item_LuaData_create_time', function()
  SQL.querySQL([[alter table lua_itemData add create_time int default 0 not null;]])
end);

function ItemExt:setItemData(itemIndex, value)
  local args = Item.GetData(itemIndex, CONST.道具_自用参数)
  if not string.match(args, '^luaData_') then
    local t = formatNumber(os.time(), 36) .. formatNumber(math.random(1, 36 * 36 * 36), 36);
    args = 'luaData_' .. t;
    Item.SetData(itemIndex, CONST.道具_自用参数, args);
  end
  local sql = 'replace into lua_itemData (id, data, create_time) VALUES ('
    .. SQL.sqlValue(args) .. ','
    .. SQL.sqlValue(JSON.encode(value)) .. ','
    .. SQL.sqlValue(os.time()) .. ')';
  local r = SQL.querySQL(sql)
  --print(r, sql);
  self.cache.set(args, value);
end

---@return table
function ItemExt:getItemData(itemIndex)
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
--- 加载模块钩子
function ItemExt:onLoad()
  self:logInfo('load')
  self.cache = LRU.new(MAX_CACHE_SIZE);
end

--- 卸载模块钩子
function ItemExt:onUnload()
  self:logInfo('unload')
end

return ItemExt;
