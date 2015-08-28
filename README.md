This is haxx for Super Smash Bros for 3DS, via local-WLAN beacon haxx. The haxx triggers while the application is scanning for local multiplayer sessions, when the beacon is being broadcasted.
In certain cases the application may somewhat hang or crash prior to any actual ROP being run: this hax is not completely reliable due to heap layout not always being in the intended state.

This repo was originally created on September 26, 2014.

Note that because this is a local-WLAN beacon broadcast, *all* 3DS systems in range doing regular smash-3ds multiplayer session scanning will be affected by doing this broadcasting: either the system would crash/etc(such as when the hax version doesn't match the app version), or code would run on the system. Therefore, please don't broadcast this when there's 3DS systems in range which are not your own doing the above scanning.

# Versions
Supported application builds:
* demo: USA+EUR supported and tested. There's no difference between the regular demo and the "Special Demo" with this hax. This was the only version of Smash-3ds supported by this hax initially, until after the USA version of the game was released.
* v1.0.0. USA: supported+tested.
* v1.0.2. USA: supported, not tested.
* v1.0.4. USA: supported+tested. "gameother": supported, not tested.
* v1.0.5. USA: "supported". The target heap address for overwriting the target object varies, hence this hax doesn't actually work right with this version. This version is not fully supported due to this. This issue doesn't seem to apply with v1.1.0.

Last version tested with this vuln was v1.1.0, vuln still isn't fixed with that version.

EUR and JPN full-game .code binaries addresses-wise are basically the same, for v1.0.4 at least. Hence, the filenames for these two regions include "gameother".

This can't be completely blocked with the main app without a system-update: even if an app-update would fix it, one could just rename/whatever the update-title directory on SD card to force the system to not use the update-title(the directory name could be restored to the original later when not using this hax). One could also do this if the currently installed update-title version is not supported, or when the latest version of the update-title isn't supported(where the currently installed version isn't supported).  
The above mentioned directory is at the following SD card location: "/Nintendo 3DS/{ID0}/{ID1}/title/0004000e/{TIDHigh}".
Where TIDHigh for the update-title is one of the following:
* USA: 000edf00
* EUR: 000ee000
* JPN: 000b8b00

# Building
ctr-wlanbeacontool from here is required: https://github.com/yellows8/ctr-wlanbeacontool

# Usage
Remember to always broadcast the beacon on the same channel as specified in the beacon itself.

One way to send the beacon is with aireplay-ng, however that requires a patch, see aireplay-ng.patch. For example, to send the beacon with aireplay-ng: aireplay-ng --interactive -r {beaconpcap_path} -h {host mac from pcap} -x 10 {wifi interface}

Note that the smashbrosfullgame_beaconseqX.pcap beacons aren't actually needed.

This can be used with the homebrew-launcher otherapp payload to boot into hbmenu. However, doing so is New3DS-only: just like regionFOUR, the current application process has to terminate for Home Menu takeover to work, and smash-bros process termination on Old3DS results in a hardware-reboot(just like normal smash-bros application exiting).

