---@class CharExt:ModuleBase
local CharExt = ModuleBase:createModule('charExt')
local MAX_CACHE_SIZE = 1000;

---迁移定义
CharExt:addMigration(1, 'init lua_charData', function()
  SQL.querySQL([[
create table if not exists lua_charData
(
	id int not null,
	data text null,
	create_time int default 0 not null,
	constraint lua_charData_pk
		primary key (id)
) engine innodb;
]])
end);
CharExt:addMigration(2, 'extend key', function()
  SQL.querySQL([[
alter table lua_chardata
	add cdkey char(32) default '' null after id;
]]);
  SQL.querySQL([[
alter table lua_chardata drop primary key;
]]);
  SQL.querySQL([[
alter table lua_chardata
	add constraint lua_chardata_pk
		primary key (id, cdkey);
]]);
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
  local sql = 'replace into lua_charData (id, cdkey, data, create_time) VALUES ('
    .. SQL.sqlValue(Char.GetData(charIndex, CONST.CHAR_RegistNumber)) .. ','
    .. SQL.sqlValue(Char.GetData(charIndex, CONST.CHAR_CDK)) .. ','
    .. SQL.sqlValue(JSON.encode(value)) .. ','
    .. SQL.sqlValue(os.time()) .. ')';
  local r = SQL.querySQL(sql)
  --print(r, sql);
  self.cache:set(Char.GetData(charIndex, CONST.CHAR_RegistNumber) .. ':' .. Char.GetData(charIndex, CONST.CHAR_CDK), value);
  return value;
end

---@return table
function CharExt:getData(charIndex)
  if Char.IsDummy(charIndex) then
    local data = self.dummyData[charIndex] or {}
    self.dummyData[charIndex] = data;
    return data;
  end
  local args = Char.GetData(charIndex, CONST.CHAR_RegistNumber) .. ':' .. Char.GetData(charIndex, CONST.CHAR_CDK)
  local data = self.cache:get(args)
  if data == nil then
    data = SQL.querySQL('select data from lua_charData where id = ' .. SQL.sqlValue(Char.GetData(charIndex, CONST.CHAR_RegistNumber))
      .. ' and cdkey = ' .. SQL.sqlValue(Char.GetData(charIndex, CONST.CHAR_CDK)));
    if type(data) == 'table' and data[1] then
      data = data[1][1]
      data = JSON.decode(data)
    else
      data = nil;
    end
  end
  data = data or {};
  self.cache:set(args, data);
  return data;
end

--- 加载模块钩子
function CharExt:onLoad()
  self:logInfo('load')
  self.cache = LRU.new(MAX_CACHE_SIZE);
  self.dummyData = { nilData = '' };
  self:regCallback('DeleteDummyEvent', function(charIndex)
    self.dummyData[charIndex] = nil;
  end);
  --self.n = SQL.querySQL('select ifnull(max(id), 0) from lua_charData')[1][1]
  self:regCallback('CharaDeletedEvent', function(cdkey, regNum)
    SQL.querySQL('delete from lua_charData where id = ' .. SQL.sqlValue(regNum) .. ' and cdkey = ' .. SQL.sqlValue(cdkey));
    self.cache:delete(regNum .. ':' .. cdkey);
  end)
  self:regCallback('LogoutEvent', function(charIndex)
    local args = Char.GetData(charIndex, CONST.CHAR_RegistNumber) .. ':' .. Char.GetData(charIndex, CONST.CHAR_CDK)
    self.cache:delete(args);
  end)
  self:regCallback('DropEvent', function(charIndex)
    local args = Char.GetData(charIndex, CONST.CHAR_RegistNumber) .. ':' .. Char.GetData(charIndex, CONST.CHAR_CDK)
    self.cache:delete(args);
  end)
end

--- 卸载模块钩子
function CharExt:onUnload()
  self:logInfo('unload')
end

return CharExt;
