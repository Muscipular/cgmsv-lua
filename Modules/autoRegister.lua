---模块类
local AutoRegister = ModuleBase:createModule('autoRegister')

--- 加载模块钩子
function AutoRegister:onLoad()
  self:logInfo('load');
  local fn = self:regCallback(Func.bind(self.OnRecv, self));
  Protocol.OnRecv(nil, fn, 'JFVf')
end

function AutoRegister:OnRecv(fd, head, data)
  --self:logDebug('OnRecv', head);
  --for i = 1, #data do
  --  self:logDebug('data:', i, data[i]);
  --end
  local user = SQL.querySQL('select * from tbl_user where CdKey = ' .. SQL.sqlValue(data[3]));
  --print(user, 'select * from tbl_user where CdKey = ' .. SQL.sqlValue(data[3]));
  if user == SQL.CONST_RET_NO_ROW then
    local seq = SQL.querySQL('select max(SequenceNumber) + 1 from tbl_user');
    local sql = 'insert into tbl_user (CdKey, SequenceNumber, AccountID, AccountPassWord, '
      .. ' EnableFlg, UseFlg, BadMsg, TrialFlg, DownFlg, ExpFlg) values ('
      .. SQL.sqlValue(data[3]) .. ', ' .. SQL.sqlValue(seq[1][1]) .. ', '
      .. SQL.sqlValue(data[3]) .. ', '
      .. SQL.sqlValue(data[2]) .. ',1,1,0,0,0,0);'
    local r = SQL.querySQL(sql)
    --print(r, sql);
  end
  return 0
end

--- 卸载模块钩子
function AutoRegister:onUnload()
  self:logInfo('unload')
end

return AutoRegister;
