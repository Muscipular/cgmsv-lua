# cgmsv lua

## 模块系统

支持动态加载、卸载以及版本升级的数据迁移。其中通过Module注册的回调卸载时自动清理

## 目前能用的模块

具体模块加载在init.lua 
```
loadModule('admin', 'admin.lua') --加载admin模块
```

1. admin 内挂相关、模块动态管理等
2. shop 东门商店NPC配置
3. warp 村落传送
4. warp2 练级点传送
5. welcome 示例模块
