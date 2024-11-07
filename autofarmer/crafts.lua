-- crafts for autofarmer mod
-- feel free to edit


-- LV planter
minetest.register_craft({
	recipe = {
		{"default:copper_ingot", "pipeworks:one_way_tube", "default:copper_ingot"},
		{"moreores:tin_ingot", "mesecons_detector:node_detector_off", "moreores:tin_ingot"},
		{"default:copper_ingot", "moreores:tin_ingot", "default:copper_ingot"}},
	output = "autofarmer:lv_planter",
})



-- MV planter
minetest.register_craft({
	recipe = {
		{"default:bronze_ingot", "pipeworks:one_way_tube",    "default:bronze_ingot"},
		{"technic:brass_ingot", "mesecons_detector:node_detector_off",     "technic:brass_ingot"},
		{"default:bronze_ingot", "technic:brass_ingot", "default:bronze_ingot"}},
	output = "autofarmer:mv_planter",
})


-- HV planter
minetest.register_craft({
	recipe = {
		{"technic:stainless_steel_ingot", "pipeworks:one_way_tube",    "technic:stainless_steel_ingot"},
		{"technic:cast_iron_ingot", "mesecons_detector:node_detector_off",     "technic:cast_iron_ingot"},
		{"technic:stainless_steel_ingot", "technic:cast_iron_ingot", "technic:stainless_steel_ingot"}},
	output = "autofarmer:hv_planter",
})

-- MV harvester
minetest.register_craft({
	recipe = {
		{"default:dirt", "default:dirt", "default:dirt"},
		{"moreores:tin_block", "technic:motor", "moreores:tin_block"},
		{"technic:mv_cable", "moreores:tin_block", "pipeworks:pipe_1_empty"}},
	output = "autofarmer:harvester",
})


