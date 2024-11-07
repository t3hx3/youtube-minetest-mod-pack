--[[
                     _____  __   
  ________________ _/ ____\/  |_ 
_/ ___\_  __ \__  \\   __\\   __\
\  \___|  | \// __ \|  |   |  |  
 \___  >__|  (____  /__|   |__|  
     \/           \/             
--]]

minetest.register_craftitem("digiline_remote:antenna_item", {
	description = "Antenna Crafting Component",
	inventory_image = "digiline_remote_antenna.png",
})

minetest.register_craft({
	output = "digiline_remote:antenna_item",
	recipe = {
		{"",                    "default:mese_crystal",        ""},
		{"",                    "default:tin_ingot",           ""},
		{"default:steel_ingot", "digilines:wire_std_00000000", "default:steel_ingot"},
	},
})
