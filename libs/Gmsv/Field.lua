-- fixed deleted chara
regGlobalEvent('CharaDeletedEvent', function(cdKey, regNum)
  print('Field delete', cdKey, regNum)
  local sql = 'delete from tbl_globalregvalue where account_id = ' .. SQL.sqlValue(cdKey)
    .. ' and reg_num = ' .. SQL.sqlValue(regNum)
    .. ' and type in (0, 1)';
  SQL.querySQL(sql);
end, 'Field')


