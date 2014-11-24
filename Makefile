#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

TOPDIR ?= $(CURDIR)
include $(DEVKITARM)/base_rules

ifeq ($(strip $(INPCAP)),)
$(error "The INPCAP param is required.")
endif

ifeq ($(strip $(PAYLOADURL)),)
$(error "The PAYLOADURL param is required.")
endif

.PHONY: clean all

all:	smashbrosusa_demo_beaconhax.pcap smashbroseur_demo_beaconhax.pcap smashbros_gameusav100_beaconhax.pcap smashbros_gameusav102_beaconhax.pcap smashbros_gameusav104_beaconhax.pcap smashbrosfullgame_beaconseq0.pcap smashbrosfullgame_beaconseq1.pcap smashbrosfullgame_beaconseq2.pcap smashbrosfullgame_beaconseq3.pcap smashbrosfullgame_beaconseq5.pcap

clean:
	rm -f smashbrosusa_demo_beaconhax.pcap smashbroseur_demo_beaconhax.pcap smashbros_gameusav100_beaconhax.pcap smashbros_gameusav102_beaconhax.pcap smashbros_gameusav104_beaconhax.pcap
	rm -f smashbrosusa_demo_beaconoui15.bin smashbroseur_demo_beaconoui15.bin smashbrosusa_demo_beaconoui15.bin smashbros_gameusav102_beaconoui15.bin smashbros_gameusav104_beaconoui15.bin
	rm -f smashbrosusa_demo_beaconoui15.elf smashbroseur_demo_beaconoui15.elf smashbros_gameusav100_beaconoui15.elf smashbros_gameusav102_beaconoui15.elf smashbros_gameusav104_beaconoui15.elf
	rm -f smashbrosusa_demo_beacon_rop_payload.bin smashbroseur_demo_beacon_rop_payload.bin smashbros_gameusav100_beacon_rop_payload.bin smashbros_gameusav102_beacon_rop_payload.bin smashbros_gameusav104_beacon_rop_payload.bin
	rm -f smashbrosusa_demo_beacon_rop_payload.elf smashbroseur_demo_beacon_rop_payload.elf smashbros_gameusav100_beacon_rop_payload.elf smashbros_gameusav102_beacon_rop_payload.elf smashbros_gameusav104_beacon_rop_payload.elf
	
	rm -f smashbrosfullgame_beaconseq0.pcap smashbrosfullgame_beaconseq1.pcap smashbrosfullgame_beaconseq2.pcap smashbrosfullgame_beaconseq3.pcap smashbrosfullgame_beaconseq5.pcap
	rm -f smashbrosfullgame_beaconseq0.bin smashbrosfullgame_beaconseq1.bin smashbrosfullgame_beaconseq2.bin smashbrosfullgame_beaconseq3.bin smashbrosfullgame_beaconseq5.bin
	rm -f smashbrosfullgame_beaconseq0.elf smashbrosfullgame_beaconseq1.elf smashbrosfullgame_beaconseq2.elf smashbrosfullgame_beaconseq3.elf smashbrosfullgame_beaconseq5.elf

smashbrosusa_demo_beaconhax.pcap: smashbrosusa_demo_beaconoui15.bin smashbrosusa_demo_beacon_rop_payload.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=$@ --inoui15=smashbrosusa_demo_beaconoui15.bin --addtagex=0xfe,0x2,smashbrosusa_demo_beacon_rop_payload.bin

smashbroseur_demo_beaconhax.pcap: smashbroseur_demo_beaconoui15.bin smashbroseur_demo_beacon_rop_payload.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=$@ --inoui15=smashbroseur_demo_beaconoui15.bin --addtagex=0xfe,0x2,smashbroseur_demo_beacon_rop_payload.bin

smashbros_gameusav100_beaconhax.pcap: smashbros_gameusav100_beaconoui15.bin smashbros_gameusav100_beacon_rop_payload.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=$@ --inoui15=smashbros_gameusav100_beaconoui15.bin --addtagex=0xfe,0x2,smashbros_gameusav100_beacon_rop_payload.bin

smashbros_gameusav102_beaconhax.pcap: smashbros_gameusav102_beaconoui15.bin smashbros_gameusav102_beacon_rop_payload.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=$@ --inoui15=smashbros_gameusav102_beaconoui15.bin --addtagex=0xfe,0x2,smashbros_gameusav102_beacon_rop_payload.bin

smashbros_gameusav104_beaconhax.pcap: smashbros_gameusav104_beaconoui15.bin smashbros_gameusav104_beacon_rop_payload.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=$@ --inoui15=smashbros_gameusav104_beaconoui15.bin --addtagex=0xfe,0x2,smashbros_gameusav104_beacon_rop_payload.bin

smashbrosfullgame_beaconseq0.pcap: smashbros_gameusav102_beaconoui15.bin smashbrosfullgame_beaconseq0.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=$@ --inoui15=smashbros_gameusav102_beaconoui15.bin --inadditionaldata=smashbrosfullgame_beaconseq0.bin

smashbrosfullgame_beaconseq1.pcap: smashbros_gameusav102_beaconoui15.bin smashbrosfullgame_beaconseq1.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=$@ --inoui15=smashbros_gameusav102_beaconoui15.bin --inadditionaldata=smashbrosfullgame_beaconseq1.bin

smashbrosfullgame_beaconseq2.pcap: smashbros_gameusav102_beaconoui15.bin smashbrosfullgame_beaconseq2.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=$@ --inoui15=smashbros_gameusav102_beaconoui15.bin --inadditionaldata=smashbrosfullgame_beaconseq2.bin

smashbrosfullgame_beaconseq3.pcap: smashbros_gameusav102_beaconoui15.bin smashbrosfullgame_beaconseq3.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=$@ --inoui15=smashbros_gameusav102_beaconoui15.bin --inadditionaldata=smashbrosfullgame_beaconseq3.bin

