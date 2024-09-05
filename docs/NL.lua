---@meta _

---获取引擎版本
---@return number @
function NL.Version() end

---打印错误信息
---@param s string 错误文本
function NL.PrintError(s) end

---使用Lua脚本创建NPC，并执行Dofile文件中的InitFuncName函数。
---[@group NL.CreateNPC]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string Init函数的名称,NPC创建后执行的函数,申明格式请参考下面的[InitCallBack]
---@return number @创建成功则返回 对象index, 失败则返回负数
function NL.CreateNPC(Dofile, InitFuncName) end

---CreateNPC的回调函数
---[@group NL.CreateNPC]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function InitCallBack(CharIndex) end

---删除用Lua创建的NPC，需要注意的是，删除NPC后本函数不会将NpcIndex的值设置为nil，请在函数后自行处理NpcIndex的值。
---@param NpcIndex  number 要删除的Npc的对象指针
---@return number @创建成功则返回 1, 失败则返回 0
function NL.DelNpc(NpcIndex) end

---直接创建data/npc.txt中支持的各种类型的npc，可以直接调用npc.txt支持的npc类型和相应的参数，并且可以获得创建的npc的对象。
---@param Type  string npc的类型文本（大小写敏感），如”Itemshop2”
---@param Arg  string 对应的npc类型的参数，即npc.txt中每个npc的最后一组参数
---@param Name  string npc显示的名字
---@param Image  number npc的图档编号
---@param Map  number npc所在的MapID
---@param Floor  number npc所在的FloorID
---@param Xpos  number npc所在的x坐标
---@param Ypos  number npc所在的y坐标
---@param Dir  number npc面朝的方向
---@return number @返回负数表示失败，大于0的正整数表示成功，并且该值为npc的对象索引值
function NL.CreateArgNpc(Type, Arg, Name, Image, Map, Floor, Xpos, Ypos, Dir) end

---直接创建data/npc.txt中支持的各种类型的npc，可以直接调用npc.txt支持的npc类型和相应的参数，并且可以获得创建的npc的对象。
---@param Type  string npc的类型文本（大小写敏感），如”Itemshop2”
---@param Arg  string 对应的npc类型的参数，即npc.txt中每个npc的最后一组参数
---@param Name  string npc显示的名字
---@param Image  number npc的图档编号
---@param Map  number npc所在的MapID
---@param Floor  number npc所在的FloorID
---@param Xpos  number npc所在的x坐标
---@param Ypos  number npc所在的y坐标
---@param Dir  number npc面朝的方向
---@param ShowTime  number 可选参数,NPC的显示时间,具体设置参考灵堂入口士兵
---@return number @返回负数表示失败，大于0的正整数表示成功，并且该值为npc的对象索引值
function NL.CreateArgNpc(Type, Arg, Name, Image, Map, Floor, Xpos, Ypos, Dir, ShowTime) end

---修改NL.CreateArgNpc创建的npc的参数
---@param NpcIndex  number npc的对象索引，一般为NL.CreateArgNpc的返回值
---@param NewArg  string 新的npc的参数
---@return number @返回负数代表失败，0表示成功，npc会自动刷新（注意，如果在有玩家触发了npc的时候修改npc的参数，可能会造成bug等影响，所以最好先隐藏NPC再修改）
function NL.SetArgNpc(NpcIndex, NewArg) end

