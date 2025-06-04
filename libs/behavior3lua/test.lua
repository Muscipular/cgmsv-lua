
local behavior_tree = require "lua.libs.behavior3lua.behavior3.behavior_tree"
local behavior_node = require "lua.libs.behavior3lua.behavior3.behavior_node"

local process = require "lua.libs.behavior3lua.example.process"
process.Listen = {
    run = function()
        print("Listen not defined")
        return "success"
    end
}

behavior_node.process(process)

local json = require "lua.libs.behavior3lua.json"

local function load_tree(path)
    local file, err = io.open(path, 'r')
    assert(file, err)
    local str = file:read('*a')
    file:close()
    return json.decode(str)
end

local monster = {
    hp = 100,
    x = 200,
    y = 0,
}

local hero = {
    hp = 100,
    x = 0,
    y = 0,
}

local ctx = {
    time = 0,
    avatars = {monster, hero},
}
function ctx:find(func)
    local list = {}
    for _, v in pairs(ctx.avatars) do
        if func(v) then
            list[#list+1] = v
        end
    end
    return list
end

local function test_hero()
    print("=================== test hero ========================")
    local btree = behavior_tree.new("hero", load_tree("workspace/trees/hero.json"), {
        ctx   = ctx,
        owner = hero,
    })

    -- �ƶ���Ŀ�겢����
    btree:run()
    btree:run()
    btree:run()
    btree:run()
    btree:run()
    btree:run()

    -- ��ҡ
    btree:run()
    btree:interrupt()
    btree:run()
    ctx.time = 20
    btree:run()
end

test_hero()


local function test_moster()
    print("=================== test monster ========================")
    local btree = behavior_tree.new("monster", load_tree("workspace/trees/monster.json"), {
        ctx   = ctx,
        owner = monster,
    })

    monster.hp = 100
    btree:run()

    monster.hp = 20
    btree:run()
    ctx.time = 40
    btree:run()
    btree:run()
end

test_moster()

local function test_repeat_until_success()
    print("=================== test repeat until success ========================")
    local btree = behavior_tree.new("repeat-until-success", load_tree("workspace/trees/test-repeat-until-success.json"), {
        ctx   = ctx,
    })
    for i = 1, 7 do
        ctx.time = ctx.time + 1
        btree:run()
    end
end

test_repeat_until_success()

local function test_repeat_until_fail()
    print("=================== test repeat until fail ========================")
    local btree = behavior_tree.new("repeat-until-fail", load_tree("workspace/trees/test-repeat-until-failure.json"), {
        ctx   = ctx,
    })
    for i = 1, 7 do
        ctx.time = ctx.time + 1
        btree:run()
    end
end

test_repeat_until_fail()


local function test_repeat_until_fail()
    print("=================== test parallel ========================")
    local btree = behavior_tree.new("parallel", load_tree("workspace/trees/test-parallel.json"), {
        ctx   = ctx,
    })
    for i = 1, 6 do
        ctx.time = ctx.time + 1
        btree:run()
    end
end

test_repeat_until_fail()

local function test_parallel_with_wait()
    print("=================== test parallel with wait ========================")
    local btree = behavior_tree.new("parallel-with-wait", load_tree("workspace/trees/test-parallel-with-wait.json"), {
    })
    for i = 1, 8 do
        btree:run()
    end
end

test_parallel_with_wait()