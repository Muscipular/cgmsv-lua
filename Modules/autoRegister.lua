---模块类
---@class AutoRegister: ModuleType
local AutoRegister = ModuleBase:createModule('autoRegister')

--- 加载模块钩子
function AutoRegister:onLoad()
  self:logInfo('load');
  self:regCallback('ProtocolOnRecv', Func.bind(self.OnRecv, self), 'JFVf');
end

function AutoRegister:OnRecv(fd, head, data)
  local user = SQL.querySQL('select * from tbl_user where CdKey = ' .. SQL.sqlValue(data[3]));
  if user == SQL.CONST_RET_NO_ROW then
    local seq = SQL.querySQL('select max(SequenceNumber) + 1 from tbl_user');
    if seq == SQL.CONST_RET_NO_ROW then
      seq = { { 0 } };
    end
    local sql = 'insert into tbl_user (CdKey, SequenceNumber, AccountID, AccountPassWord, '
        .. ' EnableFlg, UseFlg, BadMsg, TrialFlg, DownFlg, ExpFlg) values ('
        .. SQL.sqlValue(data[3]) .. ', ' .. SQL.sqlValue(seq[1][1] or 0) .. ', '
        .. SQL.sqlValue(data[3]) .. ', '
        .. SQL.sqlValue(data[2]) .. ',1,1,0,8,0,0);'
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
