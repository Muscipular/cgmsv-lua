---@meta _

---@since HOOK:v0.2.30
---@return string
function getHookVer() end

---加载Module模块
function loadModule(string) end

---加载普通LUA
function useModule(string) end

---获取模块
---@param name string 模块ID
---@return ModuleBase|any
function getModule(name) end

---重载模块
---@param name string 模块ID
function reloadModule(name) end

---卸载模块
---@param name string 模块ID
function unloadModule(name) end

--- 注册全局事件
---@param eventName string
---@param fn function|OrderedCallback
---@param moduleName string
---@param extraSign string
---@return number 全局注册Index
function regGlobalEvent(eventName, fn, moduleName, extraSign) end

--- 注册全局事件
---@param eventName string
---@param fn function|OrderedCallback
---@return number 全局注册Index
function regGlobalEvent(eventName, fn) end

--- 移除全局事件
---@param eventName string
---@param fnIndex number 全局注册Index
---@param moduleName string|nil
---@param extraSign string|nil
function removeGlobalEvent(eventName, fnIndex, moduleName, extraSign) end

--- 移除全局事件
---@param eventName string
---@param fnIndex number 全局注册Index
function removeGlobalEvent(eventName, fnIndex) end

---将内容转换成string格式，带识别转义符功能
---@param s string|number
---@return string|nil @string格式内容 失败返回'null'
function SQL.sqlValue(s) end

---执行指定的Mysql查询。
---@param sql  string 要执行的Mysql查询语句。
---@return string[][] @table[a][b]a为行数，b为列数
function SQL.querySQL(sql, returnNil) end

---获取装备的武器 ItemIndex及位置
---@param charIndex number
---@return number @装备位置
---@return number @装备类型
---@return number @itemIndex
function Char.GetWeapon(charIndex) end

---检测index是否正确
---@param charIndex number
function Char.IsValidCharIndex(charIndex) end

---获取空的道具栏
---@param charIndex number
---@return number @slot
function Char.GetEmptyItemSlot(charIndex) end

---获取道具所在栏位
---@param charIndex number
---@param itemIndex number
---@return number @slot
function Char.GetItemSlot(charIndex, itemIndex) end

---获取空的宠物栏
---@param charIndex number
---@return number @slot
function Char.GetEmptyPetSlot(charIndex) end

---是否为宠物
---@param charIndex number
---@return boolean
function Char.IsPet(charIndex) end

---是否为玩家
---@param charIndex number
---@return boolean
function Char.IsPlayer(charIndex) end

---是否为怪物
---@param charIndex number
---@return boolean
function Char.IsEnemy(charIndex) end

---是否为NPC
---@param charIndex number
---@return boolean
function Char.IsNpc(charIndex) end
