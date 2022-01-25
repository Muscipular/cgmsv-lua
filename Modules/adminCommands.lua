local AdminCommands = ModuleBase:createModule('adminCommands')
-- gm命令
local commands = {}
--GM账号列表
local gmList = { 'u01', 'u02', 'u03', 'u04', 'u05' };
local gmDict = {};
table.forEach(gmList, function(e)
  gmDict[e] = true
end)

function commands.addGold(charIndex, args)
  Char.AddGold(charIndex, tonumber(args[1]))
end

function commands.giveItem(charIndex, args)
  Char.GiveItem(charIndex, tonumber(args[1]), tonumber(args[2]), args[3] ~= '0')
end

function commands.delItem(charIndex, args)
  Char.DelItem(charIndex, tonumber(args[1]), tonumber(args[2]), args[3] ~= '0')
end

function commands.delItemBySlot(charIndex, args)
  Char.DelItemBySlot(charIndex, tonumber(args[1]), tonumber(args[2]));
end

function commands.warp(charIndex, args)
  Char.Warp(charIndex, tonumber(args[2]), tonumber(args[1]), tonumber(args[3]), tonumber(args[4]));
end

function commands.getPet(charIndex, args)
  Char.GivePet(charIndex, tonumber(args[1]))
end

function commands.upPet(charIndex, args)
  Char.SetData(Char.GetPet(charIndex, tonumber(args[1])), CONST.CHAR_等级, tonumber(args[2]));
  Pet.UpPet(charIndex, Char.GetPet(charIndex, tonumber(args[1])));
end

function commands.recipe(charIndex, args)
  if args[1] == 'del' then
    if Recipe.RemoveRecipe(charIndex, tonumber(args[2])) == 1 then
      NLG.SystemMessage(charIndex, '删除' .. args[2] .. '号配方')
    end
  elseif args[1] == 'add' then
    if Recipe.GiveRecipe(charIndex, tonumber(args[2])) == 1 then
      NLG.SystemMessage(charIndex, '获得' .. args[2] .. '号配方')
    end
  elseif args[1] == 'get' then
    for i = 0, 15 do
      local recipeId = tonumber(args[2]);
      if Recipe.GetData(recipeId, CONST.ITEM_RECIPE_ID) == 1 then
        NLG.SystemMessage(charIndex, i .. ' ' .. recipeId .. '号配方: ' .. Recipe.GetData(recipeId, i))
      end
    end
  end
end

function commands.joinParty(charIndex, args)
  if #args == 2 then
    Char.JoinParty(tonumber(args[1]), tonumber(args[2]))
  else
    Char.JoinParty(charIndex, tonumber(args[1]))
  end
end

function commands.setAction(charIndex, args)
  local charIndex1 = tonumber(args[1])
  local com1 = tonumber(args[2])
  local com2 = tonumber(args[3])
  local com3 = tonumber(args[4])
  Char.SetData(charIndex1, CONST.CHAR_BattleCom1, com1)
  Char.SetData(charIndex1, CONST.CHAR_BattleCom2, com2)
  Char.SetData(charIndex1, CONST.CHAR_BattleCom3, com3)
  if #args == 7 then
    Char.SetData(charIndex1, CONST.CHAR_Battle2Com1, tonumber(args[5]))
    Char.SetData(charIndex1, CONST.CHAR_Battle2Com2, tonumber(args[6]))
    Char.SetData(charIndex1, CONST.CHAR_Battle2Com3, tonumber(args[7]))
  end
  Char.SetData(charIndex1, CONST.CHAR_BattleMode, 3)
end

