-- EDITED BY HarrierJack

-- borrowed function from technic
local S = technic.getter


-- original function used in get_planter_region(pos,size)
-- [x][z] -- y assumed to be 0
autofarmer.fastcross = {
	[1]={
		[0]={x=0,y=0,z=-1}},
	[-1]={
		[0]={x=0,y=0,z=1}},
	[0]={
		[1]={x=-1,y=0,z=0},
		[-1]={x=1,y=0,z=0}}
	}

local function get_planter_region(pos)
	local node     = minetest.get_node(pos)
	local back_dir = minetest.facedir_to_dir(node.param2)
	
	-- determine current type and set size
	local meta = minetest.get_meta(pos)
	local flag = meta:get_string("power_flag")
	local farm_width_side = 0
	local farm_length = 0
	
	if flag == "LV" then 
		farm_width_side = autofarmer.LV_planter_width_side
		farm_length = autofarmer.LV_planter_length
	elseif flag == "MV" then
		farm_width_side = autofarmer.MV_planter_width_side
		farm_length = autofarmer.MV_planter_length
	elseif flag == "HV" then
		-- custom from panel
		farm_width_side = meta:get_int("farm_side")
		farm_length = meta:get_int("farm_length")
	end
	
	
	local sideways = autofarmer.fastcross[back_dir.x][back_dir.z]
	
	local left = vector.add(pos, vector.multiply(sideways, farm_width_side))
	left = vector.add(left, back_dir)
	local far = vector.add(pos, vector.multiply(sideways, -farm_width_side))
	far = vector.add(far, vector.multiply(back_dir, farm_length))
	far = vector.add(far, {x=0,y=-1,z=0})
	
	local minx = math.min(far.x, left.x)
	local maxx = math.max(far.x, left.x)
	local minz = math.min(far.z, left.z)
	local maxz = math.max(far.z, left.z)
	
	return 
		{x=minx,y=far.y,z=minz},
		{x=maxx,y=left.y,z=maxz}
	
end


-- find next farmland
local function find_next_plant_pos(data, area, minp, maxp)
	local c_air = minetest.get_content_id("air")
	local c_weed = minetest.get_content_id("farming:weed")
	local c_soil = minetest.get_content_id("farming:soil")
	local c_soil_wet = minetest.get_content_id("farming:soil_wet")


	for z = minp.z, maxp.z do
	for x = minp.x, maxp.x do
		local above = data[area:index(x, maxp.y, z)]
		if above == c_air or above == c_weed then
			local below = data[area:index(x, minp.y, z)]
			if below == c_soil or below == c_soil_wet then
				return vector.new(x, maxp.y, z)
			end
		end
	end
	end
end



-- plant seed on pos
local function plant_seed(pos, node)
	local meta  = minetest.get_meta(pos)
	local inv   = meta:get_inventory()
	local p1,p2 = get_planter_region(pos)

	local vm = VoxelManip()
	local e1, e2 = vm:read_from_map(p1, p2)
	local area = VoxelArea:new({MinEdge=e1, MaxEdge=e2})
	local data = vm:get_data()

	local plantp = find_next_plant_pos(data, area, p1, p2)

	if plantp == nil then
-- 			print("no planting spots available")
		-- deactivate planter
		-- minetest.swap_node(pos, {name = "autofarmer:planter" })
		-- EDIT: keep running in this case as long as there is power
		return
	end

	-- get seed from inv
	local plantname = nil
	local stackindex = nil

	local localinv = inv:get_list("src")
	if localinv ~= nil then 
		for key,value in pairs(localinv) do 
			plantname = autofarmer.seeds_nodes[value:get_name()]
			stackindex = key
			if plantname ~= nil then break end
		end
	else
		return
	end


	if plantname == nil then
		-- no seeds left
		return
	end

	-- set plant
	minetest.set_node(plantp, {name=plantname})

	-- decrement seed stack
	local src = inv:get_stack("src", stackindex)
	src:take_item()
	inv:set_stack("src", stackindex, src)

end


-- set planter power consumption and infotext
-- borrowed heavily from technic:quarry
local function set_planter_demand(meta)
	local prefix = meta:get_string("power_flag")
	local machine_name = S("%s Planter"):format(prefix)
	local planter_demand
	
	-- get the right values for the right current
	if prefix == "LV" then planter_demand = autofarmer.LV_planter_demand end
	if prefix == "MV" then planter_demand = autofarmer.MV_planter_demand end
	if prefix == "HV" then planter_demand = autofarmer.HV_planter_demand end
	
	if meta:get_int("enabled") == 0 then
		meta:set_int(prefix.."_EU_demand", 0)
		meta:set_string("infotext", S("%s Disabled"):format(machine_name))
	else
		meta:set_int(prefix.."_EU_demand", planter_demand)
		meta:set_string("infotext", S(meta:get_int(prefix.."_EU_input") >= planter_demand and "%s Active" or "%s Unpowered"):format(machine_name))
	end
