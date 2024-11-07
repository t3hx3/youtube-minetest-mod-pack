--[[
    .___.__       .__.__  .__                                                 __
  __| _/|__| ____ |__|  | |__| ____   ____     _______   ____   _____   _____/  |_  ____
 / __ | |  |/ ___\|  |  | |  |/    \_/ __ \    \_  __ \_/ __ \ /     \ /  _ \   __\/ __ \
/ /_/ | |  / /_/  >  |  |_|  |   |  \  ___/     |  | \/\  ___/|  Y Y  (  <_> )  | \  ___/
\____ | |__\___  /|__|____/__|___|  /\___  >____|__|    \___  >__|_|  /\____/|__|  \___  >
     \/   /_____/                 \/     \/_____/           \/      \/                 \/
--]]

local load_time_start = os.clock()

digiline_remote = {}

local modname = "digiline_remote"
local path = minetest.get_modpath(modname)..DIR_DELIM
dofile(path.."api.lua")
dofile(path.."antenna.lua")
dofile(path.."rc.lua")
dofile(path.."test.lua")
dofile(path.."craft.lua")


local time = math.floor(tonumber(os.clock()-load_time_start)*100+0.5)/100
local msg = "["..modname.."] loaded after ca. "..time
if time > 0.05 then
	print(msg)
else
	minetest.log("info", msg)
end
