Char = {}

---@param charIndex number
---@param dataIndex number
---@return string | number
function Char.GetData(charIndex, dataIndex)
end

---@param charIndex number
---@param dataIndex number
---@param value string|number
---@return number
function Char.SetData(charIndex, dataIndex, value)
end

---当value为0时清除标旗
---@param charIndex number
---@param flag number
---@param value number '0' | '1'
---@return void
function Char.NowEvent(charIndex, flag, value)
end
---获取当前标旗
---@param charIndex number
---@param flag number
---@return number
function Char.NowEvent(charIndex, flag)
end
---当value为0时清除标旗
---@param charIndex number
---@param flag number
---@param value number '0' | '1'
---@return void
function Char.EndEvent(charIndex, flag, value)
end
---获取当前标旗
---@param charIndex number
---@param flag number
---@return number
function Char.EndEvent(charIndex, flag)
end

---@param charIndex number
---@param itemID number
---@return number 如果有则返回第一个结果的道具栏位置，如果没有则返回-1。
function Char.FindItemId(charIndex, itemID)
end

---@param charIndex number
---@param amount number
function Char.AddGold(charIndex, amount)
end

---@param charIndex number
---@param slot number
---@return number 如果目标栏位有道具，则返回道具index，否则返回 -1: 对象指针错误 -2: 道具栏无道具 -3: 超出范围。
function Char.GetItemIndex(charIndex, slot)
end
---@param CharIndex number
---@param ItemID number
---@param Amount number
---@param ShowMsg boolean
---@return number 成功返回1，失败则返回0。
function Char.DelItem(CharIndex, ItemID, Amount, ShowMsg)
end

---@param CharIndex number
---@param ItemID number
---@param Amount number
---@param ShowMsg boolean
---@return number 目标道具index，失败则返回负数。
function Char.GiveItem(CharIndex, ItemID, Amount, ShowMsg)
end

---@param CharIndex number
---@param ItemID number
---@return number 如果目标有该道具，则返回该道具index，否则返回-1。
function Char.HaveItem(CharIndex, ItemID)
end

---@param CharIndex number
---@param Slot number
---@return number 如果目标有，则返回index，否则返回-1。
function Char.GetPet(CharIndex, Slot)
end

function Char.GivePet(CharIndex, PetID, FullBP)
end

---@return number 道具栏使用数量
function Char.ItemSlot(charIndex)
end

function Char.AddPet(CharIndex, PetID)
end
---@return number 组队中的玩家人数，无组队返回-1，否则返回玩家人数，获取失败返回0，参数数据类型不对返回-2，对象index无效返回-3。
function Char.PartyNum(CharIndex)
end

---@param Slot number 取值0-4
---@return number 返回指定位置的玩家的对象index，如果没有玩家则返回-1，获取失败返回0，参数数据类型不对返回-2，对象index无效返回-3，如果团队中的位置超过范围(0-4)返回-4。
function Char.GetPartyMember(CharIndex, Slot)
end

---@return number 返回1代表成功，返回0失败，参数数据类型不对返回-2，对象index无效返回-3。
function Char.DischargeParty(CharIndex)
end
---@return number 成功返回当前战斗index，返回-1代表没有战斗，参数数据类型不对返回-2，对象index无效返回-3。
function Char.GetBattleIndex(CharIndex)
end
---@return number 成功返回玩家对象激活的称号ID，返回-1代表失败，参数数据类型不对返回-2，对象index无效返回-3。
function Char.GetTitle(CharIndex)
end
function Char.Warp(CharIndex, MapType, FloorID, X, Y)
end

function Char.HaveSkill(CharIndex, SkillID)
end

function Char.GetSkillID(CharIndex, Slot)
end

function Char.GetSkillLv(CharIndex, Slot)
end

function Char.SetWalkPostEvent(Dofile, FuncName, CharIndex)
end

function Char.SetWalkPreEvent(Dofile, FuncName, CharIndex)
end

function Char.SetPostOverEvent(Dofile, FuncName, CharIndex)
end

