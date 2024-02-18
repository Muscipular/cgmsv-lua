---@class Decompose : ModuleType
---@field petNPC number 
---@field itemNPC number 
local Decompose = ModuleBase:createModule('decompose');

function Decompose:onLoad()
  self:logInfo('load');
  self.petNPC = self:NPC_createNormal("宠物分解", 10000, {
    mapType = 0, map = 1000, x = 100, y = 100, direction = 0
  });
  self:NPC_regTalkedEvent(self.petNPC, Func.bind(Decompose.onPetTalked, self));
  self.itemNPC = self:NPC_createNormal("物品分解", 10000, {
    mapType = 0, map = 1000, x = 100, y = 100, direction = 0
  });
  self:NPC_regTalkedEvent(self.itemNPC, Func.bind(Decompose.onItemTalked, self));
end

function Decompose:onPetTalked(npc, player)

end

function Decompose:onItemTalked(npc, player)

end

function Decompose:onUnload()
  self:logInfo('unload')
end

return Decompose;
