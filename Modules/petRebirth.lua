---宠物转生，全bp+3，技能栏+1
local moduleName = 'petRebirth'
local PetRebirth = ModuleBase:createModule(moduleName)

-- 加载模块钩子
function PetRebirth:onLoad()
  self:logInfo('load')
  local npc = self:NPC_createNormal('宠物转生', 101024, { map = 1000, x = 225, y = 83, direction = 4, mapType = 0 });
  self:NPC_regTalkedEvent(npc, function(...)
    self:onTalked(...)
  end)
  self:NPC_regWindowTalkedEvent(npc, function(...)
    self:onSelected(...)
  end)
end

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
        local lv = Char.GetData(pIndex, CONST.CHAR_等级)
        if lv > 150 then
          table.insert(list, Char.GetData(pIndex, CONST.CHAR_名字) .. ' lv.' .. lv);
        else
          table.insert(list, Char.GetData(pIndex, CONST.CHAR_名字) .. ' lv.' .. lv .. '（等级不足）');
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
    NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_关闭, 3, '\\n\\n   该位置没有宠物')
    return
  end
  if Char.GetData(pIndex, CONST.CHAR_等级) < 150 then
    NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_关闭, 3,
      '\\n\\n   ' .. Char.GetData(pIndex, CONST.CHAR_名字) .. ' lv.' .. Char.GetData(pIndex, CONST.CHAR_等级) .. ' 等级不足150')
    return
  end
  NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_是否, 10 + pIndex,
    '\\n\\n   ' .. Char.GetData(pIndex, CONST.CHAR_名字) .. ' lv.' .. Char.GetData(pIndex, CONST.CHAR_等级) .. '\\n\\n   确定转生？')
end

function PetRebirth:confirmPage(npc, player, seqNo, select, data)
  if select == CONST.BUTTON_否 then
    return
  end
  local pIndex = seqNo - 10;
  if Char.GetData(player, CONST.CHAR_金币) < 100000 then
    NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_关闭, 3, '\\n\\n   金币不足')
    return
  end
  for i = 0, 4 do
    local pIndex2 = Char.GetPet(player, i);
    if pIndex2 == pIndex then
      if Char.GetData(pIndex, CONST.CHAR_等级) < 150 then
        NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_关闭, 3,
          '\\n\\n   ' .. Char.GetData(pIndex, CONST.CHAR_名字) .. ' lv.' .. Char.GetData(pIndex, CONST.CHAR_等级) .. ' 等级不足150')
        return
      end
      Char.AddGold(player, -100000);
      local arts = { CONST.PET_体成, CONST.PET_力成, CONST.PET_强成, CONST.PET_敏成, CONST.PET_魔成 };
      arts = table.map(arts, function(v)
        return { v, math.min(62, Pet.GetArtRank(pIndex, v) + 5) };
      end)
      Pet.ReBirth(player, pIndex);
      table.forEach(arts, function(v)
        Pet.SetArtRank(pIndex, v[1], v[2]);
      end);
      Char.SetData(pIndex, CONST.CHAR_地属性, math.min(10, Char.GetData(pIndex, CONST.CHAR_地属性) + 1));
      Char.SetData(pIndex, CONST.CHAR_水属性, math.min(10, Char.GetData(pIndex, CONST.CHAR_水属性) + 1));
      Char.SetData(pIndex, CONST.CHAR_火属性, math.min(10, Char.GetData(pIndex, CONST.CHAR_火属性) + 1));
      Char.SetData(pIndex, CONST.CHAR_风属性, math.min(10, Char.GetData(pIndex, CONST.CHAR_风属性) + 1));
      Char.SetData(pIndex, CONST.PET_技能栏, math.min(10, Char.GetData(pIndex, CONST.PET_技能栏) + 1));
      arts = { CONST.CHAR_抗毒, CONST.CHAR_抗睡, CONST.CHAR_抗石, CONST.CHAR_抗醉, 
               CONST.CHAR_抗乱, CONST.CHAR_抗忘, CONST.CHAR_必杀, CONST.CHAR_反击,
               CONST.CHAR_命中, CONST.CHAR_闪躲, }
      table.forEach(arts, function(e)
        Char.SetData(pIndex, e, math.min(100, Char.GetData(pIndex, e) + 5));
      end)
      Pet.UpPet(player, pIndex);
      NLG.UpChar(player);
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_关闭, 3, '\\n\\n   已成功转生');
      return
    end
  end
  NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_关闭, 3, '\\n\\n   该位置没有宠物')
  return
end

function PetRebirth:onSelected(npc, player, seqNo, select, data)
  if seqNo == 1 then
    self:firstPage(npc, player, seqNo, select, data)
  elseif seqNo == 2 then
    self:selectPage(npc, player, seqNo, select, data)
  elseif seqNo >= 10 then
    self:confirmPage(npc, player, seqNo, select, data)
  end
end

-- 卸载模块钩子
function PetRebirth:onUnload()
  self:logInfo('unload')
end

return PetRebirth;
