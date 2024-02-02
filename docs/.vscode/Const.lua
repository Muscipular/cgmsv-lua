---@class diff
---@field start  integer # The number of bytes at the beginning of the replacement
---@field finish integer # The number of bytes at the end of the replacement
---@field text   string  # What to replace

---@param  uri  string # The uri of file
---@param  text string # The content of file
---@return nil|diff[]
function OnSetText(uri, text)
    local diffs = {}
-- print(text);
    for start, a, finish in text:gmatch("()(%%[^%% %s%.]*_[^%% %s%.]*%%)()") do
        print(start, a, finish);
        diffs[#diffs+1] = {
            start  = start,
            finish = finish - 1,
            text   = "0",
        }
    end
    for start, a, finish in text:gmatch("()(%%[A-Za-z0-9_]+%%)()") do
        print(start, a, finish);
        diffs[#diffs+1] = {
            start  = start,
            finish = finish - 1,
            text   = "0",
        }
    end

    if #diffs == 0 then
        return nil
    end

    return diffs
end