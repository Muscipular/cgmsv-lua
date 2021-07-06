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
---@return number 成功返回1，失败则返回0。
function Char.DelItem(CharIndex, ItemID, Amount)
end

---@param CharIndex number
---@param ItemID number
---@param Amount number
---@return number 目标道具index，失败则返回负数。
function Char.GiveItem(CharIndex, ItemID, Amount)
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

NLG = {}
function NLG.ShowWindowTalked(ToIndex, WinTalkIndex, WindowType, ButtonType, SeqNo, Data)
end

function NLG.CanTalk(CharIndex, TargetCharIndex)
end

function NLG.UpChar(CharIndex)
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
