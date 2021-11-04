ffi.patch(0x0058BF06, { 0x34 });
ffi.patch(0x0058C1EA, { 0x08 });
ffi.patch(0x0058C1F0, { 0xCB });
ffi.patch(0x0058C1F8, { 0xCB });
print('[DEBUG] NLG_ShowWindowTalked_Patch done')

ffi.patch(0x00572A12, { 0x7D });
print('[DEBUG] BATTLE_PVE_PATCH done')
