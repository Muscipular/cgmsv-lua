---@class AssetsPart: ModulePart
local AssetsPart = ModuleBase:createPart('AssetsPart');

function AssetsPart:readConfigFile()
  local path = string.gsub(self.___aPath, "(.*[\\\\/])[^\\\\/].+$", '%1' .. self.name .. '.config.lua')
  local fn, msg = loadfile(path, 'bt', { CONST = CONST });
  if msg then
    self:logError('loadConfig failed: ', msg);
    return nil;
  end
  local ok, res = pcall(fn);
  if not ok then
    self:logError('loadConfig failed: ', res);
    return nil;
  end
  return res;
end

function AssetsPart:parseFile(name, mode)
  local path = string.gsub(self.___aPath, "(.*[\\\\/])[^\\\\/].+$", '%1' .. name)
  local ok, data = pcall(fs.parseFile, path, mode or 'r');
  if not ok then
    self:logError('parseFile failed: ', data);
    return nil;
  end
  return data;
end

return AssetsPart;
