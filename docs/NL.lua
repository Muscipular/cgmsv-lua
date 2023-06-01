---@alias 字符串 string
---@alias 数值型 number


---使用Lua脚本创建NPC，并执行Dofile文件中的InitFuncName函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 Init函数的名称,NPC创建后执行的函数,申明格式请参考下面的[InitCallBack]
---@return number @创建成功则返回 对象index, 失败则返回负数
function NL.CreateNPC(Dofile, InitFuncName) end

---CreateNPC的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function InitCallBack(CharIndex) end

---删除用Lua创建的NPC，需要注意的是，删除NPC后本函数不会将NpcIndex的值设置为nil，请在函数后自行处理NpcIndex的值。
---@param NpcIndex  数值型 要删除的Npc的对象指针
---@return number @创建成功则返回 1, 失败则返回 0
function NL.DelNpc(NpcIndex) end

---直接创建data/npc.txt中支持的各种类型的npc，可以直接调用npc.txt支持的npc类型和相应的参数，并且可以获得创建的npc的对象。
---@param Type  字符型 npc的类型文本（大小写敏感），如”Itemshop2”
---@param Arg  字符型 对应的npc类型的参数，即npc.txt中每个npc的最后一组参数
---@param Name  字符型 npc显示的名字
---@param Image  数值型 npc的图档编号
---@param Map  数值型 npc所在的MapID
---@param Floor  数值型 npc所在的FloorID
---@param Xpos  数值型 npc所在的x坐标
---@param Ypos  数值型 npc所在的y坐标
---@param Dir  数值型 npc面朝的方向
---@param ShowTime  数值型 可选参数,NPC的显示时间,具体设置参考灵堂入口士兵
---@return any @返回负数表示失败，大于0的正整数表示成功，并且该值为npc的对象索引值
function NL.CreateArgNpc(Type, Arg, Name, Image, Map, Floor, Xpos, Ypos, Dir [, ShowTime]) end

---修改NL.CreateArgNpc创建的npc的参数
---@param NpcIndex  数值型 npc的对象索引，一般为NL.CreateArgNpc的返回值
---@param NewArg  字符串 新的npc的参数
---@return any @返回负数代表失败，0表示成功，npc会自动刷新（注意，如果在有玩家触发了npc的时候修改npc的参数，可能会造成bug等影响，所以最好先隐藏NPC再修改）
function NL.SetArgNpc(NpcIndex, NewArg) end

---创建一个所有玩家登陆游戏时候自动触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，玩家登陆会自动触发FuncName的Lua函数，该函数的申明格式请参考[LoginEventCallBack]
---@return any @
function NL.RegLoginEvent(Dofile, FuncName) end

---LoginEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function LoginEventCallBack(CharIndex) end

---创建一个所有玩家登出回记录点就会触发的Lua函数，玩家只有点击客户端”登出回记录点”按钮时才可触发该函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[LoginGateEventCallBack]
---@return any @
function NL.RegLoginGateEvent(Dofile, FuncName) end

---LoginGateEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function LoginGateEventCallBack(CharIndex) end

---创建一个所有玩家登出游戏就会触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[LogoutEventCallBack]
---@return any @
function NL.RegLogoutEvent(Dofile, FuncName) end

---LogoutEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function LogoutEventCallBack(CharIndex) end

---创建一个所有玩家说话就会触发的Lua函数，玩家在游戏中说话即可触发该事件，可以用来新建指令，GM命令等，同时可以对GM命令进行分级授权。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[TalkEventCallBack]
---@return any @
function NL.RegTalkEvent(Dofile, FuncName) end

---TalkEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param Msg  文本型 话的内容，该值由Lua引擎传递给本函数。
---@param Color  数值型 说话颜色，该值由Lua引擎传递给本函数。
---@param Range  数值型 说话音量（范围），该值由Lua引擎传递给本函数
---@param Size  数值型 说话字体大小，该值由Lua引擎传递给本函数。
---@return number @返回0拦截说话内容，返回1正常发送
function TalkEventCallBack(CharIndex, Msg, Color, Range, Size) end

---创建一个所有玩家角色升级触发的Lua函数，玩家在游戏中角色升级后就可触发，可以用来在特定等级给予特定奖励，记录玩家冲级速度排行等。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[LevelUpCallBack]
---@return any @
function NL.RegLevelUpEvent(Dofile, FuncName) end

---LevelUpEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function LevelUpCallBack(CharIndex) end

---创建一个角色进入战斗即可触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[BattleStartEventCallBack]
---@return any @
function NL.RegBattleStartEvent(Dofile, FuncName) end

---BattleStartEvent的回调函数
---@param BattleIndex  数值型 响应事件的战斗index，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function BattleStartEventCallBack(BattleIndex) end

---创建一个战斗结束即可触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[BattleOverEventCallBack]
---@return any @
function NL.RegBattleOverEvent(Dofile, FuncName) end

---BattleOverEvent的回调函数
---@param BattleIndex  数值型 响应事件的战斗index，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function BattleOverEventCallBack(BattleIndex) end

---创建一个玩家通过传送点时触发的Lua函数，可以用来记录玩家的传送轨迹。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[WarpEventCallBack]
---@return any @
function NL.RegWarpEvent(Dofile, FuncName) end

---创建一个玩家通过传送点时触发的Lua函数，可以用来记录玩家的传送轨迹。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[WarpEventCallBack]
---@return any @
function NL.RegAfterWarpEvent(Dofile, FuncName) end

---WarpEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param Ori_MapId  数值型 传送前的mapid，该值由Lua引擎传递给本函数。
---@param Ori_FloorId  数值型 传送前的floor id，该值由Lua引擎传递给本函数。
---@param Ori_X  数值型 传送前的x，该值由Lua引擎传递给本函数。
---@param Ori_Y  数值型 传送前的y，该值由Lua引擎传递给本函数。
---@param Target_MapId  数值型 传送后的mapid，该值由Lua引擎传递给本函数。
---@param Target_FloorId  数值型 传送后的floor id，该值由Lua引擎传递给本函数。
---@param Target_X  数值型 传送后的x，该值由Lua引擎传递给本函数。
---@param Target_Y  数值型 传送后的y，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function WarpEventCallBack(CharIndex, Ori_MapId, Ori_FloorId, Ori_X, Ori_Y, Target_MapId, Target_FloorId, Target_X, Target_Y) end

---创建一个所有玩家掉线就会触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[DropEventCallBack]
---@return any @
function NL.RegDropEvent(Dofile, FuncName) end

---DropEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@return number @返回0即可。
function DropEventCallBack(CharIndex) end

---创建一个所有玩家角色更换称号即可触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[TitleChangedCallBack]
---@return any @
function NL.RegTitleChangedEvent(Dofile, FuncName) end

---TitleChangedEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param Ori_Title  数值型 旧title id，该值由Lua引擎传递给本函数。
---@param New_Title  数值型 新title id，该值由Lua引擎传递给本函数。
---@return number @返回0正常切换称号,返回值小于0则拦截。
function TitleChangedCallBack(CharIndex, Ori_Title, New_Title) end

---创建一个对象获取战斗经验时触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[GetExpEventCallBack]
---@return any @
function NL.RegGetExpEvent(Dofile, FuncName) end

---GetExpEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param Exp  数值型 获取的经验值，该值由Lua引擎传递给本函数。
---@return any @返回对象要获取的经验值，如不对经验值操作，请不要写return语句或者写return Exp; 这个函数比道具对经验的加成优先，也就是说道具加成的经验值是在本函数返回值得基础上计算的。
function GetExpEventCallBack(CharIndex, Exp) end

---创建一个对象获取战斗技能经验时触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[GetBattleSkillExpEventCallBack]
---@return any @
function NL.RegBattleSkillExpEvent(Dofile, FuncName) end

---BattleSkillExpEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param SkillID  数值型 技能ID，该值由Lua引擎传递给本函数。
---@param Exp  数值型 获取的经验值，该值由Lua引擎传递给本函数。
---@return any @返回要获取的经验值，如不对经验值操作，请不要写return语句或者写return Exp; 这个函数比道具对经验的加成优先，也就是说道具加成的经验值是在本函数返回值得基础上计算的。
function GetBattleSkillExpEventCallBack(CharIndex, SkillID, Exp) end

---创建一个对象获取生产技能经验时触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[GetProductSkillExpEventCallBack]
---@return any @
function NL.RegProductSkillExpEvent(Dofile, FuncName) end

---GetProductSkillExpEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param SkillID  数值型 技能ID，该值由Lua引擎传递给本函数。
---@param Exp  数值型 获取的经验值，该值由Lua引擎传递给本函数。
---@return any @返回要获取的经验值，如不对经验值操作，请不要写return语句或者写return Exp; 这个函数比道具对经验的加成优先，也就是说道具加成的经验值是在本函数返回值得基础上计算的。
function GetProductSkillExpEventCallBack(CharIndex, SkillID, Exp) end

---创建一个宠物升级触发的Lua函数，玩家宠物在游戏中升级后就可触发，可以用来在特定等级给予特定奖励，记录玩家宠物冲级速度排行等。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[LevelUpCallBack]
---@return any @
function NL.RegPetLevelUpEvent(Dofile, FuncName) end

---PetLevelUpEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@return number @返回0即可。
function LevelUpCallBack(CharIndex) end

---创建一个所有玩家离开战斗就会触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[BattleExitCallBack]
---@return any @
function NL.RegBattleExitEvent(Dofile, FuncName) end

---BattleExitEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param BattleIndex  数值型 战斗Index，该值由Lua引擎传递给本函数。
---@param Type  数值型 离开战斗的方式，如果值为1则表示正常离开（包括战斗胜利、失败、逃跑、登出），如果该值为2，则表示玩家被飞。该值由Lua引擎传递给本函数。
---@return any @
function BattleExitCallBack(CharIndex, BattleIndex, Type) end

---创建一个玩家右键点击其他玩家就会触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[RightClickCallBack]
---@return any @
function NL.RegRightClickEvent(Dofile, FuncName) end

---RightClickEvent的回调函数
---@param CharIndex  数值型 响应事件（发起事件）的对象index，该值由Lua引擎传递给本函数。(触发事件的玩家)
---@param TargetCharIndex  数值型 响应事件（被响应事件）的对象index，该值由Lua引擎传递给本函数。(被右键点击的玩家)
---@return any @
function RightClickCallBack(CharIndex, TargetCharIndex) end

---创建一个服务器程序关闭触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[ShutDownCallBack]
---@return any @
function NL.RegShutDownEvent(Dofile, FuncName) end

---ShutDownEvent的回调函数
---@param 
---@return number @返回0即可。
function ShutDownCallBack() end

---创建一个玩家组队触发的事件。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[PartyEventCallBack]
---@return any @
function NL.RegPartyEvent(Dofile, FuncName) end

---PartyEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。（队员）
---@param TargetCharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。（队长）
---@param Type  数值型 模式，离队还是加入团队，该值由Lua引擎传递给本函数。（0 加入组队，1 离开组队）
---@return number @返回1表示允许操作，返回0表示禁止操作（组队失败/离队失败）
function PartyEventCallBack(CharIndex, TargetCharIndex, Type) end

