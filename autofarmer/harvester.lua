
-- EDITED BY HarrierJack
-- fixed syntax + spelling errors
-- fixed old texture references



-- borrowed function from technic
local S = technic.getter

local myst_agri = minetest.get_modpath("mystical_agriculture")

-- get some vars from gobal settings cause I was too lazy to change calculation references
-- local harvester_dig_above_nodes = autofarmer.MV_harvester_max_height
local harvester_max_depth = autofarmer.MV_harvester_max_depth


local function get_label(meta)
	if meta:get_int("enabled") == 1 then
		return "Disable"
	else return "Enable" end
end


local function get_harvester_formspec(side, length, height, label)
	return "size[9,5]"..
	        "list[context;tool;2,0;1,1;]"..
		"tooltip[tool;Tool used for harvesting]"..
		"field[0.3,1.5;1,1;side;Side;"..side.."]"..
		"field[1.3,1.5;1,1;length;Length;"..length.."]"..
		"field[2.3,1.5;1,1;height;Height;"..height.."]"..
		"button[0.5,2;2,1;toggle;"..label.."]"..
		"button_exit[1,3;1,1;exit;Save]"..
	        "list[current_player;main;0,4;9,1;]"
end



local function harvester_receive_fields(pos, formname, fields, sender)
	local meta = minetest.get_meta(pos)

	if fields.side and fields.length and fields.height then
		-- check side/length values
		if string.find(fields.side, "^[0-9]+$") and string.find(fields.length, "^[0-9]+$") and string.find(fields.height, "^[0-9]+$") then
			local side = tonumber(fields.side)
			local length = tonumber(fields.length)
			local height = tonumber(fields.height)

			if side < 100 and length < 100 and height < 100 then				
				meta:set_int("farm_side", side)
				meta:set_int("farm_length", length)
				meta:set_int("farm_height", height)

				meta:set_string("formspec", get_harvester_formspec(side, length, height, get_label(meta)))
			end	

		end
	end
	
	-- toggle on/off
	if fields.toggle then
		if meta:get_int("enabled") == 0 then
			meta:set_int("enabled", 1)
		else
			meta:set_int("enabled", 0)
		end
	end	
	
	return true
end


local function find_next_digpos(data, area, minp, maxp)
	
	for y = minp.y, maxp.y do
	for z = minp.z, maxp.z do
	for x = minp.x, maxp.x do
		-- check if node on pos(x,y,z) is allowed for diggin e.a. in harvester_dig_node
		local nname = minetest.get_name_from_content_id(data[area:index(x, y, z)])	
		if autofarmer.harvester_dig_nodes[nname] then
				-- harvest allowed
				return vector.new(x, y, z)
		end
	end
	end
	end
end


autofarmer.fastcross2 = {
	[1]={
		[0]={x=0,y=0,z=-1}},
	[-1]={
		[0]={x=0,y=0,z=1}},
	[0]={
		[1]={x=-1,y=0,z=0},
		[-1]={x=1,y=0,z=0}}
	}

	
local function get_harvester_region(pos)
	local node     = minetest.get_node(pos)
	local back_dir = minetest.facedir_to_dir(node.param2)	
	
	-- determine current type and set size
	local meta = minetest.get_meta(pos)
	local flag = meta:get_string("power_flag")
	local farm_width_side = meta:get_int("farm_side")
	local farm_length = meta:get_int("farm_length")
	local farm_height = meta:get_int("farm_height")

	local sideways = autofarmer.fastcross[back_dir.x][back_dir.z]
	
	local left = vector.add(pos, vector.multiply(sideways, farm_width_side))
	left = vector.add(left, back_dir)
	left = vector.add(left, {x=0,y=-harvester_max_depth,z=0})		-- harvester depth down (one)
	
	
	local far = vector.add(pos, vector.multiply(sideways, -farm_width_side))
	far = vector.add(far, vector.multiply(back_dir, farm_length))
	far = vector.add(far, {x=0,y=-1,z=0})
	
	far = vector.add(far, {x=0,y=farm_height,z=0})
	
	local minx = math.min(far.x, left.x)
	local maxx = math.max(far.x, left.x)
	local minz = math.min(far.z, left.z)
	local maxz = math.max(far.z, left.z)
	
	local miny = math.min(far.y, left.y)
	local maxy = math.max(far.y, left.y)
	
	
	return 
		{x=minx,y=miny,z=minz},
		{x=maxx,y=maxy,z=maxz}
	
end	
	
	
local function harvester_dig(pos)
	local meta = minetest.get_meta(pos)
	local drops = {}
	local owner = meta:get_string("owner")
		
	local p1,p2 = get_harvester_region(pos)

	local vm = VoxelManip()
	local e1, e2 = vm:read_from_map(p1, p2)
	local area = VoxelArea:new({MinEdge=e1, MaxEdge=e2})
	local data = vm:get_data()

	local digpos = find_next_digpos(data, area, p1, p2)

	if digpos then
		-- TODO probably check since it will be turned on again after power check / or do nothing?
		if minetest.is_protected and minetest.is_protected(digpos, owner) then		
			meta:set_int("enabled", 0)
			return
		end
	
		local node = minetest.get_node(digpos)
		local tool = meta:get_inventory():get_stack("tool", 1)
		local toolname = nil
		if not tool:is_empty() then
		  toolname = tool:get_name()
		  meta:set_string("infotext", "Tool: "..toolname)
		end

		local plant_type = minetest.registered_nodes[node.name]
		if myst_agri and plant_type._yields_essence then
			local newname = string.gsub(node.name, "step_6", "step_1")
			minetest.set_node(digpos, {name=newname})
			drops = {plant_type._yields_essence}
			return drops
		end

		drops = minetest.get_node_drops(node.name, toolname)		-- TODO get_node_drops(node, tool) optional tool...
		
		minetest.dig_node(digpos)
		if minetest.get_node(digpos).name == node.name then
			-- We tried to dig something undigable like a
			-- filled chest. Notice that we check for a node
			-- change, not for air. This is so that we get drops
			-- from things like concrete posts with platforms,
			-- which turn into regular concrete posts when dug.
			drops = {}
		end
	end

	return drops
