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
	constraint lua_petData_pk
		primary key (id)
) engine innodb;
]])
end);

function CharExt:setData(charIndex, value)
  local args = tonumber(Char.GetData(charIndex, CONST.CHAR_吃时 + 1));
  if not (args > 0) then
    args = self.n + 1;
    self.n = args;
    Char.SetData(charIndex, CONST.CHAR_吃时 + 1, args);
  end
  local sql = 'replace into lua_charData (id, data, create_time) VALUES ('
    .. SQL.sqlValue(args) .. ','
    .. SQL.sqlValue(JSON.encode(value)) .. ','
    .. SQL.sqlValue(os.time()) .. ')';
  local r = SQL.querySQL(sql)
  --print(r, sql);
  self.cache.set(args, value);
end

---@return table
function CharExt:getData(charIndex)
  local args = tonumber(Char.GetData(charIndex, CONST.CHAR_吃时 + 1));
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
  self.n = SQL.querySQL('select ifnull(max(id), 0) from lua_charData')[1][1]
end

--- 卸载模块钩子
function CharExt:onUnload()
  self:logInfo('unload')
end

return CharExt;
