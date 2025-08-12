---@class Warp:ModuleType
local Warp = ModuleBase:createModule('warp')

--��������������������
local warpPoints = {
  { "ʥ��³����", 0, 100, 134, 218 },
  { "������", 0, 100, 681, 343 },
  { "�����ش�", 0, 100, 587, 51 },
  { "άŵ�Ǵ�", 0, 100, 330, 480 },
  { "������", 0, 300, 273, 294 },
  { "���ɴ�", 0, 300, 702, 147 },
  { "��ŵ����", 0, 400, 217, 455 },
  { "���ȴ�", 0, 400, 570, 274 },
  { "������˹��", 0, 400, 248, 247 },
  { "����³����", 0, 33200, 99, 165 },
  { "���Ǳ�����", 0, 33500, 17, 76 },
  { "��������", 0, 43100, 120, 107 },
  { "³����˹��", 0, 43000, 322, 883 },
  { "��ŵ���Ǵ�", 0, 43000, 431, 823 },
  { "�׿�������", 0, 43000, 556, 313 },
  { "���׶ٴ�", 0, 32205, 127, 138 },
  { "�Ǽͳ�", 0, 322277, 33, 56 },
  { "ʥʮ�����ߵ���", 0, 32699, 50, 50 },
  { "���＼����", 0, 32104, 48, 16 },
  { "�ɼ�������", 0, 32130, 11, 8 },
}

local function calcWarp()
  local page = math.modf((#warpPoints + 7) / 8)
  local remainder = math.fmod(#warpPoints, 8)
  return page, remainder
end

function Warp:onLoad()
  self:logInfo('load');
  local list = {};
  local totalPage, remainder = calcWarp()
  self:NPC_CreateCo('������', 103010, { x = 242, y = 88, mapType = 0, map = 1000, direction = 6 },
    function(co, npc, player, msg, color, size)
      page = 1;
      repeat
        buttons = CONST.BUTTON_����ȡ��;
        if page == 1 then
          buttons = CONST.BUTTON_��ȡ��
        elseif page == totalPage then
          buttons = CONST.BUTTON_��ȡ��;
        end
        list = {};
        for i = 1, 8 do
          local s = warpPoints[i + (page - 1) * 8];
          if s then
            list[i] = s[1];
          end
        end
        local _seqno, _select, _data;
        npc, player, _seqno, _select, _data = co:next(player, npc, CONST.����_ѡ���, buttons, 0,
          self:NPC_buildSelectionText("��������ȥ����", list));
        local column = tonumber(_data)
        _select = tonumber(_select)
        --��ҳ16 ��ҳ32 �ر�/ȡ��2
        if _select > 0 then
          if _select == CONST.BUTTON_��һҳ then
            page = page + 1;
          elseif _select == CONST.BUTTON_��һҳ then
            page = page - 1;
          else
            return
          end
        else
          local count = 8 * (page - 1) + column
          local short = warpPoints[count]
          Char.Warp(player, short[2], short[3], short[4], short[5])
          return
        end
      until false
    end)
end

function Warp:onUnload()
  self:logInfo('unload')
end

return Warp;
