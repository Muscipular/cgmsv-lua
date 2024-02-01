# cgmsv lua

## 模块系统
支持动态加载、卸载以及版本升级的数据迁移。其中通过Module注册的回调卸载时自动清理，具体文档：[ModuleSystem.md](docs/ModuleSystem.md)

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
11. petLottery 宠物抽奖
12. petRebirth 宠物转生
13. autoUnlock 自动解锁崩端导致的卡号
14. charStatusExtend 动态附加属性

## 扩展事件/接口
接口参考 [docs.lua](docs/docs.lua)

## 版本&下载
版本说明:
- 0.3.x: 适配cgmsv24.x, 稳定性较高
- 0.2.x: 适配cgmsv21.2b, 稳定性一般
- 0.1.x: 纯lua版，稳定性极低

下载地址:
[releases](releases)