---当玩家进行宠物封印的时候会触发该事件，并且返回封印的结果，同时Lua也可以对封印结果进行修改。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param 
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[SealEventCallBack]
---@return any @
function NL.RegSealEvent(Dofile, FuncName) end

---SealEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param EnemyIndex  数值型 被封印的怪物对象，该值由Lua引擎传递给本函数。
---@param Ret  数值型 封印的结果，具体请查看下面对RetFlg的值的解析，该值由Lua引擎传递给本函数。
---@param Ret
---@param RetFlg为服务端对封印动作的判定结果，值可能为负数，也可能为正数，如果为负数则表示封印失败，如果为正数则表示封印成功。 封印失败返回值对应解析：
---@param -1 ：被封印对象的类型错误
---@param -2 ：被封印对象不能作为宠物
---@param -3 ：玩家身上没有足够栏位
---@param -4 ：玩家等级不足以封印宠物
---@param -5 ：被封印的宠物是召唤出来的而非野生的
---@param -6 ：玩家没有被封印宠物的图鉴
---@param -7 ：使用的封印卡道具不存在
---@param -8 ：使用的道具并不是封印卡道具
---@param -9 ：使用的封印卡没有参数设置
---@param -10：使用的封印卡种族不正确
---@param -11：不能封印邪魔系宠物
---@param ?-100：封印随机几率不足，还原封印随机几率的公式为 abs(rate/100)-1
---@return any @可以直接返回RetFlg参数，也可根据需求返回正数或者负数，返回值将影响玩家封印效果
function SealEventCallBack(CharIndex, EnemyIndex, Ret) end

---当玩家戰鬥中發出指令的时候会触发该事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[BattleActionEventCallBack]
---@return any @
function NL.RegBattleActionEvent(Dofile, FuncName) end

---BattleActionEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param BattleIndex  数值型 响应事件的战斗index，该值由Lua引擎传递给本函数。
---@param Com1  数值型 戰鬥使用的動作編號，该值由Lua引擎传递给本函数。
---@param Com2  数值型 動作的目標對象的位置，该值由Lua引擎传递给本函数。
---@param Com3  数值型 所對應的tech的ID，该值由Lua引擎传递给本函数。
---@param ActionNum  数值型 是對象的第幾動作，通常不帶寵物可以有2次有效動作，该值由Lua引擎传递给本函数。
---@return any @
function BattleActionEventCallBack(CharIndex, BattleIndex, Com1, Com2, Com3, ActionNum) end

---玩家所有的Action事件都會觸發本函數，如使用暈倒，攻擊，剪刀，石頭，布等。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[CharActionEventCallBack]
---@return any @
function NL.RegCharActionEvent(Dofile, FuncName) end

---CharActionEvent的回调函数
---@param CharIndex  数值型 响应事件（发起事件）的对象index，该值由Lua引擎传递给本函数。
---@param ActionID  数值型 玩家的動作ID，该值由Lua引擎传递给本函数。
---@return any @
function CharActionEventCallBack(CharIndex, ActionID) end

---當玩家使用生產技能製作道具的時候會觸發，可以通過該事件獲取玩家對象，技能的ID、等級和生成的道具對象。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[MergeItemEventCallBack]
---@return any @
function NL.RegMergeItemEvent(Dofile, FuncName) end

---MerGeItemEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param SkillID  数值型 生產道具所用的技能ID，该值由Lua引擎传递给本函数。
---@param SkillLv  数值型 生產道具所用的技能等級，该值由Lua引擎传递给本函数。
---@param ItemIndex  数值型 生成出的道具的對象，如果為-1，則表示生成道具失敗，该值由Lua引擎传递给本函数。
---@return any @
function MergeItemEventCallBack(CharIndex, SkillID, SkillLv, ItemIndex) end

---创建一个道具重叠触发的事件，这个道具重叠的意思是，在道具栏把一个道具拖向另一个道具会触发的事件。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[ItemOverLapEventCallBack]
---@return any @
function NL.RegItemOverLapEvent(Dofile, FuncName) end

---ItemOverLapEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param FromItemIndex  数值型 被选中的道具的对象，该值由Lua引擎传递给本函数。
---@param TargetItemIndex  数值型 被覆盖的道具的对象，该值由Lua引擎传递给本函数。
---@param Num  数值型 被选中的道具的数量，该值由Lua引擎传递给本函数
---@return number @如果有操作则返回非0值，否则返回0（执行移动道具的操作）
function ItemOverLapEventCallBack(CharIndex, FromItemIndex, TargetItemIndex, Num) end

---创建一个用户登录的时候获取登陆点信息触发的事件，这个事件可以替代Login事件中的原地登陆功能，只需要在Callback中直接设置对象的坐标等信息即可，无需warp。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[GetLoginPointEventCallBack]
---@return any @
function NL.RegGetLoginPointEvent(Dofile, FuncName) end

---GetLOginPointEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param MapID  数值型 登陆的Map ID，该值由Lua引擎传递给本函数。
---@param FloorID  数值型 登陆的Floor ID，该值由Lua引擎传递给本函数。
---@param X  数值型 登陆的X坐标，该值由Lua引擎传递给本函数。
---@param Y  数值型 登陆的Y坐标，该值由Lua引擎传递给本函数。
---@return any @
function GetLoginPointEventCallBack(CharIndex, MapID, FloorID, X, Y) end

