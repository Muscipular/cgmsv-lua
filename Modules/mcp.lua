---@class McpModule : ModuleType
local Module = ModuleBase:createModule('mcp')

---@alias ParamType {string:string}

local DEFAULT_CONFIG = {
  token = 'change-me',
  bind = '0.0.0.0',
  port = 10086,
}

local JSONRPC_VERSION = '2.0'

local function copyTable(t)
  local ret = {}
  for k, v in pairs(t) do
    ret[k] = v
  end
  return ret
end

local function getConfig()
  local config = copyTable(DEFAULT_CONFIG)
  local userConfig = rawget(_G, 'MCP_CONFIG')
  if type(userConfig) == 'table' then
    for k, v in pairs(userConfig) do
      if v ~= nil then
        config[k] = v
      end
    end
  end
  return config
end

local function makeResponse(id, result, err)
  local payload = {
    jsonrpc = JSONRPC_VERSION,
    id = id,
  }
  if err ~= nil then
    payload.error = err
  else
    payload.result = result
  end
  return JSON.encode(payload)
end

function Module:success(id, result)
  return makeResponse(id, result, nil)
end

function Module:fail(id, code, message, data)
  return makeResponse(id, nil, {
    code = code,
    message = message,
    data = data,
  })
end

function Module:unauthorized(id)
  return self:fail(id, -32001, 'unauthorized', {
    ok = false,
    code = 'UNAUTHORIZED',
    message = 'invalid token',
  })
end

function Module:validateToken(request)
  return request ~= nil and request.token == self._config.token
end

function Module:ensureHttpReady()
  local status = Http.GetStatus()
  if status == 0 then
    Http.Init()
    Http.AddMountPoint('/', './lua/www/')
    status = Http.GetStatus()
  end
  if status == 1 then
    Http.Start(self._config.bind, self._config.port)
  end
end

function Module:buildToolList()
  return {
    {
      name = 'kick_player',
      description = '按账号CdKey踢出在线玩家',
      inputSchema = {
        type = 'object',
        properties = {
          cdkey = {
            type = 'string',
            description = '玩家账号CdKey',
          },
          reason = {
            type = 'string',
            description = '踢出原因，可选',
          },
        },
        required = { 'cdkey' },
      },
    },
  }
end

function Module:handleInitialize(id)
  return self:success(id, {
    protocolVersion = JSONRPC_VERSION,
    serverInfo = {
      name = 'cgmsv-mcp',
      version = '1.0.0',
    },
    capabilities = {
      tools = {
        listChanged = false,
      },
    },
  })
end

function Module:handleToolsList(id)
  return self:success(id, {
    tools = self:buildToolList(),
  })
end

function Module:handleKickPlayer(id, args)
  if type(args) ~= 'table' then
    return self:fail(id, -32602, 'invalid arguments', {
      ok = false,
      code = 'INVALID_ARGUMENT',
      message = 'arguments must be an object',
    })
  end

  local cdkey = args.cdkey
  if type(cdkey) ~= 'string' or cdkey == '' then
    return self:fail(id, -32602, 'invalid arguments', {
      ok = false,
      code = 'INVALID_ARGUMENT',
      message = 'cdkey is required',
    })
  end

  local charIndex = NLG.FindUser(cdkey)
  if charIndex == nil or charIndex < 0 then
    return self:success(id, {
      ok = false,
      code = 'PLAYER_OFFLINE',
      message = 'player is offline',
      cdkey = cdkey,
    })
  end

  local ret = NLG.DropPlayer(charIndex)
  if ret ~= 1 then
    return self:success(id, {
      ok = false,
      code = 'DROP_FAILED',
      message = 'drop player failed',
      cdkey = cdkey,
    })
  end

  return self:success(id, {
    ok = true,
    code = 'OK',
    message = 'player dropped',
    cdkey = cdkey,
    reason = args.reason,
  })
end

function Module:handleToolsCall(id, params)
  if type(params) ~= 'table' then
    return self:fail(id, -32602, 'invalid params', {
      ok = false,
      code = 'INVALID_ARGUMENT',
      message = 'params must be an object',
    })
  end

  if params.name ~= 'kick_player' then
    return self:success(id, {
      ok = false,
      code = 'TOOL_NOT_FOUND',
      message = 'tool not found',
      name = params.name,
    })
  end

  return self:handleKickPlayer(id, params.arguments)
end

function Module:dispatchRequest(request)
  local id = request and request.id or nil
  local method = request and request.method or nil

  if method == 'ping' then
    return self:success(id, {
      ok = true,
      code = 'OK',
      message = 'pong',
    })
  end

  if not self:validateToken(request) then
    return self:unauthorized(id)
  end

  if method == 'initialize' then
    return self:handleInitialize(id)
  end

  if method == 'tools/list' then
    return self:handleToolsList(id)
  end

  if method == 'tools/call' then
    return self:handleToolsCall(id, request.params)
  end

  return self:fail(id, -32601, 'method not found', {
    ok = false,
    code = 'METHOD_NOT_FOUND',
    message = 'unsupported method',
    method = method,
  })
end

---@param method string
---@param api string
---@param params ParamType
---@param body string
---@return string
function Module:onHttpRequest(method, api, params, body)
  if string.lower(method or '') ~= 'post' or api ~= 'mcp' then
    return ''
  end

  local ok, request = pcall(JSON.decode, body or '')
  if ok ~= true or type(request) ~= 'table' then
    return self:fail(nil, -32700, 'parse error', {
      ok = false,
      code = 'PARSE_ERROR',
      message = 'invalid json body',
    })
  end

  if request.jsonrpc ~= JSONRPC_VERSION then
    return self:fail(request.id, -32600, 'invalid request', {
      ok = false,
      code = 'INVALID_REQUEST',
      message = 'jsonrpc must be 2.0',
    })
  end

  local ret, result = pcall(self.dispatchRequest, self, request)
  if ret ~= true then
    self:logError('mcp request failed', result)
    return self:fail(request.id, -32603, 'internal error', {
      ok = false,
      code = 'INTERNAL_ERROR',
      message = tostring(result),
    })
  end

  return result
end

function Module:onLoad()
  self._config = getConfig()
  self:ensureHttpReady()
  self:regCallback('HttpRequestEvent', Func.bind(self.onHttpRequest, self))
  Http.RegApi('mcp')
  self:logInfo('load')
end

function Module:onUnload()
  Http.UnregApi('mcp')
  self:logInfo('unload')
end

return Module
