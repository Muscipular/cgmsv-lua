---@meta _

---获取指定宠物的指定属性的成长值，使用该函数减去FullArtRank函数的结果，就是宠物的档数信息。
---@param PetIndex  number 目标宠物对象index。
---@param ArtType  number 要查看的属性，具体请参考附录的宠物常量。
---@return number @指定属性的成长值，数值型。
function Pet.GetArtRank(PetIndex, ArtType) end

---设置指定宠物的指定属性的成长值，但是宠物的bp分布不会根据这个修改而改变。
---@param PetIndex  number 目标宠物对象index。
---@param ArtType  number 要查看的属性，具体请参考附录的宠物常量。
---@param Value  number 要设置为的成长值。
---@return number @0成功，其他失败。
function Pet.SetArtRank(PetIndex, ArtType, Value) end

---获取指定宠物的指定属性的满档成长值。
---@param PetIndex  number 目标宠物对象index。
---@param ArtType  number 要查看的属性，具体请参考附录的宠物常量。
---@return number @指定属性的成长值。
function Pet.FullArtRank(PetIndex, ArtType) end

---回炉指定宠物，让宠物回到1级状态(属性、升级点)，但是成长档数不变。 该函数配合SetArtRank一起使用可以自定义宠物的档数，并且重新分配bp。
---@param PlayerIndex  number 目标对象index。
---@param PetIndex  number 目标宠物对象index。
---@return number @成功返回0
function Pet.ReBirth(PlayerIndex, PetIndex) end

---发送宠物状态封包给客户端，并且能重新计算宠物等级等信息。
---@param PlayerIndex  number 目标对象index。
---@param PetIndex  number 目标宠物对象index。
function Pet.UpPet(PlayerIndex, PetIndex) end

---获取宠物的拥有者对象index。 注意:如果宠物丢在地上,或者主人已经下线返回值为-1
---@param PetIndex  number 目标宠物对象index。
---@return number @返回-1为未找到，否则为对象index。
function Pet.GetOwner(PetIndex) end

---给宠物增加新的技能，如果宠物技能未满，则成功，否则不会增加技能。
---@param PetIndex  number 目标宠物对象index。
---@param SkillID  number 技能的ID，这里是指Tech.txt文件中定义的ID
---@return number @成功增加返回1，失败返回0。
function Pet.AddSkill(PetIndex, SkillID) end

---给宠物删除已有的指定技能。
---@param PetIndex  number 目标宠物对象index。
---@param SkillSlot  number 技能的位置，从0开始计算。
---@return number @成功增加返回1，失败返回0。
function Pet.DelSkill(PetIndex, SkillSlot) end

---获取宠物指定位置的技能ID。
---@param PetIndex  number 目标宠物对象index。
---@param SkillSlot  number 技能的位置，从0开始计算。
---@return number @成功返回技能ID，失败返回-1。
function Pet.GetSkill(PetIndex, SkillSlot) end

---获取宠物对象的唯一标识。
---@param PetIndex  number 目标宠物对象index。
---@return string @返回的结果是字符串 | 返回"-1"表示非宠物或无法获取，否则为宠物全局唯一标识。
function Pet.GetUUID(PetIndex) end


---移动宠物装备
---@param charIndex number 目标对象index。
---@param fromPetSlot number 0=玩家,1-5为宠物栏位
---@param fromItemSlot number 道具栏位置
---@param toPetSlot number  0=玩家,1-5为宠物栏位
---@param toItemSlot number 道具栏位置
function Pet.MoveItem(charIndex, fromPetSlot, fromItemSlot, toPetSlot, toItemSlot) end

