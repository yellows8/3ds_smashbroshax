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

DEFINES	:=	-DPAYLOADURL=\"$(PAYLOADURL)\"
PARAMS	:=	INPCAP=$(INPCAP) PAYLOADURL=$(PAYLOADURL)

COMMIDS_DEMO	:=	LEWLANCOMMID=0x0014c110 BEWLANCOMMID=0x10c11400
COMMIDS_FULLGAME	:=	LEWLANCOMMID=0x000b8b10 BEWLANCOMMID=0x108b0b00

ifneq ($(strip $(BUILDNAME)),)
	PARAMS	:=	$(PARAMS) BUILDNAME=$(BUILDNAME)
endif

ifneq ($(strip $(REGION)),)
	PARAMS	:=	$(PARAMS) REGION=$(REGION)
	DEFINES	:=	$(DEFINES) -DREGION=$(REGION)
endif

ifneq ($(strip $(APPBUILD)),)
	PARAMS	:=	$(PARAMS) APPBUILD=$(APPBUILD)
	DEFINES	:=	$(DEFINES) -DAPPBUILD=$(APPBUILD)
endif

ifneq ($(strip $(LEWLANCOMMID)),)
	PARAMS	:=	$(PARAMS) LEWLANCOMMID=$(LEWLANCOMMID)
	DEFINES	:=	$(DEFINES) -DLEWLANCOMMID=$(LEWLANCOMMID)
endif

ifneq ($(strip $(BEWLANCOMMID)),)
	PARAMS	:=	$(PARAMS) BEWLANCOMMID=$(BEWLANCOMMID)
	DEFINES	:=	$(DEFINES) -DBEWLANCOMMID=$(BEWLANCOMMID)
endif

.PHONY: clean all

all:
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=usademo APPBUILD=0 REGION=1 $(COMMIDS_DEMO)
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=eurdemo APPBUILD=0 REGION=2 $(COMMIDS_DEMO)
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=gameusav100 APPBUILD=100 REGION=1 $(COMMIDS_FULLGAME)
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=gameusav102 APPBUILD=102 REGION=1 $(COMMIDS_FULLGAME)
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=gameusav104 APPBUILD=104 REGION=1 $(COMMIDS_FULLGAME)
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=gameotherv104 APPBUILD=104 $(COMMIDS_FULLGAME)
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=gameusav105 APPBUILD=105 REGION=1 $(COMMIDS_FULLGAME)

clean:
	@make cleanbuild --no-print-directory $(PARAMS) BUILDNAME=usademo
	@make cleanbuild --no-print-directory $(PARAMS) BUILDNAME=eurdemo
	@make cleanbuild --no-print-directory $(PARAMS) BUILDNAME=gameusav100
	@make cleanbuild --no-print-directory $(PARAMS) BUILDNAME=gameusav102
	@make cleanbuild --no-print-directory $(PARAMS) BUILDNAME=gameusav104
	@make cleanbuild --no-print-directory $(PARAMS) BUILDNAME=gameotherv104
	@make cleanbuild --no-print-directory $(PARAMS) BUILDNAME=gameusav105

buildhax:
	@make smashbros_$(BUILDNAME)_beaconhax.pcap --no-print-directory $(PARAMS)

cleanbuild:
	@rm -f smashbros_$(BUILDNAME)_beaconhax.pcap
	@rm -f smashbros_$(BUILDNAME)_beaconoui15.bin
	@rm -f smashbros_$(BUILDNAME)_beaconoui15.elf
	@rm -f smashbros_$(BUILDNAME)_beacon_rop_payload.bin
	@rm -f smashbros_$(BUILDNAME)_beacon_rop_payload.elf

smashbros_$(BUILDNAME)_beaconhax.pcap: smashbros_$(BUILDNAME)_beaconoui15.bin smashbros_$(BUILDNAME)_beacon_rop_payload.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=$@ --inoui15=smashbros_$(BUILDNAME)_beaconoui15.bin --addtagex=0xfe,0x2,smashbros_$(BUILDNAME)_beacon_rop_payload.bin

smashbros_$(BUILDNAME)_beaconoui15.bin: smashbros_$(BUILDNAME)_beaconoui15.elf
	$(OBJCOPY) -O binary $< $@

smashbros_$(BUILDNAME)_beacon_rop_payload.bin: smashbros_$(BUILDNAME)_beacon_rop_payload.elf
	$(OBJCOPY) -O binary $< $@

smashbros_$(BUILDNAME)_beaconoui15.elf:	smashbros_beaconoui15.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib $(DEFINES) $< -o $@

smashbros_$(BUILDNAME)_beacon_rop_payload.elf:	smashbros_beacon_rop_payload.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib $(DEFINES) $< -o $@

