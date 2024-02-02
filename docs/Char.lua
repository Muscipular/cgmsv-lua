---@meta _

---获取对象index的指定信息。
---@param charIndex number 目标的 对象index
---@param dataIndex number 说指定的对象实例信息栏位，具体栏位常量请查看附录
---@return number|string @指定信息栏位的值
function Char.GetData(charIndex, dataIndex) end

---设置对象index的指定信息。
---@param charIndex number 目标的 对象index
---@param dataIndex number 说指定的对象实例信息栏位，具体栏位常量请查看附录
---@param value string|number 新的值
---@return number @0为失败，1为成功
function Char.SetData(charIndex, dataIndex, value) end

---获取目标对象的NowEvent任务旗标。
---@param charIndex number 目标的 对象index。
---@param flag number 任务旗标。
---@return number @则返回旗标状态。
function Char.NowEvent(charIndex, flag, value) end

---设置目标对象的NowEvent任务旗标。
---@param charIndex number 目标的 对象index。
---@param flag number 任务旗标。
---@param value number 0|1 设置的目标旗标状态[如果该参数为0，则清空目标的该旗标的NowEvent状态，如果参数为1，则设置该旗标为NowEvent状态]
function Char.NowEvent(charIndex, flag, value) end

---设置目标对象的EndEvent任务旗标。
---@param charIndex number 目标的 对象index。
---@param flag number 任务旗标。
---@param value number 0|1 设置的目标旗标状态[如果该参数为0，则清空目标的该旗标的EndEvent状态，如果参数为1，则设置该旗标为EndEvent状态]
function Char.EndEvent(charIndex, flag, value) end

---获取目标对象的EndEvent任务旗标。
---@param charIndex number 目标的 对象index。
---@param flag number 任务旗标。
---@return number @返回旗标状态。
function Char.EndEvent(charIndex, flag) end

---查找角色是否拥有ID是ItemID的道具。
---@param charIndex number 目标的 对象index。
---@param itemID number 道具ID
---@return number @如果有则返回第一个结果的道具栏位置，如果没有则返回-1。
function Char.FindItemId(charIndex, itemID) end

---为目标增加金钱。
---@param charIndex number 目标的 对象index。
---@param amount number 增加的数量，负数为减少。
---@return number @
function Char.AddGold(charIndex, amount) end

---删除目标对象道具。
---@param CharIndex number 目标的 对象index。
---@param ItemID number 道具ID。
---@param Amount number 道具的数量。
---@param ShowMsg? boolean 是否显示系统信息
---@return number @成功返回1，失败则返回0。
function Char.DelItem(CharIndex, ItemID, Amount, ShowMsg) end

---给予目标对象道具。
---@param CharIndex number 目标的 对象index。
---@param ItemID number 道具ID。
---@param Amount number 道具的数量。
---@param ShowMsg? boolean 是否显示系统信息
---@return number @目标道具index，失败则返回负数。
function Char.GiveItem(CharIndex, ItemID, Amount, ShowMsg) end

---检测对象身上是否有目标道具。
---@param CharIndex number 目标的 对象index。
---@param ItemID number 道具ID。
---@return number @如果目标有该道具，则返回该道具index，否则返回-1。
function Char.HaveItem(CharIndex,ItemID) end

---检测对象身上的已经有道具的道具栏位数量。
---@param CharIndex number 目标的 对象index。
---@return number @目标道具栏的已经使用的栏位数量，无任何道具返回0，全部都有道具返回20。
function Char.ItemSlot(CharIndex) end

---检测对象身上目标道具的数量。
---@param charIndex number 目标的 对象index。
---@param ItemID number 道具ID。
---@return number @如果目标有该道具，则返回拥有的该道具的数量，否则返回0。
function Char.ItemNum(charIndex, ItemID) end

---检测对象身上是否有目标宠物。
---@param charIndex number 目标的 对象index。
---@param petId number 宠物的ID
---@return number @如果目标有该宠物的宠物位置(0-4)，没有则返回-1，参数数据类型不对返回-2，对象index无效返回-3。
function Char.HavePet(charIndex, petId) end