---创建一个所有玩家登陆游戏时候自动触发的Lua函数。
---[@group NL.RegLoginEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，玩家登陆会自动触发FuncName的Lua函数，该函数的申明格式请参考[LoginEventCallBack]
function NL.RegLoginEvent(Dofile, InitFuncName) end

---LoginEvent的回调函数
---[@group NL.RegLoginEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function LoginEventCallBack(CharIndex) end

---创建一个所有玩家登出回记录点就会触发的Lua函数，玩家只有点击客户端”登出回记录点”按钮时才可触发该函数。
---[@group NL.RegLoginGateEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[LoginGateEventCallBack]
function NL.RegLoginGateEvent(Dofile, InitFuncName) end

---LoginGateEvent的回调函数
---[@group NL.RegLoginGateEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function LoginGateEventCallBack(CharIndex) end

---创建一个所有玩家登出游戏就会触发的Lua函数。
---[@group NL.RegLogoutEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[LogoutEventCallBack]
function NL.RegLogoutEvent(Dofile, InitFuncName) end

---LogoutEvent的回调函数
---[@group NL.RegLogoutEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function LogoutEventCallBack(CharIndex) end

---创建一个所有玩家说话就会触发的Lua函数，玩家在游戏中说话即可触发该事件，可以用来新建指令，GM命令等，同时可以对GM命令进行分级授权。
---[@group NL.RegTalkEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[TalkEventCallBack]
function NL.RegTalkEvent(Dofile, InitFuncName) end

---TalkEvent的回调函数
---[@group NL.RegTalkEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param Msg  string 话的内容，该值由Lua引擎传递给本函数。
---@param Color  number 说话颜色，该值由Lua引擎传递给本函数。
---@param Range  number 说话音量（范围），该值由Lua引擎传递给本函数
---@param Size  number 说话字体大小，该值由Lua引擎传递给本函数。
---@return number @返回0拦截说话内容，返回1正常发送
function TalkEventCallBack(CharIndex, Msg, Color, Range, Size) end

---创建一个所有玩家角色升级触发的Lua函数，玩家在游戏中角色升级后就可触发，可以用来在特定等级给予特定奖励，记录玩家冲级速度排行等。
---[@group NL.RegLevelUpEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[LevelUpCallBack]
function NL.RegLevelUpEvent(Dofile, InitFuncName) end

---LevelUpEvent的回调函数
---[@group NL.RegLevelUpEvent]
---@param CharIndex  number 宠物主人的index，该值由Lua引擎传递给本函数。
---@param PetIndex  number 宠物的index，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function LevelUpCallBack(CharIndex, PetIndex) end

---创建一个角色进入战斗即可触发的Lua函数。
---[@group NL.RegBattleStartEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[BattleStartEventCallBack]
function NL.RegBattleStartEvent(Dofile, InitFuncName) end

---BattleStartEvent的回调函数
---[@group NL.RegBattleStartEvent]
---@param BattleIndex  number 响应事件的战斗index，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function BattleStartEventCallBack(BattleIndex) end

---创建一个战斗结束即可触发的Lua函数。
---[@group NL.RegBattleOverEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[BattleOverEventCallBack]
function NL.RegBattleOverEvent(Dofile, InitFuncName) end

---BattleOverEvent的回调函数
---[@group NL.RegBattleOverEvent]
---@param BattleIndex  number 响应事件的战斗index，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function BattleOverEventCallBack(BattleIndex) end

---创建一个玩家通过传送点时触发的Lua函数，可以用来记录玩家的传送轨迹。
---[@group NL.RegWarpEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[WarpEventCallBack]
function NL.RegWarpEvent(Dofile, InitFuncName) end

---创建一个玩家通过传送点时触发的Lua函数，可以用来记录玩家的传送轨迹。
---[@group NL.RegWarpEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[WarpEventCallBack]
function NL.RegAfterWarpEvent(Dofile, InitFuncName) end

---WarpEvent的回调函数
---[@group NL.RegWarpEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param Ori_MapId  number 传送前的mapid，该值由Lua引擎传递给本函数。
---@param Ori_FloorId  number 传送前的floor id，该值由Lua引擎传递给本函数。
---@param Ori_X  number 传送前的x，该值由Lua引擎传递给本函数。
---@param Ori_Y  number 传送前的y，该值由Lua引擎传递给本函数。
---@param Target_MapId  number 传送后的mapid，该值由Lua引擎传递给本函数。
---@param Target_FloorId  number 传送后的floor id，该值由Lua引擎传递给本函数。
---@param Target_X  number 传送后的x，该值由Lua引擎传递给本函数。
---@param Target_Y  number 传送后的y，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function WarpEventCallBack(CharIndex, Ori_MapId, Ori_FloorId, Ori_X, Ori_Y, Target_MapId, Target_FloorId, Target_X, Target_Y) end

---创建一个所有玩家掉线就会触发的Lua函数。
---[@group NL.RegDropEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[DropEventCallBack]
function NL.RegDropEvent(Dofile, InitFuncName) end

---DropEvent的回调函数
---[@group NL.RegDropEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@return number @返回0即可。
function DropEventCallBack(CharIndex) end

---创建一个所有玩家角色更换称号即可触发的Lua函数。
---[@group NL.RegTitleChangedEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[TitleChangedCallBack]
function NL.RegTitleChangedEvent(Dofile, InitFuncName) end

---TitleChangedEvent的回调函数
---[@group NL.RegTitleChangedEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param Ori_Title  number 旧title id，该值由Lua引擎传递给本函数。
---@param New_Title  number 新title id，该值由Lua引擎传递给本函数。
---@return number @返回0正常切换称号,返回值小于0则拦截。
function TitleChangedCallBack(CharIndex, Ori_Title, New_Title) end

---创建一个对象获取战斗经验时触发的Lua函数。
---[@group NL.RegGetExpEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[GetExpEventCallBack]
function NL.RegGetExpEvent(Dofile, InitFuncName) end

---GetExpEvent的回调函数
---[@group NL.RegGetExpEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param Exp  number 获取的经验值，该值由Lua引擎传递给本函数。
---@return number @返回对象要获取的经验值，如不对经验值操作，请不要写return语句或者写return Exp; 这个函数比道具对经验的加成优先，也就是说道具加成的经验值是在本函数返回值得基础上计算的。
function GetExpEventCallBack(CharIndex, Exp) end

---创建一个对象获取战斗技能经验时触发的Lua函数。
---[@group NL.RegBattleSkillExpEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[GetBattleSkillExpEventCallBack]
function NL.RegBattleSkillExpEvent(Dofile, InitFuncName) end

---BattleSkillExpEvent的回调函数
---[@group NL.RegBattleSkillExpEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param SkillID  number 技能ID，该值由Lua引擎传递给本函数。
---@param Exp  number 获取的经验值，该值由Lua引擎传递给本函数。
---@return any @返回要获取的经验值，如不对经验值操作，请不要写return语句或者写return Exp; 这个函数比道具对经验的加成优先，也就是说道具加成的经验值是在本函数返回值得基础上计算的。
function GetBattleSkillExpEventCallBack(CharIndex, SkillID, Exp) end

---创建一个对象获取生产技能经验时触发的Lua函数。
---[@group NL.RegProductSkillExpEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[GetProductSkillExpEventCallBack]
function NL.RegProductSkillExpEvent(Dofile, InitFuncName) end

---GetProductSkillExpEvent的回调函数
---[@group NL.RegProductSkillExpEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param SkillID  number 技能ID，该值由Lua引擎传递给本函数。
---@param Exp  number 获取的经验值，该值由Lua引擎传递给本函数。
---@return any @返回要获取的经验值，如不对经验值操作，请不要写return语句或者写return Exp; 这个函数比道具对经验的加成优先，也就是说道具加成的经验值是在本函数返回值得基础上计算的。
function GetProductSkillExpEventCallBack(CharIndex, SkillID, Exp) end

---创建一个宠物升级触发的Lua函数，玩家宠物在游戏中升级后就可触发，可以用来在特定等级给予特定奖励，记录玩家宠物冲级速度排行等。
---[@group NL.RegPetLevelUpEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[LevelUpCallBack]
function NL.RegPetLevelUpEvent(Dofile, InitFuncName) end

---PetLevelUpEvent的回调函数
---[@group NL.RegPetLevelUpEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param PetIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@return number @返回0即可。
function LevelUpCallBack(CharIndex, PetIndex) end

---创建一个所有玩家离开战斗就会触发的Lua函数。
---[@group NL.RegBattleExitEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[BattleExitCallBack]
function NL.RegBattleExitEvent(Dofile, InitFuncName) end

---BattleExitEvent的回调函数
---[@group NL.RegBattleExitEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param BattleIndex  number 战斗Index，该值由Lua引擎传递给本函数。
---@param Type  number 离开战斗的方式，如果值为1则表示正常离开（包括战斗胜利、失败、逃跑、登出），如果该值为2，则表示玩家被飞。该值由Lua引擎传递给本函数。
function BattleExitCallBack(CharIndex, BattleIndex, Type) end

---创建一个玩家右键点击其他玩家就会触发的Lua函数。
---[@group NL.RegRightClickEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[RightClickCallBack]
function NL.RegRightClickEvent(Dofile, InitFuncName) end

---RightClickEvent的回调函数
---[@group NL.RegRightClickEvent]
---@param CharIndex  number 响应事件（发起事件）的对象index，该值由Lua引擎传递给本函数。(触发事件的玩家)
---@param TargetCharIndex  number 响应事件（被响应事件）的对象index，该值由Lua引擎传递给本函数。(被右键点击的玩家)
---@return number @返回1拦截该事件，其他不拦截
function RightClickCallBack(CharIndex, TargetCharIndex) end

---创建一个服务器程序关闭触发的事件
---[@group NL.RegShutDownEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[ShutDownCallBack]
function NL.RegShutDownEvent(Dofile, InitFuncName) end

---ShutDownEvent的回调函数
---[@group NL.RegShutDownEvent]
---@return number @返回0即可。
function ShutDownCallBack() end

---创建一个玩家组队触发的事件。
---[@group NL.RegPartyEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[PartyEventCallBack]
function NL.RegPartyEvent(Dofile, InitFuncName) end

---PartyEvent的回调函数
---[@group NL.RegPartyEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。（队员）
---@param TargetCharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。（队长）
---@param Type  number 模式，离队还是加入团队，该值由Lua引擎传递给本函数。（0 加入组队，1 离开组队）
---@return number @返回1表示允许操作，返回0表示禁止操作（组队失败/离队失败）
function PartyEventCallBack(CharIndex, TargetCharIndex, Type) end

---当玩家进行宠物封印的时候会触发该事件，并且返回封印的结果，同时Lua也可以对封印结果进行修改。
---[@group NL.RegSealEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[SealEventCallBack]
function NL.RegSealEvent(Dofile, InitFuncName) end

---SealEvent的回调函数
---[@group NL.RegSealEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param EnemyIndex  number 被封印的怪物对象，该值由Lua引擎传递给本函数。
---@param Ret  number 封印的结果，具体请查看下面对RetFlg的值的解析，该值由Lua引擎传递给本函数。
---RetFlg为服务端对封印动作的判定结果，值可能为负数，也可能为正数，如果为负数则表示封印失败，如果为正数则表示封印成功。 <br/>
---封印失败返回值对应解析：<br/>
--- -1 ：被封印对象的类型错误<br/>
--- -2 ：被封印对象不能作为宠物<br/>
--- -3 ：玩家身上没有足够栏位<br/>
--- -4 ：玩家等级不足以封印宠物<br/>
--- -5 ：被封印的宠物是召唤出来的而非野生的<br/>
--- -6 ：玩家没有被封印宠物的图鉴<br/>
--- -7 ：使用的封印卡道具不存在<br/>
--- -8 ：使用的道具并不是封印卡道具<br/>
--- -9 ：使用的封印卡没有参数设置<br/>
--- -10 ：使用的封印卡种族不正确<br/>
--- -11 ：不能封印邪魔系宠物<br/>
--- -100 ：封印随机几率不足，还原封印随机几率的公式为 abs(rate/100)-1
---@return number @可以直接返回RetFlg参数，也可根据需求返回正数或者负数，返回值将影响玩家封印效果
function SealEventCallBack(CharIndex, EnemyIndex, Ret) end

---当玩家戰鬥中發出指令的时候会触发该事件
---[@group NL.RegBattleActionEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[BattleActionEventCallBack]
function NL.RegBattleActionEvent(Dofile, InitFuncName) end

---BattleActionEvent的回调函数
---[@group NL.RegBattleActionEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param Com1  number 戰鬥使用的動作編號，该值由Lua引擎传递给本函数。
---@param Com2  number 動作的目標對象的位置，该值由Lua引擎传递给本函数。
---@param Com3  number 所對應的tech的ID，该值由Lua引擎传递给本函数。
---@param ActionNum  number 是對象的第幾動作，通常不帶寵物可以有2次有效動作，该值由Lua引擎传递给本函数。
function BattleActionEventCallBack(CharIndex, Com1, Com2, Com3, ActionNum) end

---玩家所有的Action事件都會觸發本函數，如使用暈倒，攻擊，剪刀，石頭，布等。
---[@group NL.RegCharActionEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[CharActionEventCallBack]
function NL.RegCharActionEvent(Dofile, InitFuncName) end

---CharActionEvent的回调函数
---[@group NL.RegCharActionEvent]
---@param CharIndex  number 响应事件（发起事件）的对象index，该值由Lua引擎传递给本函数。
---@param ActionID  number 玩家的動作ID，该值由Lua引擎传递给本函数。
function CharActionEventCallBack(CharIndex, ActionID) end

---當玩家使用生產技能製作道具的時候會觸發，可以通過該事件獲取玩家對象，技能的ID、等級和生成的道具對象。
---[@group NL.RegMergeItemEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[MergeItemEventCallBack]
function NL.RegMergeItemEvent(Dofile, InitFuncName) end

---MerGeItemEvent的回调函数
---[@group NL.RegMergeItemEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param SkillID  number 生產道具所用的技能ID，该值由Lua引擎传递给本函数。
---@param SkillLv  number 生產道具所用的技能等級，该值由Lua引擎传递给本函数。
---@param ItemIndex  number 生成出的道具的對象，如果為-1，則表示生成道具失敗，该值由Lua引擎传递给本函数。
---@param jewelNo  number 宝石物品Id
function MergeItemEventCallBack(CharIndex, SkillID, SkillLv, ItemIndex, jewelNo) end

---创建一个道具重叠触发的事件，这个道具重叠的意思是，在道具栏把一个道具拖向另一个道具会触发的事件。
---[@group NL.RegItemOverLapEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[ItemOverLapEventCallBack]
function NL.RegItemOverLapEvent(Dofile, InitFuncName) end

---ItemOverLapEvent的回调函数
---[@group NL.RegItemOverLapEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param FromItemIndex  number 被选中的道具的对象，该值由Lua引擎传递给本函数。
---@param TargetItemIndex  number 被覆盖的道具的对象，该值由Lua引擎传递给本函数。
---@param Num  number 被选中的道具的数量，该值由Lua引擎传递给本函数
---@return number @返回1或少于0时拦截，返回0时正常移动
function ItemOverLapEventCallBack(CharIndex, FromItemIndex, TargetItemIndex, Num) end

---创建一个用户登录的时候获取登陆点信息触发的事件，这个事件可以替代Login事件中的原地登陆功能，只需要在Callback中直接设置对象的坐标等信息即可，无需warp。
---[@group NL.RegGetLoginPointEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[GetLoginPointEventCallBack]
function NL.RegGetLoginPointEvent(Dofile, InitFuncName) end

---GetLoginPointEvent的回调函数
---[@group NL.RegGetLoginPointEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param MapID  number 登陆的Map ID，该值由Lua引擎传递给本函数。
---@param FloorID  number 登陆的Floor ID，该值由Lua引擎传递给本函数。
---@param X  number 登陆的X坐标，该值由Lua引擎传递给本函数。
---@param Y  number 登陆的Y坐标，该值由Lua引擎传递给本函数。
function GetLoginPointEventCallBack(CharIndex, MapID, FloorID, X, Y) end

---创建一个可以在itemset中使用的道具效果字段，当道具触发该字段时，将会自动调用定义的lua函数。
---[@group NL.RegItemString]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
---@param ItemSigh  string Itemset中对应的功能字段，初始化触发的函数用LUA_init开头、使用触发的函数用LUA_use开头、装备道具触发的函数用LUA_att开头、卸除装备触发的函数用LUA_det开头、道具丢下时触发的函数用LUA_drop开头、道具拾取前触发的函数用LUA_prepick开头、道具拾取后触发的函数用LUA_pick开头
--- itemset.txt中的自定义函数名所对应的列不同.<br/>
--- FuncName所定义的函数的申明格式根据不同的道具效果而不同，具体请参考以下数据 <br/>
--- <br/>
--- LUA_init： [ItemStringInitCallBack] 道具初始化触发,itemset.txt第4列填自定义函数名. <br/>
--- LUA_use ： [ItemStringUseCallBack] 道具使用触发,itemset.txt第6列填自定义函数名. <br/>
--- LUA_att ： [ItemStringAttachCallBack] 道具装备触发,itemset.txt第7列填自定义函数名. <br/>
--- LUA_det ： [ItemStringDetachCallBack] 道具卸下触发,itemset.txt第8列填自定义函数名. <br/>
--- LUA_drop   [ItemStringDropCallBack]道具丢下时触发,itemset.txt第9列填自定义函数名. <br/>
--- LUA_prepick   [ItemStringPrePickUpCallBack]道具拾取前触发,itemset.txt第10列填自定义函数名. <br/>
--- LUA_pick  [ItemStringPickUpCallBack]道具拾取后触发,itemset.txt第11列填自定义函数名. 
function NL.RegItemString(Dofile, InitFuncName, ItemSigh) end

---ItemString的回调函数
---[@group NL.RegItemString]
---@param CharIndex  number 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param ItemIndex  number 响应事件的道具index，该值由Lua引擎传递给本函数。
function ItemStringInitCallBack(CharIndex, ItemIndex) end

---ItemString的回调函数
---[@group NL.RegItemString]
---@param CharIndex  number 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param TargetCharIndex  number 道具使用目标的对象index，对自身使用则与CharIndex值相同，该值由Lua引擎传递给本函数。
---@param ItemSlot  number 响应事件的道具所在的栏位，范围8-27，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function ItemStringUseCallBack(CharIndex, TargetCharIndex, ItemSlot) end

---ItemString的回调函数
---[@group NL.RegItemString]
---@param CharIndex  number 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param FromItemIndex  number 响应事件的道具Index，该值由Lua引擎传递给本函数。
---@return number @返回值小于0则取消道具装备,返回大于等于0则正常装备。
function ItemStringAttachCallBack(CharIndex, FromItemIndex) end

---ItemString的回调函数
---[@group NL.RegItemString]
---@param CharIndex  number 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param FromItemIndex  number 响应事件的道具Index，该值由Lua引擎传递给本函数。
function ItemStringDetachCallBack(CharIndex, FromItemIndex) end

---ItemString的回调函数
---[@group NL.RegItemString]
---@param CharIndex  number 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param ItemIndex  number 响应事件的道具Index，该值由Lua引擎传递给本函数。
function ItemStringDropCallBack(CharIndex, ItemIndex) end

---ItemString的回调函数
---[@group NL.RegItemString]
---@param CharIndex  number 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param ItemIndex  number 响应事件的道具Index，该值由Lua引擎传递给本函数。
---@return any @返回值小于0则取消道具使用,返回大于等于0则正常拾取道具。
function ItemStringPrePickUpCallBack(CharIndex, ItemIndex) end

---ItemString的回调函数
---[@group NL.RegItemString]
---@param CharIndex  number 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param ItemIndex  number 响应事件的道具Index，该值由Lua引擎传递给本函数。
function ItemStringPickUpCallBack(CharIndex, ItemIndex) end

---创建一个所有玩家所有道具初始化时就会触发的Lua函数,此函数会加重引擎负载,请谨慎使用!
---[@group NL.RegItemInitEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称 
---只要注册了本事件,不管道具是否具有Init函数,本函数都会触发.
---触发条件如下:  玩家登陆, 创建或获取新道具, 打开银行, 打开公会仓库。
function NL.RegItemInitEvent(Dofile, InitFuncName) end

---ItemInitEvent的回调函数
---[@group NL.RegItemInitEvent]
---@param CharIndex  number 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param ItemIndex  number 响应事件的道具index，该值由Lua引擎传递给本函数。
function ItemInitCallBack(CharIndex, ItemIndex) end

---创建一个所有玩家使用道具(包括战斗中)就会触发的Lua函数。
---[@group NL.RegItemUseEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegItemUseEvent(Dofile, InitFuncName) end

---ItemUseEvent的回调函数
---[@group NL.RegItemUseEvent]
---@param CharIndex  number 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param TargetCharIndex  number 道具使用目标的对象index，对自身使用则与CharIndex值相同，该值由Lua引擎传递给本函数。
---@param ItemSlot  number 响应事件的道具所在的栏位，范围8-27，该值由Lua引擎传递给本函数。
---@return number @返回值小于0则取消道具使用,返回大于等于0则正常使用。
function ItemUseCallBack(CharIndex, TargetCharIndex, ItemSlot) end

---创建一个所有玩家装备道具时就会触发的Lua函数。
---[@group NL.RegItemAttachEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegItemAttachEvent(Dofile, InitFuncName) end

---ItemAttachEvent的回调函数
---[@group NL.RegItemAttachEvent]
---@param CharIndex  number 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param FromItemIndex  number 响应事件的道具Index，该值由Lua引擎传递给本函数。
---@return number @返回值小于0则取消道具使用,返回大于等于0则正常使用。
function ItemAttachCallBack(CharIndex, FromItemIndex) end

---创建一个所有玩家卸下装备道具时就会触发的Lua函数。
---[@group NL.RegItemDetachEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegItemDetachEvent(Dofile, InitFuncName) end

---ItemDetachEvent的回调函数
---[@group NL.RegItemDetachEvent]
---@param CharIndex  number 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param FromItemIndex  number 响应事件的道具Index，该值由Lua引擎传递给本函数。
function ItemDetachCallBack(CharIndex, FromItemIndex) end

---创建一个所有玩家丢弃道具时就会触发的Lua函数。
---[@group NL.RegItemDropEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegItemDropEvent(Dofile, InitFuncName) end

---ItemDropEvent的回调函数
---[@group NL.RegItemDropEvent]
---@param CharIndex  number 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param ItemIndex  number 响应事件的道具Index，该值由Lua引擎传递给本函数。
---@return any @返回值小于0则拦截丢弃,返回大于等于0则正常丢弃。
function ItemDropCallBack(CharIndex, ItemIndex) end

---创建一个所有玩家成功拾取道具之后就会触发的Lua函数。
---[@group NL.RegItemPickUpEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegItemPickUpEvent(Dofile, InitFuncName) end

---ItemPickUpEvent的回调函数
---[@group NL.RegItemPickUpEvent]
---@param CharIndex  number 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param ItemIndex  number 响应事件的道具Index，该值由Lua引擎传递给本函数。
---@return any @返回值小于0则拦截拾取,返回大于等于0则正常拾取。
function ItemPickUpCallBack(CharIndex, ItemIndex) end

---创建一个所有玩家展示(休息)宠物就会触发的Lua函数。
---[@group NL.RegPetFieldEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegPetFieldEvent(Dofile, InitFuncName) end

---PetFieldEvent的回调函数
---[@group NL.RegPetFieldEvent]
---@param CharIndex  number 宠物所有者的对象index，该值由Lua引擎传递给本函数。
---@param PetIndex  number 被展示(休息)宠物的对象index，该值由Lua引擎传递给本函数。
---@param PetPos  number 被展示(休息)的宠物所在栏位，该值由Lua引擎传递给本函数。
---@return any @返回值小于0则拦截展示,返回大于等于0则正常展示(休息)。
function PetFieldCallBack(CharIndex, PetIndex, PetPos) end

---创建一个所有玩家丢出宠物就会触发的Lua函数。
---[@group NL.RegPetDropEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegPetDropEvent(Dofile, InitFuncName) end

---PetDropEvent的回调函数
---[@group NL.RegPetDropEvent]
---@param CharIndex  number 宠物所有者的对象index，该值由Lua引擎传递给本函数。
---@param PetPos  number 被丢出的宠物所在栏位，该值由Lua引擎传递给本函数。
---@return number @返回值小于0则拦截丢弃,返回大于等于0则正常丢弃。
function PetDropCallBack(CharIndex, PetPos) end

---创建一个所有玩家捡起宠物就会触发的Lua函数。
---[@group NL.RegPetPickUpEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegPetPickUpEvent(Dofile, InitFuncName) end

---PetPickUpEvent的回调函数
---[@group NL.RegPetPickUpEvent]
---@param CharIndex  number 宠物所有者的对象index，该值由Lua引擎传递给本函数。
---@param PetIndex  number 要捡起宠物的对象索引，该值由Lua引擎传递给本函数。
---@return number @返回值小于0则拦截拾取,返回大于等于0则继续正常拾取流程(不是强行拾取)。
function PetPickUpCallBack(CharIndex, PetIndex) end

---战斗中计算伤害时会触发该函数
---[@group NL.RegDamageCalculateEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[DamageCalculateCallBack]
function NL.RegDamageCalculateEvent(Dofile, InitFuncName) end

---DamageCalculateEvent的回调函数
---[@group NL.RegDamageCalculateEvent]
---@param CharIndex  number 响应事件的对象index（攻击者），该值由Lua引擎传递给本函数。
---@param DefCharIndex  number 响应事件的对象index（防御者），该值由Lua引擎传递给本函数。
---@param OriDamage  number 未修正伤害，该值由Lua引擎传递给本函数。
---@param Damage  number 修正伤害（真实伤害），该值由Lua引擎传递给本函数。
---@param BattleIndex  number 当前战斗index，该值由Lua引擎传递给本函数。
---@param Com1  number 攻击者使用的動作編號，该值由Lua引擎传递给本函数。
---@param Com2  number 攻击者攻击動作的目標對象的位置，该值由Lua引擎传递给本函数。
---@param Com3  number 攻击者使用的所對應的tech的ID，该值由Lua引擎传递给本函数。
---@param DefCom1  number 防御者使用的動作編號，该值由Lua引擎传递给本函数。
---@param DefCom2  number 防御者攻击動作的目標對象的位置，该值由Lua引擎传递给本函数。
---@param DefCom3  number 防御者使用的所對應的tech的ID，该值由Lua引擎传递给本函数。
---@param Flg  number 伤害模式，具体查看CONST.DamageFlags
---@param ExFlg  number 伤害模式2，具体查看CONST.DamageFlagsEx
---@return number @伤害值
function DamageCalculateCallBack(CharIndex, DefCharIndex, OriDamage, Damage, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg, ExFlg) end

---技能附加参数获取时触发的函数
---[@group NL.RegTechOptionEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[TechOptionCallBack]
function NL.RegTechOptionEvent(Dofile, InitFuncName) end

---TechOptionEvent的回调函数
---[@group NL.RegTechOptionEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param Option  string 响应事件的技能的Option字段，该值由Lua引擎传递给本函数。
---@param TechID  number 当前技能的Tech ID，该值由Lua引擎传递给本函数。
---@param Val  number 对应字段的值，该值由Lua引擎传递给本函数。
---@return number @新的值
function TechOptionCallBack(CharIndex, Option, TechID, Val) end

---创建一个所有角色显示头饰效果的时候触发的函数。
---[@group NL.RegHeadCoverEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[HeadCoverEventCallBack]
function NL.RegHeadCoverEvent(Dofile, InitFuncName) end

---HeadCoverEvent的回调函数
---[@group NL.RegHeadCoverEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param CurrentHeadCoverImage  number 该对象当前的头饰图档id，该值由Lua引擎传递给本函数。
---@return number @返回新的头饰图档id，如不变更，则返回CurrentHeadCoverImage即可
function HeadCoverEventCallBack(CharIndex, CurrentHeadCoverImage) end

---创建一个所有玩家角色职业晋级时触发的Lua函数，玩家在游戏中角色职业晋级后就可触发，可以用来在特定职业等级给予特定奖励，记录玩家冲级速度排行等。
---[@group NL.RegRankUpEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 触发的Lua函数的名称，该函数的申明格式请参考[RankUpCallBack]
function NL.RegRankUpEvent(Dofile, InitFuncName) end

---RankUpEvent的回调函数
---[@group NL.RegRankUpEvent]
---@param CharIndex  number 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param OldRank  number 响应事件的对象当前职业等级，该值由Lua引擎传递给本函数。
---@param NewRank  number 响应事件的对象职业晋级后的职业等级，该值由Lua引擎传递给本函数。
---@return number @返回值大于等于0允许晋级,返回值为负数拒绝此次晋级。
function RankUpCallBack(CharIndex, OldRank, NewRank) end

---创建一个当地面的宠物被系统删时会触发的事件，利用此事件可以进行延长该宠物的删除时间等操作。
---[@group NL.RegPetTimeDeleteEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegPetTimeDeleteEvent(Dofile, InitFuncName) end

---PetTimeDeleteEvent的回调函数
---[@group NL.RegPetTimeDeleteEvent]
---@param PetIndex  number 触发时间的宠物索引，该值由Lua引擎传递给本函数。
---@return number @返回值小于等于0则继续正常删除。 | 返回大于0则该宠物的删除时间将会被延长至返回值设定的秒数后删除。
function PetTimeDeleteCallBack(PetIndex) end

---创建一个战斗偷袭之前触发的事件，利用此事件可以改变战斗的偷袭形式
---[@group NL.RegBattleSurpriseEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegBattleSurpriseEvent(Dofile, InitFuncName) end

---BattleSurpriseEvent的回调函数
---[@group NL.RegBattleSurpriseEvent]
---@param battleIndex number 战斗的index
---@param result number 此次战斗的偷袭形式 0不偷袭，1偷袭，2被偷袭
---@return number @返回0不偷袭，返回1偷袭，返回2被偷袭
function BattleSurpriseCallBack(battleIndex, result) end

---创建一个怪物施放召唤时触发的事件，利用此事件可以改变召唤物的种类和等级
---[@group NL.RegBattleSummonEnemyEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegBattleSummonEnemyEvent(Dofile, InitFuncName) end

---BattleSummonEnemyEvent的回调函数
---[@group NL.RegBattleSummonEnemyEvent]
---@param battleIndex number 战斗的index
---@param charIndex number 施放召唤角色的index
---@param enemyId number 召唤的enemyId
---@return number @返回新表格 {enemyId，等级，等级波动}
function BattleSummonEnemyCallBack(battleIndex, charIndex, enemyId) end

---创建一个召唤物生成前触发的事件，利用此事件可以改变召唤物的属性
---[@group NL.RegBattleSummonedEnemyEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegBattleSummonedEnemyEvent(Dofile, InitFuncName) end

---BattleSummonedEnemy的回调函数
---[@group NL.RegBattleSummonedEnemyEvent]
---@param battleIndex number 战斗的index
---@param actionCharIndex number 施放召唤角色的index
---@param charIndex number 被召唤角色的index
function BattleSummonedEnemyCallBack(battleIndex, actionCharIndex, charIndex) end

---创建一个连战生成前触发的事件，利用此事件可以改变连战的怪物和等级
---[@group NL.RegBattleNextEnemyEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegBattleNextEnemyEvent(Dofile, InitFuncName) end

---BattleNextEnemy的回调函数
---[@group NL.RegBattleNextEnemyEvent]
---@param battleIndex number 战斗的index
---@param flg number lua连战参数
---@return number[]|nil @返回新表格{enmeyId,等级,...}按10-19的位置排列，返回nil取消连战
function BattleNextEnemyCallBack(battleIndex, flg) end

---创建一个连战魔物生成前触发的事件，利用此事件可以改变连战魔物的属性
---[@group NL.RegBattleNextEnemyInitEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegBattleNextEnemyInitEvent(Dofile, InitFuncName) end

---BattleNextEnemyInit的回调函数
---[@group NL.RegBattleNextEnemyInitEvent]
---@param battleIndex number 战斗的index
---@param flg number lua连战参数
function BattleNextEnemyInitCallBack(battleIndex, flg) end

---创建一个怪物ai执行前触发的事件
---[@group NL.RegBeforeBattleTurnEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegBeforeBattleTurnEvent(Dofile, InitFuncName) end

---BeforeBattleTurnEvent的回调函数
---[@group NL.RegBeforeBattleTurnEvent]
---@param battleIndex number 战斗的index
function BeforeBattleTurnCallBack(battleIndex) end

---创建一个所有指令已就位触发的事件
---[@group NL.RegBeforeBattleTurnStartEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegBeforeBattleTurnStartEvent(Dofile, InitFuncName) end

---BeforeBattleTurnStartevent的回调函数
---[@group NL.RegBeforeBattleTurnStartEvent]
---@param battleIndex number 战斗的index
function BeforeBattleTurnStartCallBack(battleIndex) end

---创建一个回合结束触发的事件
---[@group NL.RegAfterBattleTurnEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegAfterBattleTurnEvent(Dofile, InitFuncName) end

---AfterBattleTurnevent的回调函数
---[@group NL.RegAfterBattleTurnEvent]
---@param battleIndex number 战斗的index
function AfterBattleTurnCallBack(battleIndex) end

---创建一个角色属性计算触发的事件(包括装备属性)
---[@group NL.RegAfterCalcCharaBpEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegAfterCalcCharaBpEvent(Dofile, InitFuncName) end

---AfterCalcCharaBpevent的回调函数
---[@group NL.RegAfterCalcCharaBpEvent]
---@param charIndex number 角色的index
function AfterCalcCharaBpCallBack(charIndex) end

---创建一个角色装备计算触发的事件(包括受伤，掉魂)
---[@group NL.RegAfterCalcCharaStatusEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegAfterCalcCharaStatusEvent(Dofile, InitFuncName) end

---AfterCalcCharaStatusevent的回调函数
---[@group NL.RegAfterCalcCharaStatusEvent]
---@param charIndex number 角色的index
function AfterCalcCharaStatusCallBack(charIndex) end

---创建一个角色计算属性的的事件
---[@group NL.RegStatusCalcEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegStatusCalcEvent(Dofile, InitFuncName) end

---StatusCalcEvent的回调函数
---[@group NL.RegStatusCalcEvent]
---@param charIndex number 角色的index
function StatusCalcCallBack(charIndex) end

---创建一个怪物执行AI触发的事件
---[@group NL.RegEnemyCommandEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegEnemyCommandEvent(Dofile, InitFuncName) end

---EnemyCommandEvent的回调函数
---[@group NL.RegEnemyCommandEvent]
---@param battleIndex number 战斗的index
---@param side number 0 为下方，1位上方
---@param slot number 战斗中站位
---@param action number 本回合中动作次数
function EnemyCommandCallBack(battleIndex, side, slot, action) end

---创建一个娃娃(替身娃娃 A|B型)结算前的触发事件
---[@group NL.RegCheckDummyDollEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegCheckDummyDollEvent(Dofile, InitFuncName) end

---CheckDummyDollEvent的回调函数
---[@group NL.RegCheckDummyDollEvent]
---@param charIndex number 角色的index
---@param battleIndex number 战斗的index
---@param dmg number 受到的伤害
---@param type number 伤害类型
---@return number @返回1可以使用娃娃，返回0禁用娃娃
function CheckDummyDoll(charIndex, battleIndex, dmg, type) end

---创建一个受伤时触发的事件
---[@group NL.BattleInjuryCallBack]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegBattleInjuryEvent(Dofile, InitFuncName) end

---BattleInjuryEvent的回调事件
---[@group NL.BattleInjuryCallBack]
---@param fIndex number 防御者的index
---@param aIndex number 攻击者的index
---@param battleIndex number 战斗的index
---@param inject number 受伤程度
---@return any @返回受伤程度，范围0~100
function BattleInjuryCallBack(fIndex, aIndex, battleIndex, inject) end

---创建一个战斗结算画面出现时触发的事件
---[@group NL.RegResetCharaBattleStateEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegResetCharaBattleStateEvent(Dofile, InitFuncName) end

---ResetCharaBattleStateEvent的回调函数
---[@group NL.RegResetCharaBattleStateEvent]
---@param charIndex number 角色的index
function ResetCharaBattleStateCallBack(charIndex) end

---创建一个角色保存后触发的事件
---[@group NL.RegCharaSavedEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegCharaSavedEvent(Dofile, InitFuncName) end

---CharaSavedEvent的回调函数
---[@group NL.RegCharaSavedEvent]
---@param charIndex number 角色的index
function CharaSavedCallBack(charIndex) end

---创建一个角色数据保存前触发的事件
---[@group NL.RegBeforeCharaSaveEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegBeforeCharaSaveEvent(Dofile, InitFuncName) end

---BeforeCharaSave的回调函数
---[@group NL.RegBeforeCharaSaveEvent]
---@param charIndex number 角色的index
function BeforeCharaSaveCallBack(charIndex) end

---创建一个角色删除时触发的事件
---[@group NL.RegCharaDeletedEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegCharaDeletedEvent(Dofile, InitFuncName) end

---CharaDeleted的回调函数
---[@group NL.RegCharaDeletedEvent]
---@param cdkey string 角色的cdkey
---@param registnumber number 角色的注册号
---@param result number 成功为1, 其他为失败
function CharaDeletedCallBack(cdkey, registnumber, result) end

---创建一个luac触发的事件
---[@group NL.RegScriptCallEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称，参考[ScriptCallCallBack]
function NL.RegScriptCallEvent(Dofile, InitFuncName) end

---ScriptCallEvent的回调函数
---[@group NL.RegScriptCallEvent]
---@param npcIndex number 触发npc的index
---@param playerIndex number 角色的index
---@param text string 由luac传入的字符串
---@param msg string 打字触发的字符串，参考头目万岁
---@return number @返回新值，返回给data
function ScriptCallCallBack(npcIndex, playerIndex, text, msg) end

---创建一个物品掉率的事件
---[@group NL.RegDropRateEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegDropRateEvent(Dofile, InitFuncName) end

---DropRateEvent的回调函数
---[@group NL.RegDropRateEvent]
---@param enemyIndex number 魔物index
---@param itemId number
---@param rate number 掉落率
function DropRateCallBack(enemyIndex, itemId, rate) end

---创建一个逃跑时触发的事件
---[@group NL.RegBattleEscapeEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegBattleEscapeEvent(Dofile, InitFuncName) end

---BattleEscapeEvent的回调函数
---[@group NL.RegBattleEscapeEvent]
---@param battleIndex number 战斗的index
---@param charIndex number 施放召唤角色的index
---@param rate number 逃跑结果, 成功为1, 0为失败
---@return number @逃跑结果, 成功为1, 0为失败
function BattleEscape(battleIndex, charIndex, rate) end

---创建一个封印时触发的事件，该事件不能突破服务器的设定
---[@group NL.RegBattleSealRateEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegBattleSealRateEvent(Dofile, InitFuncName) end

---BattleSealRateEvent的回调函数
---[@group NL.RegBattleSealRateEvent]
---@param battleIndex number 战斗的index
---@param charIndex number 施放封印角色的index
---@param enemyIndex number 封印的魔物index
---@param rate number 封印成功率
---@return number @成功率
function BattleSealRateCallBack(battleIndex, charIndex, enemyIndex, rate) end

---创建一个暴击时触发的事件
---[@group NL.RegCalcCriticalRateEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegCalcCriticalRateEvent(Dofile, InitFuncName) end

---CalcCriticalRateEvent的回调函数
---[@group NL.RegCalcCriticalRateEvent]
---@param aIndex number 攻击者的index
---@param fIndex number 防御者的index
---@param rate number 必杀率
---@return number @必杀率
function CalcCriticalRateCallBack(aIndex, fIndex, rate) end

---创建一个闪躲时触发的事件
---[@group NL.RegBattleDodgeRateEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegBattleDodgeRateEvent(Dofile, InitFuncName) end

---BattleDodgeRateEvent的回调函数
---[@group NL.RegBattleDodgeRateEvent]
---@param battleIndex number 战斗的index
---@param aIndex number 攻击者的index
---@param fIndex number 防御者的index
---@param rate number 闪躲率
---@return number @闪躲率
function BattleDodgeRateCallBack(battleIndex, aIndex, fIndex, rate) end

---创建一个反击时触发的事件
---[@group NL.RegBattleCounterRateEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegBattleCounterRateEvent(Dofile, InitFuncName) end

---BattleCounterRateEvent的回调函数
---[@group NL.RegBattleCounterRateEvent]
---@param battleIndex number 战斗的index
---@param aIndex number 攻击者的index
---@param fIndex number 防御者的index
---@param rate number 反击率
---@return number @反击率
function BattleCounterRateCallBack(battleIndex, aIndex, fIndex, rate) end

---创建一个造成魔法伤害触发的事件，用于改变魔法伤害系数
---[@group NL.RegBattleMagicDamageRateEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegBattleMagicDamageRateEvent(Dofile, InitFuncName) end

---BattleMagicDamageRateEvent的回调函数
---[@group NL.RegBattleMagicDamageRateEvent]
---@param battleIndex number 战斗的index
---@param aIndex number 攻击者的index
---@param fIndex number 防御者的index
---@param rate number 魔法系数
---@return number @魔法系数
function BattleMagicDamageRateCallBack(battleIndex, aIndex, fIndex, rate) end

---创建一个造成魔法伤害触发的事件，用于改变魔防系数
---[@group NL.RegBattleMagicRssRateEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegBattleMagicRssRateEvent(Dofile, InitFuncName) end

---BattleMagicRssRateEvent的回调函数
---[@group NL.RegBattleMagicRssRateEvent]
---@param battleIndex number 战斗的index
---@param aIndex number 攻击者的index
---@param fIndex number 防御者的index
---@param rate number 魔防系数
---@return number @魔防系数
function BattleMagicRssRateCallBack(battleIndex, aIndex, fIndex, rate) end

---创建一个宝箱生成触发的事件
---[@group NL.RegItemBoxGenerateEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegItemBoxGenerateEvent(Dofile, InitFuncName) end

---ItemBoxGenerateEvent的回调函数
---[@group NL.RegItemBoxGenerateEvent]
---@param mapId number 宝箱所在地图类型
---@param floor number 宝箱所在地图
---@param itemBoxType number 宝箱itemId
---@param adm number 影响出产物品，作用未知
---@return number[] @返回宝箱参数 {itemBoxType, adm}
function ItemBoxGenerateCallback(mapId, floor, itemBoxType, adm) end

---创建一个宝箱获取物品的事件
---[@group NL.RegItemBoxLootEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegItemBoxLootEvent(Dofile, InitFuncName) end

---ItemBoxLootEvent的回调函数
---[@group NL.RegItemBoxLootEvent]
---@param charaIndex number 获得物品的角色
---@param mapId number charaIndex地图类型
---@param floor number charaIndex地图
---@param X number charaIndex X坐标
---@param Y number charaIndex Y坐标
---@param boxType number 宝箱itemId
---@param adm number
---@return number @number 返回1拦截默认物品, 返回0不拦截
function ItemBoxLootCallback(charaIndex, mapId, floor, X, Y, boxType, adm) end

---创建一个宝箱遇敌概率的事件
---[@group NL.RegItemBoxEncountRateEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegItemBoxEncountRateEvent(Dofile, InitFuncName) end

---ItemBoxEncountRateEvent的回调函数
---[@group NL.RegItemBoxEncountRateEvent]
---@param charaIndex number
---@param mapId number
---@param floor number
---@param X number
---@param Y number
---@param itemIndex number 箱子物品index
---@param rate number 遇敌率
---@param boxType number 箱子id
---@return number @遇敌概率
function ItemBoxEncountRateEventCallback(charaIndex, mapId, floor, X, Y, itemIndex, rate, boxType) end

---创建一个宝箱遇敌的事件
---[@group NL.RegItemBoxEncountEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegItemBoxEncountEvent(Dofile, InitFuncName) end

---ItemBoxEncountEvent的回调函数
---[@group NL.RegItemBoxEncountEvent]
---@param charaIndex number 开宝箱的角色
---@param mapId number charaIndex地图类型
---@param floor number charaIndex地图
---@param X number charaIndex X坐标
---@param Y number charaIndex Y坐标
---@param itemIndex number 箱子index
---@return number[]|nil @遇敌数组 每个怪物3个参数，分别为 id，等级，随机等级， 返回nil不拦截， 例子： {0, 100, 5, 1, 1, 0} 生成0号怪物100-105级，1号怪物1级
function ItemBoxEncountCallback(charaIndex, mapId, floor, X, Y, itemIndex) end

---创建一个种族伤害比率事件
---[@group NL.RegTribeRateEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegTribeRateEvent(Dofile, InitFuncName) end

---ItemTribeRateEvent的回调函数
---[@group NL.RegTribeRateEvent]
---@param a number 进攻种族
---@param b number 防守种族
---@param rate number 克制比率
---@return number @返回新的克制比率
function TribeRateCallback(a, b, rate) end

---创建一个Http请求事件
---[@group NL.RegHttpRequestEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegHttpRequestEvent(Dofile, InitFuncName) end

---HttpRequestEvent的回调函数
---[@group NL.RegHttpRequestEvent]
---@param method string
---@param api string API名字
---@param params {string:string} 参数
---@param body string body内容
---@return string @返回内容
function HttpRequestCallBack(method, api, params, body) end

---创建一个治疗时触发的事件
---[@group NL.RegBattleHealCalculateEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegBattleHealCalculateEvent(Dofile, InitFuncName) end

---BattleHealCalculate的回调函数
---[@group NL.RegBattleHealCalculateEvent]
---@param charIndex  number 响应事件的对象index（攻击者），该值由Lua引擎传递给本函数。
---@param defCharIndex  number 响应事件的对象index（防御者），该值由Lua引擎传递给本函数。
---@param oriheal  number 未修正治疗，该值由Lua引擎传递给本函数。
---@param heal  number 修正治疗（真实治疗），该值由Lua引擎传递给本函数。
---@param battleIndex  number 当前战斗index，该值由Lua引擎传递给本函数。
---@param com1  number 攻击者使用的動作編號，该值由Lua引擎传递给本函数。
---@param com2  number 攻击者攻击動作的目標對象的位置，该值由Lua引擎传递给本函数。
---@param com3  number 攻击者使用的所對應的tech的ID，该值由Lua引擎传递给本函数。
---@param defCom1  number 防御者使用的動作編號，该值由Lua引擎传递给本函数。
---@param defCom2  number 防御者攻击動作的目標對象的位置，该值由Lua引擎传递给本函数。
---@param defCom3  number 防御者使用的所對應的tech的ID，该值由Lua引擎传递给本函数。
---@param flg  number 伤害模式，具体查看CONST.HealDamageFlags
---@param ExFlg  number 伤害模式2，具体查看CONST.DamageFlagsEx
---@return number @治疗值
function BattleHealCalculateCallBack(charIndex, defCharIndex, oriheal, heal, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg) end

---创建一个耗魔时触发的事件
---[@group NL.RegCalcFpConsumeEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegCalcFpConsumeEvent(Dofile, InitFuncName) end

---CalcFpConsume的回调函数
---[@group NL.RegCalcFpConsumeEvent]
---@param charIndex number 角色的index
---@param techId number 技能id
---@param Fp number 耗魔数值
---@return number @耗魔数值
function CalcFpConsumeCallBack(charIndex, techId, Fp) end

---创建一个装备说明的事件，用于修改物品说明
---[@group NL.RegItemExpansionEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegItemExpansionEvent(Dofile, InitFuncName) end

---ItemExpansion的回调函数
---[@group NL.RegItemExpansionEvent]
---@param itemIndex number
---@param type number 1物品说明，2右键说明
---@param msg string 物品说明内容
---@param charIndex number
---@param slot number 道具位置
---@return string @物品说明
function ItemExpansionCallBack(itemIndex, type, msg, charIndex, slot) end

---创建一个检查称号触发的事件，用于通过lua自定义称号，定义方式：titleconfig.txt中增加新条件设置，使用LUA为条件关键字，如LUA=50,=对应Flg中的5,50对应Data
---[@group NL.RegTitleCheckCallEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegTitleCheckCallEvent(Dofile, InitFuncName) end

---TitleCheckCallEvent的回调函数
---[@group NL.RegTitleCheckCallEvent]
---@param charIndex number 角色的index
---@param Data number 条件数值
---@param Flg number 条件判定符 0: <=、 1: >=、 2: <>、 3: >、 4: <、 5: =
---@return number @返回0称号条件不满足，返回1称号条件满足
function TitleCheckCallCallBack(charIndex, Data, Flg) end

---创建一个采集技能事件
---[@group NL.RegGatherItemEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称,参考[GatherItemEventCallback]
function NL.RegGatherItemEvent(Dofile, InitFuncName) end

---GatherItemEvent的回调函数
---[@group NL.RegGatherItemEvent]
---@param charIndex number 角色的index
---@param skillId number 技能id
---@param skillLv number 技能等级
---@param itemId number 采集物Id,参考itemset.txt
---@return number @返回采集物的Id，参考itemset.txt | 不写返回值时采集为默认结果
function GatherItemEventCallback(charIndex, skillId, skillLv, itemId) end

---在玩家遇敌的时候触发，可以通过这个接口来修改遇敌的队列和数量。
---[@group NL.RegVSEnemyCreateEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称,参考[VSEnemyCreateEventCallback]
function NL.RegVSEnemyCreateEvent(Dofile, InitFuncName) end

---VSEnemyCreateEvent的回调函数
---[@group NL.RegVSEnemyCreateEvent]
---@param CharIndex number 响应事件的对象index，该值由Lua引擎传递给本函数
---@param GroupId number 响应事件的战斗遇敌group ID，对应group.txt。
---@param EnemyNum number 响应事件的战斗遇敌数量，该值由Lua引擎传递给本函数。
---@param EnemyList number[] 响应事件的战斗遇敌队列，该值由Lua引擎传递给本函数。
---@return number[] @返回新的遇敌队列即可，如无修改返回EnemyList或其他非Table类值即可。
function VSEnemyCreateEventCallback(CharIndex, GroupId, EnemyNum, EnemyList) end

---玩家攻击时触发，可以修改攻击目标（乱射、连击等）。
---[@group NL.RegBattleActionTargetEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称,参考[BattleActionTargetEventCallback]
function NL.RegBattleActionTargetEvent(Dofile, InitFuncName) end

---BattleActionTargetEvent的回调函数
---[@group NL.RegBattleActionTargetEvent]
---@param charIndex number 对象index
---@param battleIndex number 战斗Index
---@param com1 number COM1。技能类别
---@param com2 number COM2。点选目标
---@param com3 number COM3。一般是TechId
---@param targetList number[] 响应事件的目标位置队列
---@return number[] @返回新的目标位置，如无修改返回targetList或其他非Table类值即可。
function BattleActionTargetEventCallback(charIndex, battleIndex, com1, com2, com3, targetList) end

---控制技能是否可以使用事件
---[@group NL.RegBattleSkillCheckEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称,参考[BattleSkillCheckEventCallback]
function NL.RegBattleSkillCheckEvent(Dofile, InitFuncName) end

---BattleSkillCheckEvent的回调函数
---[@group NL.RegBattleSkillCheckEvent]
---@param charIndex number 对象index
---@param battleIndex number 战斗Index
---@param arrayOfSkillEnable number[] 对应的技能是否可用，1为可用，0为不可用
---@return number[] @返回对应的技能是否可用，1为可用，0为不可用
function BattleSkillCheckEventCallback(charIndex, battleIndex, arrayOfSkillEnable) end

---自定义lua技能回调事件
---[@group NL.RegBattleLuaSkillEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称,参考[BattleLuaSkillEventCallback]
function NL.RegBattleLuaSkillEvent(Dofile, InitFuncName) end

---BattleLuaSkillEvent的回调函数
---[@group NL.RegBattleLuaSkillEvent]
---@param charIndex number 对象index
---@param battleIndex number 战斗Index
---@param SKLFunc function 发送SKL技能封包，所有参数可选,参考[SKLFunc]
---@param DMGFunc function 发送伤害封包，参考[DMGFunc]
function BattleLuaSkillEventCallback(battleIndex, charIndex, SKLFunc, DMGFunc) end

---发送SKL技能封包，支持0-3个参数
---[@group NL.RegBattleLuaSkillEvent]
---@param TechId number 技能编号
---@param WeaponType number 攻击武器类型
---@param AttackerPos number 攻击者战斗位置
function SKLFunc(TechId, WeaponType, AttackerPos) end

---发送SKL技能封包，支持0-3个参数
---[@group NL.RegBattleLuaSkillEvent]
---@param TechId number 技能编号
---@param WeaponType number 攻击武器类型
function SKLFunc(TechId, WeaponType) end

---发送SKL技能封包，支持0-3个参数
---[@group NL.RegBattleLuaSkillEvent]
---@param TechId number 技能编号
function SKLFunc(TechId) end

---[@group NL.RegBattleLuaSkillEvent]
---发送SKL技能封包，支持0-3个参数
function SKLFunc() end

---发送伤害封包
---[@group NL.RegBattleLuaSkillEvent]
---@param pos number 目标位置
---@param flg number 攻击效果旗标，参考CONST.TECH_CONST.BM_FLAG_XXX
---@param dmg number 伤害/治疗数值
function DMGFunc(pos, flg, dmg) end

---物品耐久变化事件
---[@group NL.RegItemDurabilityChangedEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称,参考[ItemDurabilityChangedEventCallback]
function NL.RegItemDurabilityChangedEvent(Dofile, InitFuncName) end

---ItemDurabilityChangedEvent的回调函数
---[@group NL.RegItemDurabilityChangedEvent]
---@param itemIndex number ItemIndex
---@param oldDurability number 原来的耐久
---@param newDurability number 变化后的耐久
---@param value number 变化值
---@param mode number 0正常战斗损耗（1-2耐久），1致死打击（-50%当前耐久），2沉重打击（-10%最大耐久），3装备破坏技能
---@return number @新的mode，用于mode为1、2时返回0取消对应提示
function ItemDurabilityChangedEventCallback(itemIndex, oldDurability, newDurability, value, mode) end

---战斗获得战利品（物品）事件
---[@group NL.RegBattleGetProfitEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称,参考[BattleGetProfitEventCallback]
function NL.RegBattleGetProfitEvent(Dofile, InitFuncName) end


---BattleGetProfitEvent的回调函数
---[@group NL.RegBattleGetProfitEvent]
---@param battleIndex number 战斗Index
---@param side number 队伍0或1
---@param pos number 队伍内位置0-9
---@param charaIndex number 角色Index
---@param type number EXP = -1,DP = -2,ITEM1 = 0,ITEM2 = 1,ITEM3 = 2,
---@param reward number EXP/DP时为对应经验/DP，ITEM1/ITEM2/ITEM3为itemIndex
---@return number @返回修改后的经验/DP/ItemIndex
function BattleGetProfitEventCallback(battleIndex, side, pos, charaIndex, type, reward) end


---战斗计算行动优先级事件
---[@group NL.RegBattleCalcDexEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称,参考[BattleCalcDexEventCallback]
function NL.RegBattleCalcDexEvent(Dofile, InitFuncName) end


---BattleCalcDexEvent的回调函数
---[@group NL.RegBattleCalcDexEvent]
---@param battleIndex number 战斗Index
---@param action number 0为1动，1为2动
---@param charaIndex number 角色Index
---@param flg number 标旗
---@param dex number 行动优先级
---@return number @返回修改后的dex
function BattleCalcDexEventCallback(battleIndex, charaIndex, action, flg, dex) end


---创建一个所有玩家丢弃道具之前就会触发的Lua函数。
---[@group NL.RegPreItemDropEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegPreItemDropEvent(Dofile, InitFuncName) end

---PreItemDropEvent的回调函数
---[@group NL.RegPreItemDropEvent]
---@param CharIndex  number 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param ItemIndex  number 响应事件的道具Index，该值由Lua引擎传递给本函数。
---@return any @返回值小于0则拦截丢弃,返回大于等于0则正常丢弃。
function PreItemDropCallBack(CharIndex, ItemIndex) end


---创建一个所有玩家成功拾取道具之前就会触发的Lua函数。
---[@group NL.RegPreItemPickUpEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegPreItemPickUpEvent(Dofile, InitFuncName) end

---PreItemPickUpEvent的回调函数
---[@group NL.RegPreItemPickUpEvent]
---@param CharIndex  number 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param ItemIndex  number 响应事件的道具Index，该值由Lua引擎传递给本函数。
---@return any @返回值小于0则拦截拾取,返回大于等于0则正常拾取。
function PreItemPickUpCallBack(CharIndex, ItemIndex) end

---创建一个玩家在战斗中使用物品时会触发的Lua函数。
---[@group NL.RegItemConsumeEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegItemConsumeEvent(Dofile, InitFuncName) end

---ItemConsumeEvent的回调函数
---[@group NL.RegItemConsumeEvent]
---@param charIndex  number 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param itemIndex  number 响应事件的道具Index，该值由Lua引擎传递给本函数。
---@param slot  number 响应事件的道具的位置，该值由Lua引擎传递给本函数。
---@param amount  number 响应事件的道具的消费数量，该值由Lua引擎传递给本函数。
---@return number @消费数量
function ItemConsumeEventCallback(charIndex, itemIndex, slot, amount) end


---删除用Lua创建的NPC，需要注意的是，删除NPC后本函数不会将NpcIndex的值设置为nil，请在函数后自行处理NpcIndex的值。
---@param NpcIndex  number 要删除的Npc的对象指针
---@return number @创建成功则返回 1, 失败则返回 0
function NL.DelArgNpc(NpcIndex) end


---获取引擎版本
---@return string @cgmsv
function NL.Ver() end


---摆摊有物品交易成功时触发的事件。
---[@group NL.RegCharaStallSoldEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegCharaStallSoldEvent(Dofile, InitFuncName) end

---CharaStallSoldEvent的回调函数
---[@group NL.RegCharaStallSoldEvent]
---@param buyer  number 购买者的对象index，该值由Lua引擎传递给本函数。
---@param seller  number 售卖者的对象index，该值由Lua引擎传递给本函数。
---@param itemIndex  number 售出道具Index，该值由Lua引擎传递给本函数。
---@param petIndex  number 售出宠物Index，该值由Lua引擎传递给本函数。
---@param price  number 响应事件的道具的消费数量，该值由Lua引擎传递给本函数。
function CharaStallSoldEventCallback(buyer, seller, itemIndex, petIndex, price) end


---摆摊开始事件
---[@group NL.RegCharaStallStartEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegCharaStallStartEvent(Dofile, InitFuncName) end

---CharaStallStartEvent的回调函数
---[@group NL.RegCharaStallStartEvent]
---@param seller  number 售卖者的对象index，该值由Lua引擎传递给本函数。
function CharaStallStartEventCallback(seller) end


---摆摊结束事件
---[@group NL.RegCharaStallEndEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegCharaStallEndEvent(Dofile, InitFuncName) end

---CharaStallEndEvent的回调函数
---[@group NL.RegCharaStallEndEvent]
---@param seller  number 售卖者的对象index，该值由Lua引擎传递给本函数。
function CharaStallEndEventCallback(seller) end


---摆摊浏览事件
---[@group NL.RegCharaStallBrowseEvent]
---@param Dofile?  string 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  string 指向的Lua函数的名称
function NL.RegCharaStallBrowseEvent(Dofile, InitFuncName) end

---CharaStallBrowseEvent的回调函数
---[@group NL.RegCharaStallBrowseEvent]
---@param buyer  number 购买者的对象index，该值由Lua引擎传递给本函数。
---@param seller  number 售卖者的对象index，该值由Lua引擎传递给本函数。
function CharaStallBrowseEventCallback(buyer,seller) end