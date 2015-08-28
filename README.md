This is haxx for Super Smash Bros for 3DS, via local-WLAN beacon haxx. The haxx triggers while the application is scanning for local multiplayer sessions, when the beacon is being broadcasted.
In certain cases the application may somewhat hang instead of crashing.

Note that because this is a local-WLAN beacon broadcast, *all* 3DS systems in range doing regular smash-3ds multiplayer session scanning will be affected by doing this broadcasting: either the system would crash/etc(such as when the hax version doesn't match the app version), or code would run on the system. Therefore, please don't broadcast this when there's 3DS systems in range which are not your own doing the above scanning.

Remember to always broadcast the beacon on the same channel as specified in the beacon itself.

Supported application builds:
* demo: USA+EUR supported and tested.
* v1.0.0. USA: supported+tested.
* v1.0.2. USA: supported, not tested.
* v1.0.4. USA: supported+tested. "gameother": supported, not tested.
* v1.0.5. USA: "supported". The target heap address for overwriting the target object varies, hence this hax doesn't actually work right with this version. This version is not fully supported due to this. This issue doesn't seem to apply with v1.1.0.

Last version tested with this vuln was v1.1.0, vuln still isn't fixed with that version.

EUR and JPN full-game .code binaries addresses-wise are basically the same, for v1.0.4 at least. Hence, the filenames for these two regions include "gameother".

ctr-wlanbeacontool from here is required: https://github.com/yellows8/ctr-wlanbeacontool

One way to send the beacon is with aireplay-ng, however that requires a patch, see aireplay-ng.patch. For example, to send the beacon with aireplay-ng: aireplay-ng --interactive -r {beaconpcap_path} -h {host mac from pcap} -x 10 {wifi interface}

Note that the smashbrosfullgame_beaconseqX.pcap beacons aren't actually needed.

