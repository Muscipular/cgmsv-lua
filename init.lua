_HookFunc = false;
_GMVS_ = nil;
if NL.Version == nil or NL.Version() < 20230511 then
  print(string.format('[WARN] CGMSV not match'));
else
  _GMVS_ = NL.Version();
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
