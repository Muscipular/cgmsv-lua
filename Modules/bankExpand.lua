---模块类
local BankExpand = ModuleBase:createModule('bankExpand')

--BankExpand:addMigration(1, 'migrate1', function()
--  local res = SQL.QueryEx("select * from lua_chardata");
--  if res.rows then
--    for i, row in ipairs(res.rows) do
--      pcall(function()
--        local data = JSON.decode(row.data);
--        local regId = row.id;
--        local cdkey = row.cdkey;
--        if data.bag and data.bagIndex then
--          for i = 1, 5 do
--            for j = 1, 20 do
--              if data.bag[i] and data.bag[i][j] then
--                SQL.QueryEx("insert into hook_charaext (cdKey, regNo, sKey, val, valType) values (?,?,?,?,?)",
--                  cdkey, regId, string.format("bag-%d-%d", i, j), JSON.encode(data.bag[i][j]), 0);
--              end
--            end
--          end
--          SQL.QueryEx("insert into hook_charaext (cdKey, regNo, sKey, val, valType) values (?,?,?,?,?)",
--            cdkey, regId, "bag-index", data.bagIndex, 1);
--        end
--      end)
--    end
--  end
--end);

--- 加载模块钩子
function BankExpand:onLoad()
  self:logInfo('load')
  self:regCallback('ProtocolOnRecv', Func.bind(self.onProtoHook, self), 'rh');
end

--- 卸载模块钩子
function BankExpand:onUnload()
  self:logInfo('unload')
end

function BankExpand:onProtoHook(fd, head, data)
  --self:logDebug(fd, head, data, data[1]);
  data = tonumber(data[1]);
  local charIndex = Protocol.GetCharIndexFromFd(fd);
  local bIndex = Char.GetExtData(charIndex, "bank-index") or 1;
  if bIndex == data then
    return ;
  end
  --self:setData(charIndex, "index", data);
  for i = 0, 19 do
    local itemIndex = Char.GetPoolItem(charIndex, i);
    if itemIndex >= 0 then
      Char.SetExtData(charIndex, string.format("bank-%d-%d", bIndex, i), JSON.encode(self:readItemData(itemIndex)));
      Char.RemovePoolItem(charIndex, i);
    else
      Char.SetExtData(charIndex, string.format("bank-%d-%d", bIndex, i), nil);
    end
    local itemData = Char.GetExtData(charIndex, string.format("bank-%d-%d", data, i));
    pcall(function()
      if itemData then
        itemData = JSON.decode(itemData);
      end
    end)
    Char.SetExtData(charIndex, string.format("bank-%d-%d", data, i), nil);
    if type(itemData) == 'table' then
      local itemId = itemData['0'];
      if itemId <= 0 then
        itemId = 0;
      end
      itemIndex = Item.MakeItem(0);
      if itemIndex >= 0 then
        self:setItemData(itemIndex, itemData);
        local ret = Char.SetPoolItem(charIndex, i, itemIndex);
        if ret < 0 then
          self:logError('Char.SetPoolItem error: ', charIndex, i, itemIndex, ret);
        end
      end
    end
  end
  Char.SetExtData(charIndex, "bank-index", data);
  NLG.OpenBank(charIndex, charIndex);
end

local itemFields = { }
for i = 0, 0x4b do
  table.insert(itemFields, i);
end
for i = 0, 0xd do
  table.insert(itemFields, i + 2000);
end

function BankExpand:readItemData(itemIndex)
  local itemData = {}
  if itemIndex >= 0 then
    itemData = {};
    for _, v in pairs(itemFields) do
      itemData[tostring(v)] = Item.GetData(itemIndex, v);
    end
  else
    itemData = 0;
  end
  return itemData;
end

function BankExpand:setItemData(itemIndex, itemData)
  if itemIndex >= 0 then
    for _, v in pairs(itemFields) do
      if type(itemData[tostring(v)]) ~= 'nil' then
        Item.SetData(itemIndex, v, itemData[tostring(v)]);
      end
    end
  end
end

return BankExpand;
