local Module = ModuleBase:createModule('manaPool')
local itemList = {
  { name = 'Ñª³Ø²¹³ä£¨1000LP£©', image = 27243, price = 1500, desc = '²¹³äÑª³ØÊ¹ÓÃÁ¿1000µã', count = 1, maxCount = 999, value = 1000, type = 'lp' },
  { name = 'Ñª³Ø²¹³ä£¨10000LP£©', image = 27243, price = 14500, desc = '²¹³äÑª³ØÊ¹ÓÃÁ¿10000µã', count = 1, maxCount = 999, value = 1000, type = 'lp' },
  { name = 'Ñª³Ø²¹³ä£¨100000LP£©', image = 27243, price = 140000, desc = '²¹³äÑª³ØÊ¹ÓÃÁ¿100000µã', count = 1, maxCount = 999, value = 100000, type = 'lp' },
  { name = 'Ä§³Ø²¹³ä£¨1000FP£©', image = 26206, price = 2500, desc = '²¹³äÄ§³ØÊ¹ÓÃÁ¿1000µã', count = 1, maxCount = 999, value = 1000, type = 'fp' },
  { name = 'Ä§³Ø²¹³ä£¨10000FP£©', image = 26206, price = 24500, desc = '²¹³äÄ§³ØÊ¹ÓÃÁ¿10000µã', count = 1, maxCount = 999, value = 10000, type = 'fp' },
  { name = 'Ä§³Ø²¹³ä£¨100000FP£©', image = 26206, price = 240000, desc = '²¹³äÄ§³ØÊ¹ÓÃÁ¿100000µã', count = 1, maxCount = 999, value = 100000, type = 'fp' },
}

--- ¼ÓÔØÄ£¿é¹³×Ó
function Module:onLoad()
  self:logInfo('load')
  local npc = self:NPC_createNormal('ÑªÄ§¼ÓÓÍÕ¾', 101024, { map = 1000, x = 225, y = 81, direction = 4, mapType = 0 })
  self:NPC_regTalkedEvent(npc, Func.bind(self.onSellerTalked, self))
  self:NPC_regWindowTalkedEvent(npc, Func.bind(self.onSellerSelected, self));
  self:regCallback('ResetCharaBattleStateEvent', Func.bind(self.onBattleReset, self))
end