---为对象增加一只等级为1成长随机的PetID的宠物。
---@param CharIndex number 目标的 对象index。
---@param PetID number 宠物的ID
---@return number @制作成功则返回目标宠物的对象index，否则返回-1，参数数据类型不对返回-2，对象index无效返回-3。
function Char.AddPet(CharIndex, PetID) end

---为对象增加一只等级为1的PetID宠物。
---@param CharIndex number 目标的 对象index。
---@param PetID number 宠物的ID
---@param FullBP? number 1表示制作满档宠物，0表示档数随机，不填写该参数则档数随机
---@return number @制作成功则返回目标宠物的对象index，否则返回-1，参数数据类型不对返回-2，对象index无效返回-3。
function Char.GivePet(CharIndex,PetID,FullBP) end

---获取目标位置的宠物对象index。
---@param CharIndex number 目标的 对象index。
---@param Slot number 宠物的位置，范围0-4。
---@return number @如果目标有该宠物的宠物对象index，没有则返回-1，参数数据类型不对返回-2，对象index无效返回-3，位置超出范围(0-4)返回-4。
function Char.GetPet(CharIndex, Slot) end

---删除对象身上满足条件的宠物。
---@param CharIndex number 目标的 对象index。
---@param PetID number 宠物的ID
---@param Level number 宠物的等级。
---@param LevelSetting number 0为删除一只小于等于Level的宠物，1为删除一只等于Level的宠物，2为删除一只大于等于Level的宠物。
---@return number @制作删除返回0，否则返回-1，参数数据类型不对返回-2，对象index无效返回-3。
function Char.DelPet(CharIndex, PetID, Level, LevelSetting) end

---删除目标指定栏位的宠物。
---@param CharIndex number 目标的 对象index。
---@param Slot number 宠物的位置，范围0-4。
---@return number @成功删除返回1，失败返回0，宠物位置超出范围(0-4)返回-1，参数数据类型不对返回-2，对象index无效返回-3。
function Char.DelSlotPet(CharIndex, Slot) end

---检测对象身的宠物数量。
---@param charIndex number 目标的 对象index。
---@return number @返回目标的宠物数量，范围0-5。
function Char.PetNum(charIndex) end

---丢出目标指定栏位的宠物。
---@param charIndex number 目标的 对象index。
---@param slot number 宠物的位置，范围0-4。
---@return number @成功丢出返回1，失败返回0，宠物的位置范围错误(0-4)返回-1，参数数据类型不对返回-2，对象index无效返回-3，按位置获取的宠物错误返回-4。
function Char.DropPet(charIndex, slot) end

---将对象传送到指定坐标处。
---@param CharIndex  number 目标的 对象index。
---@param MapType  number MapID。
---@param FloorID  number FloorID。
---@param X  number X坐标
---@param Y  number Y坐标
---@return boolean @成功返回true
function Char.Warp(CharIndex, MapType, FloorID, X, Y) end

---获取对象的组队中的玩家人数。
---@param CharIndex  number 目标的 对象index。
---@return number @组队中的玩家人数，无组队返回-1，否则返回玩家人数，获取失败返回0，参数数据类型不对返回-2，对象index无效返回-3。
function Char.PartyNum(CharIndex) end

---获取对象的组队中的指定对象。
---@param CharIndex  number 目标的 对象index。
---@param Slot  number 团队中的位置，取值0-4
---@return number @返回指定位置的玩家的对象index，如果没有玩家则返回-1，获取失败返回0，参数数据类型不对返回-2，对象index无效返回-3，如果团队中的位置超过范围(0-4)返回-4。
function Char.GetPartyMember(CharIndex,Slot) end

---解散玩家的团队。
---@param CharIndex  number 目标对象index。
---@return number @返回1代表成功，返回0失败，参数数据类型不对返回-2，对象index无效返回-3。
function Char.DischargeParty(CharIndex) end

