---@meta _

--[[
---@since HOOK:v0.2.30
---@return string
function getHookVer() end

---加载Module模块
function loadModule(string) end 

---加载普通LUA
function useModule(string) end 

---获取模块
---@param name string 模块ID
---@return ModuleBase 
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

Char = Char or {}

---获取装备的武器 ItemIndex及位置
---@param charIndex number
---@return number 装备位置 ,number 装备类型, number itemIndex
function Char.GetWeapon(charIndex) end

---@param charIndex number
function Char.UnsetWalkPostEvent(charIndex) end

---@param charIndex number
function Char.UnsetWalkPreEvent(charIndex) end

---@param charIndex number
function Char.UnsetPostOverEvent(charIndex) end

---@param charIndex number
function Char.UnsetLoopEvent(charIndex) end

---@param charIndex number
function Char.UnsetTalkedEvent(charIndex) end

---@param charIndex number
function Char.UnsetWindowTalkedEvent(charIndex) end

---@param charIndex number
function Char.UnsetItemPutEvent(charIndex) end

---@param charIndex number
function Char.UnsetWatchEvent(charIndex) end

---@param ptr number
---@return boolean
function Char.IsValidCharPtr(ptr) end

---@param charIndex number
---@return boolean
function Char.IsValidCharIndex(charIndex) end

---通过ptr获取数据
---@param charPtr number
---@param dataLine number
---@return string|number|nil
function Char.GetDataByPtr(charPtr, dataLine) end

---通过ptr获取数据
---@param charPtr number
---@param dataLine number
---@param value string|number
function Char.SetDataByPtr(charPtr, dataLine, value) end

---根据位置删除物品
---@param CharIndex number
---@param Slot number
function Char.DelItemBySlot(CharIndex, Slot) end

---移动角色、NPC
---@param charIndex number
---@param walkArray number[] 移动列表，取值0-7对应 CONST里面的方向，不建议超过5次移动
function Char.MoveArray(charIndex, walkArray) end

---@param charIndex number
---@param dataIndex number
---@return string | number
function Char.GetData(charIndex, dataIndex) end

---@param charIndex number
---@param dataIndex number
---@param value string|number
---@return number
function Char.SetData(charIndex, dataIndex, value) end

---设置自定义数据（保存到数据库）
---@param charIndex number
---@param dataIndex string
---@return string | number
function Char.GetExtData(charIndex, dataIndex) end

---获取自定义数据（保存到数据库）
---@param charIndex number
---@param dataIndex string
---@param value string|number
---@return number
function Char.SetExtData(charIndex, dataIndex, value) end

---设置临时数据（不保存到数据库）
---@param charIndex number
---@param dataIndex string
---@return string | number
function Char.GetTempData(charIndex, dataIndex) end

---获取临时数据（不保存到数据库）
---@param charIndex number
---@param dataIndex string
---@param value string|number
---@return number
function Char.SetTempData(charIndex, dataIndex, value) end

---获取一个唯一ID
---@param charIndex number
---@return string
function Char.GetUUID(charIndex) end

---当value为0时清除标旗
---@param charIndex number
---@param flag number
---@param value number '0' | '1'
---@return nil
function Char.NowEvent(charIndex, flag, value) end

---获取当前标旗
---@param charIndex number
---@param flag number
---@return number
function Char.NowEvent(charIndex, flag) end

---当value为0时清除标旗
---@param charIndex number
---@param flag number
---@param value number '0' | '1'
---@return nil
function Char.EndEvent(charIndex, flag, value) end

---获取当前标旗
---@param charIndex number
---@param flag number
---@return number
function Char.EndEvent(charIndex, flag) end

---@param charIndex number
---@param itemID number
---@return number 如果有则返回第一个结果的道具栏位置，如果没有则返回-1。
function Char.FindItemId(charIndex, itemID) end

---@param charIndex number
---@param amount number
function Char.AddGold(charIndex, amount) end

---@param charIndex number
---@param slot number
---@return number 如果目标栏位有道具，则返回道具index，否则返回 -1: 对象指针错误 -2: 道具栏无道具 -3: 超出范围。
function Char.GetItemIndex(charIndex, slot) end

---@param CharIndex number
---@param ItemID number
---@param Amount number
---@param ShowMsg boolean
---@return number 成功返回1，失败则返回0。
function Char.DelItem(CharIndex, ItemID, Amount, ShowMsg) end

---@param CharIndex number
---@param ItemID number
---@param Amount number
---@param ShowMsg boolean
---@return number 目标道具index，失败则返回负数。
function Char.GiveItem(CharIndex, ItemID, Amount, ShowMsg) end

---@param CharIndex number
---@param ItemID number
---@return number 如果目标有该道具，则返回该道具index，否则返回-1。
function Char.HaveItem(CharIndex, ItemID) end

---@param CharIndex number
---@param Slot number
---@return number 如果目标有，则返回index，否则返回-1。
function Char.GetPet(CharIndex, Slot) end

function Char.GivePet(CharIndex, PetID, FullBP) end

---@return number 道具栏使用数量
function Char.ItemSlot(charIndex) end

function Char.AddPet(CharIndex, PetID) end

---@return number 组队中的玩家人数，无组队返回-1，否则返回玩家人数，获取失败返回0，参数数据类型不对返回-2，对象index无效返回-3。
function Char.PartyNum(CharIndex) end

---@param Slot number 取值0-4
---@return number 返回指定位置的玩家的对象index，如果没有玩家则返回-1，获取失败返回0，参数数据类型不对返回-2，对象index无效返回-3，如果团队中的位置超过范围(0-4)返回-4。
function Char.GetPartyMember(CharIndex, Slot) end

---@return number 返回1代表成功，返回0失败，参数数据类型不对返回-2，对象index无效返回-3。
function Char.DischargeParty(CharIndex) end

---@return number 成功返回当前战斗index，返回-1代表没有战斗，参数数据类型不对返回-2，对象index无效返回-3。
function Char.GetBattleIndex(CharIndex) end

---加入组队，无视组队开关及距离
---@param sourceIndex number 队员index
---@param targetIndex number 队长index
function Char.JoinParty(sourceIndex, targetIndex) end

---离开队伍
---@param charIndex number
function Char.LeaveParty(charIndex) end

---@return number 成功返回玩家对象激活的称号ID，返回-1代表失败，参数数据类型不对返回-2，对象index无效返回-3。
function Char.GetTitle(CharIndex) end

function Char.Warp(CharIndex, MapType, FloorID, X, Y) end

function Char.HaveSkill(CharIndex, SkillID) end

function Char.GetSkillID(CharIndex, Slot) end

function Char.GetSkillLv(CharIndex, Slot) end

function Char.SetWalkPostEvent(Dofile, FuncName, CharIndex) end

function Char.SetWalkPreEvent(Dofile, FuncName, CharIndex) end

function Char.SetPostOverEvent(Dofile, FuncName, CharIndex) end

function Char.SetItemPutEvent(Dofile, FuncName, CharIndex) end

function Char.SetWatchEvent(Dofile, FuncName, CharIndex) end

function Char.SetLoopEvent(Dofile, FuncName, CharIndex, Interval) end

function Char.DelPet(CharIndex, PetID, Level, LevelSetting) end

function Char.DelSlotPet(CharIndex, Slot) end

---移动物品
---@param charIndex number
---@param fromSlot number 移动那个物品，取值0-27
---@param toSlot number 移动到那个位置, 取值0-27
---@param amount number 数量，整体移动取值可为-1
function Char.MoveItem(charIndex, fromSlot, toSlot, amount) end

---检测是否假人
---@param charIndex integer
---@return boolean
function Char.IsDummy(charIndex) end

---标记为假人
---@param charIndex integer
function Char.SetDummy(charIndex) end

---删除假人
---@param charIndex integer
function Char.DelDummy(charIndex) end

---计算技能所需的魔法
---@param charIndex integer
---@param techId integer
function Char.CalcConsumeFp(charIndex, techId) end

---设置宠物战斗状态
---@param charIndex integer
---@param slot integer
---@param state integer CONST.PET_STATE_*
function Char.SetPetDepartureState(charIndex, slot, state) end

---设置宠物战斗状态(批量)
---@param charIndex integer
---@param pet1State integer CONST.PET_STATE_*
---@param pet2State integer CONST.PET_STATE_*
---@param pet3State integer CONST.PET_STATE_*
---@param pet4State integer CONST.PET_STATE_*
---@param pet5State integer CONST.PET_STATE_*
function Char.SetPetDepartureStateAll(charIndex, pet1State, pet2State, pet3State, pet4State, pet5State) end

---直接交易物品
---@param fromChar integer 从谁身上交出 CharIndex
---@param toChar integer 交易给谁 CharIndex
---@param slot integer 道具栏位置，8-27
function Char.TradeItem(fromChar, slot, toChar) end

---直接交易宠物
---@param fromChar integer 从谁身上交出 CharIndex
---@param toChar integer 交易给谁 CharIndex
---@param slot integer 道具栏位置，8-27
function Char.TradePet(fromChar, slot, toChar) end

---获取空的ItemSlot
---@param charIndex integer
---@return integer
function Char.GetEmptyItemSlot(charIndex) end

---获取空的PetSlot
---@param charIndex integer
---@return integer
function Char.GetEmptyPetSlot(charIndex) end

NLG = NLG or {}
function NLG.ShowWindowTalked(ToIndex, WinTalkIndex, WindowType, ButtonType, SeqNo, Data) end

function NLG.SystemMessage(CharIndex, Message) end

function NLG.TalkToCli(ToIndex, TalkerIndex, Msg, FontColor, FontSize) end

function NLG.CanTalk(npc, player) end

function NLG.UpChar(CharIndex) end

function NLG.c(str) end

function NLG.TalkToMap(Map, Floor, TalkerIndex, Msg, FontColor, FontSize) end

---降低cpu使用
---@param ms number 少0时关闭，大于或等于0时为Sleep时间，不建议大于2
function NLG.LowCpuUsage(ms) end

---@overload fun(cdkey: string):number
---@param cdkey string
---@param regId number
---@return number charIndex
function NLG.FindUser(cdkey, regId) end

---@param min number
---@param max number
---@return number
function NLG.Rand(min, max) end

---@param npcOrPlayer number npc或者玩家index
---@param player number 玩家index
function NLG.OpenBank(npcOrPlayer, player) end

---宠物乱射(全局开启)
---@param enable boolean 启用:1 不启用:0
function NLG.SetPetRandomShot(enable) end

---宠物乱射(某种宠物开启)
---@param enable boolean 启用:1 不启用:0
---@param petId number 宠物id（EnemyBaseId）
function NLG.SetPetRandomShot(petId, enable) end

---修改暴击时伤害计算
-----@param mode number|boolean 取值： 0 = 普通模式 1 = 倍率模式 2 = 无 true = 普通模式 false = 无
-----@param val number 倍率，默认1.5倍
function NLG.SetCriticalDamageAddition(mode, val) end

---设置乱敏概率
---@param rate integer 0-100
---@param mode? nil|0|1|2 0 @0=PVE&PVP 1=PVE 2=PVP
function NLG.SetDexRearrangeRate(rate, mode) end

function NLG.DropPlayer(charIndex) end

Pet = {}

function Pet.ReBirth(PlayerIndex, PetIndex) end

function Pet.SetArtRank(PetIndex, ArtType, Value) end

function Pet.GetArtRank(PetIndex, ArtType) end

function Pet.ArtRank(PetIndex, ArtType) end

function Pet.FullArtRank(PetIndex, ArtType) end

function Pet.UpPet(PlayerIndex, PetIndex) end

function Pet.GetSkill(PetIndex, SkillSlot) end

function Pet.AddSkill(PetIndex, SkillID) end

---启用宠物突破63bp限制
function Pet.AllowBpOverflow() end

---获取唯一id
---@return string
function Pet.GetUUID() end

Item = {}

---扩展自定义物品类别名称
---@param type number 类型
---@param name string 名称
---@return boolean
function Item.SetItemTypeName(type, name) end

---获取扩展自定义物品类别名称
---@param type number 类型
---@return string 名称
function Item.GetItemTypeName(type) end

---扩展自定义物品类别装备位置
---@param type number 类型
---@param place string 位置
---@return boolean
function Item.SetItemTypeEquipPlace(type, place) end

---获取扩展自定义物品类别装备位置
---@param type number 类型
---@return number 位置
function Item.GetItemTypeEquipPlace(type) end

---扩展自定义物品类别职业装备等级
---@param job number 职业ID
---@param type number 类型
---@param level number 等级
---@return boolean
function Item.SetItemTypeEquipLevelForJob(job, type, level) end

---获取扩展自定义物品类别职业装备等级
---@param job number 职业ID
---@param type number 类型
---@return number 位置
function Item.GetItemTypeEquipLevelForJob(job, type) end

function Item.GetData(ItemIndex, Dataline) end

function Item.SetData(ItemIndex, Dataline, value) end

function Item.UpItem(CharIndex, Slot) end

function Item.Kill(CharIndex, ItemIndex, Slot) end

Battle = {}

---@param BattleIndex number 战斗index，为Encount、PVE或PVP函数的返回值。
---@param Slot number 战斗队列中玩家位置,范围0-19，其中0-9为下方实例队列，10-19为上方实例队列。
---@return number 返回-1失败，成功返回对象实例的 对象index，参数数据类型不对返回-2，战斗index无效返回-3，战斗队列中玩家位置范围错误返回-4。
function Battle.GetPlayer(BattleIndex, Slot) end

---@param BattleIndex number 战斗index，为Encount、PVE或PVP函数的返回值。
---@param Slot number 战斗队列中玩家位置,范围0-19，其中0-9为下方实例队列，10-19为上方实例队列。
---@return number 返回-1失败，成功返回对象实例的 对象index，参数数据类型不对返回-2，战斗index无效返回-3，战斗队列中玩家位置范围错误返回-4。
function Battle.GetPlayIndex(BattleIndex, Slot) end

function Battle.Encount(UpIndex, DownIndex) end

---@param CharIndex number
---@param CreatePtr number
---@param DoFunc string
---@param EnemyIdAr number[]
---@param BaseLevelAr number[]
---@param RandLv number[]
function Battle.PVE(CharIndex, CreatePtr, DoFunc, EnemyIdAr, BaseLevelAr, RandLv) end

function Battle.PVP(UpIndex, DownIndex) end

function Battle.SetType(BattleIndex, Type) end

---@return number
function Battle.GetType(BattleIndex) end

function Battle.SetGainMode(BattleIndex, Mod) end

function Battle.GetGainMode(BattleIndex) end

---@return number 取值0或者1。 0表示战斗下方，即0-9位置的玩家；1表示上方，即10-19位置的玩家。
function Battle.GetWinSide(BattleIndex) end

function Battle.SetWinEvent(DoFile, FuncName, BattleIndex) end

function Battle.ExitBattle(CharIndex) end

function Battle.SetPVPWinEvent(DoFile, FuncName, BattleIndex) end

---@param battleIndex integer
function Battle.UnsetWinEvent(battleIndex) end

---@param battleIndex integer
function Battle.UnsetPVPWinEvent(battleIndex) end

---连战设置
---@overload fun(battleIndex: number, encountIndex: number):number
---@param battleIndex number
---@param encountIndex number -1=取消连战，  -2=lua生成连战
---@param flg number lua连战参数
---@return number 成功返回0
function Battle.SetNextBattle(battleIndex, encountIndex, flg) end

---连战设置
---@param battleIndex number
---@param encountIndex number encount编号，  -1=取消连战
---@return number 成功返回0
function Battle.SetNextBattle(battleIndex, encountIndex) end

---获取连战id
---@param battleIndex number
---@return number encountIndex
function Battle.GetNextBattle(battleIndex) end

---获取lua连战flg
---@param battleIndex number
---@return number flg
function Battle.GetNextBattleFlg(battleIndex) end

---计算属性伤害比率
---@param ap number[] 4属性，地、水、火、风
---@param dp number[] 4属性，地、水、火、风
---@return number
function Battle.CalcPropScore(ap, dp) end

---让指定玩家对象加入另一个玩家对象的战斗中，也就是让CharIndex2加入CharIndex1的战斗
---@param a number 目标的对象index，在战斗中的玩家
---@param b number 目标的对象index，不在战斗中的玩家
---@return number 其中0为成功，其他失败。
function Battle.JoinBattle(a, b) end

---让对象执行指定的战斗操作，必须在对象Battle.IsWaitingCommand(index)返回值为1时才可以有效使用。
---@param charIndex number
---@param com1 number @see CONST.BATTLE_COM
---@param com2 number @see CONST.BATTLE_COM_TARGET
---@param com3 number techId
---@return number
function Battle.ActionSelect(charIndex, com1, com2, com3) end

---判断当前对象是否在战斗中且处于等待输入战斗指令的状态。
---@return number 返回1为等待指令
function Battle.IsWaitingCommand(charIndex) end

---获取当前动作技能参数
---@param charIndex number
---@param type string 取值 DD: AR: 等
---@return number|nil
function Battle.GetTechOption(charIndex, type) end

---获取属性克制关系
---@param attackerIndex number
---@param defenceIndex number
---@return number 克制比率
function Battle.CalcAttributeDmgRate(attackerIndex, defenceIndex) end

---计算种族伤害
---@param a number 攻击方种族
---@param b number 防御方种族
---@return number
function Battle.CalcTribeRate(a, b) end

---计算当前战斗种族伤害
---@param aIndex number 攻击方index
---@param bIndex number 防御方index
---@return number
function Battle.CalcTribeDmgRate(aIndex, bIndex) end

---获取当前战斗回合
---@param battleIndex number 
---@return number
function Battle.GetTurn(battleIndex) end

---设置当前回合数
---@param battleIndex number 
---@param turn number 
function Battle.SetTurn(battleIndex, turn) end

---伤害事件中获取乱射hit数 1,2,3,4.....
---@param defSlot number 防御者slot
---@param battleIndex number
---@return integer
function Battle.GetRandomShotHit(battleIndex, defSlot) end

---获取属性领域参数
---@param BattleIndex integer
---@return number 属性, number 剩余回合, number 威力
function Battle.GetBattleFieldAttribute(BattleIndex) end

---设置属性领域
---@param BattleIndex integer
---@param Attribute integer 属性
---@param TurnCount integer 剩余回合
---@param AttributePower integer 威力
---@return integer 是否成功 返回1为成功 其他为失败
function Battle.SetBattleFieldAttribute(BattleIndex, Attribute, TurnCount, AttributePower) end

---为当前处理的战斗添加信息
---@param msg string
function Battle.AppendBattleMsg(msg) end

Field = Field or {}

function Field.Get(CharIndex, Field) end

function Field.Set(CharIndex, Field, Value) end

NL = NL or {}

function NL.CreateNPC(Dofile, InitFuncName) end

function NL.DelNpc(NpcIndex) end

function NL.CreateArgNpc(Type, Arg, Name, Image, Map, Floor, Xpos, Ypos, Dir, ShowTime) end

function NL.SetArgNpc(NpcIndex, NewArg) end

function NL.RegCallback(event, callbackStr) end

function NL.RemoveCallback(event) end

---道具说明修改事件
---@param callback string callback回调参数 
---@see NL.RegItemExpansionEventCallback
function NL.RegItemExpansionEvent(dofile, callback) end

---道具说明修改事件回调
---@param itemIndex number
---@param type number
---@param msg string
---@param charIndex number
---@param slot number
---@return string
function NL.RegItemExpansionEventCallback(itemIndex, type, msg, charIndex, slot) end

---宝箱遇敌事件
---@param callback string callback回调参数 
---@see NL.ItemBoxEncountEventCallback
function NL.RegItemBoxEncountEvent(dofile, callback) end

---宝箱遇敌事件回调
---@param charaIndex number
---@param mapId number
---@param floor number
---@param X number
---@param Y number
---@param itemIndex number 箱子物品index
---@return number[]|nil 遇敌数组 每个怪物3个参数，分别为 id，等级，随机等级， 返回nil不拦截， 例子： {0, 100, 5, 1, 1, 0} 生成0号怪物100-105级，1号怪物1级
function NL.ItemBoxEncountEventCallback(charaIndex, mapId, floor, X, Y, itemIndex) end

---宝箱遇敌概率事件
---@param callback string callback回调参数 
---@see NL.ItemBoxEncountRateEventCallback
function NL.RegItemBoxEncountRateEvent(dofile, callback) end

---宝箱遇敌概率事件回调
---@param charaIndex number
---@param mapId number
---@param floor number
---@param X number
---@param Y number
---@param itemIndex number 箱子物品index
---@param boxType number
---@param rate number 遇敌率
---@return number 遇敌率
function NL.ItemBoxEncountRateEventCallback(charaIndex, mapId, floor, X, Y, itemIndex, rate, boxType) end

---宝箱获取物品事件
---@param callback string callback回调参数 
---@see NL.ItemBoxLootEventCallback
function NL.RegItemBoxLootEvent(dofile, callback) end

---宝箱获取物品事件回调
---@param charaIndex number
---@param mapId number
---@param floor number
---@param X number
---@param Y number
---@param boxType number
---@param adm number
---@return number 返回1拦截默认物品
function NL.ItemBoxLootEventCallback(charaIndex, mapId, floor, X, Y, boxType, adm) end

---宝箱生成事件
---@param callback string callback回调参数 
---@see NL.ItemBoxGenerateEventCallback
function NL.RegItemBoxGenerateEvent(dofile, callback) end

---宝箱生成事件回调
---@param mapId number
---@param floor number
---@param itemBoxType number 宝箱编号
---@param adm number 影响出产物品，作用未知
---@return number[] 返回宝箱参数 {itemBoxType, adm}
function NL.ItemBoxGenerateEventCallback(mapId, floor, itemBoxType, adm) end

---种族伤害比率事件
---@param callback string callback回调参数 
---@see NL.ItemTribeRateEventCallback
function NL.RegItemTribeRateEvent(dofile, callback) end

---种族伤害比率事件回调
---@param a number 进攻种族
---@param b number 防守种族
---@param rate number 克制比率
---@return number 返回新的克制比率
function NL.ItemTribeRateEventCallback(a, b, rate) end

---Http请求事件
---@param callback string callback回调参数 
---@see Http.HttpRequestEventCallback
function NL.RegHttpRequestEvent(dofile, callback) end

---@param sql string sql
---@vararg string|number 绑定参数，最多40个
---@return {status:number, effectRows:number, rows: table} 返回查询内容
function SQL.QueryEx(sql, ...) end

Data = Data or {}

---设置Msg
---@param msgId number
---@param val string
function Data.SetMessage(msgId, val) end

---获取Msg
---@param msgId number
---@return string
function Data.GetMessage(msgId) end

---设置种族伤害比率
---@param a number 进攻种族 支持 0 ~ 19
---@param b number 防守种族 支持 0 ~ 19
---@param rate number 克制比率支持 -128 ~ 127
function Data.SetTribeMapValue(a, b, rate) end

---获取ItemsetIndex
function Data.ItemsetGetIndex(ItemID) end

---获取Itemset数据
function Data.ItemsetGetData(ItemsetIndex, DataPos) end

---获取EnemyDataIndex
function Data.EnemyGetDataIndex(enemyId) end

---获取Enemy数据
function Data.EnemyGetData(enemyIndex, DataPos) end

---获取EnemyBaseDataIndex
function Data.EnemyBaseGetDataIndex(enemyBaseId) end

---获取EnemyBase数据
function Data.EnemyBaseGetData(enemyBaseIndex, DataPos) end

function Data.GetEncountIndex(encountId) end

function Data.GetEncountData(encountIndex, dataPos) end

function Data.GetEnemyBaseIdByEnemyId(enemyId) end

function Data.GetEnemyBaseIndexByEnemyId(enemyId) end


Tech = Tech or {}

---获取TechIndex
---@param techId integer
---@return integer
function Tech.GetTechIndex(techId) end

---获取Tech数据
---@param techIndex integer
---@param dataLine integer
---@return integer|string
function Tech.GetData(techIndex, dataLine) end

---设置魔法属性
---@param techId number
---@param earth number 每10等于1格属性
---@param water number 每10等于1格属性
---@param fire number 每10等于1格属性
---@param wind number 每10等于1格属性
function Tech.SetTechMagicAttribute(techId, earth, water, fire, wind) end

---根据fd获取角色Index
---@param fd integer
---@return integer charIndex
function Protocol.GetCharIndexFromFd(fd) end

---发送封包到客户端
---@param charIndex number
---@param header string 封包头
---@vararg number|string data，根据封包内容而定，数字及字符串无须进行封包编码，会默认处理
---@return number 返回少于0为失败，其他可视为成功
function Protocol.Send(charIndex, header, ...) end

---发送封包到客户端
---@param fd number
---@param header string 封包头
---@vararg number|string data，根据封包内容而定，数字及字符串无须进行封包编码，会默认处理
---@return number 返回少于0为失败，其他可视为成功
function Protocol.SendToFd(fd, header, ...) end

---获取客户端IP
---@param fd number
---@return string ip
function Protocol.GetIp(fd) end

---获取fd
---@param charIndex number
---@return number fd
function Protocol.GetFdByCharIndex(charIndex) end

---拦截封包回调
---@param Dofile? string 加载文件
---@param FuncName string 回调名字
---@param PacketID string 封包头
function Protocol.OnRecv(Dofile, FuncName, PacketID) end

Recipe = Recipe or {}

---@return number 成功时返回 1, 失败返回 0, charIndex无效返回 -1, 配方无效返回 -2, 配方已获得返回 -3
function Recipe.GiveRecipe(charIndex, recipeNo) end

---@return number 成功时返回 1, 失败返回 0, charIndex无效返回 -1, 配方无效返回 -2, 配方已获得返回 -3
function Recipe.RemoveRecipe(charIndex, recipeNo) end

---@return number 返回值 有配方时返回 1, 无配方返回 0, charIndex无效返回 -1, 配方无效返回 -2
function Recipe.HasRecipe(charIndex, recipeNo) end

function Recipe.GetData(recipeNo, dataLine) end

Skill = Skill or {}

---设置扩展技能经验表
---@param expId number 经验表Id
---@param lv number 技能等级
---@param exp number 需要的经验
function Skill.SetExpForLv(expId, lv, exp) end

---设置技能最大等级
---@param level number 最大支持127
function Skill.SetMaxLevel(level) end

---获取职业最高技能等级
---@param skillIndex any
---@param job any
---@return integer
function Skill.GetMaxSkillLevelOfJob(skillIndex, job) end

---获取skillIndex
---@param id integer 技能id
---@return integer
function Skill.GetSkillIndex(id) end

---修改调教增加的宠物忠诚度
---@param lv integer 等级
---@param add integer 增加的忠诚度，默认每级1点忠诚
function Skill.SetPetTrainAddition(lv, add) end

---设置普通职业最大成功率
---@param rate number
function Skill.SetNormalJobStealMaxRate(rate) end

---设置医生职业ID
---@param jobId number
function Skill.AddDoctorJob(jobId) end

---移除医生职业ID
---@param jobId number
function Skill.RemoveDoctorJob(jobId) end

---设置普通职业治疗成功率
---@param lv integer 
---@param mode 0|1|2|3 0=白伤，1=黄，2=紫，3=红
---@param rate integer 失败概率
function Skill.SetNormalJobMedicalTreatmentRate(lv, mode, rate) end

---设置医生职业治疗成功率
---@param lv integer 
---@param mode 0|1|2|3 0=白伤，1=黄，2=紫，3=红
---@param rate integer 失败概率
function Skill.SetDoctorJobMedicalTreatmentRate(lv, mode, rate) end

---设置医生职业成治疗功率(带了专属饰品)
---@param lv integer 
---@param mode 0|1|2|3 0=白伤，1=黄，2=紫，3=红
---@param rate integer 失败概率
function Skill.SetDoctorJobExMedicalTreatmentRate(lv, mode, rate) end

Map = Map or {}

---获取迷宫的剩余时间
---@param dungeonId integer
---@return integer 时间（秒）
function Map.GetDungeonExpireTimeByDungeonId(dungeonId) end

---获取迷宫地图的剩余时间
---@param floor integer
---@return integer 时间（秒）
function Map.GetDungeonExpireTime(floor) end

---获取迷宫的过期时间
---@param dungeonId integer
---@return integer 时间（UnixTime）
function Map.GetDungeonExpireAtByDungeonId(dungeonId) end

---获取迷宫的过期时间
---@param floor integer floor
---@return integer 时间（UnixTime）
function Map.GetDungeonExpireAt(floor) end

---根据floor设置迷宫重置时间 
---@param floor integer floor
---@param time integer UnixTime
function Map.SetDungeonExpireAt(floor, time) end

---根据迷宫Id设置迷宫重置时间 
---@param dungeonId integer dungeonId
---@param time integer UnixTime
function Map.SetDungeonExpireAtByDungeonId(dungeonId, time) end

---获取迷宫Id
---@param floor integer
---@return integer dungeonId 迷宫id
function Map.GetDungeonId(floor) end

---获取迷宫入口
---@param dungeonId integer dungeonId
---@return number mapType, number floor, number x, number y
function Map.FindDungeonEntry(dungeonId) end

Http = _G.Http or {}

---初始化Http服务器
function Http.Init() end

---开启Http服务
---@param addr string 监听IP,例如: "0.0.0.0"
---@param port integer 端口 建议10000以上
---@return integer ret @1：成功，其他为失败
function Http.Start(addr, port) end

---关闭Http服务器，需要注意，在请求中停止会导致请求响应502并且强制关闭所有未处理的请求
function Http.Stop() end

---获取Http服务器状态
---@return 0|1|2 status  @0=未初始化 1=未启动 2=运行中
function Http.GetStatus() end

---绑定静态资源
---@param path string url地址
---@param dir string 本地目录
function Http.AddMountPoint(path, dir) end

---移除静态资源
---@param path string url地址
function Http.RemoveMountPoint(path) end

---http请求回调
---@param method string
---@param api string API名字
---@param params {string:string} 参数
---@param body string body内容
---@return string body 返回内容
function Http.HttpRequestEventCallback(method, api, params, body) end
--]]--
