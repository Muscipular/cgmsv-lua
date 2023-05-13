local BattleCommands = {};
_G.BattleCommands = BattleCommands;

function BattleCommands.GetTargets(battleIndex, attackerSlot)
  local attacker = Battle.GetPlayer(battleIndex, attackerSlot);
  local weapon, weaponSlot = Char.GetWeapon(attacker);
  local isRanger = false;
  if weapon > 0 and table.indexOf(Item.Types.RangerWeaponType, Item.GetData(weapon, CONST.道具_类型)) > 0 then
    isRanger = true;
  end
  local targets = {}
  local allowTargets = {}
  if attackerSlot < 10 then
    allowTargets = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }
    for i = 10, (attackerSlot >= 5 or isRanger) and 19 or 14 do
      if Battle.GetPlayer(battleIndex, i) > i then
        table.insert(targets, i);
      end
    end
    allowTargets = table.combine(allowTargets, targets);
  else
    allowTargets = { 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 }
    for i = 0, (attackerSlot >= 5 or isRanger) and 9 or 4 do
      if Battle.GetPlayer(battleIndex, i) > i then
        table.insert(targets, i);
      end
    end
    allowTargets = table.combine(allowTargets, targets);
  end
  return targets, allowTargets
end

function BattleCommands.Attack(battleIndex, attackerSlot, action, slot)
  local attacker = Battle.GetPlayer(battleIndex, attackerSlot);
  if attacker < 0 then
    return -1;
  end
  local targets, allowTargets = BattleCommands.GetTargets(battleIndex, attackerSlot);
  if slot == nil or Battle.GetPlayer(battleIndex, slot) < 0 or table.indexOf(allowTargets, slot) < 1 then
    slot = targets[math.random(0, #targets)]
  end

  Char.SetData(attacker, action == 1 and CONST.CHAR_Battle2Com1 or CONST.CHAR_BattleCom1, CONST.BATTLE_COM.BATTLE_COM_ATTACK);
  Char.SetData(attacker, action == 1 and CONST.CHAR_Battle2Com2 or CONST.CHAR_BattleCom2, slot);
  Char.SetData(attacker, action == 1 and CONST.CHAR_Battle2Com3 or CONST.CHAR_BattleCom3, -1);
  return 0;
end

function Battle.GetSlot(battleIndex, charIndex)
  for i = 0, 19 do
    if Battle.GetPlayer(battleIndex, i) == charIndex then
      return i;
    end
  end
  return -1;
end 

----- @return number BatteIndex
function Battle.GetCurrentBattle(CharIndex)
  if Char.GetData(CharIndex, CONST.CHAR_战斗状态) == 0 then
    return -1;
  end
  return Char.GetData(CharIndex, CONST.CHAR_BattleIndex)
end