---创建一个可以在itemset中使用的道具效果字段，当道具触发该字段时，将会自动调用定义的lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@param ItemSigh  字符串 Itemset中对应的功能字段，初始化触发的函数用LUA_init开头、使用触发的函数用LUA_use开头、装备道具触发的函数用LUA_att开头、卸除装备触发的函数用LUA_det开头、道具丢下时触发的函数用LUA_drop开头、道具拾取前触发的函数用LUA_prepick开头、道具拾取后触发的函数用LUA_pick开头
---@param itemset.txt中的自定义函数名所对应的列不同.
---@param FuncName所定义的函数的申明格式根据不同的道具效果而不同，具体请参考以下数据 
---@param 
---@param LUA_init： [ItemStringInitCallBack] 道具初始化触发,itemset.txt第4列填自定义函数名.
---@param LUA_use ： [ItemStringUseCallBack] 道具使用触发,itemset.txt第6列填自定义函数名.
---@param LUA_att ： [ItemStringAttachCallBack] 道具装备触发,itemset.txt第7列填自定义函数名.
---@param LUA_det ： [ItemStringDetachCallBack] 道具卸下触发,itemset.txt第8列填自定义函数名.
---@param LUA_drop   [ItemStringDropCallBack]道具丢下时触发,itemset.txt第9列填自定义函数名.
---@param LUA_prepick   [ItemStringPrePickUpCallBack]道具拾取前触发,itemset.txt第10列填自定义函数名.
---@param LUA_pick  [ItemStringPickUpCallBack]道具拾取后触发,itemset.txt第11列填自定义函数名.
---@return any @
function NL.RegItemString(Dofile, FuncName, ItemSigh) end

---ItemString的回调函数
---@param CharIndex  数值型 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param ItemIndex  数值型 响应事件的道具index，该值由Lua引擎传递给本函数。
---@return any @
function ItemStringInitCallBack(CharIndex, ItemIndex) end

---ItemString的回调函数
---@param CharIndex  数值型 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param TargetCharIndex  数值型 道具使用目标的对象index，对自身使用则与CharIndex值相同，该值由Lua引擎传递给本函数。
---@param ItemSlot  数值型 响应事件的道具所在的栏位，范围8-27，该值由Lua引擎传递给本函数。
---@return number @返回0即可
function ItemStringUseCallBack(CharIndex, TargetCharIndex, ItemSlot) end

---ItemString的回调函数
---@param CharIndex  数值型 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param FromItemIndex  数值型 响应事件的道具Index，该值由Lua引擎传递给本函数。
---@return any @返回值小于0则取消道具装备,返回大于等于0则正常装备。
function ItemStringAttachCallBack(CharIndex, FromItemIndex) end

---ItemString的回调函数
---@param CharIndex  数值型 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param FromItemIndex  数值型 响应事件的道具Index，该值由Lua引擎传递给本函数。
---@return any @
function ItemStringDetachCallBack(CharIndex, FromItemIndex) end

---ItemString的回调函数
---@param CharIndex  数值型 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param ItemIndex  数值型 响应事件的道具Index，该值由Lua引擎传递给本函数。
---@return any @
function ItemStringDropCallBack(CharIndex, ItemIndex) end

---ItemString的回调函数
---@param CharIndex  数值型 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param ItemIndex  数值型 响应事件的道具Index，该值由Lua引擎传递给本函数。
---@return any @返回值小于0则取消道具使用,返回大于等于0则正常拾取道具。
function ItemStringPrePickUpCallBack(CharIndex, ItemIndex) end

---ItemString的回调函数
---@param CharIndex  数值型 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param ItemIndex  数值型 响应事件的道具Index，该值由Lua引擎传递给本函数。
---@return any @
function ItemStringPickUpCallBack(CharIndex, ItemIndex) end

---创建一个所有玩家所有道具初始化时就会触发的Lua函数,此函数会加重引擎负载,请谨慎使用!
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@param 只要注册了本事件,不管道具是否具有Init函数,本函数都会触发.
---@param 触发条件如下 
---@param 玩家登陆
---@param 创建或获取新道具,
---@param 打开银行
---@param 打开公会仓库。
---@return any @
function NL.RegItemInitEvent(Dofile, FuncName) end

---ItemInitEvent的回调函数
---@param CharIndex  数值型 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param ItemIndex  数值型 响应事件的道具index，该值由Lua引擎传递给本函数。
---@return any @
function ItemInitCallBack(CharIndex, ItemIndex) end

---创建一个所有玩家使用道具(包括战斗中)就会触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegItemUseEvent(Dofile, FuncName) end

---ItemUseEvent的回调函数
---@param CharIndex  数值型 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param TargetCharIndex  数值型 道具使用目标的对象index，对自身使用则与CharIndex值相同，该值由Lua引擎传递给本函数。
---@param ItemSlot  数值型 响应事件的道具所在的栏位，范围8-27，该值由Lua引擎传递给本函数。
---@return any @返回值小于0则取消道具使用,返回大于等于0则正常使用。
function ItemUseCallBack(CharIndex, TargetCharIndex, ItemSlot) end

---创建一个所有玩家装备道具时就会触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegItemAttachEvent(Dofile, FuncName) end

---ItemAttachEvent的回调函数
---@param CharIndex  数值型 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param FromItemIndex  数值型 响应事件的道具Index，该值由Lua引擎传递给本函数。
---@return any @返回值小于0则取消道具使用,返回大于等于0则正常使用。
function ItemAttachCallBack(CharIndex, FromItemIndex) end

---创建一个所有玩家卸下装备道具时就会触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegItemDetachEvent(Dofile, FuncName) end

