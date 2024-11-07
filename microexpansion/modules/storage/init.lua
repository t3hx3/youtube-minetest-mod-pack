-- storage/init.lua

local module_path = microexpansion.get_module_path("storage")

microexpansion.require_module("network")

-- Load API
dofile(module_path.."/api.lua")

-- Load storage devices
dofile(module_path.."/storage.lua")

-- Load machines
dofile(module_path.."/drive.lua")
dofile(module_path.."/terminal.lua")
