autofarmer
================

by Izzy
Props to RealBadAngel, VanessaE. Lots of code "borrowed" from them.

Edit and fixes by HarrierJack and beepbopbeepboop, borrowing even more code..

###Introduction:
Adds automatic farming machines to minetest. They run on LV/MV/HV power from technic, and integrate with pipeworks. 

The planter will put seeds from the normal game plants (wheat etc.) and plants without seeds from farming onto available farmland in its front position and only at its own block level. 

A mesecon signal can be used to turn the machine off. Powering the planter is enough to activate it, providing there are seeds/plants inside it.

Values can be changed in default_settings.txt
LV-planter: 6000 EU for a 5 X 6 grid
MV-planter: 11000 EU for a 7 X 15 grid 
HV-planter: 22000 EU for a grid of choice through its interface

The Harvester will 'harvest' any plant/tree node within it's reach, settings are configurable through it's own form. The harvester only comes in MV flavor, _TODO: it just requires more the bigger the area._ Also height is a factor so it can be used for farming trees. Harvesting can also be done one block down so the harvester can be stacked on top of the planter.


####TODO: 	
	- [ ] do something with water/pipes? (probably not)
	- [ ] ohyeah, some pretty textures would be nice.. :S
	- [ ] Consider bonemeal for added speed.

###How to install:
Import and enable autofarmer from ContentDB.

Manual method:

Unzip the archive an place it in minetest-base-directory/mods/minetest/
if you have a windows client or a linux run-in-place client. If you have
a linux system-wide instalation place it in ~/.minetest/mods/minetest/.
If you want to install this mod only in one world create the folder
worldmods/ in your worlddirectory.
For further information or help see:
<http://wiki.minetest.com/wiki/Installing_Mods>


Requires:
[Technic](https://github.com/minetest-technic/technic)

[Mesecons](https://github.com/Jeija/minetest-mod-mesecons)

[Pipeworks](https://github.com/minetest-mods/pipeworks)

[MoreOres](https://github.com/minetest-mods/moreores)



####License:
UNLICENSE (see LICENSE file in package)
--or--
WTFPL (see below)
--or--
Whatever license you feel like. AGPLv3 is nice. ;)

See also:
<http://minetest.net/>






         DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

 Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO.

