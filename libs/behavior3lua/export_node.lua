package.path = package.path .. ';lualib/?.lua'

-- 导出节点设置
CONST = {}
Battle = {}
Char = {}
Data = {}
Ext = {}
Field = {}
Http = {}
Iconv = {}
Item = {}
Map = {}
NL = {}
NLG = {}
Obj = {}
Pet = {}
Protocol = {}
Recipe = {}
Setup = {}
Skill = {}
SQL = {}
Stall = {}
Tech = {}
TechArea = {}

require "lua.docs.CONST"
require "lua.docs.Battle"
require "lua.docs.Char"
require "lua.docs.Data"
require "lua.docs.Ext"
require "lua.docs.Field"
require "lua.docs.Http"
require "lua.docs.Iconv"
require "lua.docs.Item"
require "lua.docs.Map"
require "lua.docs.NL"
require "lua.docs.NLG"
require "lua.docs.Obj"
require "lua.docs.Pet"
require "lua.docs.Protocol"
require "lua.docs.Recipe"
require "lua.docs.Setup"
require "lua.docs.Skill"
require "lua.docs.SQL"
require "lua.docs.Stall"
require "lua.docs.Tech"
require "lua.docs.TechArea"

local olua = require "lua.libs.behavior3lua.olua"
-- local process = require "lua.libs.behavior3lua.example.process"
local process = require "lua.Modules.BehaviorTree.process"

local nodes = {}
for k, v in pairs(process) do
    if v.args then
        for i, vv in pairs(v.args) do
            if #vv > 0 then
                v.args[i] = vv
            end
        end
    end

    local doc = v.doc
    if type(doc) == "string" then
        doc = string.gsub(doc, "^([ ]+", "")
        doc = string.gsub(doc, "\n([ ]+", "\n")
    end

    local node = {
        name     = v.name,
        type     = v.type,
        desc     = v.desc,
        args     = v.args,
        input    = v.input,
        output   = v.output,
        children = v.children,
        status   = v.status,
        doc      = doc,
    }
    table.insert(nodes, node)
end

table.sort(nodes, function(a, b)
    return a.name < b.name
end)

local str = olua.json_stringify(nodes, { indent = 2 })
print(str)

local path = "lua/libs/behavior3lua/workspace/node-config.b3-setting"
local file = io.open(path, "w")
if file then
    local success, err = pcall(function()
        file:write(str)
    end)
    if not success then
        print("Error writing to file:", err)
    end
    file:close()
else
    print("Error: Unable to open file for writing")
end

print("save to", path)