function Module:onBattleReset(charIndex)
  if Char.IsDummy(charIndex) then
    return
  end
  local lpPool = tonumber(Field.Get(charIndex, 'LpPool')) or 0;
  local fpPool = tonumber(Field.Get(charIndex, 'FpPool')) or 0;
  if lpPool <= 0 and fpPool <= 0 then
    return
  end
  local lp = Char.GetData(charIndex, CONST.CHAR_Ñª)
  local maxLp = Char.GetData(charIndex, CONST.CHAR_×î´óÑª)
  local fp = Char.GetData(charIndex, CONST.CHAR_Ä§)
  local maxFp = Char.GetData(charIndex, CONST.CHAR_×î´óÄ§)
  if lpPool > 0 and lp < maxLp then
    lpPool = lpPool - maxLp + lp;
    if lpPool < 0 then
      maxLp = maxLp + lpPool;
      lpPool = 0;
    end
    NLG.SystemMessage(charIndex, '[ÑªÄ§³Ø] ÒÑ»Ö¸´: ' .. (maxLp - lp) .. 'LP, Ñª³ØÊ£Óà: ' .. lpPool);
  else
    maxLp = lp;
  end
  if fpPool > 0 and fp < maxFp then
    fpPool = fpPool - maxFp + fp;
    if fpPool < 0 then
      maxFp = maxFp + fpPool;
      fpPool = 0;
    end
    NLG.SystemMessage(charIndex, '[ÑªÄ§³Ø] ÒÑ»Ö¸´: ' .. (maxFp - fp) .. 'FP, Ä§³ØÊ£Óà: ' .. fpPool);
  else
    maxFp = fp;
  end
  Char.SetData(charIndex, CONST.CHAR_Ñª, maxLp)
  Char.SetData(charIndex, CONST.CHAR_Ä§, maxFp)
  NLG.UpChar(charIndex);
  local petIndex = Char.GetData(charIndex, CONST.CHAR_Õ½³è);
  if petIndex >= 0 then
    petIndex = Char.GetPet(charIndex, petIndex);
    lp = Char.GetData(petIndex, CONST.CHAR_Ñª)
    maxLp = Char.GetData(petIndex, CONST.CHAR_×î´óÑª)
    fp = Char.GetData(petIndex, CONST.CHAR_Ä§)
    maxFp = Char.GetData(petIndex, CONST.CHAR_×î´óÄ§)
    if lpPool > 0 and lp < maxLp then
      lpPool = lpPool - maxLp + lp;
      if lpPool < 0 then
        maxLp = maxLp + lpPool;
        lpPool = 0;
      end
      NLG.SystemMessage(charIndex, '[ÑªÄ§³Ø] ÒÑ»Ö¸´³èÎï: ' .. (maxLp - lp) .. 'LP, Ñª³ØÊ£Óà: ' .. lpPool);
    else
      maxLp = lp;
    end
    if fpPool > 0 and fp < maxFp then
      fpPool = fpPool - maxFp + fp;
      if fpPool < 0 then
        maxFp = maxFp + fpPool;
        fpPool = 0;
      end
      NLG.SystemMessage(charIndex, '[ÑªÄ§³Ø] ÒÑ»Ö¸´³èÎï: ' .. (maxFp - fp) .. 'FP, Ä§³ØÊ£Óà: ' .. fpPool);
    else
      maxFp = fp;
    end
    Char.SetData(petIndex, CONST.CHAR_Ñª, maxLp)
    Char.SetData(petIndex, CONST.CHAR_Ä§, maxFp)
    NLG.UpChar(petIndex);
  end
  Field.Set(charIndex, 'LpPool', tostring(lpPool));
  Field.Set(charIndex, 'FpPool', tostring(fpPool));
end

function Module:onSellerTalked(npc, player)
  if NLG.CanTalk(npc, player) then
    NLG.ShowWindowTalked(player, npc, CONST.´°¿Ú_ÉÌµêÂò, CONST.BUTTON_ÊÇ, 0,
      self:NPC_buildBuyWindowData(101024, 'ÑªÄ§¼ÓÓÍÕ¾', '³äÖµÑªÄ§³Ø', '½ðÇ®²»×ã', '±³°üÒÑÂú', itemList))
  end
end

function Module:onSellerSelected(npc, player, seqNo, select, data)
  local items = string.split(data, '|');
  local lpPool = tonumber(Field.Get(player, 'LpPool')) or 0;
  local fpPool = tonumber(Field.Get(player, 'FpPool')) or 0;
  local gold = Char.GetData(player, CONST.CHAR_½ð±Ò)
  local totalGold = 0;
  local totalLp = 0;
  local totalFp = 0;
  for i = 1, #items / 2 do
    local c = itemList[items[(i - 1) * 2 + 1] + 1]
    if c then
      local count = (tonumber(items[(i - 1) * 2 + 2]) or 0);
      if c.type == 'lp' then
        totalLp = totalLp + c.value * count;
      else
        totalFp = totalFp + c.value * count;
      end
      totalGold = totalGold + c.price * count;
    end
  end
  if gold < totalGold then
    NLG.SystemMessage(player, '½ð±Ò²»×ã');
    return
  end
  Char.AddGold(player, -totalGold);
  Field.Set(player, 'LpPool', tostring(lpPool + totalLp));
  Field.Set(player, 'FpPool', tostring(fpPool + totalFp));
  NLG.UpChar(player);
  if totalLp > 0 then
    NLG.SystemMessage(player, '[ÑªÄ§³Ø] ²¹³äÑª³Ø: ' .. totalLp .. ', ¹²: ' .. (lpPool + totalLp));
  end
  if totalFp > 0 then
    NLG.SystemMessage(player, '[ÑªÄ§³Ø] ²¹³äÄ§³Ø: ' .. totalFp .. ', ¹²: ' .. (fpPool + totalFp));
  end
end

--- Ð¶ÔØÄ£¿é¹³×Ó
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