---ItemDetachEvent的回调函数
---@param CharIndex  数值型 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param FromItemIndex  数值型 响应事件的道具Index，该值由Lua引擎传递给本函数。
---@return any @
function ItemDetachCallBack(CharIndex, FromItemIndex) end

---创建一个所有玩家丢弃道具时就会触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegItemDropEvent(Dofile, FuncName) end

---ItemDropEvent的回调函数
---@param CharIndex  数值型 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param ItemIndex  数值型 响应事件的道具Index，该值由Lua引擎传递给本函数。
---@return any @返回值小于0则拦截丢弃,返回大于等于0则正常丢弃。
function ItemDropCallBack(CharIndex, ItemIndex) end

---创建一个所有玩家成功拾取道具之后就会触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegItemPickUpEvent(Dofile, FuncName) end

---ItemPickUpEvent的回调函数
---@param CharIndex  数值型 道具所有者的对象index，该值由Lua引擎传递给本函数。
---@param ItemIndex  数值型 响应事件的道具Index，该值由Lua引擎传递给本函数。
---@return any @返回值小于0则拦截拾取,返回大于等于0则正常拾取。
function ItemPickUpCallBack(CharIndex, ItemIndex) end

---创建一个所有玩家展示(休息)宠物就会触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegPetFieldEvent(Dofile, FuncName) end

---PetFieldEvent的回调函数
---@param CharIndex  数值型 宠物所有者的对象index，该值由Lua引擎传递给本函数。
---@param PetIndex  数值型 被展示(休息)宠物的对象index，该值由Lua引擎传递给本函数。
---@param PetPos  数值型 被展示(休息)的宠物所在栏位，该值由Lua引擎传递给本函数。
---@return any @返回值小于0则拦截展示,返回大于等于0则正常展示(休息)。
function PetFieldCallBack(CharIndex, PetIndex, PetPos) end

---创建一个所有玩家丢出宠物就会触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegPetDropEvent(Dofile, FuncName) end

---PetDropEvent的回调函数
---@param CharIndex  数值型 宠物所有者的对象index，该值由Lua引擎传递给本函数。
---@param PetPos  数值型 被丢出的宠物所在栏位，该值由Lua引擎传递给本函数。
---@return any @返回值小于0则拦截丢弃,返回大于等于0则正常丢弃。
function PetDropCallBack(CharIndex, PetPos) end

---创建一个所有玩家捡起宠物就会触发的Lua函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegPetPickUpEvent(Dofile, FuncName) end

---PetPickUpEvent的回调函数
---@param CharIndex  数值型 宠物所有者的对象index，该值由Lua引擎传递给本函数。
---@param PetIndex  数值型 要捡起宠物的对象索引，该值由Lua引擎传递给本函数。
---@return any @返回值小于0则拦截拾取,返回大于等于0则继续正常拾取流程(不是强行拾取)。
function PetPickUpCallBack(CharIndex, PetIndex) end

---战斗中计算伤害时会触发该函数
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[DamageCalculateCallBack]
---@return any @
function NL.RegDamageCalculateEvent(Dofile, FuncName) end

---DamageCalculateEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index（攻击者），该值由Lua引擎传递给本函数。
---@param DefCharIndex  数值型 响应事件的对象index（防御者），该值由Lua引擎传递给本函数。
---@param OriDamage  数值型 未修正伤害，该值由Lua引擎传递给本函数。
---@param Damage  数值型 修正伤害（真实伤害），该值由Lua引擎传递给本函数。
---@param BattleIndex  数值型 当前战斗index，该值由Lua引擎传递给本函数。
---@param Com1  数值型 攻击者使用的動作編號，该值由Lua引擎传递给本函数。
---@param Com2  数值型 攻击者攻击動作的目標對象的位置，该值由Lua引擎传递给本函数。
---@param Com3  数值型 攻击者使用的所對應的tech的ID，该值由Lua引擎传递给本函数。
---@param DefCom1  数值型 防御者使用的動作編號，该值由Lua引擎传递给本函数。
---@param DefCom2  数值型 防御者攻击動作的目標對象的位置，该值由Lua引擎传递给本函数。
---@param DefCom3  数值型 防御者使用的所對應的tech的ID，该值由Lua引擎传递给本函数。
---@param Flg  数值型 伤害模式，具体查看CONST.DamageFlags
---@return number @伤害值数值型
function DamageCalculateCallBack(CharIndex, DefCharIndex, OriDamage, Damage, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg) end

---技能附加参数获取时触发的函数
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[TechOptionCallBack]
---@return any @
function NL.RegTechOptionEvent(Dofile, FuncName) end

---TechOptionEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param Option  字符型 响应事件的技能的Option字段，该值由Lua引擎传递给本函数。
---@param TechID  数值型 当前技能的Tech ID，该值由Lua引擎传递给本函数。
---@param Val  数值型 对应字段的值，该值由Lua引擎传递给本函数。
---@return number @新的值数值型
function TechOptionCallBack(CharIndex, Option, TechID, Val) end

---创建一个所有角色显示头饰效果的时候触发的函数。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[HeadCoverEventCallBack]
---@return any @
function NL.RegHeadCoverEvent(Dofile, FuncName) end

---HeadCoverEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param CurrentHeadCoverImage  数值型 该对象当前的头饰图档id，该值由Lua引擎传递给本函数。
---@return number @返回新的头饰图档id，如不变更，则返回CurrentHeadCoverImage即可
function HeadCoverEventCallBack(CharIndex, CurrentHeadCoverImage) end

