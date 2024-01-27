-- 3rd libs
_G.LRU = dofile('lua/libs/three_parts/lru.lua');
_G.JSON = dofile('lua/libs/three_parts/json.lua');
--_G.MT19937 = dofile('lua/libs/three_parts/mt19937ar.lua');
_G.MT19937 = _G.MT or dofile('lua/libs/three_parts/mt19937ar.lua');
-- Base Extensions
if _HookFunc then
dofile('lua/libs/ffi.lua')    
end
dofile('lua/libs/logger.lua')
dofile('lua/libs/table.lua')
dofile('lua/libs/file.lua')
dofile('lua/libs/number.lua')
dofile('lua/libs/string.lua')
dofile('lua/libs/functions.lua')
dofile('lua/libs/sql.lua')
dofile('lua/libs/GlobalEvents.lua')
--dofile('lua/libs/Item.lua')
