---@meta _

---@class NPCPart
---@class AssetsPart
---@class CharPart
---@class ModulePart

---@class ModuleBase
ModuleBase = { name = '', callbacks = {}, lastIx = 0, migrations = nil };

---@class ModulePart: ModuleBase
---@field name string
---@field onLoad function
---@field onUnload function
---@field ___isPart boolean


---@param name string
---@param depParts string[]
---@return ModuleType
function ModuleBase:createModule(name, depParts) end

---@param name string
---@return ModuleType
function ModuleBase:createModule(name) end

---@alias MigrationData {version:number,name:string,value:string|function}

---@class ModuleBase
---@field name string
---@field protected ___aPath string
---@field lastIx number
---@field parts ModulePart[]
---@field migrations MigrationData[]|nil
---@field callbacks {fn: function, fnIndex: number, key: string, extSign?:string}[]

---@param fn function
---@return string fnKey, number cbIndex, number fnIndex
function ModuleBase:regCallback(fn) end

---@param callbackKey EventName
---@param fn function
---@return string fnKey, number cbIndex, number fnIndex
function ModuleBase:regCallback(callbackKey, fn) end

---@param callbackKey EventName
---@param extSign string
---@param fn function
---@return string fnKey, number cbIndex, number fnIndex
function ModuleBase:regCallback(callbackKey, fn, extSign) end

---@param name string
---@return ModulePart
function ModuleBase:createPart(name) end

---@class AssetsPart: ModulePart

---读取配置文件
function AssetsPart:readConfigFile() end;

---读取配置文件
---@param name string 文件名
---@param mode 'r'|'rw'|'r+'|'w'|'w+' 打开模式
function AssetsPart:parseFile(name, mode) end

---读取配置文件
---@param name string 文件名
function AssetsPart:parseFile(name) end

---@class CharaWrapper: {[number]: string|number|nil}
---@field public charaIndex number
CharaWrapper = {};

---@class CharPart: ModulePart
---@param field string
---@return string|number|nil
function CharaWrapper:getTmpData(field) end

---@param field string
---@param value number|string|nil
---@return number
function CharaWrapper:setTmpData(field, value) end

---@param field string
---@return string|number|nil
function CharaWrapper:getExtData(field) end

---@param field string
---@param value number|string|nil
---@return number
function CharaWrapper:setExtData(field, value) end

---包装CharaIndex
---@param charaIndex CharIndex
---@return CharaWrapper
function CharPart:Chara(charaIndex) end

---@alias NpcPosition {x:number,y:number,map:number,mapType:number,direction:number}
---@alias ShopBaseInfo {buyRate:number,sellRate:number,shopType:number,msgBuySell:number,msgBuy:number,msgMoneyNotEnough:number,msgBagFull:number,msgSell:number,msgAfterSell:number,sellTypes:table|'all'}


---@class NPCPart: ModulePart
---@field npcList number[]
NPCPart = NPCPart or {};

---@param name string
---@param image number
---@param positionInfo NpcPosition
---@return CharIndex
function NPCPart:NPC_createNormal(name, image, positionInfo) end

---@param name string
---@param image number
---@param positionInfo NpcPosition
---@param shopBaseInfo ShopBaseInfo
---@return CharIndex
function NPCPart:NPC_createShop(name, image, positionInfo, shopBaseInfo, items) end

---@param name string
---@param image number
---@param positionInfo NpcPosition
---@param initCallback fun(charIndex:number):boolean
---@return CharIndex
function NPCPart:NPC_createNormal(name, image, positionInfo, initCallback) end

---@param list {name:string,image:number,price:number,desc:string,count:number, maxCount:number}[]
---@param image number
---@param msg1 string
---@param msg2 string
---@param msg3 string
---@param name string
---@return string
function NPCPart:NPC_buildBuyWindowData(image, name, msg1, msg2, msg3, list) end

---注册npc Talked事件
---@param npc number
---@param fn fun(npc: number, player: number):void
---@return string fnKey
---@return number lastIndex
---@return number fnIndex
function NPCPart:NPC_regTalkedEvent(npc, fn) end

---@alias WindowTalkedCallback fun(npc: number, player: number, seqno: number, select: number, data: string):void

---注册npc WindowTalked事件
---@param npc number
---@param fn  WindowTalkedCallback
---@return string fnKey
---@return number lastIndex
---@return number fnIndex
function NPCPart:NPC_regWindowTalkedEvent(npc, fn) end

---@param title string
---@param options string[]
---@return string
function NPCPart:NPC_buildSelectionText(title, options) end

---@class ModuleType: ModuleBase
---@class ModuleType: NPCPart
---@class ModuleType: AssetsPart
---@class ModuleType: CharPart
