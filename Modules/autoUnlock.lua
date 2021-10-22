---模块类
local Module = ModuleBase:createModule('autoUnlock')

function Module:onLogin(fd, head, data)
  local user = SQL.querySQL('select RegistNumber from tbl_lock where CdKey = ' .. SQL.sqlValue(data[3]), true);
  if user then
    local charIndex = NLG.FindUser(data[3], tonumber(user[1][1]));
    if charIndex >= 0 then
      return 0;
    end
    self:logInfo('解锁', data[3])
    SQL.querySQL('delete from tbl_lock where CdKey = ' .. SQL.sqlValue(data[3]));
  end
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ProtocolOnRecv', Func.bind(self.onLogin, self), 'JFVf');
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
