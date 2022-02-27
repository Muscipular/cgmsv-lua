---模块类
local BankFix = ModuleBase:createModule('bankFix')
--- 加载模块钩子
function BankFix:onLoad()
  self:logInfo('load')
  ---@type AdminCommands
  local adminCommands = getModule("adminCommands");
  adminCommands:regCommand('bankFix', function()
    local res = SQL.QueryEx("select * from lua_chardata");
    if res.rows then
      for i, row in ipairs(res.rows) do
        pcall(function()
          local data = JSON.decode(row.data);
          local regId = row.id;
          local cdkey = row.cdkey;
          if data.bankExpand then
            for i = 1, 9 do
              for j = 0, 0 do
                local key = string.format("slot-%d-%d", i, j);
                if type(data.bankExpand[key]) == 'table' then
                  local res = SQL.QueryEx('select * from hook_charaext where cdkey = ? and regNo = ? and sKey = ?',
                    cdkey, regId, string.format("bank-%d-%d", i, j))
                  if res.rows and #res.rows < 1 then
                    SQL.QueryEx("insert into hook_charaext (cdKey, regNo, sKey, val, valType) values (?,?,?,?,?)",
                      cdkey, regId, string.format("bank-%d-%d", i, j), JSON.encode(data.bankExpand[key]), 0);
                  end
                end
              end
            end
            SQL.QueryEx("insert into hook_charaext (cdKey, regNo, sKey, val, valType) values (?,?,?,?,?)",
              cdkey, regId, "bank-index", data.bankExpand.index, 1);
          end
        end)
      end
    end
  end);
end

--- 卸载模块钩子
function BankFix:onUnload()
  self:logInfo('unload')
end

return BankFix;
