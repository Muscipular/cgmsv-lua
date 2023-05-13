_HookVer = '0.2.31'
_HookFunc = false;
if NL.Version == nil or NL.Version() < 20230511 then
  if getHookVer == nil then
    error(string.format('[ERR]HOOK not load %s', _HookVer))
  end
  if getHookVer() ~= _HookVer then
    error(string.format('[ERR]HOOK not match require %s, but found %s', _HookVer, getHookVer()));
  end
  print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>")
  print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>")
  print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>")
  print(string.format("[LUA]HOOK loaded %s, start load lua ........", _HookVer))
  print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>")
  print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>")
  print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>")
  _HookFunc = true;
end
print("[LUA]Initial Lua System......")
collectgarbage()
collectgarbage('stop')
math.randomseed(os.time())
dofile('lua/Const.lua')
dofile('lua/Util.lua')
dofile('lua/libs/GmsvExtension.lua')
dofile('lua/libs/ModuleSystem.lua')
collectgarbage('restart')
collectgarbage()
print("[LUA]Initial Lua System done.")
dofile('lua/ModuleConfig.lua')
pcall(dofile, 'lua/Modules/Private/Config.lua')
if _HookFunc then
  NL.EmitInit()
end
