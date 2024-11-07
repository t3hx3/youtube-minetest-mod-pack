-- power/init.lua

local me = microexpansion

local path     = microexpansion.get_module_path("power")

me.power = {}

-- Load Resources

dofile(path.."/network.lua") -- Network Management
--dofile(path.."/ctrl.lua") -- Controller/wires
dofile(path.."/gen.lua") -- Generators