---创建一个所有玩家角色职业晋级时触发的Lua函数，玩家在游戏中角色职业晋级后就可触发，可以用来在特定职业等级给予特定奖励，记录玩家冲级速度排行等。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param InitFuncName  字符串 触发的Lua函数的名称，该函数的申明格式请参考[RankUpCallBack]
---@return any @
function NL.RegRankUpEvent(Dofile, FuncName) end

---RankUpEvent的回调函数
---@param CharIndex  数值型 响应事件的对象index，该值由Lua引擎传递给本函数。
---@param OldRank  数值型 响应事件的对象当前职业等级，该值由Lua引擎传递给本函数。
---@param NewRank  数值型 响应事件的对象职业晋级后的职业等级，该值由Lua引擎传递给本函数。
---@return any @返回值大于等于0允许晋级,返回值为负数拒绝此次晋级。
function RankUpCallBack(CharIndex, OldRank, NewRank) end

---创建一个当地面的宠物被系统删时会触发的事件，利用此事件可以进行延长该宠物的删除时间等操作。
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegPetTimeDeleteEvent(Dofile, FuncName) end

---PetTimeDeleteEvent的回调函数
---@param PetIndex  数值型 触发时间的宠物索引，该值由Lua引擎传递给本函数。
---@return any @返回值小于等于0则继续正常删除。 | 返回大于0则该宠物的删除时间将会被延长至返回值设定的秒数后删除。
function PetTimeDeleteCallBack(PetIndex) end

---创建一个战斗偷袭之前触发的事件，利用此事件可以改变战斗的偷袭形式
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return nil @
function NL.RegBattleSurpriseEvent(Dofile, FuncName) end

---BattleSurpriseEvent的回调函数
---@param battle number 战斗的index
---@param result number 此次战斗的偷袭形式 0不偷袭，1偷袭，2被偷袭
---@return number @返回0不偷袭，返回1偷袭，返回2被偷袭
function BattleSurpriseCallBack(battleIndex, result) end

---创建一个怪物施放召唤时触发的事件，利用此事件可以改变召唤物的种类和等级
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegBattleSummonEnemyEvent(Dofile, FuncName) end

---BattleSummonEnemyEvent的回调函数
---@param battle number 战斗的index
---@param charIndex number 施放召唤角色的index
---@param enemyId number 召唤的enemyId
---@return number @返回新表格 {enemyId，等级，等级波动}
function BattleSummonEnemyCallBack(battleIndex, charIndex, enemyId) end

---创建一个召唤物生成前触发的事件，利用此事件可以改变召唤物的属性
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegBattleSummonedEnemyEvent(Dofile, FuncName) end

---BattleSummonedEnemy的回调函数
---@param battle number 战斗的index
---@param charIndex number 施放召唤角色的index
---@param charIndex number 被召唤角色的index
---@return any @
function BattleSummonedEnemyCallBack(battleIndex, actionCharIndex, charIndex) end

---创建一个连战生成前触发的事件，利用此事件可以改变连战的怪物和等级
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return nil @
function NL.RegBattleNextEnemyEvent(Dofile, FuncName) end

---BattleNextEnemy的回调函数
---@param battle number 战斗的index
---@param flg number lua连战参数
---@return number @返回新表格{enmeyId,等级,...}按10-19的位置排列，返回nil取消连战
function BattleNextEnemyCallBack(battleIndex, flg) end

---创建一个连战魔物生成前触发的事件，利用此事件可以改变连战魔物的属性
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegBattleNextEnemyInitEvent(Dofile, FuncName) end

---BattleNextEnemyInit的回调函数
---@param battle number 战斗的index
---@param flg number lua连战参数
---@return any @
function BattleNextEnemyInitCallBack(battleIndex, flg) end

---创建一个怪物ai执行前触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegBeforeBattleTurnEvent(Dofile, FuncName) end

---BeforeBattleTurnEvent的回调函数
---@param battleIndex number 战斗的index
---@return any @
function BeforeBattleTurnCallBack(battleIndex) end

---创建一个所有指令已就位触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegBeforeBattleTurnStartEvent(Dofile, FuncName) end

---BeforeBattleTurnStartevent的回调函数
---@param battleIndex number 战斗的index
---@return any @
function BeforeBattleTurnStartCallBack(battleIndex) end

---创建一个回合结束触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegAfterBattleTurnEvent(Dofile, FuncName) end

---AfterBattleTurnevent的回调函数
---@param battleIndex number 战斗的index
---@return any @
function AfterBattleTurnCallBack(battleIndex) end

---创建一个角色属性计算触发的事件(包括装备属性)
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegAfterCalcCharaBpEvent(Dofile, FuncName) end

---AfterCalcCharaBpevent的回调函数
---@param charIndex number 角色的index
---@return any @
function AfterCalcCharaBpCallBack(charIndex) end

---创建一个角色装备计算触发的事件(包括受伤，掉魂)
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegAfterCalcCharaStatusEvent(Dofile, FuncName) end

---AfterCalcCharaStatusevent的回调函数
---@param charIndex number 角色的index
---@return any @
function AfterCalcCharaStatusCallBack(charIndex) end

---创建一个角色计算属性的的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegStatusCalcEvent end

---StatusCalcEvent的回调函数
---@param charIndex number 角色的index
---@return any @
function StatusCalcCallBack(charIndex) end

---创建一个怪物执行AI触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegEnemyCommandEvent(Dofile, FuncName) end

---EnemyCommandEvent的回调函数
---@param battleIndex number 战斗的index
---@param side number 0 为下方，1位上方
---@param slot number 战斗中站位
---@param action number 本回合中动作次数
---@return any @
function EnemyCommandCallBack(battleIndex, side, slot, action) end

