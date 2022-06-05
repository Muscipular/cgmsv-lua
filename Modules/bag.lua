---模块类
local BagModule = ModuleBase:createModule('bag')

BagModule:addMigration(1, "migrate1", function()
  local res = SQL.QueryEx("select * from lua_chardata");
  if res.rows then
    for i, row in ipairs(res.rows) do
      pcall(function()
        local data = JSON.decode(row.data);
        local regId = row.id;
        local cdkey = row.cdkey;
        if data.bag and data.bagIndex then
          for i = 1, 5 do
            for j = 1, 20 do
              if data.bag[i] and data.bag[i][j] then
                SQL.QueryEx("insert into hook_charaext (cdKey, regNo, sKey, val, valType) values (?,?,?,?,?)",
                  cdkey, regId, string.format("bag-%d-%d", i, j), JSON.encode(data.bag[i][j]), 0);
              end
            end
          end
          SQL.QueryEx("insert into hook_charaext (cdKey, regNo, sKey, val, valType) values (?,?,?,?,?)",
            cdkey, regId, "bag-index", data.bagIndex, 1);
        end
      end)
    end
  end
end)

local itemFields = { }
for i = 0, 0x4b do
  table.insert(itemFields, i);
end
for i = 0, 0xd do
  table.insert(itemFields, i + 2000);
end

function BagModule:onTalkEvent(CharIndex, Msg, Color, Range, Size)
  if string.sub(Msg, 1, 4) ~= '/bag' then
    return 1;
  end
  if Battle.GetCurrentBattle(CharIndex) >= 0 then
    NLG.SystemMessage(CharIndex, '战斗中无法切换背包')
    return 0;
  end
  local bagIndex = tonumber(string.sub(Msg, 5));
  if bagIndex < 1 or bagIndex > 5 then
    NLG.SystemMessage(CharIndex, '无效背包')
    return 0;
  end
  local oBagIndex = Char.GetExtData(CharIndex, "bag-index") or 1;
  self:logDebug('bagIndex', oBagIndex, '=>', bagIndex);
  if bagIndex == oBagIndex then
    NLG.SystemMessage(CharIndex, '无须切换背包')
    --Char.SetExtData(CharIndex, "bag-index", 1);
    return 0;
  end
  Char.SetExtData(CharIndex, "bag-index", bagIndex);
  for i = 1, 20 do
    local itemIndex = Char.GetItemIndex(CharIndex, i + 7)
    --self:logDebug('backup', i + 7, itemIndex);
    if itemIndex >= 0 then
      local item = {};
      for _, v in pairs(itemFields) do
        item[tostring(v)] = Item.GetData(itemIndex, v);
      end
      local r = Char.DelItemBySlot(CharIndex, i + 7);
      Char.SetExtData(CharIndex, string.format("bag-%d-%d", oBagIndex, i), JSON.encode(item));
    else
      Char.SetExtData(CharIndex, string.format("bag-%d-%d", oBagIndex, i), nil);
    end
  end
  for i = 1, 20 do
    local bagItem = Char.GetExtData(CharIndex, string.format("bag-%d-%d", bagIndex, i));
    Char.SetExtData(CharIndex, string.format("bag-%d-%d", bagIndex, i), nil);
    pcall(function()
      if bagItem then
        bagItem = JSON.decode(bagItem);
      end
    end)
    if type(bagItem) == 'table' then
      --self:logDebug('restore', bagItem[tostring(CONST.道具_ID)], bagItem[tostring(CONST.道具_堆叠数)]);tbl_character_down
      local itemId = bagItem[tostring(CONST.道具_ID)];
      if itemId < 0 then
        itemId = 0
      end
      local itemIndex = Char.GiveItem(CharIndex, itemId, 1, false);
      if itemIndex >= 0 then
        for _, field in pairs(itemFields) do
          local r = 0;
          if type(bagItem[tostring(field)]) ~= 'nil' then
            r = Item.SetData(itemIndex, field, bagItem[tostring(field)]);
            --if r ~= 1 then
            --  self:logWarnF("itemIndex %s, %s, set field %d = %s error", r, itemIndex, field, tostring(bagItem[tostring(field)]));
            --end
          else
            --self:logWarnF("itemIndex %d, field %s is nil", itemIndex, tostring(field));
          end
          --self:logDebug(itemIndex, field, bagItem[tostring(field)], Item.GetData(itemIndex, field), r);
        end
      end
    end
  end
  Item.UpItem(CharIndex, -1);
  NLG.SystemMessage(CharIndex, '切换背包' .. bagIndex)
  return 0;
end

function BagModule:onLoginEvent(charIndex)
  local bIndex = Char.GetExtData(charIndex, "bag-index") or 1;
  Protocol.Send(charIndex, "bagIndex",  tonumber(bIndex));
end

--- 加载模块钩子
function BagModule:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.onTalkEvent, self));
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
end

--- 卸载模块钩子
function BagModule:onUnload()
  self:logInfo('unload')
end

return BagModule;
