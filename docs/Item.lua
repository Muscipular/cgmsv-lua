---@meta _

---获取道具对象index的指定信息。
---@param ItemIndex  number 目标的 道具index。
---@param Dataline  number 说指定的对象实例信息栏位，具体栏位常量请查看附录。
---@return number|string @指定信息栏位的值
function Item.GetData(ItemIndex,Dataline) end

---设置道具对象index的指定信息。
---@param ItemIndex  number 目标的 道具对象index。
---@param Dataline  number 说指定的对象实例信息栏位，具体栏位常量请查看附录。
---@param Data  number|string 新的值
---@return number @0为失败，1为成功。
function Item.SetData(ItemIndex,Dataline,Data) end

---获取道具对象index的指定信息。
---@param ItemIndex  number 目标的 道具index。
---@param Dataline  string 说指定的对象实例信息栏位
---@return number|string @指定信息栏位的值
function Item.GetExtData(ItemIndex,Dataline) end

---设置道具对象index的指定信息。
---@param ItemIndex  number 目标的 道具对象index。
---@param Dataline  string 说指定的对象实例信息栏位
---@param Data  number|string 新的值
---@return number @0为失败，1为成功。
function Item.SetExtData(ItemIndex,Dataline,Data) end

---发送更新道具的封包给关联的玩家。
---@param CharIndex  number 目标对象index。
---@param Slot  number 指定背包的位置，如果为-1则遍历所有的道具。
function Item.UpItem(CharIndex, Slot) end

---删除道具并且发送封包通知玩家。
---@param CharIndex  number 目标对象index。
---@param ItemIndex  number 目标道具index。
---@param Slot  number 指定背包的位置。
---@return number @道具删除成功返回1,失败返回0或负数。
function Item.Kill(CharIndex, ItemIndex, Slot) end

---创建新的道具类型
---@param type number 道具类型编号
---@param name string 道具类型名称
---@param defaultImage number 未鉴定时图档
---@param place number 装备位置
---@param flags number 武器类型。1-剑，2-斧，4-枪，8-杖，16-弓，32-小刀，64-回力镖，128-空手，255-所有武器，投掷类武器=16+32+64=112
---@return number @成功返回1
function Item.CreateNewItemType(type, name, defaultImage, place, flags) end

---获得新得道具类型信息
---@param type number 道具类型编号
---@return number   @由CreateNewItemType输入的type
---@return string   @由CreateNewItemType输入的name
---@return number   @由CreateNewItemType输入的place
---@return number   @由CreateNewItemType输入的defaultImage
---@return number   @由CreateNewItemType输入的flags
function Item.GetNewItemType(type) end

---获取扩展自定义物品类别职业装备等级
---@param job number 职业ID
---@param type number 道具类型
---@return number @该物品类别的职业装备等级
function Item.GetItemTypeEquipLevelForJob(job, type) end

---扩展自定义物品类别职业装备等级
---@param job number 职业ID
---@param type number 道具类型
---@param level number 职业装备等级
---@return boolean @成功返回true
function Item.SetItemTypeEquipLevelForJob(job, type, level) end

---获取道具的userdata
---@param ItemIndex number 道具index
---@return number @道具的userdata
function Item.GetCharPointer(ItemIndex) end

---定义道具的userdata
---@param ItemIndex number 道具index
---@param val userdata 
---@return number @成功返回0
function Item.SetCharPointer(ItemIndex, val) end

---移除道具的userdata
---@param ItemIndex number 道具index
---@return number @道具的userdata
function Item.RemoveCharPointer(ItemIndex) end

---获取itemId的名字
---@param ItemId number 道具id
---@return number @string 道具名
function Item.GetNameFromNumber(ItemId) end

---删除道具
---@param ItemIndex number 道具index
---@return number @成功返回0
function Item.UnlinkItem(ItemIndex) end

---判断道具是否是武器
---@param ItemIndex number 道具index
---@return number @是武器时返回1
function Item.IsWeaponType(ItemIndex) end

---制作新物品，新物品是无主物品
---@param itemId number 道具id
---@return number @number 返回道具itemindex
function Item.MakeItem(itemId) end

---获取道具类型宠物装备位置
---@param type number 道具类型
---@param place number 位置，0-4，参考CONST.宠道栏_*
---@return number @能装备为返回1
function Item.GetPetEquipPlace(type, place) end


---获取道具类型宠物装备位置
---@param type number 道具类型
---@param place number 位置，0-4，参考CONST.宠道栏_*
---@param enable number|boolean 能否装备
---@return number @成功返回1
function Item.SetPetEquipPlace(type, place, enable) end

---获取道具所有者的CharIndex
---@param itemIndex number ItemIndex
---@return number @道具所有者的CharIndex
function Item.GetOwner(itemIndex) end
