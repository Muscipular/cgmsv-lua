-- GMSV HOOKs and Lua API Extensions
if _HookFunc then 

dofile('lua/libs/Gmsv/Addresses.lua')
dofile('lua/libs/Gmsv/NL.lua')
dofile('lua/libs/Gmsv/NLG.lua')
dofile('lua/libs/Gmsv/Data.lua')
dofile('lua/libs/Gmsv/Item.lua')
dofile('lua/libs/Gmsv/Char.lua')
dofile('lua/libs/Gmsv/DummyChar.lua')
dofile('lua/libs/Gmsv/Recipe.lua')
dofile('lua/libs/Gmsv/Protocol.lua')
dofile('lua/libs/Gmsv/Battle.lua')
dofile('lua/libs/Gmsv/Field.lua')
dofile('lua/libs/Gmsv/Tech.lua')
dofile('lua/libs/Gmsv/Skill.lua')
dofile('lua/libs/Gmsv/Map.lua')
dofile('lua/libs/Gmsv/LowCpuUsage.lua')
dofile('lua/libs/Gmsv/DamageHook.lua')
dofile('lua/libs/Gmsv/Script.lua')
dofile('lua/libs/Gmsv/MagicAttrFix.lua')
dofile('lua/libs/Gmsv/NLG_ShowWindowTalked_Patch.lua')
dofile('lua/libs/Gmsv/NL_RegPartyEvent_Patch.lua')
dofile('lua/libs/Gmsv/NL_GetLoginPoint_Patch.lua')
dofile('lua/libs/Gmsv/BATTLE_PVE_PATCH.lua')
dofile('lua/libs/Gmsv/TechOptionEventPatch.lua')

Addresses.load();

end
dofile('lua/libs/Gmsv/ItemEx.lua')
dofile('lua/libs/Gmsv/DataEx.lua')
dofile('lua/libs/Gmsv/CharEx.lua')
dofile('lua/libs/Gmsv/BattleEx.lua')