smashbrosfullgame_beaconseq5.pcap: smashbros_gameusav102_beaconoui15.bin smashbrosfullgame_beaconseq5.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=$@ --inoui15=smashbros_gameusav102_beaconoui15.bin --inadditionaldata=smashbrosfullgame_beaconseq5.bin

smashbrosusa_demo_beaconoui15.bin: smashbrosusa_demo_beaconoui15.elf
	$(OBJCOPY) -O binary $< $@

smashbroseur_demo_beaconoui15.bin: smashbroseur_demo_beaconoui15.elf
	$(OBJCOPY) -O binary $< $@

smashbros_gameusav100_beaconoui15.bin: smashbros_gameusav100_beaconoui15.elf
	$(OBJCOPY) -O binary $< $@

smashbros_gameusav102_beaconoui15.bin: smashbros_gameusav102_beaconoui15.elf
	$(OBJCOPY) -O binary $< $@

smashbros_gameusav104_beaconoui15.bin: smashbros_gameusav104_beaconoui15.elf
	$(OBJCOPY) -O binary $< $@

smashbrosusa_demo_beacon_rop_payload.bin: smashbrosusa_demo_beacon_rop_payload.elf
	$(OBJCOPY) -O binary $< $@

smashbroseur_demo_beacon_rop_payload.bin: smashbroseur_demo_beacon_rop_payload.elf
	$(OBJCOPY) -O binary $< $@

smashbros_gameusav100_beacon_rop_payload.bin: smashbros_gameusav100_beacon_rop_payload.elf
	$(OBJCOPY) -O binary $< $@

smashbros_gameusav102_beacon_rop_payload.bin: smashbros_gameusav102_beacon_rop_payload.elf
	$(OBJCOPY) -O binary $< $@

smashbros_gameusav104_beacon_rop_payload.bin: smashbros_gameusav104_beacon_rop_payload.elf
	$(OBJCOPY) -O binary $< $@

smashbrosfullgame_beaconseq0.bin: smashbrosfullgame_beaconseq0.elf
	$(OBJCOPY) -O binary $< $@

smashbrosfullgame_beaconseq1.bin: smashbrosfullgame_beaconseq1.elf
	$(OBJCOPY) -O binary $< $@

smashbrosfullgame_beaconseq2.bin: smashbrosfullgame_beaconseq2.elf
	$(OBJCOPY) -O binary $< $@

smashbrosfullgame_beaconseq3.bin: smashbrosfullgame_beaconseq3.elf
	$(OBJCOPY) -O binary $< $@

smashbrosfullgame_beaconseq5.bin: smashbrosfullgame_beaconseq5.elf
	$(OBJCOPY) -O binary $< $@

smashbrosusa_demo_beaconoui15.elf:	smashbros_beaconoui15.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DREGION=1 -DAPPBUILD=0 -DLEWLANCOMMID=0x0014c110 -DBEWLANCOMMID=0x10c11400 $< -o $@

smashbroseur_demo_beaconoui15.elf:	smashbros_beaconoui15.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DREGION=2 -DAPPBUILD=0 -DLEWLANCOMMID=0x0014c110 -DBEWLANCOMMID=0x10c11400 $< -o $@

smashbros_gameusav100_beaconoui15.elf:	smashbros_beaconoui15.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DAPPBUILD=100 -DLEWLANCOMMID=0x000b8b10 -DBEWLANCOMMID=0x108b0b00 $< -o $@

smashbros_gameusav102_beaconoui15.elf:	smashbros_beaconoui15.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DAPPBUILD=102 -DLEWLANCOMMID=0x000b8b10 -DBEWLANCOMMID=0x108b0b00 $< -o $@

smashbros_gameusav104_beaconoui15.elf:	smashbros_beaconoui15.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DAPPBUILD=104 -DLEWLANCOMMID=0x000b8b10 -DBEWLANCOMMID=0x108b0b00 $< -o $@

smashbrosusa_demo_beacon_rop_payload.elf:	smashbros_beacon_rop_payload.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DREGION=1 -DAPPBUILD=0 -DPAYLOADURL=\"$(PAYLOADURL)\" $< -o $@

smashbroseur_demo_beacon_rop_payload.elf:	smashbros_beacon_rop_payload.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DREGION=2 -DAPPBUILD=0 -DPAYLOADURL=\"$(PAYLOADURL)\" $< -o $@

smashbros_gameusav100_beacon_rop_payload.elf:	smashbros_beacon_rop_payload.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DAPPBUILD=100 -DPAYLOADURL=\"$(PAYLOADURL)\" $< -o $@

smashbros_gameusav102_beacon_rop_payload.elf:	smashbros_beacon_rop_payload.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DAPPBUILD=102 -DPAYLOADURL=\"$(PAYLOADURL)\" $< -o $@

smashbros_gameusav104_beacon_rop_payload.elf:	smashbros_beacon_rop_payload.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DAPPBUILD=104 -DPAYLOADURL=\"$(PAYLOADURL)\" $< -o $@

smashbrosfullgame_beaconseq0.elf:	smashbrosfullgame_beaconseq0.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib  $< -o $@

smashbrosfullgame_beaconseq1.elf:	smashbrosfullgame_beaconseq1.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib  $< -o $@

smashbrosfullgame_beaconseq2.elf:	smashbrosfullgame_beaconseq2.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib  $< -o $@

smashbrosfullgame_beaconseq3.elf:	smashbrosfullgame_beaconseq3.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib  $< -o $@

smashbrosfullgame_beaconseq5.elf:	smashbrosfullgame_beaconseq5.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib  $< -o $@

