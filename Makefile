ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/base_rules

ifeq ($(strip $(INPCAP)),)
$(error "The INPCAP param is required.")
endif

all:	smashbrosusa_beaconhax.pcap smashbroseur_beaconhax.pcap

clean:
	rm -f smashbrosusa_beaconhax.pcap smashbroseur_beaconhax.pcap smashbrosusa_beaconoui15.bin smashbroseur_beaconoui15.bin smashbrosusa_beaconoui15.elf smashbroseur_beaconoui15.elf

smashbrosusa_beaconhax.pcap: smashbrosusa_beaconoui15.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=smashbrosusa_beaconhax.pcap --inoui15=smashbrosusa_beaconoui15.bin

smashbroseur_beaconhax.pcap: smashbroseur_beaconoui15.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=smashbroseur_beaconhax.pcap --inoui15=smashbroseur_beaconoui15.bin

smashbrosusa_beaconoui15.bin: smashbrosusa_beaconoui15.elf
	$(OBJCOPY) -O binary smashbrosusa_beaconoui15.elf smashbrosusa_beaconoui15.bin

smashbroseur_beaconoui15.bin: smashbroseur_beaconoui15.elf
	$(OBJCOPY) -O binary smashbroseur_beaconoui15.elf smashbroseur_beaconoui15.bin

smashbrosusa_beaconoui15.elf:	smashbros_beaconoui15.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DREGION=1 $< -o smashbrosusa_beaconoui15.elf

smashbroseur_beaconoui15.elf:	smashbros_beaconoui15.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -DREGION=2 $< -o smashbroseur_beaconoui15.elf

