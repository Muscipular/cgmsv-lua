---模块类
---@class ActionAdd: ModuleType
local ActionAdd = ModuleBase:createModule('actionAdd')

--- 加载模块钩子
function ActionAdd:onLoad()
    self:logInfo('load')
    self:regCallback('BattleBeforeActionEvent', function(battleIndex, charIndex)
        self:logInfo("BattleBeforeActionEvent", battleIndex, charIndex)
    end)
    self:regCallback('BattleAfterActionEvent', function(battleIndex, charIndex, fn)
        self:logInfo("BattleAfterActionEvent", battleIndex, charIndex, fn)
        if (Char.GetData(charIndex, CONST.对象_类型) == CONST.对象类型_人) then
            local pet = Char.GetPet(charIndex, Char.GetData(charIndex, CONST.CHAR_战宠));
            if pet >= 0 then
                fn(pet, CONST.BATTLE_COM.BATTLE_COM_ATTACK, 10, -1);
            end
            self:logInfo("pet", pet);
            fn(charIndex, CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER, 10, 100);
            fn(charIndex, CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER, 10, 300);
            fn(charIndex, CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, CONST.BATTLE_COM_TARGETS.ALL.SIDE_1, 2900);
            fn(charIndex, CONST.BATTLE_COM.BATTLE_COM_P_RENZOKU, 10, 0);
        end
    end)
end

--- 卸载模块钩子
function ActionAdd:onUnload()
    self:logInfo('unload')
end

return ActionAdd;
