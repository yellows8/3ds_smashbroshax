#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

TOPDIR ?= $(CURDIR)
include $(DEVKITARM)/base_rules

ifeq ($(strip $(INPCAP)),)
	INPCAP	:=	smashdemo_beacon_modbase.pcap
endif

DEFINES	:=	
PARAMS	:=	INPCAP=$(INPCAP)
INCLUDECMD	:=	

COMMIDS_DEMO	:=	LEWLANCOMMID=0x0014c110 BEWLANCOMMID=0x10c11400
COMMIDS_FULLGAME	:=	LEWLANCOMMID=0x000b8b10 BEWLANCOMMID=0x108b0b00

ifneq ($(strip $(PAYLOADURL)),)
	DEFINES	:=	$(DEFINES) -DPAYLOADURL=\"$(PAYLOADURL)\"
	PARAMS	:=	$(PARAMS) PAYLOADURL=$(PAYLOADURL)
endif

ifneq ($(strip $(PAYLOADPATH)),)
	DEFINES	:=	$(DEFINES) -DPAYLOADPATH=\"$(PAYLOADPATH)\"
	PARAMS	:=	$(PARAMS) PAYLOADPATH=$(PAYLOADPATH)
endif

ifneq ($(strip $(ADDITONALDATA_SIZE1)),)
	DEFINES	:=	$(DEFINES) -DADDITONALDATA_SIZE1=$(ADDITONALDATA_SIZE1)
	PARAMS	:=	$(PARAMS) ADDITONALDATA_SIZE1=$(ADDITONALDATA_SIZE1)
endif

ifneq ($(strip $(BEACON_BYTEID)),)
	DEFINES	:=	$(DEFINES) -DBEACON_BYTEID=$(BEACON_BYTEID)
	PARAMS	:=	$(PARAMS) BEACON_BYTEID=$(BEACON_BYTEID)
endif

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

ifneq ($(strip $(ROP_PATH)),)
	INCLUDECMD	:=	-include prebuilt_smashbrosrop/$(ROP_PATH)
endif

.PHONY: clean all

all:
	@mkdir -p pcap_out
	@mkdir -p build
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=usademo APPBUILD=0 REGION=1 $(COMMIDS_DEMO)
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=eurdemo APPBUILD=0 REGION=2 $(COMMIDS_DEMO)
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=gameusav100 APPBUILD=100 REGION=1 $(COMMIDS_FULLGAME)
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=gameotherv100 APPBUILD=100 $(COMMIDS_FULLGAME)
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=gameusav102 APPBUILD=102 REGION=1 $(COMMIDS_FULLGAME) ROP_PATH=USA/1.0.2
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=gameusav104 APPBUILD=104 REGION=1 $(COMMIDS_FULLGAME) ROP_PATH=USA/1.0.4
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=gameotherv104 APPBUILD=104 $(COMMIDS_FULLGAME) ROP_PATH=gameother/1.0.4
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=gameusav105 APPBUILD=105 REGION=1 $(COMMIDS_FULLGAME) ROP_PATH=USA/1.0.5
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=gameusav110 APPBUILD=110 REGION=1 $(COMMIDS_FULLGAME) ROP_PATH=USA/1.1.0
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=gameotherv110 APPBUILD=110 $(COMMIDS_FULLGAME) ROP_PATH=gameother/1.1.0
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=gameusav111 APPBUILD=111 REGION=1 $(COMMIDS_FULLGAME) ROP_PATH=USA/1.1.1
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=gameotherv111 APPBUILD=111 $(COMMIDS_FULLGAME) ROP_PATH=gameother/1.1.1
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=gameusav112 APPBUILD=112 REGION=1 $(COMMIDS_FULLGAME) ROP_PATH=USA/1.1.2
	@make buildhax --no-print-directory $(PARAMS) BUILDNAME=gameotherv112 APPBUILD=112 $(COMMIDS_FULLGAME) ROP_PATH=gameother/1.1.2

clean:
	@rm -R -f build
	@rm -R -f pcap_out

buildhax:
	@make pcap_out/smashbros_$(BUILDNAME)_beaconhax.pcap --no-print-directory $(PARAMS)

pcap_out/smashbros_$(BUILDNAME)_beaconhax.pcap: build/smashbros_$(BUILDNAME)_beaconoui15.bin build/smashbros_$(BUILDNAME)_beacon_rop_payload.bin
	ctr-wlanbeacontool --inpcap=$(INPCAP) --outpcap=$@ --inoui15=build/smashbros_$(BUILDNAME)_beaconoui15.bin --addtagex=0xfe,0x2,build/smashbros_$(BUILDNAME)_beacon_rop_payload.bin

build/smashbros_$(BUILDNAME)_beaconoui15.bin: build/smashbros_$(BUILDNAME)_beaconoui15.elf
	$(OBJCOPY) -O binary $< $@

build/smashbros_$(BUILDNAME)_beacon_rop_payload.bin: build/smashbros_$(BUILDNAME)_beacon_rop_payload.elf
	$(OBJCOPY) -O binary $< $@

build/smashbros_$(BUILDNAME)_beaconoui15.elf:	smashbros_beaconoui15.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib $(INCLUDECMD) $(DEFINES) $< -o $@

build/smashbros_$(BUILDNAME)_beacon_rop_payload.elf:	smashbros_beacon_rop_payload.s
	$(CC) -x assembler-with-cpp -nostartfiles -nostdlib $(INCLUDECMD) $(DEFINES) $< -o $@

