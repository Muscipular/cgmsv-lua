Char = {}

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
---@return void
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
---@return void
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

---@param charIndex number
---@return number
function Char.IsDummy(charIndex) end

---@param charIndex number
---@return number
function Char.SetDummy(charIndex) end

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

_G.Field = {}

function Field.Get(CharIndex, Field) end

function Field.Set(CharIndex, Field, Value) end

_G.NL = {}

function NL.CreateNPC(Dofile, InitFuncName) end

function NL.DelNpc(NpcIndex) end

function NL.CreateArgNpc(Type, Arg, Name, Image, Map, Floor, Xpos, Ypos, Dir, ShowTime) end

function NL.SetArgNpc(NpcIndex, NewArg) end

function NL.RegCallback(event, callbackStr) end

function NL.RemoveCallback(event) end

---宝箱遇敌事件
---@param callback string callback回调参数 fun(charaIndex:number,mapId:number,floor:number,X:number,Y:number,boxType:number):number[]|nil
function NL.RegItemBoxEncountEvent(dofile, callback) end

---宝箱遇敌事件回调
---@param charaIndex number
---@param mapId number
---@param floor number
---@param X number
---@param Y number
---@param boxType number
---@return number[]|nil 遇敌数组 每个怪物3个参数，分别为 id，等级，随机等级， 返回nil不拦截， 例子： {0, 100, 5, 1, 1, 0} 生成0号怪物100-105级，1号怪物1级
function NL.ItemBoxEncountRateEventCallback(charaIndex, mapId, floor, X, Y, boxType) end

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
---@param boxType number
---@param rate number 遇敌率
---@return number 遇敌率
function NL.ItemBoxEncountRateEventCallback(charaIndex, mapId, floor, X, Y, boxType, rate) end

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

---@param sql string sql
---@vararg string|number 绑定参数，最多40个
---@return {status:number, effectRows:number, rows: table} 返回查询内容
function SQL.QueryEx(sql, ...) end

---@overload fun(battleIndex: number, encountIndex: number):number
---@param battleIndex number
---@param encountIndex number encount编号， -1=取消连战， -2=lua生成连战
---@param flg number lua连战参数
---@return number 成功返回0
function Battle.SetNextBattle(battleIndex, encountIndex, flg) end

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

---获取当前技能参数
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

---设置Msg
---@param msgId number
---@param val string
function Data.SetMessage(msgId, val) end

---获取Msg
---@param msgId number
---@return string
function Data.GetMessage(msgId) end

---设置魔法属性
---@param techId number
---@param earth number 每10等于1格属性
---@param water number 每10等于1格属性
---@param fire number 每10等于1格属性
---@param wind number 每10等于1格属性
function Tech.SetTechMagicAttribute(techId, earth, water, fire, wind) end
