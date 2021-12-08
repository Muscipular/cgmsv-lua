ffi.patch(0x0058BF06, { 0x34 });
ffi.patch(0x0058C1EA, { 0x08 });
ffi.patch(0x0058C1F0, { 0xCB });
ffi.patch(0x0058C1F8, { 0xCB });
print('[DEBUG] NLG_ShowWindowTalked_Patch done')

ffi.patch(0x00572A12, { 0x7D });
ffi.patch(0x005836FD, { 0x3B, 0x7D, 0x1C });
print('[DEBUG] BATTLE_PVE_PATCH done')
