---模块类
local BankExpand = ModuleBase:createModule('bankExpand')

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
  local bIndex = self:getData(charIndex, "index") or 1;
  if bIndex == data then
    return ;
  end
  local dataSave = {
    index = data,
  }
  --self:setData(charIndex, "index", data);
  for i = 0, 19 do
    local itemIndex = Char.GetPoolItem(charIndex, i);
    if itemIndex >= 0 then
      dataSave[string.format("slot-%d-%d", bIndex, i)] = self:readItemData(itemIndex);
      Char.RemovePoolItem(charIndex, i);
    else
      dataSave[string.format("slot-%d-%d", bIndex, i)] = 0;
    end
    local itemData = self:getData(charIndex, string.format("slot-%d-%d", data, i));
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
  self:setData(charIndex, dataSave);
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
      Item.SetData(itemIndex, v, itemData[tostring(v)]);
    end
  end
end

function BankExpand:getData(charIndex, field)
  ---@type CharExt
  local charExt = getModule('charExt')
  local data = charExt:getData(charIndex).bankExpand or {};
  return data[tostring(field)];
end

function BankExpand:setData(charIndex, field, itemData)
  ---@type CharExt
  local charExt = getModule('charExt')
  local data = charExt:getData(charIndex);
  if data.bankExpand == nil then
    data.bankExpand = {}
  end
  if type(field) == 'table' then
    for i, v in pairs(field) do
      data.bankExpand[i] = v;
    end
  elseif type(field) == 'string' then
    data.bankExpand[tostring(field)] = itemData;
  end
  charExt:setData(charIndex, data);
end

return BankExpand;