function commands.createDummy(charIndex, args)
  local charIndex1 = Char.CreateDummy()
  Char.SetData(charIndex1, CONST.CHAR_X, Char.GetData(charIndex, CONST.CHAR_X));
  Char.SetData(charIndex1, CONST.CHAR_Y, Char.GetData(charIndex, CONST.CHAR_Y));
  Char.SetData(charIndex1, CONST.CHAR_地图, Char.GetData(charIndex, CONST.CHAR_地图));
  Char.SetData(charIndex1, CONST.CHAR_名字, Char.GetData(charIndex, CONST.CHAR_名字) .. ' 复制');
  Char.SetData(charIndex1, CONST.CHAR_地图类型, Char.GetData(charIndex, CONST.CHAR_地图类型));
  Char.SetData(charIndex1, CONST.CHAR_形象, Char.GetData(charIndex, CONST.CHAR_形象));
  Char.SetData(charIndex1, CONST.CHAR_原形, Char.GetData(charIndex, CONST.CHAR_原形));
  Char.SetData(charIndex1, CONST.CHAR_原始图档, Char.GetData(charIndex, CONST.CHAR_原始图档));
  print('charIndex1', charIndex1)
  Char.SetData(charIndex1, CONST.CHAR_体力, 999999);
  NLG.UpChar(charIndex1);
  Char.SetData(charIndex1, CONST.CHAR_血, Char.GetData(charIndex1, CONST.CHAR_最大血));
  Char.SetData(charIndex1, CONST.CHAR_魔, Char.GetData(charIndex1, CONST.CHAR_最大魔));
  Char.GiveItem(charIndex1, 2100, 1, false);
  Char.MoveItem(charIndex1, 8, CONST.EQUIP_左手, -1);
  Char.SetData(charIndex1, CONST.CHAR_职业, 41);
  Char.SetData(charIndex1, CONST.CHAR_职类ID, 40);
  Char.SetData(charIndex1, CONST.CHAR_职阶, 1);
  Char.AddSkill(charIndex1, 95);
  Char.GivePet(charIndex1, 3004);
  Char.SetPetDepartureState(charIndex1, 0, CONST.PET_STATE_战斗);
  --Char.SetData(charIndex1, CONST.CHAR_战宠, 0);
  --local petIndex = Char.GetPet(charIndex1, 0);
  --Char.SetData(petIndex, CONST.PET_DepartureBattleStatus, CONST.PET_STATE_战斗);
  NLG.SystemMessage(charIndex, 'dummy: ' .. charIndex1)
  Char.JoinParty(charIndex1, charIndex);
end

function commands.setCharData(charIndex, args)
  local cix = tonumber(args[1])
  local dl = tonumber(args[2])
  local v = args[3]
  if dl >= 2000 then
  else
    v = tonumber(v)
  end
  NLG.SystemMessage(charIndex, 'Char.SetData: ' .. Char.SetData(cix, dl, v));
end

function commands.getCharData(charIndex, args)
  local cix = tonumber(args[1])
  local dl = tonumber(args[2])

  local function ifNil(a, b)
    if a == nil then
      return b
    end
    return a;
  end
  NLG.SystemMessage(charIndex, 'Char.GetData: ' .. args[1] .. '-' .. args[2] .. '=' .. ifNil(Char.GetData(cix, dl), 'nil'));
end

function commands.autoBattle(charIndex, args)
  if args[1] == 'on' then
    Protocol.Send(charIndex, "SkipBtCmd");
    Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_ATTACK, 11, -1);
    Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_ATTACK, 11, -1);
  end
end

function commands.delDummy(charIndex, args)
  Char.DelDummy(tonumber(args[1]))
end

function commands.moveChar(charIndex, args)
  Char.MoveArray(tonumber(args[1]), table.slice(args, 2))
end

function commands.calcFp(charIndex, args)
  NLG.SystemMessage(charIndex, string.format("%d => fp: %d %d", tonumber(args[1]), Char.CalcConsumeFp(charIndex, tonumber(args[1])), 999));
end

function commands.dofile2(charIndex, args)
  local r, fn = pcall(dofile, args[1]);
  logDebug('', r, fn);
  if r then
    pcall(fn, charIndex, table.slice(args, 2));
  end
end
--
--function commands.rift(charIndex, args)
--  local rift = getModule('rift')
--  rift:loadConfig()
--end

--function commands.testNextBattle(charIndex)
--  local battleIndex = Battle.PVE(charIndex, charIndex, nil, { 1 }, { 1 });
--  Battle.SetNextBattle(battleIndex, -2, 0xeeff);
--end

function AdminCommands:regCommand(key, fn)
  commands[key] = fn;
end

function AdminCommands:unloadCommand(key)
  commands[key] = nil;
end

function AdminCommands:onLoad()
  self:logInfo('load')
  local fnName, ix = self:regCallback(self.name .. '_WalkPostEvent', function(charIndex)
    self:logDebug('WalkPostEvent', charIndex)
    self:logDebug(Char.GetData(charIndex, CONST.CHAR_名字));
  end)

  local function handleChat(charIndex, msg, color, range, size)
    if not getModule('admin'):isAdmin(charIndex) then
      return 1
    end
    local command = msg:match('^/([%w]+)')
    if commands[command] then
      local arg = msg:match('^/[%w]+ +(.+)$')
      arg = arg and string.split(arg, ' ') or {}
      commands[command](charIndex, arg);
      return 0
    end
    if command == 'walkTest' then
      Char.SetWalkPostEvent(nil, fnName, charIndex)
    end
    if command == 'walkTestOff' then
      Char.UnsetWalkPostEvent(charIndex)
    end
    return 1
  end
  self:regCallback('TalkEvent', handleChat)
end

function AdminCommands:onUnload()
  self:logInfo('unload')
end

return AdminCommands;
