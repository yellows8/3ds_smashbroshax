ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/base_rules

ifeq ($(strip $(INPCAP)),)
$(error "The INPCAP param is required.")
endif

all:	smashbrosusa_demo_beaconhax.pcap smashbroseur_demo_beaconhax.pcap

clean:
	rm -f smashbrosusa_demo_beaconhax.pcap smashbroseur_demo_beaconhax.pcap smashbrosusa_demo_beaconoui15.bin smashbroseur_demo_beaconoui15.bin smashbrosusa_demo_beaconoui15.elf smashbroseur_demo_beaconoui15.elf

smashbrosusa_demo_beaconhax.pcap: smashbrosusa_demo_beaconoui15.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=smashbrosusa_demo_beaconhax.pcap --inoui15=smashbrosusa_demo_beaconoui15.bin

smashbroseur_demo_beaconhax.pcap: smashbroseur_demo_beaconoui15.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=smashbroseur_demo_beaconhax.pcap --inoui15=smashbroseur_demo_beaconoui15.bin

smashbrosusa_demo_beaconoui15.bin: smashbrosusa_demo_beaconoui15.elf
	$(OBJCOPY) -O binary smashbrosusa_demo_beaconoui15.elf smashbrosusa_demo_beaconoui15.bin

smashbroseur_demo_beaconoui15.bin: smashbroseur_demo_beaconoui15.elf
	$(OBJCOPY) -O binary smashbroseur_demo_beaconoui15.elf smashbroseur_demo_beaconoui15.bin

smashbrosusa_demo_beaconoui15.elf:	smashbros_beaconoui15.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DREGION=1 -DAPPBUILD=0 $< -o smashbrosusa_demo_beaconoui15.elf

smashbroseur_demo_beaconoui15.elf:	smashbros_beaconoui15.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DREGION=2 -DAPPBUILD=0 $< -o smashbroseur_demo_beaconoui15.elf

