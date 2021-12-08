_G.fs = {};

function fs.parseFile(filePath)
  local list = {}
  local file = io.open(filePath)
  for line in file:lines() do
    if line then
      if string.match(line, '^(%s*(#|$))') then
        goto continue;
      end
      local dataLines = string.split(line, '\t');
      if dataLines and #dataLines > 0 then
        table.insert(list, dataLines)
      end
    end
    :: continue ::
  end
  file:close();
  return list;
end