end



local function planter_run(pos, node)	
	local meta = minetest.get_meta(pos)
	--local inv = meta:get_inventory()
	-- initialize cache for the case we load an older world
	--inv:set_size("cache", 12)
	
	local prefix = meta:get_string("power_flag")
	
	-- create delay/chance so not every second something is planted
	if math.random(autofarmer.planter_delay) == 1 then	
		if meta:get_int("enabled") == 1 and meta:get_int(prefix.."_EU_input") >= meta:get_int(prefix.."_EU_demand") then
			-- plant on plantable spot
			plant_seed(pos, node)		
		end
	end
	
	set_planter_demand(meta)
end



-- REGISTER NODES
-- LV planter
minetest.register_node("autofarmer:lv_planter", {
	description = "LV Planter",
	tiles = {"default_copper_block.png", "default_copper_block.png",
	         "default_copper_block.png", "default_copper_block.png",
	         "default_copper_block.png^farming_tool_stonehoe.png", "default_copper_block.png"},
	paramtype2 = "facedir",
	groups = {cracky=2, tubedevice=1, tubedevice_receiver=1, technic_machine=1, technic_lv=1, mesecon_effector_off = 1, mesecon = 2},
	connect_sides = {"bottom", "front", "left", "right"},	
	tube = {
		insert_object = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			return inv:add_item("src", stack)
		end,
		can_insert = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			return inv:room_for_item("src", stack)
		end,
		connect_sides = {top = 1, front = 1, left = 1, right = 1},
	},
	mesecons = {effector = {
		action_on = function (pos, node)
			-- turn OFF on mese power
			local meta = minetest.get_meta(pos)
			meta:set_int("enabled", 0)			
		end,
		
		action_off = function (pos, node)
			-- turn ON without mesepower
			local meta = minetest.get_meta(pos)
			meta:set_int("enabled", 1)
		end
				
	}},
	on_construct = function(pos)
		local size = 6
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "LV Planter")
		meta:set_string("formspec", "size[9,7;]list[current_name;src;2.5,0;3,2;]list[current_player;main;0,3;9,4;]")
		meta:set_int("enabled", 0)
		meta:set_string("power_flag", "LV")
		set_planter_demand(meta)
		local inv = meta:get_inventory()
		inv:set_size("src", size)
	end,
	
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if not inv:is_empty("src") then
			minetest.chat_send_player(player:get_player_name(),
					"Machine cannot be removed because it is not empty")
			return false
		else
			return true
		end
	end,
-- old test function
--	on_punch = function(pos) 
		-- toggle on/off
--		local meta = minetest.get_meta(pos)
--		if meta:get_int("enabled") == 1 then
--			meta:set_int("enabled", 0)
--		else
--			meta:set_int("enabled", 1)
--		end
--	end,
	
	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
		pipeworks.scan_for_tube_objects(pos)
	end,
	on_receive_fields = function(pos, formname, fields, player)
			-- receive form spec here
		
	end,
	after_dig_node = pipeworks.scan_for_tube_objects,
	technic_run = planter_run,
})


-- create formspec for HV planter
local function set_HV_planter_formspec(meta)
	local side = meta:get_int("farm_side")
	local length = meta:get_int("farm_length")
	
	meta:set_string("formspec", "size[9,7;]"..
			"list[current_name;src;0,0;4,2;]"..
			"list[current_player;main;0,3;9,4;]"..
			"field[5,0.5;1,1;farm_side;Side;"..side.."]"..	
			"field[5,1.5;1,1;farm_length;Length;"..length.."]"..
			"button_exit[6,2;2,1;exit;Save]")
	
end


