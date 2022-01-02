---模块类
local Module = ModuleBase:createModule('charExtHotPatch')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  ---@type CharExt
  local charExt = getModule('charExt')
  charExt.getData = function(self, charIndex)
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
        pcall(function()
          local data2 = data;
          data = nil;
          data = JSON.decode(data2);
        end)
      else
        data = nil;
      end
      if data == nil then
        pcall(function()
          local file = io.open('lua/Modules/charExt.data.' .. Char.GetData(charIndex, CONST.CHAR_RegistNumber) .. '_' .. Char.GetData(charIndex, CONST.CHAR_CDK)
            .. '.json', 'r')
          local data1 = file:read("*a")
          file:close();
          data = JSON.decode(data1);
        end)
      end
    end
    data = data or {};
    self.cache:set(args, data);
    return data;
  end
  charExt.setData = function(self, charIndex, value)
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
    local r = SQL.querySQL(sql);
    --print(r, sql);

    pcall(function()
      local file = io.open('lua/Modules/charExt.data.' .. Char.GetData(charIndex, CONST.CHAR_RegistNumber) .. '_' .. Char.GetData(charIndex, CONST.CHAR_CDK)
        .. '.json', 'w');
      file:write(JSON.encode(value));
      file:flush();
      file:close();
    end)
    self.cache:set(Char.GetData(charIndex, CONST.CHAR_RegistNumber) .. ':' .. Char.GetData(charIndex, CONST.CHAR_CDK), value);
    return value;
  end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
