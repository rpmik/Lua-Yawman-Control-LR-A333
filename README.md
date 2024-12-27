# Lua-Yawman-Control-LR-A333
Multifunction buttons on the Yawman Arrow Controller for the Laminar Research A330-300

X-Plane 12 FlyWithLua Script for Multifunction Yawman Arrow Controls
* [Full and Most Up To Date List](https://www.distortions.net/yawman-arrow-controller-xplane/#:~:text=All%20the%20Scripts%20(Github%20Downloads)) (at distortions.net)
* Also see [the script for the LR 737-800](https://github.com/rpmik/Lua-Yawman-Control-LR-B738).
* Also see [the script for the Toliss A321 and A321 Neo (A21N)](https://github.com/rpmik/Lua-Yawman-Control-Toliss-A321x/)
* Also see [the script for the Toliss A320](https://github.com/rpmik/Lua-Yawman-Control-Toliss-A20N/)
* Also see [the script for the Felis 747-200](https://github.com/rpmik/Lua-Controller-Mapping-Felis-B742).
* Also see [the script for the Flight Factor 777-200 v2](https://github.com/rpmik/Lua-Yawman-Control-Flight-Factor-B772).
* Also see [the script for the XCrafts E-175 for XP12](https://github.com/rpmik/Lua-Yawman-Control-XCrafts-E175).

# Requirements
* [X-Plane 12](https://www.x-plane.com/) only
* Laminar Research A330-300
* [FlyWithLua 2.8 for X-Plane 12](https://forums.x-plane.org/index.php?/files/file/82888-flywithlua-ng-next-generation-plus-edition-for-x-plane-12-win-lin-mac/)
* [Yawman Arrow Controller](https://yawmanflight.com/)

# Installation
Note that the current script does not modify your axes. You'll need to set up your Yawman Arrow's axes as you like.

Save _LR A330 Yawman Multipress.lua_ to /X-Plane 12/Resources/plugins/FlyWithLua/Scripts

Assignments closely matches Yawman's PMDG 777 mappings but there are notable differences. See Yawman's [discord](https://discord.gg/dcpTc5KP).

# TODO
* Implement radio tuning

# Assignments are In Work!
Sixpack 1, 2, 3, 4, 5, and 6 are referred to as SP1, SP2, SP3 etc. These are the two rows of three buttons, where the upper-most left button is 1 and the lower-most right button is 6.

Some Yawman documentation refer to these as MF 1L (SP1), MF 1C (SP2), MF 1R (SP3), MF 2L (SP4), MF 2C (SP5), MF 2R (SP6)

# Assignments

The following assignments are not completely documented at this time. It's best to review the script for assignments until the coder gets his house in order.

* DPAD Left = Zoom Out
* DPAD Right = Zoom In
* DPAD Center = Chase or Aircraft's Default View
* Stick, Center Click = Brakes
* POV Up = Pitch Trim Up
* POV Down = Pitch Trim Down		
* POV Left = Glance Left
* POV Right = Glance Right
* Right Bumper = Auto Pilot 1 Engage (On/Off)


* SP1 plus
	* DPAD Up = Speed Up
	* DPAD Down = Speed Down
	* DPAD Right = Speed Knob Pull
  	* DPAD Left = Speed Knob Push
  	* Right Bumper = Auto Throttle Button
* SP 2 plus
	* DPAD Down = Approach Button
	* DPAD Left = Localizer Button (I think)
	* DPAD Up = Pull Alt Knob (Dupe; need to reassign)
	* DPAD Right = Pull Hdg Knob (Dupe; need to reassign)
	* Right Bumper = Flight Director 1
	* SP5 = Red Flash Light
* SP3 plus
	* DPAD Up = AP Alt Select Up
	* DPAD Down = AP Alt Select Down
	* DPAD Left = Push Alt Knob
	* DPAD Right = Pull Alt Knob
	* Right Bumper = VNAV Button
	* SP6 = Landing Lights Toggle
* SP5 plus
	* DPAD Up = Hdg up
	* DPAD Down = Hdg Down
        * DPAD Left = Push Hdg Knob
        * DPAD Right = Pull Hdg Knob
	* Right Bumper = Push Hdg Knob (Dupe; need to reassign)
* SP6 plus
	* DPAD Up = VS Down
	* DPAD Down = VS Up
	* DPAD Left = Barometric Down
	* DPAD Right = Barometric Up
	* DPAD Center = Barometric Standard
	* Right Bumper = Push VS Knob
* LEFT Bumper then
	* Wheel Up/Down = Brakes Max (Parking Brake)
	* SP1 = View, Overhead Panel
	* SP2 = View, Radios, Transponder 
	* SP3 = View, EFB
	* SP4 = View, Glarshield
	* SP5 = View, FMS
	* SP6 = Pilot's view of throttles
	
* DPAD Up plus
	* Wheel Up = Flaps Up
	* Wheel Down = Flaps Down
	* POV Left = Glance Left
	* POV Right = Glance Right
	* POV Up = Straight Up
	* POV Down = Straight Down
	* DPAD Left = View, Pilot's View
	* DPAD Right = View, Co-Pilot's View
	* Right Bumper = Auto-Throttle Button?

* DPAD Down plus
	* Right Bumper = AP 1 Disconnect (Side stick)

