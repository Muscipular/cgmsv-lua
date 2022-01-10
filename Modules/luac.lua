---模块类
local Luac = ModuleBase:createModule('luac')

--- 加载模块钩子
function Luac:onLoad()
  self:logInfo('load')
  self:regCallback('ScriptCallEvent', function(npcIndex, playerIndex, text, msg)
    self:logDebugF('npcIndex: %s, playerIndex: %s, text: %s, msg: %s', npcIndex, playerIndex, text, msg)
    local result = table.pack(string.match(text, 'getpetskill:(%d),(%d)'))
    if result and result[1] ~= nil and result[2] ~= nil then
      local petIndex = Char.GetPet(playerIndex, tonumber(result[1]))
      if petIndex >= 0 then
        return Pet.GetSkill(petIndex, tonumber(result[2]))
      end
    end
    result = table.pack(string.match(text, 'addpetskill:(%d),(%d)'))
    if result and result[1] ~= nil and result[2] ~= nil then
      local petIndex = Char.GetPet(playerIndex, tonumber(result[1]))
      if petIndex >= 0 then
        return Pet.AddSkill(petIndex, tonumber(result[2]))
      end
    end
    return -1;
  end)
end

--- 卸载模块钩子
function Luac:onUnload()
  self:logInfo('unload')
end

return Luac;