---获取等级Level-1到等级Level所需的经验。
---@param Level  number 等级Level。
---@return number @Level-1到等级Level所需的经验，传入的等级参数小于等于0则返回-1，参数数据类型不对返回-2。
function Char.GetLevelExp(Level) end

---获取对象的下一级所需经验。
---@param CharIndex  number 目标的 对象index。
---@return number @下一级所需经验，传入的等级参数小于等于0则返回-1，参数数据类型不对返回-2，对象index无效返回-3。
function Char.LevelExp(CharIndex) end

---获取对象的下一级所需经验。
---@param CharIndex  number 目标的 对象index。
---@return number @下一级所需经验，传入的等级参数小于等于0则返回-1，参数数据类型不对返回-2，对象index无效返回-3。
function Char.GetNextExp(CharIndex) end

---为目标玩家增加指定技能（指定初始经验）。
---@param CharIndex  number 目标的 对象index。
---@param SkillID  number 技能的ID，对应Skill.txt的id。
---@param SkillExp?  number 技能的初始经验值，如果不写则为0。
---@param ShowMsg?  boolean 是否显示系统信息。
---@return number @如果成功则返回增加的技能栏的位置，范围0-14，如果失败则返回-1，参数数据类型不对返回-2，对象index无效返回-3，技能的ID错误返回-4。
function Char.AddSkill(CharIndex,SkillID,SkillExp,ShowMsg) end

---删除目标玩家的指定技能。
---@param CharIndex  number 目标的 对象index。
---@param SkillID  number 技能的ID，对应Skill.txt的id。
---@param ShowMsg?  boolean 是否显示系统信息。
---@return number @如果成功删除技能则返回该技能原本的技能栏的位置，范围0-14，如果失败则返回-1。 |  | 如果玩家没有该技能，也返回-1。 |  | 参数数据类型不对返回-2，对象index无效返回-3，技能的ID错误返回-4。
function Char.DelSkill(CharIndex,SkillID,ShowMsg) end

---获取指定玩家的指定技能位置的技能等级。
---@param CharIndex  number 目标的 对象index。
---@param Slot  number 技能位置，可用Char.HaveSkill来获取位置。
---@return number @成功返回技能等级,失败返回-1，参数数据类型不对返回-2，对象index无效返回-3，技能的位置错误返回-4。
function Char.GetSkillLevel(CharIndex,Slot) end

---获取指定玩家的指定技能位置的技能等级。
---@param CharIndex  number 目标的 对象index。
---@param Slot  number 技能位置，可用Char.HaveSkill来获取位置。
---@return number @成功返回技能等级,失败返回-1，参数数据类型不对返回-2，对象index无效返回-3，技能的位置错误返回-4。
function Char.GetSkillLv(CharIndex,Slot) end

---获取指定玩家的指定技能的位置。
---@param CharIndex  number 目标的 对象index。
---@param SkillID  number 技能ID，与skill.txt内容相对应。
---@return number @返回-1代表失败，其他为技能栏位置，参数数据类型不对返回-2，对象index无效返回-3，技能的ID错误返回-4。
function Char.HaveSkill(CharIndex,SkillID) end

---获取指定玩家的指定位置的技能ID。
---@param CharIndex  number 目标的 对象index。
---@param Slot  number 技能位置，不能大于人物自身的技能栏位数量。
---@return number @返回-1代表失败，其他为技能ID，与skill.txt内容相对应，参数数据类型不对返回-2，对象index无效返回-3，技能位置超出范围返回-4。
function Char.GetSkillID(CharIndex,Slot) end

---获取指定玩家的指定位置的技能ID。
---@param CharIndex  number 目标的 对象index。
---@param Slot  number 技能位置，不能大于人物自身的技能栏位数量。
---@return number @返回-1代表失败，其他为技能ID，与skill.txt内容相对应，参数数据类型不对返回-2，对象index无效返回-3，技能位置超出范围返回-4。
function Char.GetSkillId(CharIndex,Slot) end