function Char.SetItemPutEvent(Dofile, FuncName, CharIndex)
end

function Char.SetWatchEvent(Dofile, FuncName, CharIndex)
end

function Char.SetLoopEvent(Dofile, FuncName, CharIndex, Interval)
end

function Char.DelPet(CharIndex, PetID, Level, LevelSetting)
end

function Char.DelSlotPet(CharIndex, Slot)
end

NLG = {}
function NLG.ShowWindowTalked(ToIndex, WinTalkIndex, WindowType, ButtonType, SeqNo, Data)
end

function NLG.SystemMessage(CharIndex, Message)
end

function NLG.TalkToCli(ToIndex, TalkerIndex, Msg, FontColor, FontSize)
end

function NLG.CanTalk(npc, player)
end

function NLG.UpChar(CharIndex)
end

function NLG.c(str)
end

Pet = {}
function Pet.ReBirth(PlayerIndex, PetIndex)
end

function Pet.SetArtRank(PetIndex, ArtType, Value)
end

function Pet.GetArtRank(PetIndex, ArtType)
end

function Pet.UpPet(PlayerIndex, PetIndex)
end

Item = {}
function Item.GetData(ItemIndex, Dataline)
end

function Item.SetData(ItemIndex, Dataline, value)
end

function Item.UpItem(CharIndex, Slot)
end

function Item.Kill(CharIndex, ItemIndex, Slot)
end

Battle = {}
---@param BattleIndex number 战斗index，为Encount、PVE或PVP函数的返回值。
---@param Slot number 战斗队列中玩家位置,范围0-19，其中0-9为下方实例队列，10-19为上方实例队列。
---@return number 返回-1失败，成功返回对象实例的 对象index，参数数据类型不对返回-2，战斗index无效返回-3，战斗队列中玩家位置范围错误返回-4。
function Battle.GetPlayer(BattleIndex, Slot)
end
---@param BattleIndex number 战斗index，为Encount、PVE或PVP函数的返回值。
---@param Slot number 战斗队列中玩家位置,范围0-19，其中0-9为下方实例队列，10-19为上方实例队列。
---@return number 返回-1失败，成功返回对象实例的 对象index，参数数据类型不对返回-2，战斗index无效返回-3，战斗队列中玩家位置范围错误返回-4。
function Battle.GetPlayIndex(BattleIndex, Slot)
end
function Battle.Encount(UpIndex, DownIndex)
end
---@param CharIndex number
---@param CreatePtr number
---@param DoFunc string
---@param EnemyIdAr number[]
---@param BaseLevelAr number[]
---@param RandLv number[]
function Battle.PVE(CharIndex, CreatePtr, DoFunc, EnemyIdAr, BaseLevelAr, RandLv)
end
function Battle.PVP(UpIndex, DownIndex)
end
function Battle.SetType(BattleIndex, Type)
end
---@return number
function Battle.GetType(BattleIndex)
end
function Battle.SetGainMode(BattleIndex, Mod)
end
function Battle.GetGainMode(BattleIndex)
end
---@return number 取值0或者1。 0表示战斗下方，即0-9位置的玩家；1表示上方，即10-19位置的玩家。
function Battle.GetWinSide(BattleIndex)
end
function Battle.SetWinEvent(DoFile, FuncName, BattleIndex)
end
function Battle.ExitBattle(CharIndex)
end
function Battle.SetPVPWinEvent(DoFile, FuncName, BattleIndex)
end
_G.Field = {}
function Field.Get(CharIndex, Field)
end
function Field.Set(CharIndex, Field, Value)
end

_G.NL = {}

function NL.CreateNPC(Dofile, InitFuncName)
end

function NL.DelNpc(NpcIndex)
end

function NL.CreateArgNpc(Type, Arg, Name, Image, Map, Floor, Xpos, Ypos, Dir, ShowTime)
end

function NL.SetArgNpc(NpcIndex, NewArg)
end

_G.NLG = {}

function NLG.TalkToMap(Map, Floor, TalkerIndex, Msg, FontColor, FontSize)
end
