#ifndef SMASHBROSHAX_H_
#define SMASHBROSHAX_H_

#if APPBUILD==0
//USA/EUR demos(unknown if these are valid for the JPN demos):

#define ADDITIONALDATA_ADR 0x00c9d7d0
#define STACKPIVOT_ADR 0x0012a4f4 //This stack-pivot gadget also exists in spider.
#define POP_PC 0x0010b930
#define POP_R0R4SLIPPC 0x001ca5b4 //pop {r0, r1, r2, r3, r4, sl, ip, pc}
#define NWMUDS_RecvBeaconBroadcastData 0x00314860 //r0=outbuf, r1=size, r2=u8id, r3=wlancommID

#elif APPBUILD==10//Full-game v1.0.

#if REGION==3//JPN
#define STACKPIVOT_ADR 0x0012e264

#error "This appbuild+region isn't fully supported."
#else
#error "The specified region for this APPBUILD value is not supported."
#endif

#else
#error "The specified APPBUILD value is not supported."
#endif

#define POP_LRPC STACKPIVOT_ADR+0x18
#define MOVSPLR_POPLRPC STACKPIVOT_ADR+0x14 //"mov sp, lr" "pop {lr, pc}"

#define BEACONDATA_ADR ADDITIONALDATA_ADR+0xb8
#define BEACONTAGDATA_OUITYPE80_ADR (BEACONDATA_ADR + (0xc + 0x1c + 0x1bc + 4)) //Offset 0x4 in the tag-data in the tag for OUI type 0x80(from smashbros_beacon_rop_payload.s).

#endif

