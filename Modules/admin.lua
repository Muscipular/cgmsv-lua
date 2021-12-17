local Admin = ModuleBase:createModule('admin')
-- gm√¸¡Ó
local commands = {}
--GM’À∫≈¡–±Ì
local gmList = { 'u01', 'u02', 'u03', 'u04', 'u05' };
local gmDict = {};
table.forEach(gmList, function(e)
  gmDict[e] = true
end)

function commands.module(charIndex, args)
  if args[1] == 'reload' then
    reloadModule(args[2]);
  elseif args[1] == 'unload' then
    unloadModule(args[2]);
  elseif args[1] == 'load' then
    loadModule(args[2]);
  end
end

function commands.dofile(charIndex, args)
  local r, msg = pcall(dofile, args[1]);
  if not r then
    NLG.TalkToCli(charIndex, -1, tostring(msg));
  end
end

function Admin:handleChat(charIndex, msg, color, range, size)
  local cdKey = Char.GetData(charIndex, CONST.CHAR_CDK)
  local command = msg:match('^/([%w]+)')
  if not gmDict[cdKey] then
    return 1
  end
  if commands[command] then
    local arg = msg:match('^/[%w]+ +(.+)$')
    arg = arg and string.split(arg, ' ') or {}
    commands[command](charIndex, arg);
    return 0
  end
  return 1
end

function Admin:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(Admin.handleChat, self))
end

function Admin:onUnload()
  self:logInfo('unload')
end

return Admin;
