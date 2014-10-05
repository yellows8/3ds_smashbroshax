ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/base_rules

ifeq ($(strip $(INPCAP)),)
$(error "The INPCAP param is required.")
endif

ifeq ($(strip $(PAYLOADURL)),)
$(error "The PAYLOADURL param is required.")
endif

all:	smashbrosusa_demo_beaconhax.pcap smashbroseur_demo_beaconhax.pcap smashbros_gamev102_beaconhax.pcap

clean:
	rm -f smashbrosusa_demo_beaconhax.pcap smashbroseur_demo_beaconhax.pcap smashbros_gamev102_beaconhax.pcap smashbrosusa_demo_beaconoui15.bin smashbroseur_demo_beaconoui15.bin smashbros_gamev102_beaconoui15.bin smashbrosusa_demo_beaconoui15.elf smashbroseur_demo_beaconoui15.elf smashbros_gamev102_beaconoui15.elf smashbrosusa_demo_beacon_rop_payload.bin smashbroseur_demo_beacon_rop_payload.bin smashbros_gamev102_beacon_rop_payload.bin smashbrosusa_demo_beacon_rop_payload.elf smashbroseur_demo_beacon_rop_payload.elf smashbros_gamev102_beacon_rop_payload.elf

smashbrosusa_demo_beaconhax.pcap: smashbrosusa_demo_beaconoui15.bin smashbrosusa_demo_beacon_rop_payload.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=$@ --inoui15=smashbrosusa_demo_beaconoui15.bin --addtagex=0xfe,0x2,smashbrosusa_demo_beacon_rop_payload.bin

smashbroseur_demo_beaconhax.pcap: smashbroseur_demo_beaconoui15.bin smashbroseur_demo_beacon_rop_payload.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=$@ --inoui15=smashbroseur_demo_beaconoui15.bin --addtagex=0xfe,0x2,smashbroseur_demo_beacon_rop_payload.bin

smashbros_gamev102_beaconhax.pcap: smashbros_gamev102_beaconoui15.bin smashbros_gamev102_beacon_rop_payload.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=$@ --inoui15=smashbros_gamev102_beaconoui15.bin --addtagex=0xfe,0x2,smashbros_gamev102_beacon_rop_payload.bin

smashbrosusa_demo_beaconoui15.bin: smashbrosusa_demo_beaconoui15.elf
	$(OBJCOPY) -O binary $< $@

smashbroseur_demo_beaconoui15.bin: smashbroseur_demo_beaconoui15.elf
	$(OBJCOPY) -O binary $< $@

smashbros_gamev102_beaconoui15.bin: smashbros_gamev102_beaconoui15.elf
	$(OBJCOPY) -O binary $< $@

smashbrosusa_demo_beacon_rop_payload.bin: smashbrosusa_demo_beacon_rop_payload.elf
	$(OBJCOPY) -O binary $< $@

smashbroseur_demo_beacon_rop_payload.bin: smashbroseur_demo_beacon_rop_payload.elf
	$(OBJCOPY) -O binary $< $@

smashbros_gamev102_beacon_rop_payload.bin: smashbros_gamev102_beacon_rop_payload.elf
	$(OBJCOPY) -O binary $< $@

smashbrosusa_demo_beaconoui15.elf:	smashbros_beaconoui15.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DREGION=1 -DAPPBUILD=0 -DWLANCOMMID=0x10c11400 $< -o $@

smashbroseur_demo_beaconoui15.elf:	smashbros_beaconoui15.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DREGION=2 -DAPPBUILD=0 -DWLANCOMMID=0x10c11400 $< -o $@

smashbros_gamev102_beaconoui15.elf:	smashbros_beaconoui15.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DAPPBUILD=102 -DWLANCOMMID=0x108b0b00 $< -o $@

smashbrosusa_demo_beacon_rop_payload.elf:	smashbros_beacon_rop_payload.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DREGION=1 -DAPPBUILD=0 -DPAYLOADURL=\"$(PAYLOADURL)\" $< -o $@

smashbroseur_demo_beacon_rop_payload.elf:	smashbros_beacon_rop_payload.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DREGION=2 -DAPPBUILD=0 -DPAYLOADURL=\"$(PAYLOADURL)\" $< -o $@

smashbros_gamev102_beacon_rop_payload.elf:	smashbros_beacon_rop_payload.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DAPPBUILD=102 -DPAYLOADURL=\"$(PAYLOADURL)\" $< -o $@

