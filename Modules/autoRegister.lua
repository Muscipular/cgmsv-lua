---模块类
---@class AutoRegister: ModuleType
local AutoRegister = ModuleBase:createModule('autoRegister')

--- 加载模块钩子
function AutoRegister:onLoad()
  self:logInfo('load');
  self:regCallback('ProtocolOnRecv', Func.bind(self.OnRecv, self), 'JFVf');
end

function AutoRegister:OnRecv(fd, head, data)
  local user = SQL.QueryEx('select 1 from tbl_user where CdKey = ?', data[3]);
  if !user.rows || #user.rows <= 0 then
    local seq = SQL.QueryEx('select max(SequenceNumber) + 1 as Seq from tbl_user');
    if !seq.rows || #seq.rows <= 0 then
      seq = 0;
    else
      seq = seq.rows[1].Seq or 0;
    end
    local sql = 'insert into tbl_user (CdKey, SequenceNumber, AccountID, AccountPassWord, '
        .. ' EnableFlg, UseFlg, BadMsg, TrialFlg, DownFlg, ExpFlg) values (?, ?, ?, ?,1,1,0,8,0,0);'
    local r = SQL.QueryEx(sql, data[3], seq, data[3], data[2])
    --print(r, sql);
  end
  return 0
end

--- 卸载模块钩子
function AutoRegister:onUnload()
  self:logInfo('unload')
end

return AutoRegister;
