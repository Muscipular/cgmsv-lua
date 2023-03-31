---@alias CharIndex integer
---@alias ItemIndex integer
---@alias BattleIndex integer
---@alias void nil

---@class ModuleBase
ModuleBase = ModuleBase or {}

---@alias DamageCalculateEventCallback fun(charIndex:CharIndex, defCharIndex:CharIndex, oriDamage:integer, damage:integer, battleIndex:BattleIndex, com1:integer, com2:integer, com3:integer, defCom1:integer, defCom2:integer, defCom3:integer, flg:integer):integer|void
---@class ModuleBase
---@param callbackKey 'DamageCalculateEvent'
---@param fn DamageCalculateEventCallback
---@return string fnKey, number cbIndex, number fnIndex
function ModuleBase:regCallback(callbackKey, fn) end


---@alias ProtocalCallback fun(fd, head, data):integer|void
---@class ModuleBase
---@param callbackKey 'ProtocolOnRecv'
---@param fn ProtocalCallback
---@param head string
---@return string fnKey, number cbIndex, number fnIndex
function ModuleBase:regCallback(callbackKey, fn, head) end

---@alias EnemyCommandEventCallback fun(battleIndex: BattleIndex, side: integer, slot: integer, action: 0|1):integer|void
---@class ModuleBase
---@param callbackKey 'EnemyCommandEvent'
---@param fn EnemyCommandEventCallback
---@return string fnKey, number cbIndex, number fnIndex
function ModuleBase:regCallback(callbackKey, fn) end

---@param fn function
---@return string fnKey, number cbIndex, number fnIndex
function ModuleBase:regCallback(fn) end

---@class ModuleBase
---@param callbackKey string
---@param fn function
---@return string fnKey, number cbIndex, number fnIndex
function ModuleBase:regCallback(callbackKey, fn) end

---@class ModuleBase
---@param name string
---@return ModuleBase|NPCPart|AssetsPart
function ModuleBase:createModule(name) end

---@class NPCPart
NPCPart = NPCPart or {};

---@class NPCPart
---@param name string
---@param image number
---@param positionInfo NpcPosition
---@return CharIndex
function NPCPart:NPC_createNormal(name, image, positionInfo) end