---创建一个娃娃(替身娃娃 A|B型)结算前的触发事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegCheckDummyDollEvent(Dofile, FuncName) end

---CheckDummyDollEvent的回调函数
---@param charIndex number 角色的index
---@param battleIndex number 战斗的index
---@param dmg number 受到的伤害
---@param type number 伤害类型
---@return number @返回1可以使用娃娃，返回0禁用娃娃
function CheckDummyDoll(charIndex, battleIndex, dmg, type) end

---创建一个受伤时触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegBattleInjuryEvent(Dofile, FuncName) end

---BattleInjuryEvent的回调事件
---@param fIndex number 防御者的index
---@param aIndex number 攻击者的index
---@param battleIndex number 战斗的index
---@param inject number 受伤程度
---@return any @返回受伤程度，范围0~100
function BattleInjuryCallBack(fIndex, aIndex, battleIndex, inject) end

---创建一个战斗结算画面出现时触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegResetCharaBattleStateEvent(Dofile, FuncName) end

---ResetCharaBattleStateEvent的回调函数
---@param battleIndex number 战斗的index
---@return any @
function ResetCharaBattleStateCallBack(battleIndex) end

---创建一个角色保存后触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegCharaSavedEvent(Dofile, FuncName) end

---CharaSavedEvent的回调函数
---@param charIndex number 角色的index
---@return any @
function CharaSavedCallBack(charIndex) end

---创建一个角色数据保存前触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegBeforeCharaSaveEvent(Dofile, FuncName) end

---BeforeCharaSave的回调函数
---@param charIndex number 角色的index
---@return any @
function BeforeCharaSaveCallBack(charIndex) end

---创建一个角色删除时触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegCharaDeletedEvent(Dofile, FuncName) end

---CharaDeleted的回调函数
---@param charIndex number 角色的index
---@return any @
function CharaDeletedCallBack(charIndex) end

---创建一个luac触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegScriptCallEvent(Dofile, FuncName) end

---ScriptCallEvent的回调函数
---@param npcIndex number 触发npc的index
---@param playerIndex number 角色的index
---@param text string 由luac传入的字符串
---@param msg string 打字触发的字符串，参考头目万岁
---@return any @返回新值，返回给data
function ScriptCallCallBack(npcIndex, playerIndex, text, msg) end

---创建一个物品掉率的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegDropRateEvent(Dofile, FuncName) end

---DropRateEvent的回调函数
---@param enemyIndex number 魔物index
---@param itemId number
---@param rate number 掉落率
---@return any @
function DropRateCallBack(enemyIndex,itemId,rate) end

---创建一个逃跑时触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegBattleEscapeEvent(Dofile, FuncName) end

---BattleEscapeEvent的回调函数
---@param battle number 战斗的index
---@param charIndex number 施放召唤角色的index
---@param rate number 逃跑成功率
---@return any @成功率
function BattleEscape(battleIndex,charIndex,rate) end

---创建一个封印时触发的事件，该事件不能突破服务器的设定
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegBattleSealRateEvent(Dofile, FuncName) end

---BattleSealRateEvent的回调函数
---@param battle number 战斗的index
---@param charIndex number 施放封印角色的index
---@param enemyIndex number 封印的魔物index
---@param rate number 封印成功率
---@return any @成功率
function BattleSealRateCallBack(battleIndex,charIndex,enemyIndex,rate) end

---创建一个暴击时触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegCalcCriticalRateEvent(Dofile, FuncName) end

---CalcCriticalRateEvent的回调函数
---@param aIndex number 攻击者的index
---@param fIndex number 防御者的index
---@param rate number 必杀率
---@return any @必杀率
function CalcCriticalRateCallBack(aIndex,fIndex,rate) end

---创建一个闪躲时触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegBattleDodgeRateEvent(Dofile, FuncName) end

---BattleDodgeRateEvent的回调函数
---@param battleIndex number 战斗的index
---@param aIndex number 攻击者的index
---@param fIndex number 防御者的index
---@param rate number 闪躲率
---@return any @闪躲率
function BattleDodgeRateCallBack(battleIndex,aIndex,fIndex,rate) end

---创建一个反击时触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegBattleCounterRateEvent(Dofile, FuncName) end

---BattleCounterRateEvent的回调函数
---@param battleIndex number 战斗的index
---@param aIndex number 攻击者的index
---@param fIndex number 防御者的index
---@param rate number 反击率
---@return any @反击率
function BattleCounterRateCallBack(battleIndex,aIndex,fIndex,rate) end

---创建一个造成魔法伤害触发的事件，用于改变魔法伤害系数
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegBattleMagicDamageRateEvent(Dofile, FuncName) end

---BattleMagicDamageRateEvent的回调函数
---@param battleIndex number 战斗的index
---@param aIndex number 攻击者的index
---@param fIndex number 防御者的index
---@param rate number 魔法系数
---@return any @魔法系数
function BattleMagicDamageRateCallBack(battleIndex,aIndex,fIndex,rate) end

---创建一个造成魔法伤害触发的事件，用于改变魔防系数
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegBattleMagicRssRateEvent(Dofile, FuncName) end

---BattleMagicRssRateEvent的回调函数
---@param battleIndex number 战斗的index
---@param aIndex number 攻击者的index
---@param fIndex number 防御者的index
---@param rate number 魔防系数
---@return any @魔防系数
function BattleMagicRssRateCallBack(battleIndex,aIndex,fIndex,rate) end

---创建一个宝箱生成触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegItemBoxGenerateEvent(Dofile, FuncName) end

