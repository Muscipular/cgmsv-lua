---@meta _

---开启摆摊
---@param charIndex number 摆摊对象index。
---@param name string 商铺名字
---@param desc string 商铺描述
---@param itemPriceList table 售卖道具价格表
---@param petPriceList table 售卖道具价格表
function Stall.Start(charIndex, name, desc, itemPriceList, petPriceList) end

---关闭摆摊
---@param charIndex number 摆摊对象index。
function Stall.End(charIndex) end

---购买道具
---@param buyer number 购买对象index。
---@param seller number 摆摊对象index。
---@param pos number 摆摊对象道具栏的位置 0-19
function Stall.BuyItem(buyer, seller, pos) end

---购买宠物
---@param buyer number 购买对象index。
---@param seller number 摆摊对象index。
---@param pos number 摆摊对象宠物栏的位置 0-4
function Stall.BuyPet(buyer, seller, pos) end

---获得售卖道具的价格
---@param charIndex number 摆摊对象index。
---@param pos number 位置 0-19
function Stall.GetItemPrice(charIndex, pos) end

---获得售卖宠物的价格
---@param charIndex number 摆摊对象index。
---@param pos number 位置 0-4
function Stall.GetPetPrice(charIndex, pos) end