---获取指定玩家的指定技能位置的技能经验。
---@param CharIndex  number 目标的 对象index。
---@param Slot  number 技能位置，可用Char.HaveSkill来获取位置。
---@return number @成功返回技能经验,失败返回-1，参数数据类型不对返回-2，对象index无效返回-3，技能的位置错误返回-4。
function Char.GetSkillExp(CharIndex,Slot) end

---获取指定玩家的指定技能位置的技能等级。
---@param CharIndex  number 目标的 对象index。
---@param Slot  number 技能位置，可用Char.HaveSkill来获取位置。
---@param Level  number 新的技能等级。
---@param ShowMsg?  boolean 是否显示系统信息。
---@return number @成功返回新技能等级,失败返回-1，传入的参数数据类型不对返回-2，对象index无效返回-3，技能的位置错误返回-4，传入的新等级小于1则返回-5。
function Char.SetSkillLevel(CharIndex,Slot,Level,ShowMsg) end

---获取指定玩家的指定技能位置的技能经验。
---@param CharIndex  number 目标的 对象index。
---@param Slot  number 技能位置，可用Char.HaveSkill来获取位置。
---@param EXP  number 新的技能经验。
---@param ShowMsg?  boolean 是否显示系统信息。
---@return number @成功返回新的技能经验,失败返回-1，传入的参数数据类型不对返回-2，对象index无效返回-3，技能的位置错误返回-4，传入的新经验小于1则返回-5。
function Char.SetSkillExp(CharIndex,Slot,EXP,ShowMsg) end

---获取指定玩家的家族ID。
---@param CharIndex  number 目标的 对象index。
---@return number @成功返回玩家家族ID，返回-1代表没有家族，参数数据类型不对返回-2，对象index无效返回-3。
function Char.GetGuildID(CharIndex) end

---获取指定玩家激活的称号ID。
---@param CharIndex  number 目标的 对象index。
---@return number @成功返回玩家对象激活的称号ID，返回-1代表失败，参数数据类型不对返回-2，对象index无效返回-3。
function Char.GetTitle(CharIndex) end

---获取指定玩家当前战斗index。
---@param CharIndex  number 目标的 对象index。
---@return number @成功返回当前战斗index，返回-1代表没有战斗，参数数据类型不对返回-2，对象index无效返回-3。
function Char.GetBattleIndex(CharIndex) end

---获取指定对象的对象指针，指针为内存地址，如果不清楚如何使用请勿使用。
---@param CharIndex  number 目标的 对象index。
---@return number @返回-1代表失败，其他为对象的内存地址。
function Char.GetCharPointer(CharIndex) end

---获取玩家对象出租屋中指定位置的宠物对象index。
---@param CharIndex  number 目标的 对象index。
---@param Slot  number 出租屋中的位置，范围0-4。
---@return number @如果目标有该宠物的宠物对象index，没有则返回-1，参数数据类型不对返回-2，对象index无效返回-3，宠物的位置范围错误返回-4。
function Char.GetHousePet(CharIndex,Slot) end

---获取玩家对象银行中指定位置的宠物对象index。
---@param CharIndex  number 目标的 对象index。
---@param Slot  number 银行中的位置，范围0-4。
---@return number @如果目标有该宠物的宠物对象index，没有则返回-1，参数数据类型不对返回-2，对象index无效返回-3，宠物的位置范围错误返回-4。
function Char.GetPoolPet(CharIndex,Slot) end

---获取玩家对象出租屋中指定位置的道具对象index。
---@param CharIndex  number 目标的 对象index。
---@param Slot  number 出租屋中的位置，范围0-19。
---@return number @如果目标有则返回道具对象index，没有则返回-1，参数数据类型不对返回-2，对象index无效返回-3，道具的位置范围错误返回-4。
function Char.GetHouseItem(CharIndex,Slot) end

---获取玩家对象出租屋中指定位置的道具对象index。
---@param CharIndex  number 目标的 对象index。
---@param Slot  number 银行中的位置，韩服范围0-19，台服范围0-39，国服范围0-79。
---@return number @如果目标有则返回道具对象index，没有则返回-1，参数数据类型不对返回-2，对象index无效返回-3，银行中道具位置范围错误返回-4。
function Char.GetPoolItem(CharIndex,Slot) end