-- MV PLANTER
minetest.register_node("autofarmer:mv_planter", {
	description = "MV Planter",
	tiles = {"default_bronze_block.png", "default_bronze_block.png",
	         "default_bronze_block.png", "default_bronze_block.png",
	         "default_bronze_block.png^farming_tool_bronzehoe.png", "default_bronze_block.png"},
	paramtype2 = "facedir",
	groups = {cracky=2, tubedevice=1, tubedevice_receiver=1, technic_machine=1, technic_mv=1, mesecon_effector_off = 1, mesecon = 2},
	connect_sides = {"bottom", "front", "left", "right"},
	tube = {
		insert_object = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			return inv:add_item("src", stack)
		end,
		can_insert = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			return inv:room_for_item("src", stack)
		end,
		connect_sides = {top = 1, front = 1, left = 1, right = 1},
	},
	mesecons = {effector = {
		action_on = function (pos, node)
			-- turn OFF on mese power
			local meta = minetest.get_meta(pos)
			meta:set_int("enabled", 0)			
		end,
		
		action_off = function (pos, node)
			-- turn ON without mesepower
			local meta = minetest.get_meta(pos)
			meta:set_int("enabled", 1)
		end
				
	}},
	on_construct = function(pos)
		local size = 8
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "MV Planter")
		meta:set_string("formspec", "size[9,7;]list[current_name;src;2,0;4,2;]list[current_player;main;0,3;9,4;]")
		meta:set_string("power_flag", "MV")
		meta:set_int("enabled", 0)
		set_planter_demand(meta)
		local inv = meta:get_inventory()
		inv:set_size("src", size)
	end,
	
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if not inv:is_empty("src") then
			minetest.chat_send_player(player:get_player_name(),
					"Machine cannot be removed because it is not empty")
			return false
		else
			return true
		end
	end,
	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
		pipeworks.scan_for_tube_objects(pos)
	end,
	on_receive_fields = function(pos, formname, fields, player)
		-- receive form spec here

	end,
	after_dig_node = pipeworks.scan_for_tube_objects,
	technic_run = planter_run,
})	
	

-- HV planter
minetest.register_node("autofarmer:hv_planter", {
	description = "HV Planter",
	tiles = {"default_steel_block.png", "default_steel_block.png",
	         "default_steel_block.png", "default_steel_block.png",
	         "default_steel_block.png^farming_tool_diamondhoe.png", "default_steel_block.png"},
	paramtype2 = "facedir",
	groups = {cracky=2, tubedevice=1, tubedevice_receiver=1, technic_machine=1, technic_hv=1, mesecon_effector_off = 1, mesecon = 2},
	connect_sides = {"bottom", "front", "left", "right"},
	tube = {	-- TODO CHECK DOUBLE FUNCTION?
		insert_object = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			return inv:add_item("src", stack)
		end,
		can_insert = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			return inv:room_for_item("src", stack)
		end,
		connect_sides = {top = 1, front = 1, left = 1, right = 1},
	},
	mesecons = {effector = {
		action_on = function (pos, node)
			-- turn OFF on mese power
			local meta = minetest.get_meta(pos)
			meta:set_int("enabled", 0)			
		end,
		
		action_off = function (pos, node)
			-- turn ON without mesepower
			local meta = minetest.get_meta(pos)
			meta:set_int("enabled", 1)
		end
				
	}},
	on_construct = function(pos)
		local size = 8
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "HV Planter")
		meta:set_string("power_flag", "HV")
		meta:set_int("enabled", 0)
			
		-- init meta values so they are set for first time calculations
		meta:set_int("farm_side", 0)
		meta:set_int("farm_length", 0)
			
		set_planter_demand(meta)
		local inv = meta:get_inventory()
		inv:set_size("src", size)
		set_HV_planter_formspec(meta)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if not inv:is_empty("src") then
			minetest.chat_send_player(player:get_player_name(),
					"Machine cannot be removed because it is not empty")
			return false
		else
			return true
		end
	end,
	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
		pipeworks.scan_for_tube_objects(pos)
	end,
	on_receive_fields = function(pos, formname, fields, player)
			-- receive form spec here
			if fields.exit and string.find(fields.farm_side, "^[0-9]+$") and string.find(fields.farm_length, "^[0-9]+$") then
				local side = tonumber(fields.farm_side)
				local length = tonumber(fields.farm_length)
				local meta = minetest.get_meta(pos)
				
				if side < 100 and length < 100 then
					meta:set_int("farm_side", side)
					meta:set_int("farm_length", length)
					set_HV_planter_formspec(meta)
				end	
			
			end
		end,	
	after_dig_node = pipeworks.scan_for_tube_objects,
	technic_run = planter_run,
})


technic.register_machine("LV", "autofarmer:lv_planter", technic.receiver)
technic.register_machine("MV", "autofarmer:mv_planter", technic.receiver)
technic.register_machine("HV", "autofarmer:hv_planter", technic.receiver)
