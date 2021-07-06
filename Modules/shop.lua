local Shop = ModuleBase:createModule('shop')

function Shop:onLoad()
  logInfo(self.name, 'load')
  local shopConfig = { sellTypes = 'all' };
  self:NPC_createShop('¿óÊ¯··Âô', 104863, { map = 1000, mapType = 0, x = 235, y = 86, direction = 4 }, shopConfig, {
    9600, 9601, 9602, 9603, 9604, 9605, 9606, 9607, 9608, 9609,
    9610, 9625, 9630, 9708, 9639, 9641, 9637, 9630, 18509
  });
  self:NPC_createShop('¿óÌõ··Âô', 104863, { map = 1000, mapType = 0, x = 237, y = 86, direction = 4 }, shopConfig, {
    9611, 9612, 9613, 9614, 9615, 9616, 9617, 9618, 9619, 9620,
    9621, 9700, 9638, 9640, 9642,
  });
  self:NPC_createShop('Ä¾²Ä··Âô', 104863, { map = 1000, mapType = 0, x = 233, y = 86, direction = 4 }, shopConfig, {
    10000, 10001, 10002, 10100, 10003, 10004, 10005, 10006, 10007, 10008,
    10009, 10010, 10011,
  });
  self:NPC_createShop('Æ¤²¼··Âô', 104863, { map = 1000, mapType = 0, x = 231, y = 86, direction = 4 }, shopConfig, {
    18211, 12415, 18634, 10400, 10401, 10402, 10403, 10404, 10405, 10406,
    10407, 10408, 10409, 10410, 10411, 40738, 40739, 40740, 40741, 40742,
  });
  self:NPC_createShop('Æ¤²¼··Âô', 104863, { map = 1000, mapType = 0, x = 229, y = 86, direction = 4 }, shopConfig, {
    40743, 40744, 40745, 40746, 40747, 40748,
  });
  self:NPC_createShop('»¨²Ý··Âô', 104863, { map = 1000, mapType = 0, x = 227, y = 86, direction = 4 }, shopConfig, {
    12800, 12801, 12802, 12803, 12804, 12805, 12806, 12807, 12808, 12809,
    12810, 12811, 12822
  });
  self:NPC_createShop('Ë®Áú··Âô', 104863, { map = 1000, mapType = 0, x = 225, y = 86, direction = 4 }, shopConfig, {
    18851, 18852, 18853, 18854, 18855, 18856, 18857, 18858, 18859, 18860,
    18861, 18862, 18863, 18864, 18865, 18866, 18867, 18843
  });
  self:NPC_createShop('ÆäËû··Âô', 104863, { map = 1000, mapType = 0, x = 223, y = 86, direction = 4 }, shopConfig, {
    --18442,
    18449, 18450, 18451, 18452, 18453, 18454, 18455, 18456, 40042, 16378,
    16379, 18310, 18311, 18312, 18313, 18443, 18195, 18795
    --18457, 18458, 18459
  });
  self:NPC_createShop('Ò©Æ···Âô', 104863, { map = 1000, mapType = 0, x = 237, y = 91, direction = 0 }, shopConfig, {
    15605, 15606, 15607, 15608, 15609, 15610, 15611, 15612, 15613, 15614,
    15615, 18567
  });
  self:NPC_createShop('ÁÏÀí··Âô', 104863, { map = 1000, mapType = 0, x = 235, y = 91, direction = 0 }, shopConfig, {
    15201, 15202, 15203, 15204, 15205, 15206, 15207, 15208, 15209, 15210,
    15211, 15212, 15213, 15214, 15215, 15216, 15217, 15218, 15219,
  });
  self:NPC_createShop('±¦Ê¯··Âô', 104863, { map = 1000, mapType = 0, x = 233, y = 91, direction = 0 }, shopConfig, {
    13609, 13619, 13629, 13639, 13649, 13659, 13669, 13679, 18375, 18658,
    18699, 40949, 40962, 40963, 46074, 606209, 606219, 606229, 606239, 606249,
  });
  self:NPC_createShop('±¦Ê¯··Âô', 104863, { map = 1000, mapType = 0, x = 231, y = 91, direction = 0 }, shopConfig, {
    606259, 606269, 606279, 606289, 606299, 606309, 606319, 606328,
  });
  self:NPC_createShop('Ë®¾§··Âô', 104863, { map = 1000, mapType = 0, x = 229, y = 91, direction = 0 }, shopConfig, {
    9201, 9202, 9203, 9204, 9209, 9218, 9227, 9236, 46630, 46631,
    46632, 46633, 46634, 46635, 46636, 46637, 9315
  });
  self:NPC_createShop('·âÓ¡··Âô', 104863, { map = 1000, mapType = 0, x = 227, y = 91, direction = 0 }, shopConfig, {
    14409, 14419, 14429, 14439, 14449, 14459, 14469, 14479, 14489,
    14499,
  });
  self:NPC_createShop('²ÊÆ±··Âô', 104863, { map = 1000, mapType = 0, x = 225, y = 91, direction = 0 }, shopConfig, {
    47763, 16000, 16001, 16002, 45950, 45981, 45969
  });
  self:NPC_createShop('±äÉí··Âô', 104863, { map = 1000, mapType = 0, x = 223, y = 91, direction = 0 }, shopConfig, {
    46329, 70001,
  });
end

function Shop:onUnload()
  logInfo(self.name, 'unload')
end

return Shop;