---获取玩家对象玩家是否在打卡状态。
---@param CharIndex  number 目标的 对象index。
---@return number @1在打卡，0不在打卡，参数数据类型不对返回-2，对象index无效返回-3。
function Char.IsFeverTime(CharIndex) end

---开始玩家打卡状态。
---@param CharIndex  number 目标的 对象index。
---@return number @1打卡成功，0打卡失败，参数数据类型不对返回-2，对象index无效返回-3。
function Char.FeverStart(CharIndex) end

---结束玩家打卡状态。
---@param CharIndex  number 目标的 对象index。
---@return number @1结束打卡成功，0结束打卡失败，参数数据类型不对返回-2，对象index无效返回-3。
function Char.FeverStop(CharIndex) end

---为对象index设置行走前事件的回调函数，对象在行走前会触发该函数，由Lua引擎将Callback的参数传递给指定的Callback并执行。
---[@group Char.SetWalkPreEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[CharWalkPreCallBack]
---@param CharIndex  number 设置的对象index。
function Char.SetWalkPreEvent(Dofile,FuncName,CharIndex) end

---WalkPreEvent回调函数
---[@group Char.SetWalkPreEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@return number @返回1执行行走，返回0行走取消。
function CharWalkPreCallBack(CharIndex) end

---为对象index设置行走后事件的回调函数，对象在行走后会触发该函数，由Lua引擎将Callback的参数传递给指定的Callback并执行。
---[@group Char.SetWalkPostEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[CharWalkPostCallBack]
---@param CharIndex  number 设置的对象index。
---@return number @成功返回0
function Char.SetWalkPostEvent(Dofile,FuncName,CharIndex) end

---WalkPostEvent回调函数
---[@group Char.SetWalkPostEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
function CharWalkPostCallBack(CharIndex) end

---为对象index设置覆盖其他对象后事件的回调函数，对象在覆盖其他对象后会触发该函数，由Lua引擎将Callback的参数传递给指定的Callback并执行。
---[@group Char.SetPostOverEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[PostOverEventCallBack]
---@param CharIndex  number 设置的对象index。
function Char.SetPostOverEvent(Dofile,FuncName,CharIndex) end

---PostOverEvent回调函数
---[@group Char.SetPostOverEvent]
---@param CharIndex  number 下层的对象index，该值由Lua引擎传递给本函数。
---@param TargetCharIndex  number 上层的对象index，该值由Lua引擎传递给本函数。
function PostOverEventCallBack(CharIndex, TargetCharIndex) end

---为对象index设置循环事件的回调函数，事件会每隔Interval时间循环触发该函数，由Lua引擎将Callback的参数传递给指定的Callback并执行。
---[@group Char.SetLoopEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[CharLoopCallBack]
---@param CharIndex  number 设置的对象index。
---@param Interval  number 循环间隔，单位毫秒。
function Char.SetLoopEvent(Dofile,FuncName,CharIndex,Interval) end

---LoopEvent回调函数
---[@group Char.SetLoopEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
function CharLoopCallBack(CharIndex) end

---为对象index设置对话开启事件的回调函数，对象在开启对话的时候会触发该函数，由Lua引擎将Callback的参数传递给指定的Callback并执行。
---[@group Char.SetTalkedEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[CharWalkPreCallBack]
---@param CharIndex  number 设置的对象index。
function Char.SetTalkedEvent(Dofile,FuncName,CharIndex) end

---TalkedEvent回调函数
---[@group Char.SetTalkedEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。（一般是NPC）
---@param TalkerCharIndex  number 触发事件的对象index，该值由Lua引擎传递给本函数。（一般是玩家）
function CharTalkedCallBack(CharIndex, TalkerCharIndex) end

---为对象index设置对话事件的回调函数，对象在进行对话交互的时候会触发该函数，由Lua引擎将Callback的参数传递给指定的Callback并执行。
---[@group Char.SetWindowTalkedEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[CharWindowTalkedCallBack]
---@param CharIndex  number 设置的对象index。
function Char.SetWindowTalkedEvent(Dofile,FuncName,CharIndex) end

---WindoxTalkedEvent回调函数
---[@group Char.SetWindowTalkedEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。（一般是NPC）
---@param TalkerCharIndex  number 触发事件的对象index，该值由Lua引擎传递给本函数。（一般是玩家）
---@param SeqNo  number 来源对话框的ID，该值与NLG.ShowWindowTalked中的定义应该对应。
---@param Select  number 玩家所按下的按钮的值或选择框中的选项的值。
---@param Data  string 客户端所传递回来的值，这个值将根据不同的窗口类型而不同。
function CharWindowTalkedCallBack(CharIndex, TalkerCharIndex,SeqNo,Select,Data) end

---为对象index设置丢弃道具事件的回调函数，对象在丢弃道具的时候会触发该函数，由Lua引擎将Callback的参数传递给指定的Callback并执行。
---[@group Char.SetItemPutEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[CharItemPutCallBack]
---@param CharIndex  number 设置的对象index。
function Char.SetItemPutEvent(Dofile,FuncName,CharIndex) end

---ItemPutEvent回调函数
---[@group Char.SetItemPutEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。（一般是NPC）
---@param ItemIndex  number 被丢弃的道具index，该值由Lua引擎传递给本函数。（一般是玩家）
function CharItemPutCallBack(CharIndex, ItemIndex) end

---疑似限时道具
---[@group Char.SetWatchEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[CharWatchCallBack]
---@param CharIndex  number 设置的对象index。
function Char.SetWatchEvent(Dofile, FuncName, CharIndex) end

---WatchEvent回调函数
---[@group Char.SetWatchEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。（一般是NPC）
---@param ItemIndex  number 被丢弃的道具index，该值由Lua引擎传递给本函数。（一般是玩家）
function CharWatchCallBack(CharIndex, ItemIndex) end

---解除walkpostevent
---@param charIndex  number 目标的 对象index。
function Char.UnsetWalkPostEvent(charIndex) end

---解除WalkPreEvent
---@param charIndex  number 目标的 对象index。
function Char.UnsetWalkPreEvent(charIndex) end

---解除PostOverEvent
---@param charIndex  number 目标的 对象index。
function Char.UnsetPostOverEvent(charIndex) end

---解除LoopEvent
---@param charIndex  number 目标的 对象index。
function Char.UnsetLoopEvent(charIndex) end

---解除TalkedEvent
---@param charIndex  number 目标的 对象index。
function Char.UnsetTalkedEvent(charIndex) end

---解除WindowTalkedEvent
---@param charIndex  number 目标的 对象index。
function Char.UnsetWindowTalkedEvent(charIndex) end

---解除ItemPutEvent
---@param charIndex  number 目标的 对象index。
function Char.UnsetItemPutEvent(charIndex) end

---解除WatchEvent
---@param charIndex  number 目标的 对象index。
function Char.UnsetWatchEvent(charIndex) end

---检查角色是否加入公会
---@param CharIndex  number 目标的 对象index。
---@return number @如果目标有工会，则返回1，没有则返回-1。
function Char.HaveGuild(CharIndex) end

---刷新玩家的称号，如阿蒙。
---@param CharIndex  number 目标的 对象index。
---@return number @刷新玩家称号，返回-1失败，参数数据类型不对返回-2，对象index无效返回-3。
function Char.CheckTitle(CharIndex) end

---获取自定义数据（保存到数据库）
---@param charIndex number 目标的 对象index。
---@param dataIndex string 信息储存的位置，自定义
---@return string|number|nil @获得指定位置的字符串
function Char.GetExtData(charIndex, dataIndex) end

---设置自定义数据（保存到数据库）
---@param charIndex number 目标的 对象index。
---@param dataIndex string 信息储存的位置，自定义
---@param value string|number|nil 存储的信息
---@return number @
function Char.SetExtData(charIndex, dataIndex, value) end

---获取自定义数据（不保存到数据库）
---@param charIndex number 目标的 对象index。
---@param dataIndex string 信息储存的位置，自定义
---@return string|number|nil @获得指定位置的字符串
function Char.GetTempData(charIndex, dataIndex) end

---设置自定义数据（不保存到数据库）
---@param charIndex number 目标的 对象index。
---@param dataIndex string 信息储存的位置，自定义
---@param value string|number|nil 存储的信息
---@return number @
function Char.SetTempData(charIndex, dataIndex, value) end

---角色是否有符合itemId条件的道具
---@param charIndex number 目标的 对象index。
---@param itemId number 道具ID
---@return number @第一个符合条件的itemIndex
function Char.HaveItemID(charIndex, itemId) end

---角色是否有符合itemId条件的道具，并返回位置
---@param charIndex number 目标的 对象index。
---@param itemId number 道具ID
---@return number @第一个符合条件的道具栏
function Char.HaveItemPos(charIndex, itemId) end

---获得指定道具栏的itemIndex
---@param charIndex number 目标的 对象index。
---@param slot number 道具栏位置
---@return number @如果目标栏位有道具，则返回道具index，否则返回 -1: 对象指针错误 -2: 道具栏无道具 -3: 超出范围。
function Char.GetItemIndex(charIndex, slot) end

---设置指定道具栏的道具为itemIndex,可与Item.MakeItem(itemId)联用
---@param charIndex number 目标的 对象index。
---@param slot number 道具栏位置
---@param itemIndex number 道具的 index
---@return number @成功所在栏位
function Char.SetItemIndex(charIndex, slot, itemIndex) end

---设置银行指定道具栏的道具为itemIndex，可与Item.MakeItem(itemId)联用
---@param charIndex number 目标的 对象index。
---@param slot number 道具栏位置
---@param itemIndex number 道具的 index
---@return number @成功返回0
function Char.SetPoolItem(charIndex, slot, itemIndex) end

---删除银行指定道具栏的道具
---@param charIndex number 目标的 对象index。
---@param slot number 道具栏位置
---@return number @成功返回0
function Char.RemovePoolItem(charIndex, slot) end

---把道具交易给指定玩家
---@param fromChar number 从谁身上交出去 对象index
---@param slot number 道具栏位置，范围8-27
---@param toChar number 交易给谁 对象index
---@return number @接收者所在的栏位，少于0时失败
function Char.TradeItem(fromChar, slot, toChar) end

---根据位置删除物品
---@param charIndex number 目标的 对象index。
---@param slot number 道具栏位置
---@return number @成功返回0
function Char.DelItemBySlot(charIndex, slot) end

---移动物品
---@param charIndex number 目标的 对象index。
---@param fromSlot number 移动那个物品，取值0-27
---@param toSlot number 移动到那个位置, 取值0-27
---@param amount number 数量，整体移动取值可为-1
---@return number @成功返回0
function Char.MoveItem(charIndex, fromSlot, toSlot, amount) end

---查询角色身上金币数量
---@param charIndex number 目标的 对象index。
---@return number @角色身上金币数量
function Char.GetGold(charIndex) end

---更新角色状态信息
---@param charIndex number 目标的 对象index。
---@return number @成功返回0
function Char.UpCharStatus(charIndex) end

---移动角色、NPC
---@param charIndex number 目标的 对象index。
---@param walkArray number[] 移动列表，取值0-7对应 CONST里面的方向，不建议超过5次移动
---@return number @成功返回1
function Char.MoveArray(charIndex, walkArray) end

---获取一个唯一ID
---@param charIndex number 目标的 对象index。
---@return number @角色UUID
function Char.GetUUID(charIndex) end

---计算技能所需的魔法
---@param charIndex number 目标的 对象index。
---@param techId number tech.txt中的ID
---@return number @techId释放需要的魔法值
function Char.CalcConsumeFp(charIndex, techId) end

---保存角色数据到数据库
---@param charIndex number 目标的 对象index。
---@return number @成功返回0
function Char.SaveToDb(charIndex) end

---查询角色家族中的称号ID
---@param charIndex number 目标的 对象index。
---@return number @返回-1代表没有家族，其他为玩家家族中的称号ID，参数数据类型不对返回-2，对象index无效返回-3。
function Char.GetGuildTitle(charIndex) end

---查询玩家称号index
---@param charIndex number 目标的 对象index。
---@return number @玩家称号index
function Char.GetTitleIndex(charIndex) end

---获得宠物enemyId
---@param charIndex number 目标的 对象index。
---@param slot number 宠物栏位置
---@return number @宠物enemyId
function Char.GetPetEnemyId(charIndex, slot) end

---设置宠物战斗状态
---@param charIndex number 目标的 对象index。
---@param slot number 宠物栏位置
---@param state number 宠物状态，对应CONST.PET_STATE_*
---@return number @成功返回1
function Char.SetPetDepartureState(charIndex, slot, state) end

---设置宠物战斗状态(批量)
---@param charIndex number 目标的 对象index。
---@param pet1State number 宠物状态，对应CONST.PET_STATE_*
---@param pet2State number 宠物状态，对应CONST.PET_STATE_*
---@param pet3State number 宠物状态，对应CONST.PET_STATE_*
---@param pet4State number 宠物状态，对应CONST.PET_STATE_*
---@param pet5State number 宠物状态，对应CONST.PET_STATE_*
---@return number @成功返回1
function Char.SetPetDepartureStateAll(charIndex, pet1State, pet2State, pet3State, pet4State, pet5State) end

---直接交易宠物
---@param fromChar number 从谁身上交出 CharIndex
---@param slot number 宠物栏位置，0-4
---@param toChar number 交易给谁 CharIndex
---@return number @成功所在的新栏位
function Char.TradePet(fromChar, slot, toChar) end

---移动宠物
---@param charIndex number 目标的 对象index。
---@param frslot number 移动前宠物栏位置，0-4
---@param toslot number 移动后宠物栏位置，0-4
---@return number @成功返回1
function Char.MovePet(charIndex, frslot, toslot) end

---加入组队，无视距离
---@param sourceIndex number 队员index
---@param targetIndex number 队长index
---@param flag? boolean 是否无视组队开关
---@return number @成功返回0
function Char.JoinParty(sourceIndex, targetIndex, flag) end

---离开队伍
---@param charIndex number 目标的 对象index。
---@return number @成功返回1
function Char.LeaveParty(charIndex) end

---获得角色道具栏套装的ID
---@param charIndex number 目标的 对象index。
---@param slot number 道具栏位置
---@return number @角色道具栏套装的ID
function Char.GetSuitId(charIndex, slot) end

---角色激活套装的数量
---@param charIndex number 目标的 对象index。
---@return number @套装数量
function Char.GetSuitCount(charIndex) end

---@class DummyCreateOptions
---@field mapType number 
---@field floor number 
---@field x number
---@field y number
---@field image number
---@field name string

---创建假人
---@param opt? DummyCreateOptions @
---@return number @假人index
function Char.CreateDummy(opt) end

---检测是否假人
---@param charIndex number 目标的 对象index。
---@return number @true，假人，false，不是假人
function Char.IsDummy(charIndex) end

---标记为假人
---@param charIndex number 目标的 对象index。
---@return number @成功返回0
function Char.SetDummy(charIndex) end

---删除假人
---@param charIndex number 目标的 对象index。
---@return number @成功返回0
function Char.DelDummy(charIndex) end

---查看角色的出租房floor
---@param charIndex number 对象的index
---@return number @成功返回出租房floor，失败返回-1
function Char.GetMyRoomFloor(charIndex) end

---设置头顶技能图标
---@param charIndex number 对象的index
---@param skillNo number 图标旗标，取值0~15
---@return number @成功返回0
function Char.SetSkillAction(charIndex,?skillNo) end