---ItemBoxGenerateEvent的回调函数
---@param mapId number
---@param floor number
---@param itemBoxType number 宝箱编号
---@param adm number 影响出产物品，作用未知
---@return any @number[] 返回宝箱参数 {itemBoxType, adm}
function ItemBoxGenerateCallback(mapId, floor, itemBoxType, adm) end

---创建一个宝箱获取物品的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegItemBoxLootEvent(Dofile, FuncName) end

---ItemBoxLootEvent的回调函数
---@param charaIndex number
---@param mapId number
---@param floor number
---@param X number
---@param Y number
---@param boxType number
---@param adm number
---@return number @number 返回1拦截默认物品
function ItemBoxLootCallback(charaIndex, mapId, floor, X, Y, boxType, adm) end

---创建一个宝箱遇敌概率的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegItemBoxEncountRateEvent(Dofile, FuncName) end

---ItemBoxEncountEvent的回调函数
---@param charaIndex number
---@param mapId number
---@param floor number
---@param X number
---@param Y number
---@param itemIndex number 箱子物品index
---@return number @number[]|nil 遇敌数组 每个怪物3个参数，分别为 id，等级，随机等级， 返回nil不拦截， 例子： {0, 100, 5, 1, 1, 0} 生成0号怪物100-105级，1号怪物1级
function ItemBoxEncountCallback(charaIndex, mapId, floor, X, Y, itemIndex) end

---创建一个种族伤害比率事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegItemTribeRateEvent(Dofile, FuncName) end

---ItemTribeRateEvent的回调函数
---@param a number 进攻种族
---@param b number 防守种族
---@param rate number 克制比率
---@return any @number 返回新的克制比率
function ItemTribeRateCallback(a, b, rate) end

---创建一个Http请求事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegHttpRequestEvent(Dofile, FuncName) end

---HttpRequestEvent的回调函数
---@param method string
---@param api string API名字
---@param params ParamType 参数
---@param body string body内容
---@return any @string body 返回内容
function HttpRequestCallBack(method, api, params, body) end

---创建一个治疗时触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegBattleHealCalculateEvent(Dofile, FuncName) end

---BattleHealCalculate的回调函数
---@param CharIndex  数值型 响应事件的对象index（攻击者），该值由Lua引擎传递给本函数。
---@param DefCharIndex  数值型 响应事件的对象index（防御者），该值由Lua引擎传递给本函数。
---@param Oriheal  数值型 未修正治疗，该值由Lua引擎传递给本函数。
---@param heal  数值型 修正治疗（真实治疗），该值由Lua引擎传递给本函数。
---@param BattleIndex  数值型 当前战斗index，该值由Lua引擎传递给本函数。
---@param Com1  数值型 攻击者使用的動作編號，该值由Lua引擎传递给本函数。
---@param Com2  数值型 攻击者攻击動作的目標對象的位置，该值由Lua引擎传递给本函数。
---@param Com3  数值型 攻击者使用的所對應的tech的ID，该值由Lua引擎传递给本函数。
---@param DefCom1  数值型 防御者使用的動作編號，该值由Lua引擎传递给本函数。
---@param DefCom2  数值型 防御者攻击動作的目標對象的位置，该值由Lua引擎传递给本函数。
---@param DefCom3  数值型 防御者使用的所對應的tech的ID，该值由Lua引擎传递给本函数。
---@param Flg  数值型 伤害模式，具体查看CONST.HealDamageFlags
---@return any @治疗值
function BattleHealCalculateCallBack(charIndex, defCharIndex, oriheal, heal, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg) end

---创建一个耗魔时触发的事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegCalcFpConsumeEvent(Dofile, FuncName) end

---CalcFpConsume的回调函数
---@param charIndex number 角色的index
---@param techId number 技能id
---@param Fp number 耗魔数值
---@return any @耗魔数值
function CalcFpConsumeCallBack(charIndex,techId,Fp) end

---创建一个装备说明的事件，用于修改物品说明
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegItemExpansionEvent(Dofile, FuncName) end

---ItemExpansion的回调函数
---@param itemIndex number
---@param type number 1物品说明，2右键说明
---@param msg string 物品说明内容
---@param charIndex number
---@param slot number 道具位置
---@return any @string 物品说明
function ItemExpansionCallBack(itemIndex, type, msg, charIndex, slot) end

---创建一个检查称号触发的事件，用于通过lua自定义称号，定义方式：titleconfig.txt中增加新条件设置，使用LUA为条件关键字，如LUA=50,=对应Flg中的5,50对应Data
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegTitleCheckCallEvent(Dofile, FuncName) end

---TitleCheckCallEvent的回调函数
---@param charIndex number 角色的index
---@param Data number 条件数值
---@param Flg number 条件判定符 0 <= 1 >= 2 <> 3 > 4 < 5 =
---@return number @返回0称号条件不满足，返回1称号条件满足
function TitleCheckCallCallBack(charIndex, Data, Flg) end

---创建一个采集技能事件
---@param Dofile  字符串 要加载的脚本文件名，如果为当前文件，则定义nil即可
---@param FuncName  字符串 指向的Lua函数的名称
---@return any @
function NL.RegGatherItemEvent(Dofile, FuncName) end

---GatherItemEvent的回调函数
---@param charIndex number 角色的index
---@param skillId number 技能id
---@param skillLv number 技能等级
---@param itemNo number 采集物Id,参考itemset.txt
---@return number @返回采集物的Id，参考itemset.txt | 不写返回值时采集为默认结果
function GatherItemEventCallback(charIndex, skillId, skillLv, itemNo)  end

