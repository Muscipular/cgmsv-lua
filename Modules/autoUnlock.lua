---模块类
---@class AutoUnlockModule : ModuleType
local AutoUnlockModule = ModuleBase:createModule('autoUnlock')

function AutoUnlockModule:onLogin(fd, head, data)
  local user = SQL.querySQL('select RegistNumber from tbl_lock where CdKey = ' .. SQL.sqlValue(data[3]), true);
  if user then
    local charIndex = NLG.FindUser(data[3], tonumber(user[1][1]));
    if charIndex >= 0 then
      return 0;
    end
    self:logInfo('解锁', data[3])
    SQL.querySQL('delete from tbl_lock where CdKey = ' .. SQL.sqlValue(data[3]));
    SQL.querySQL('delete from tbl_lock2 where CdKey = ' .. SQL.sqlValue(data[3]));
  end
end

function AutoUnlockModule:onTalked(charIndex, msg, color, range, size)
  local command = msg:match('^/([%w]+)')
  if command and string.lower(command) == 'selfkickout' then
    local arg = msg:match('^/[%w]+ +(.+)$')
    arg = arg and string.split(arg, ' ') or {}
    if #arg >= 2 then
      local ret = SQL.querySQL("select 1 from tbl_user where CdKey = " .. SQL.sqlValue(arg[1]) .. ' and AccountPassWord = ' .. SQL.sqlValue(arg[2]), true)
      if ret ~= nil then
        local targetChar = NLG.FindUser(arg[1]);
        if targetChar >= 0 then
          self:logInfoF("%s(%s) 踢出 %s(%s)",
            Char.GetData(charIndex, CONST.CHAR_名字),
            Char.GetData(charIndex, CONST.CHAR_CDK),
            Char.GetData(targetChar, CONST.CHAR_名字),
            Char.GetData(targetChar, CONST.CHAR_CDK)
          )
          NLG.DropPlayer(targetChar);
          NLG.SystemMessage(charIndex, string.format('操作成功'));
        else
          NLG.SystemMessage(charIndex, string.format('该账户不在线'));
        end
      else
        --todo 安全防护
        NLG.SystemMessage(charIndex, string.format('账号或密码不正确'));
      end
    else
      NLG.SystemMessage(charIndex, string.format('指令错误: /selfKickOut 账号 密码'));
    end
    return 0
  end
  return 1
end

--- 加载模块钩子
function AutoUnlockModule:onLoad()
  self:logInfo('load')
  self:regCallback('ProtocolOnRecv', Func.bind(self.onLogin, self), 'JFVf');
  self:regCallback('TalkEvent', Func.bind(self.onTalked, self));
end

--- 卸载模块钩子
function AutoUnlockModule:onUnload()
  self:logInfo('unload')
end

return AutoUnlockModule;