end

local function send_items(items, pos, node)
	for _, item in pairs(items) do
		-- ejecting up seems the most obvious (and easy, since up is always up)
		technic.tube_inject_item(pos, pos, vector.new(0, 1, 0), item)
	end
end


local function calculate_demand(meta)	
	local height = meta:get_int("farm_height")
	local length = meta:get_int("farm_length")
	local width = meta:get_int("farm_side")
	-- calculate proper width
	width = (width * 2) + 1
	
	-- adjust for exploiting multiplying by zero height
	if(height<=0) then height = 1 end	
	if(width<=0) then width = 1 end
	if(length<=1) then length = 2 end
	
	local demand_per_node = autofarmer.harvester_demand_per_node
	
	
	-- require minimum power harvester_min_demand
	local demand = (height * length * width * demand_per_node)
	if(demand < autofarmer.harvester_min_demand) then
		demand = autofarmer.harvester_min_demand
	else
		demand = autofarmer.harvester_min_demand + demand
	end
	
	return demand
end


local function set_harvester_demand(meta)
	local prefix = meta:get_string("power_flag")
	local machine_name = S("%s Harvester"):format(prefix)
	local harvester_demand = calculate_demand(meta)
	
	-- get the right values for the right current TODO perhaps not, currently only enhanced MV implemented
	--if prefix == "LV" then harvester_demand = autofarmer.LV_harvester_demand end
	--if prefix == "MV" then harvester_demand = autofarmer.MV_harvester_demand end
	--if prefix == "HV" then harvester_demand = autofarmer.HV_harvester_demand end
	
	
	
	if meta:get_int("enabled") == 0 then
		meta:set_int(prefix.."_EU_demand", 0)
		meta:set_string("infotext", S("%s Disabled"):format(machine_name))
	else
		meta:set_int(prefix.."_EU_demand", harvester_demand)
		meta:set_string("infotext", S(meta:get_int(prefix.."_EU_input") >= harvester_demand and "%s Active" or "%s Unpowered"):format(machine_name))
	end
		
	meta:set_string("formspec", get_harvester_formspec(meta:get_int("farm_side"), meta:get_int("farm_length"), meta:get_int("farm_height"), get_label(meta)))
end


-- function called by technic mod
local function harvester_run(pos, node)
	local meta = minetest.get_meta(pos)	
	local prefix = meta:get_string("power_flag")
	
	-- create delay/chance so not every second something is harvested
	if math.random(autofarmer.MV_harvester_delay) == 1 then	
		if meta:get_int("enabled") == 1 and meta:get_int(prefix.."_EU_input") >= meta:get_int(prefix.."_EU_demand") then
			-- do harvesting work	
			local drops = harvester_dig(pos)	
			send_items(drops, pos, node)
		end
	
	end	
		
	set_harvester_demand(meta)
end
	

minetest.register_node("autofarmer:harvester", {
	description = "MV Harvester",
	tiles = {"moreores_tin_block.png", "moreores_tin_block.png",
	         "moreores_tin_block.png", "moreores_tin_block.png",
	         "moreores_tin_block.png^farming_tool_steelhoe.png", "moreores_tin_block.png"},
	paramtype2 = "facedir",
	groups = {cracky=2, tubedevice=1, technic_machine=1, technic_mv=1},
	connect_sides = {"bottom", "front", "left", "right"},
	tube = {
		connect_sides = {top = 1},	-- TODO front? (real world backside) but this was easiest since up (or down) 
										-- is always the same regardless of orientation
	},
		
	mesecons = {effector = {
	action_on = function (pos, node)
			local meta = minetest.get_meta(pos)
			meta:set_int("enabled", 0)			
		end,

		action_off = function (pos, node)
			local meta = minetest.get_meta(pos)
			meta:set_int("enabled", 1)
		end

	}},
		
	on_construct = function(pos)
		local side = 2
		local length = 5
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Harvester")
		meta:set_string("formspec", get_harvester_formspec(side, length, 1, get_label(meta)))
		meta:set_int("farm_side", side)
		meta:set_int("farm_length", length)
		meta:set_string("power_flag", "MV")
		local inv = meta:get_inventory()
		inv:set_size("main", 1)
		inv:set_size("tool", 1)
	end,
	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
		pipeworks.scan_for_tube_objects(pos)
	end,
	can_dig = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("tool")
	end,
	after_dig_node = pipeworks.scan_for_tube_objects,
	on_receive_fields = harvester_receive_fields,
	technic_run = harvester_run,
		
		-- old test function
	--on_punch = function(pos) 
		-- toggle on/off
	--	local meta = minetest.get_meta(pos)
	--	if meta:get_int("enabled") == 1 then
	--		meta:set_int("enabled", 0)
	--	else
	--		meta:set_int("enabled", 1)
	--	end
	--	end,
		
})



technic.register_machine("MV", "autofarmer:harvester", technic.receiver)

