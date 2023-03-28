---@class ModuleBase
ModuleBase = ModuleBase or {}

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

---@alias CharIndex integer
---@alias ItemIndex integer
---@alias void nil