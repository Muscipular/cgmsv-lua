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
### loadModule 
加载`Modules`下的Module，Module的作用域相互独立，除非手动指定全局变量，否则不会影响其他Module，如需访问其他Module可通过getModule获取
```
loadModule('admin') --加载admin模块
```
### useModule 
加载`Module`目录下的普通lua, 普通lua都会在一个公共的作用域下执行。除非手动指定为全局变量，否则只会影响普通lua，module不能访问相关变量/方法
```
useModule('Welcome') --加载Welcome
```
### getModule
获取对应的Module

### unloadModule
卸载Module

### reloadModule
重新加载Module

### 目前能用的模块
1. admin 模块动态管理等
2. ng 内挂相关
3. shop 东门商店NPC配置
4. warp 村落传送
5. warp2 练级点传送
6. welcome 示例模块
7. itemPowerUp.lua 装备强化
8. manaPool 血魔池
9. bag 背包切换
10. autoRegister 自动注册
11. petExt/charExt/itemExt 公共扩展模块
12. petLottery 宠物抽奖
13. petRebirth 宠物转生
   
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
9. DummyChar.lua 假人相关
10. NL.lua 扩展事件相关
11. NLG_ShowWindowTalked_Patch.lua NLG.ShowWindowTalked 长度补丁
12. Addresses.lua 基础地址
13. Field.lua Field相关

## 扩展事件/接口
- `NL.RegEnemyCommandEvent` 怪物行动事件
- `NL.RegCharaDeletedEvent` 角色删除事件
- `NL.RegResetCharaBattleStateEvent` 角色战斗结束事件
- `NL.RegBattleDamageEvent` 原来的RegDamageCalculateEvent
- `NL.RegDamageCalculateEvent` 补丁后的战斗伤害事件
- `NL.RegBattleHealCalculateEvent` 战斗治疗事件
- `NL.RegDeleteDummyEvent` 假人删除事件
- `NL.RegItemExpansionEvent` 用于物品说明处理
- `Char.GetCharPointer` 获取角色Ptr
- `Char.GetWeapon` 获取武器
- `Char.GiveItem` 添加物品，支持静默模式
- `Char.DelItem` 删除物品，支持静默模式
- `Char.DelItemBySlot` 删除指定位置的物品
- `Char.UnsetWalkPostEvent` 移除事件
- `Char.UnsetWalkPreEvent` 移除事件
- `Char.UnsetPostOverEvent` 移除事件
- `Char.UnsetLoopEvent` 移除事件
- `Char.UnsetTalkedEvent` 移除事件
- `Char.UnsetWindowTalkedEvent` 移除事件
- `Char.UnsetItemPutEvent` 移除事件
- `Char.UnsetWatchEvent` 移除事件
- `Char.MoveArray` 角色连续移动
- `Char.JoinParty` 加入队伍
- `Char.LeaveParty` 离开队伍
- `Char.MoveItem` 移动物品
- `Char.IsValidCharPtr` 
- `Char.IsValidCharIndex` 
- `Char.GetDataByPtr` 根据Ptr获取数据
- `Char.IsDummy` 是否是假人
- `Char.CreateDummy` 创建假人
- `Char.DelDummy` 删除假人
- `Char.CalcConsumeFp` 用于获取技能所需要的fp
- `Battle.UnsetWinEvent` 移除事件
- `Battle.UnsetPVPWinEvent` 移除事件
- `Battle.GetNextBattle` 获取下一场连战Id
- `Battle.SetNextBattle` 设置下一场连战Id
- `Battle.GetTurn` 获取当前回合
- `Data.ItemsetGetIndex` 获取ItemsetIndex
- `Data.ItemsetGetData` 获取Itemset数据
- `Data.GetEncountData` 获取Encount数据
- `Data.SetMessage` 获取Msg
- `Data.GetMessage` 修改/新增Msg，动态创建物品时大概会有用
- `Item.GetSlot` 获取ItemIndex对应位置
- `Protocol.makeEscapeString` 编码字符串
- `Protocol.makeStringFromEscaped` 解码字符串
- `Protocol.nrprotoEscapeString` 封包编码字符串
- `Protocol.nrprotoUnescapeString` 封包解码字符串
- `Protocol.Send` 发送自定义封包
- `Protocol.GetCharIndexFromFd` 通过fd获取charIndex
- `Protocol.OnRecv` 拦截封包
- `Recipe.GiveRecipe` 添加配方
- `Recipe.RemoveRecipe` 删除配方
- `regGlobalEvent` 注册全局事件，代替Delegate，Delegate也是包装这个方法
- `removeGlobalEvent` 移除注册事件
