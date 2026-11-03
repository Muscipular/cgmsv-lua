## 项目说明
这是魔力宝贝游戏引擎服务端的lua扩展部分。采用luajit最新的2.1作为脚本引擎。实现扩展玩法和功能。
在这个基础上进行Module化封装，方便开发与管理。

本项目lua采用gbk编码，读取和写入务必保证编码为gbk，注释请使用中文注释

## 项目结构

- docs/*.lua 引擎提供的lua文档
- libs 框架封装代码类
- Module 存放普通lua代码，采用Delegate做事件共享
- Modules Module类代码，按照Module类进行封装
- www/* http服务的静态资源
- CONST.lua 常量lua
- init.lua lua启动入口
- ModuleConfig.lua 模块配置入口

!Important! 具体接口索引参考 `docs/api_index.json` 或 `docs/api_index.md`

## luajit扩展
扩展支持 `!=` `!` `&&` `||` `%` 等符号


## Module规则
### 名字
请注意ModuleName和文件名（不含后缀）务必保证一致。

### 事件注册
NL.Reg*请勿直接使用，而使用Module:regCallback，unload时会动释放
Cron.* 可以使用Module中同名函数代替，unload时会动释放

### 作用域
Module间的作用域相互独立，所以不同module获取变量需要通过getModule方法获取Module示例在获取Module对象内的变量

### NPC对话
Module的NPC对话建议使用CO模块进行简化，参考函数`NPCPart:NPC_CreateCo`, `CO:next`, lua: `Modules/co.lua'`

## 其他注意事项
- 获取角色、物品等数据请优先参考CONST
- CONST请勿使用魔法数字！必须使用CONST下变量！
- NPC对话、信息提示请使用简体中文提示

## 代码风格要求
1. 代码尽量简洁，通俗易懂。
2. 驼峰命名，方法大写开头，事件回调以onXXXX开头
3. 关键逻辑需要添加注释
4. 检查时需要规避重复的逻辑和代码

## 规划规则
1. 先理解！再规划！遵循以下规则 理解需求 -> 读代码 -> 写计划 -> 读文档 -> 复核计划 -> 写代码
2. 建立./tmp/${timestamp}/文件夹存放用于规划文件
