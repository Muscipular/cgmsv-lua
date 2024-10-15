_G.loggerLevel = 3;

function _G.log(module, level, msg, ...)
  if _G.loggerLevel >= 1 then
    print("[" .. level .. "][" .. module .. "]", msg, ...)
  end
end

function _G.logInfo(module, msg, ...)
  if _G.loggerLevel >= 3 then
    print("[INFO][" .. module .. "]", msg, ...)
  end
end

function _G.logError(module, msg, ...)
  if _G.loggerLevel >= 1 then
    print("[ERROR][" .. module .. "]", msg, ...)
  end
end

function _G.logWarn(module, msg, ...)
  if _G.loggerLevel >= 2 then
    print("[WARN][" .. module .. "]", msg, ...)
  end
end

function _G.logDebug(module, msg, ...)
  if _G.loggerLevel >= 4 then
    print("[DEBUG][" .. module .. "]", msg, ...)
  end
end
