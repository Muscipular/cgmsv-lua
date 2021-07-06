function _G.log(module, level, msg, ...)
  print("[" .. level .. "][" .. module .. "]", msg, ...)
end
function _G.logInfo(module, msg, ...)
  print("[INFO][" .. module .. "]", msg, ...)
end
function _G.logError(module, msg, ...)
  print("[ERROR][" .. module .. "]", msg, ...)
end
function _G.logWarn(module, msg, ...)
  print("[WARN][" .. module .. "]", msg, ...)
end
function _G.logDebug(module, msg, ...)
  print("[DEBUG][" .. module .. "]", msg, ...)
end

