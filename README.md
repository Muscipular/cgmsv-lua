# cgmsv lua

## 模块系统

支持动态加载、卸载以及版本升级的数据迁移。其中通过Module注册的回调卸载时自动清理

### ModuleBase类

#### 属性

1. `name` 当前模块名字, string类型
2. `migrations` 升级迁移列表， 数组类型， 每项元素需要有`version`，`name`，`value` 三个属性
    - `version` 版本号 number类型
    - `name` 名称 string类型
    - `value` sql或者具体方法 string或function类型

#### 方法

1. `ModuleBase:regCallback(eventNameOrCallbackKeyOrFn, fn)`  注册回调
    - 参数 `eventNameOrCallbackKeyOrFn`
      - 可以传入NL.Reg*对应的事件名称，如NL.RegLoginEvent 传入 `LoginEvent`
      - 自定义的名称用于非全局回调（如NPC创建回调）
      - 匿名回调（如NPC创建回调）

    - 参数 `fn`
      - 回调函数，如果eventNameOrCallbackKeyOrFn是匿名回调，fn可以传nil

    - 返回值 `eventNameOrCallbackKeyOrFn`, `lastIx`, `fnIndex`
      - `eventNameOrCallbackKeyOrFn` 函数的全局Key，用于传入NL.Reg*
      - `lastIx` 当前模块下的注册序列
      - `fnIndex` 全局注册序列

2. `ModuleBase:unRegCallback(eventNameOrCallbackKey, fnOrFnIndex)`  反注册回调
    - 参数 `eventNameOrCallbackKey`
      - 可以传入NL.Reg*对应的事件名称，如NL.RegLoginEvent 传入 `LoginEvent`
      - 自定义的名称用于非全局回调（如NPC创建回调）

    - 参数 `fnOrFnIndex`
      - 可入传入注册用的回调函数
      - 也可以fnIndex 全局注册序列
3. `ModuleBase:onLoad()`  模块注册钩子，由具体实现模块实现
4. `ModuleBase:onUnload()`  模块卸载钩子，由具体实现模块实现
5. `ModuleBase:logInfo(msg, ...)`  打印日志
6. `ModuleBase:logDebug(msg, ...)`  打印日志
7. `ModuleBase:logWarn(msg, ...)`  打印日志
8. `ModuleBase:logError(msg, ...)`  打印日志
9. `ModuleBase:log(level, msg, ...)`  打印日志
10. `ModuleBase:addMigration(version, name, sqlOrFunction)` 创建一个新迁移

## 模块加载
具体模块加载在ModuleConfig.lua

```
loadModule('admin') --加载admin模块
```
### 目前能用的模块
1. admin 内挂相关、模块动态管理等
2. shop 东门商店NPC配置
3. warp 村落传送
4. warp2 练级点传送
5. welcome 示例模块
6. itemPowerUp.lua 装备强化
   
### 开发中的模块
- AI扩展

## GMSV 扩展模块
1. BattleEx.lua 战斗相关扩展
2. Char.lua  人物相关扩展
3. DamageHook.lua 伤害修改补丁
4. Data.lua Data相关
5. Item.lua 物品相关
6. LowCpuUsage.lua 减低cpu使用补丁
7. Protocol.lua 封包拦截相关
8. Recipe.lua 配方相关
