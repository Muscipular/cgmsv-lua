---宠物转生，全bp+3，技能栏+1
local moduleName = 'petRebirth'
local PetRebirth = ModuleBase:createModule(moduleName)

function PetRebirth:onTalked(npc, player)
  if NLG.CanTalk(npc, player) then
    NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_下取消, 1, '\\n\\n   大于150级的宠物可以转生\\n   转生后bp+5,技能栏+1,全属性+1,抗性+5,暴击/闪避/反击/命中+5\\n   费用: 10万魔币')
  end
end

function PetRebirth:firstPage(npc, player, seqNo, select, data)
  if select == CONST.BUTTON_下一页 then
    if Char.GetData(player, CONST.CHAR_金币) < 100000 then
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_关闭, 3, '\\n\\n   金币不足')
      return
    end
    local list = { }
    for i = 0, 4 do
      local pIndex = Char.GetPet(player, i);
      if pIndex >= 0 then
        local rebirthTime = Char.GetExtData(pIndex, 'rebirthTime') or 0;
        local lv = Char.GetData(pIndex, CONST.CHAR_等级)
        if lv > 150 then
          table.insert(list, Char.GetData(pIndex, CONST.CHAR_名字) .. ' lv.' .. lv .. ' ' .. rebirthTime .. '转');
        else
          table.insert(list, Char.GetData(pIndex, CONST.CHAR_名字) .. ' lv.' .. lv .. ' ' .. rebirthTime .. '转' .. '（等级不足）');
        end
      else
        table.insert(list, '[空]');
      end
    end
    if table.isEmpty(list) then
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_关闭, 3, '\\n\\n   没有合适的宠物')
      return
    end
    NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 2, self:NPC_buildSelectionText('选择转生的宠物', list));
  else
    return
  end
end

function PetRebirth:selectPage(npc, player, seqNo, select, data)
  if select == CONST.BUTTON_关闭 then
    return
  end
  local pIndex = Char.GetPet(player, tonumber(data) - 1);
  if pIndex < 0 then
    NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_确定, 3, '\\n\\n   该位置没有宠物')
    return
  end
  if Char.GetData(pIndex, CONST.CHAR_等级) < 150 then
    NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_确定, 3,
      '\\n\\n   ' .. Char.GetData(pIndex, CONST.CHAR_名字) .. ' lv.' .. Char.GetData(pIndex, CONST.CHAR_等级) .. ' 等级不足150')
    return
  end
  Char.SetData(player, CONST.CHAR_WindowBuffer2, pIndex + 1);
  NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_是否, 4,
    '\\n\\n   ' .. Char.GetData(pIndex, CONST.CHAR_名字) .. ' lv.' .. Char.GetData(pIndex, CONST.CHAR_等级) .. '\\n\\n   确定转生？')
end

function PetRebirth:confirmPage(npc, player, seqNo, select, data)
  if select == CONST.BUTTON_否 then
    return
  end
  local pIndex = Char.GetData(player, CONST.CHAR_WindowBuffer2) - 1;
  Char.SetData(player, CONST.CHAR_WindowBuffer2, 0);
  if not Char.IsValidCharIndex(pIndex) then
    return
  end
  if Char.GetData(player, CONST.CHAR_金币) < 100000 then
    NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_确定, 3, '\\n\\n   金币不足')
    return
  end
  for i = 0, 4 do
    local pIndex2 = Char.GetPet(player, i);
    if pIndex2 == pIndex then
      if Char.GetData(pIndex, CONST.CHAR_等级) < 150 then
        NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_确定, 3,
          '\\n\\n   ' .. Char.GetData(pIndex, CONST.CHAR_名字) .. ' lv.' .. Char.GetData(pIndex, CONST.CHAR_等级) .. ' 等级不足150')
        return
      end
      --Char.AddGold(player, -100000);
      local arts = { CONST.PET_体成, CONST.PET_力成, CONST.PET_强成, CONST.PET_敏成, CONST.PET_魔成 };
      arts = table.map(arts, function(v)
        return { v, math.min(62, Pet.GetArtRank(pIndex, v) + 5) };
      end)
      table.forEach(arts, function(v)
        Pet.SetArtRank(pIndex, v[1], v[2]);
      end);
      Pet.ReBirth(player, pIndex);
      table.forEach(arts, function(v)
        Pet.SetArtRank(pIndex, v[1], v[2]);
      end);
      Char.SetData(pIndex, CONST.CHAR_地属性, math.min(100, Char.GetData(pIndex, CONST.CHAR_地属性) + 10));
      Char.SetData(pIndex, CONST.CHAR_水属性, math.min(100, Char.GetData(pIndex, CONST.CHAR_水属性) + 10));
      Char.SetData(pIndex, CONST.CHAR_火属性, math.min(100, Char.GetData(pIndex, CONST.CHAR_火属性) + 10));
      Char.SetData(pIndex, CONST.CHAR_风属性, math.min(100, Char.GetData(pIndex, CONST.CHAR_风属性) + 10));
      Char.SetData(pIndex, CONST.PET_技能栏, math.min(10, Char.GetData(pIndex, CONST.PET_技能栏) + 1));
      arts = { CONST.CHAR_抗毒, CONST.CHAR_抗睡, CONST.CHAR_抗石, CONST.CHAR_抗醉,
               CONST.CHAR_抗乱, CONST.CHAR_抗忘, CONST.CHAR_必杀, CONST.CHAR_反击,
               CONST.CHAR_命中, CONST.CHAR_闪躲, }
      table.forEach(arts, function(e)
        Char.SetData(pIndex, e, math.min(100, Char.GetData(pIndex, e) + 5));
      end)
      local rebirthTime = Char.GetExtData(pIndex, 'rebirthTime')
      rebirthTime = (rebirthTime or 0) + 1;
      Char.SetExtData(pIndex, 'rebirthTime', rebirthTime);
      --self:logDebug('rebirthTime=', petExtData.rebirthTime);
      if (rebirthTime or 0) > 5 then
        Char.SetData(pIndex, CONST.CHAR_种族, CONST.种族_邪魔);
      end
      Pet.UpPet(player, pIndex);
      NLG.UpChar(pIndex);
      NLG.UpChar(player);
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_确定, 3, '\\n\\n   已成功转生');
      return
    end
  end
  NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_确定, 3, '\\n\\n   该位置没有宠物')
  return
end

function PetRebirth:onSelected(npc, player, seqNo, select, data)
  if seqNo == 1 then
    self:firstPage(npc, player, seqNo, select, data)
  elseif seqNo == 2 then
    self:selectPage(npc, player, seqNo, select, data)
  elseif seqNo == 4 then
    self:confirmPage(npc, player, seqNo, select, data)
  end
end

--function PetRebirth:getPetData(charIndex)
--  ---@type PetExt
--  local charExt = getModule('petExt')
--  return charExt:getData(charIndex)
--end

--function PetRebirth:setPetData(charIndex, value)
--  ---@type PetExt
--  local charExt = getModule('petExt')
--  return charExt:setData(charIndex, value)
--end

--- 加载模块钩子
function PetRebirth:onLoad()
  self:logInfo('load')
  local npc = self:NPC_createNormal('宠物转生', 101024, { map = 1000, x = 225, y = 83, direction = 4, mapType = 0 });
  self:NPC_regTalkedEvent(npc, Func.bind(self.onTalked, self));
  self:NPC_regWindowTalkedEvent(npc, Func.bind(self.onSelected, self));
end

--- 卸载模块钩子
function PetRebirth:onUnload()
  self:logInfo('unload')
end

return PetRebirth;
