local ModuleBase = { name = '', callbacks = {}, lastIx = 0, migrations = nil };

_G.ModuleBase = ModuleBase;

function ModuleBase:new(name)
  local o = {};
  setmetatable(o, self)
  self.__index = self
  o.name = name;
  o.callbacks = {};
  o.lastIx = 0;
  o.npcList = {};
  return o;
end

function ModuleBase:createModule(name)
  local SubModule = ModuleBase:new(name)
  function SubModule:new()
    local o = ModuleBase:new(name);
    setmetatable(o, self)
    self.__index = self;
    return o;
  end

  return SubModule;
end

---@param eventNameOrCallbackKeyOrFn string|nil|function
---@param fn function|nil
---@return string, number, number
function ModuleBase:regCallback(eventNameOrCallbackKeyOrFn, fn)
  self.lastIx = self.lastIx + 1;
  if type(eventNameOrCallbackKeyOrFn) == 'function' then
    fn = eventNameOrCallbackKeyOrFn;
    eventNameOrCallbackKeyOrFn = '_' .. self.name .. '_cb_' .. self.lastIx;
  end
  local fnIndex = regGlobalEvent(eventNameOrCallbackKeyOrFn, fn, self.name);
  logInfo(self.name, 'regCallback', eventNameOrCallbackKeyOrFn, self.lastIx, fnIndex, fn);
  self.callbacks[self.lastIx] = { key = eventNameOrCallbackKeyOrFn, fnIndex = fnIndex, fn = fn };
  return eventNameOrCallbackKeyOrFn, self.lastIx, fnIndex;
end

---@param eventNameOrCallbackKey string
---@param fnOrFnIndex function|number
function ModuleBase:unRegCallback(eventNameOrCallbackKey, fnOrFnIndex)
  local cbIndex = fnOrFnIndex;
  if type(fnOrFnIndex) == 'function' then
    cbIndex = table.findIndex(self.callbacks, function(e)
      return fnOrFnIndex == e.fn
    end)
  end
  local fnCb = self.callbacks[cbIndex];
  if not fnCb then
    logWarn(self.name, 'cannot find callback of ' .. eventNameOrCallbackKey, fnOrFnIndex)
    return
  end
  logInfo(self.name, 'unRegGlobalEvent', fnCb.key, fnCb.fnIndex, fnCb.fn);
  unRegGlobalEvent(fnCb.key, fnCb.fnIndex, self.name);
  self.callbacks[cbIndex] = nil;
end

function ModuleBase:onUnload()

end

function ModuleBase:unload()
  self:onUnload()
  for i, v in pairs(self.npcList) do
    NL.DelNpc(v);
  end
  for i, fnCb in pairs(self.callbacks) do
    unRegGlobalEvent(fnCb.key, fnCb.fnIndex, self.name);
  end
  self.callbacks = {};
end

function ModuleBase:migrate()
  if self.migrations then
    local ret = SQL.querySQL('select ifnull(max(id), 0) version from lua_migration where module = \'' .. self.name .. '\';');
    local version = tonumber(ret[1][1]);
    table.sort(self.migrations, function(a, b)
      return a.version - b.version
    end)
    for i, migration in ipairs(self.migrations) do
      if migration.version > version then
        self:logInfo('run migration: ' .. migration.version)
        version = migration.version;
        if type(migration.value) == 'function' then
          migration.value();
        elseif type(migration.value) == 'string' then
          SQL.querySQL(migration.value);
        end
        SQL.querySQL('insert into lua_migration (id, name, module) values (' .. migration.version .. ', \'' .. migration.name .. '\', \'' .. self.name .. '\');')
      end
    end
  end
end

function ModuleBase:log(level, msg, ...)
  log(self.name, level, msg, ...)
end

function ModuleBase:logInfo(msg, ...)
  logInfo(self.name, msg, ...)
end

function ModuleBase:logDebug(msg, ...)
  logDebug(self.name, msg, ...)
end

function ModuleBase:logWarn(msg, ...)
  logWarn(self.name, msg, ...)
end

function ModuleBase:logError(msg, ...)
  logError(self.name, msg, ...)
end

function ModuleBase:load()
  self:migrate();
  self:onLoad()
end

function ModuleBase:onLoad()

end

local function fillShopSellType(tb)
  local all = tb == 'all';
  local ret = {}
  for i = 1, 48 do
    if all or tb[i - 1] then
      table.insert(ret, '1');
    else
      table.insert(ret, '0');
    end
  end
  return ret;
end

local sellAllTypes = table.range(0, 47, function()
  return 1
end)

---@param positionInfo {x:number,y:number,map:number,mapType:number,direction:number}
---@param shopBaseInfo {buyRate:number,sellRate:number,shopType:number,msgBuySell:number,msgBuy:number,msgMoneyNotEnough:number,msgBagFull:number,msgSell:number,msgAfterSell:number,sellTypes:table|'all'}
---@param image number
---@param name string
function ModuleBase:NPC_createShop(name, image, positionInfo, shopBaseInfo, items)
  local shopNpcPrefix = table.join({
    shopBaseInfo.buyRate or 100,
    shopBaseInfo.sellRate or 100,
    shopBaseInfo.shopType or CONST.SHOP_TYPE_BOTH,
    shopBaseInfo.msgBuySell or '10146',
    shopBaseInfo.msgBuy or '10147',
    shopBaseInfo.msgMoneyNotEnough or '10148',
    shopBaseInfo.msgBagFull or '10149',
    shopBaseInfo.msgSell or '10150',
    shopBaseInfo.msgAfterSell or '10151',
    table.unpack(fillShopSellType(shopBaseInfo.sellTypes or {})),
  }, '|');
  local ret = NL.CreateArgNpc("Itemshop2", shopNpcPrefix .. '|' .. table.join(items or {}, '|'), name, image, positionInfo.mapType, positionInfo.map, positionInfo.x, positionInfo.y, positionInfo.direction);
  if ret >= 0 then
    table.insert(self.npcList, ret);
  end
  return ret;
end
