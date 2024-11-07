-- create some basic global vars
autofarmer = {}
autofarmer.modname = minetest.get_current_modname()
autofarmer.modpath = minetest.get_modpath(autofarmer.modname)


-- load changeable settings
dofile(autofarmer.modpath .. "/default_settings.txt")

-- load planter
dofile(autofarmer.modpath .. "/planter.lua")

-- load harvester
dofile(autofarmer.modpath .. "/harvester.lua")

-- load craft recipes
dofile(autofarmer.modpath .. "/crafts.lua")


