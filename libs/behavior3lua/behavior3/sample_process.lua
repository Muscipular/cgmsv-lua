return {
  -- 复合节点
  IfElse             = require "lua.libs.behavior3lua.behavior3.nodes.composites.ifelse",
  Parallel           = require "lua.libs.behavior3lua.behavior3.nodes.composites.parallel",
  Selector           = require "lua.libs.behavior3lua.behavior3.nodes.composites.selector",
  Sequence           = require "lua.libs.behavior3lua.behavior3.nodes.composites.sequence",

  -- 装饰节点
  Once               = require "lua.libs.behavior3lua.behavior3.nodes.decorators.once",
  Invert             = require "lua.libs.behavior3lua.behavior3.nodes.decorators.invert",
  AlwaysFail         = require "lua.libs.behavior3lua.behavior3.nodes.decorators.always_fail",
  AlwaysSuccess      = require "lua.libs.behavior3lua.behavior3.nodes.decorators.always_success",
  RepeatUntilSuccess = require "lua.libs.behavior3lua.behavior3.nodes.decorators.repeat_until_success",
  RepeatUntilFailure = require "lua.libs.behavior3lua.behavior3.nodes.decorators.repeat_until_fail",
  Repeat             = require "lua.libs.behavior3lua.behavior3.nodes.decorators.repeat",

  -- 条件节点
  Check              = require "lua.libs.behavior3lua.behavior3.nodes.conditions.check",
  Cmp                = require "lua.libs.behavior3lua.behavior3.nodes.conditions.cmp",
  Includes           = require "lua.libs.behavior3lua.behavior3.nodes.conditions.includes",
  IsNull             = require "lua.libs.behavior3lua.behavior3.nodes.conditions.is_null",
  NotNull            = require "lua.libs.behavior3lua.behavior3.nodes.conditions.not_null",

  -- 行为节点
  Calculate          = require "lua.libs.behavior3lua.behavior3.nodes.actions.calculate",
  Clear              = require "lua.libs.behavior3lua.behavior3.nodes.actions.clear",
  Filter             = require "lua.libs.behavior3lua.behavior3.nodes.actions.filter",
  ForEach            = require "lua.libs.behavior3lua.behavior3.nodes.actions.foreach",
  Index              = require "lua.libs.behavior3lua.behavior3.nodes.actions.index",
  Let                = require "lua.libs.behavior3lua.behavior3.nodes.actions.let",
  Log                = require "lua.libs.behavior3lua.behavior3.nodes.actions.log",
  Now                = require "lua.libs.behavior3lua.behavior3.nodes.actions.now",
  Push               = require "lua.libs.behavior3lua.behavior3.nodes.actions.push",
  Random             = require "lua.libs.behavior3lua.behavior3.nodes.actions.random",
  RandomIndex        = require "lua.libs.behavior3lua.behavior3.nodes.actions.random_index",
  Wait               = require "lua.libs.behavior3lua.behavior3.nodes.actions.wait",
  Concat             = require "lua.libs.behavior3lua.behavior3.nodes.actions.concat",
  WaitForCount       = require "lua.libs.behavior3lua.behavior3.nodes.actions.wait_for_count",
}
