---@class CharExt:ModuleBase
local CharExt = ModuleBase:createModule('charExt')
local MAX_CACHE_SIZE = 1000;

---迁移定义
CharExt:addMigration(1, 'init lua_charData', function()
  SQL.querySQL([[create table if not exists lua_charData
(
	id int not null,
	data text null,
	create_time int default 0 not null,
	constraint lua_charData_pk
		primary key (id)
) engine innodb;
]])
end);

function CharExt:setData(charIndex, value)
  local type = Char.GetData(charIndex, CONST.CHAR_类型);
  if type ~= CONST.对象类型_人 then
    return nil;
  end
  if Char.IsDummy(charIndex) then
    self.dummyData[charIndex] = value;
    return value;
  end
  local args = tonumber(Char.GetData(charIndex, CONST.CHAR_ThankFlower));
  if not (args > 0) then
    args = self.n + 1;
    self.n = args;
    Char.SetData(charIndex, CONST.CHAR_ThankFlower, args);
  end
  local sql = 'replace into lua_charData (id, data, create_time) VALUES ('
    .. SQL.sqlValue(args) .. ','
    .. SQL.sqlValue(JSON.encode(value)) .. ','
    .. SQL.sqlValue(os.time()) .. ')';
  local r = SQL.querySQL(sql)
  --print(r, sql);
  self.cache.set(args, value);
  return value;
end

---@return table
function CharExt:getData(charIndex)
  if Char.IsDummy(charIndex) then
    local data = self.dummyData[charIndex] or {}
    self.dummyData[charIndex] = data;
    return data;
  end
  local args = tonumber(Char.GetData(charIndex, CONST.CHAR_ThankFlower));
  if args > 0 then
    local data = self.cache.get(args)
    if not data then
      data = SQL.querySQL('select data from lua_charData where id = ' .. SQL.sqlValue(args))
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
function CharExt:onLoad()
  self:logInfo('load')
  self.cache = LRU.new(MAX_CACHE_SIZE);
  self.dummyData = { nilData = '' };
  self:regCallback('DeleteDummy', function(charIndex)
    self.dummyData[charIndex] = nil;
  end);
  self.n = SQL.querySQL('select ifnull(max(id), 0) from lua_charData')[1][1]
end

--- 卸载模块钩子
function CharExt:onUnload()
  self:logInfo('unload')
end

return CharExt;
