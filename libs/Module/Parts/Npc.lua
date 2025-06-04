---@class NPCPart: ModulePart
local NPCPart = ModuleBase:createPart('NpcPart');

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

---@param name string
---@param image number
---@param positionInfo NpcPosition
---@param shopBaseInfo ShopBaseInfo
---@return CharIndex
function NPCPart:NPC_createShop(name, image, positionInfo, shopBaseInfo, items)
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
  local ret = NL.CreateArgNpc("Itemshop2", shopNpcPrefix .. '|' .. table.join(items or {}, '|'), name, image,
    positionInfo.mapType, positionInfo.map, positionInfo.x, positionInfo.y, positionInfo.direction);
  if ret >= 0 then
    table.insert(self.npcList, ret);
  end
  return ret;
end

---@param name string
---@param image number
---@param positionInfo NpcPosition
---@param initCallback fun(charIndex:number):boolean
---@return CharIndex
function NPCPart:NPC_createNormal(name, image, positionInfo, initCallback)
  local initFn, cbIndex, fnIndex = self:regCallback(initCallback or function()
    return true
  end)
  local npc = NL.CreateNpc(nil, initFn);
  self:unRegCallback(initFn, cbIndex);
  if npc < 0 then
    return -1;
  end
  table.insert(self.npcList, npc);
  Char.SetData(npc, CONST.CHAR_形象, image);
  Char.SetData(npc, CONST.CHAR_原形, image);
  Char.SetData(npc, CONST.CHAR_X, positionInfo.x);
  Char.SetData(npc, CONST.CHAR_Y, positionInfo.y);
  Char.SetData(npc, CONST.CHAR_地图, positionInfo.map);
  Char.SetData(npc, CONST.CHAR_方向, positionInfo.direction);
  Char.SetData(npc, CONST.CHAR_名字, name);
  Char.SetData(npc, CONST.CHAR_地图类型, positionInfo.mapType);
  NLG.UpChar(npc);
  return npc
end

---@param list {name:string,image:number,price:number,desc:string,count:number, maxCount:number}[]
---@param image number
---@param msg1 string
---@param msg2 string
---@param msg3 string
---@param name string
---@return string
function NPCPart:NPC_buildBuyWindowData(image, name, msg1, msg2, msg3, list)
  return table.join({ image, name, msg1, msg2, msg3, table.unpack(table.map(list, function(e)
    return table.join({ e.name or '?', e.image or 0, e.price or 0, e.desc or '', e.count or 1, e.maxCount or 1 }, '|')
  end)) }, '|')
end

---注册npc Talked事件
---@param npc number
---@param fn fun(npc: number, player: number, msg: string, color:number, size:number):void
---@return string fnKey
---@return number lastIndex
---@return number fnIndex
function NPCPart:NPC_regTalkedEvent(npc, fn)
  local talkedFn, lastIndex, fnIndex = self:regCallback(self.name .. '_npc_' .. npc .. '_TalkedEvent', fn)
  Char.SetTalkedEvent(nil, talkedFn, npc);
  return talkedFn, lastIndex, fnIndex
end

---注册npc WindowTalked事件
---@param npc number
---@param fn  WindowTalkedCallback
---@return string fnKey
---@return number lastIndex
---@return number fnIndex
function NPCPart:NPC_regWindowTalkedEvent(npc, fn)
  local talkedFn, lastIndex, fnIndex = self:regCallback(self.name .. '_npc_' .. npc .. '_WindowTalkedEvent', fn)
  Char.SetWindowTalkedEvent(nil, talkedFn, npc);
  return talkedFn, lastIndex, fnIndex
end

---@param title string
---@param options string[]
---@return string
function NPCPart:NPC_buildSelectionText(title, options)
  local line = #(string.split(title, '\\n') or {}) or 1;
  local msg = line .. '\\n' .. title .. '\\n'
  for i = 1, 8 do
    if options[i] == nil then
      return msg;
    end
    msg = msg .. options[i] .. '\\n'
  end
  return msg;
end

---@class CO
---@field fun function
---@field module string
---@field ctx {[number]:thread}
local CO = {
  ctx = {}
}

regGlobalEvent("LogoutEvent", function(player)
  CO.ctx[player] = nil;
end)

function CO:onTalk(npc, player, msg, color, size)
  self.ctx[player] = coroutine.create(self.fun)
  -- print(self.ctx[player], coroutine.status(self.ctx[player]))
  coroutine.resume(self.ctx[player], self, npc, player, msg, color, size);
  if coroutine.status(self.ctx[player]) == "dead" then
    self.ctx[player] = nil;
  end
end

function CO:onWindowTalk(npc, player, seqno, select, data)
  if coroutine.status(self.ctx[player]) == "dead" then
    logError(self.module, "coroutine is dead!");
    return
  end
  coroutine.resume(self.ctx[player], npc, player, seqno, select, data);
  if coroutine.status(self.ctx[player]) == "dead" then
    self.ctx[player] = nil;
  end
end

---生成并发送对话框
---@param ToIndex  number 接收对话框的目标的对象index。
---@param WinTalkIndex  number 生成对话框的目标的对象index，一般为NPC。
---@param WindowType  number 查阅附录对话框类型
---@param ButtonType  number 对话框包含的按钮，查阅附录对话框按钮
---@param SeqNo  number 自定义数值，用于识别不同的对话框事件响应, 具体会在WindowTalkedCallBack中调用
---@param Data  string 对话框的内容,根据不同的对话框类别,有不同的格式,具体会在附录中说明
---@return number CharIndex
---@return number TargetCharIndex 
---@return number SeqNo 
---@return number Select 
---@return string Data 
function CO:next(ToIndex, WinTalkIndex, WindowType, ButtonType, SeqNo, Data)
  NLG.ShowWindowTalked(ToIndex, WinTalkIndex, WindowType, ButtonType, SeqNo, Data);
  return coroutine.yield()
end

function NPCPart:NPC_CreateCo(name, image, posistionInfo, fun)
  local co = {
    npc = self:NPC_createNormal(name, image, posistionInfo),
    fun = fun,
    module = self.name,
  };

  setmetatable(co, { __index = CO });
  self:NPC_regTalkedEvent(co.npc, Func.bind(CO.onTalk, co));
  self:NPC_regWindowTalkedEvent(co.npc, Func.bind(CO.onWindowTalk, co));
  return co;
end

function NPCPart:onLoad()
  self.npcList = {};
end

function NPCPart:onUnload()
  for i, v in pairs(self.npcList) do
    Char.UnsetLoopEvent(v);
    Char.UnsetWindowTalkedEvent(v);
    Char.UnsetTalkedEvent(v);
    NL.DelNpc(v);
  end
end

return NPCPart;
