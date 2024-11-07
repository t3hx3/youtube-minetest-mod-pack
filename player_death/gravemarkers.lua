player_death = {}
player_death.huds = {}
local namem = {}
local shapes = {}

local mode = minetest.settings:get("player_death.mode") or "Tombstone"
if mode ~= "Tombstone" and mode ~= "Drop" and mode ~= "Keep" then
		mode = "Tombstone"
	end

local death_position_message = minetest.settings:get("player_death.death_position_message") or "Player"
if death_position_message ~= "Player" and death_position_message ~= "All" and death_position_message ~= "Off" then
		death_position_message = "Player"
end

local death_show_in_hud = minetest.settings:get("player_death.death_show_in_hud") or "Yes"
if death_show_in_hud ~= "Yes" and death_show_in_hud ~= "No" then
		death_show_in_hud = "Yes"
	end

local function is_owner(pos, name)
	local owner = minetest.get_meta(pos):get_string("owner")
	if owner == "" or owner == name or minetest.check_player_privs(name, "protection_bypass") then
		return true
	end
	return false
end

local function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local function may_replace(pos, player)
	local node_name = minetest.get_node(pos).name
	local node_definition = minetest.registered_nodes[node_name]

	if not node_definition then
		return false
	end

	if node_name == "air" or node_definition.liquidtype ~= "none" then
		return true
	end

	local can_dig_func = node_definition.can_dig
	if can_dig_func and not can_dig_func(pos, player) then
		return false
	end

	return node_definition.buildable_to and not minetest.is_protected(pos, player:get_player_name())
end

local drop = function(pos, itemstack)
	local obj = minetest.add_item(pos, itemstack:take_item(itemstack:get_count()))
	if obj then
		obj:set_velocity({
			x = math.random(-10, 10) / 9,
			y = 5,
			z = math.random(-10, 10) / 9,
		})
	end
end

local output = ('')

local player_inventory_lists = { "main", "craft" }
player_death.player_inventory_lists = player_inventory_lists


local function is_all_empty(player_inv)
	for _, list_name in ipairs(player_inventory_lists) do
		if not player_inv:is_empty(list_name) then
			return false
		end
	end
	return true
end

function player_death.register_stones(recipe, name, desc, textures, light)
shapes = { --mesh identifier, shape, col
   {'_0', 'Rectangle', colbox_0_0},
   {'_1', 'Cross', colbox_1_0},
   {'_2', 'Pointed', colbox_0_0},
   {'_3', 'Short Slanted', colbox_3_0},
   {'_4', 'Short Flat', colbox_4_0},
   {'_5', 'Fancy Cross', colbox_5_0},
   {'_6', 'Staggered', colbox_6_0},
   {'_7', 'Celtic Cross', colbox_7_0},
   {'_8', 'Obelisk', colbox_8_0},
   {'_9', 'Stacked', colbox_9_0},
   {'_10', 'Rounded', colbox_0_0},
   {'_11', 'Sam', colbox_11_0},
   {'_12', '5 Pointed Star', colbox_12_0},
   {'_13', '6 Pointed Star', colbox_12_0},
   {'_14', 'Octothorp', colbox_14_0},
   }

table.insert(namem, name)

for i in ipairs (shapes) do
   local mesh = shapes[i][1]
   local shape = shapes[i][2]
   local col = shapes[i][3]
   
   minetest.register_node('player_death:'..string.lower(name)..mesh, {
      description = desc..' Gravemarker ('..shape..')',
      drawtype = 'mesh',
      mesh = 'gravemarker'..mesh..'.obj',
      tiles = {textures..'.png'},
      paramtype = 'light',
      paramtype2 = 'facedir',
      light_source = light,
      selection_box = col,
      collision_box = col,
      groups = {oddly_breakable_by_hand=2},

      allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if is_owner(pos, player:get_player_name()) then
			return count
		end
		return 0
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		return 0
	end,

	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if is_owner(pos, player:get_player_name()) then
			return stack:get_count()
		end
		return 0
	end,

	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if meta:get_inventory():is_empty("main") then
			local inv = player:get_inventory()
			if inv:room_for_item("main", {name = output}) then
				inv:add_item("main", {name = output})
			else
				minetest.add_item(pos, output)
			end
			minetest.remove_node(pos)
		end
	end,

	

	
	on_blast = function(pos)
	end,

      can_dig = function(pos, player)
		local inv = minetest.get_meta(pos):get_inventory()
		local name = ""
		if player then
			name = player:get_player_name()
		end
		return is_owner(pos, name) and inv:is_empty("main")
	end,

     on_punch = function(pos, node, player)
		if not is_owner(pos, player:get_player_name()) then
			return
		end

		if minetest.get_meta(pos):get_string("infotext") == "" then
			return
		end

		local inv = minetest.get_meta(pos):get_inventory()
		local player_inv = player:get_inventory()
		local has_space = true

		for i = 1, inv:get_size("main") do
			local stk = inv:get_stack("main", i)
			if player_inv:room_for_item("main", stk) then
				inv:set_stack("main", i, nil)
				player_inv:add_item("main", stk)
			else
				has_space = false
				break
			end
		end

		if has_space then
			if player_inv:room_for_item("main", {name = output}) then
				player_inv:add_item("main", {name = output})
			else
				minetest.add_item(pos,output)
			end
			minetest.remove_node(pos)
		end
		
		if death_show_in_hud == "Yes" then

		for keym, val in pairs(player_death.huds[player]) do
			local hudobject = player:hud_get(val)
			for key, val in pairs(hudobject) do
				if key == "world_pos" then 
					if val.x == pos.x and val.y == pos.y and val.z == pos.z then
						player:hud_remove(keym);
						player_death.huds[player][keym] = nil;
					end
				end
			end
                end

		end

	end,
   })

end
end

minetest.register_on_joinplayer(function(player)

	if death_show_in_hud == "Yes" then

	if not player_death.huds[player] then
            player_death.huds[player] = {}
        end

	end
end)

minetest.register_on_dieplayer(function(player)
        local num = math.random(0, tablelength(namem))
        output = ('player_death:'..namem[num]..'_'..tostring(math.random(0, 14)))
	local player_name = player:get_player_name()
	local pos = vector.round(player:get_pos())
	local pos_string = minetest.pos_to_string(pos)

	if death_show_in_hud == "Yes" then

	local hudid = player:hud_add({
            hud_elem_type = "waypoint",
            name = player:get_player_name().."'s grave!",
            number = 0xFFFFFF,
            world_pos = {x=pos.x, y=pos.y, z=pos.z},
        });

	player_death.huds[player][hudid] = hudid;

	end

	if mode == "Keep" or (creative and creative.is_enabled_for
			and creative.is_enabled_for(player:get_player_name())) then
		minetest.log("action", player_name .. " dies at " .. pos_string ..
			". No grave placed")
                if death_position_message == "All" then
			minetest.chat_send_all(player_name.. " died at " .. pos_string .. ".")
		end
		if death_position_message == "Player" then
			minetest.chat_send_player(player_name, "You died at " .. pos_string .. ".")
		end
                return
	end

	local player_inv = player:get_inventory()
	if is_all_empty(player_inv) then
		minetest.log("action", player_name .. " dies at " .. pos_string ..
			". No grave placed")
                if death_position_message == "All" then
			minetest.chat_send_all(player_name.. " died at " .. pos_string .. ".")
		end
		if death_position_message == "Player" then
			minetest.chat_send_player(player_name, "You died at " .. pos_string .. ".")
		end
		return
	end

	if mode == "Tombstone" and not may_replace(pos, player) then
		local air = minetest.find_node_near(pos, 1, {"air"})
		if air and not minetest.is_protected(air, player_name) then
			pos = air
		else
			mode = "Drop"
		end
	end

	if mode == "Drop" then
		for _, list_name in ipairs(player_inventory_lists) do
			for i = 1, player_inv:get_size(list_name) do
				drop(pos, player_inv:get_stack(list_name, i))
			end
			player_inv:set_list(list_name, {})
		end
		drop(pos, ItemStack(output))
		minetest.log("action", player_name .. " dies at " .. pos_string ..
			". Inventory dropped")
                if death_position_message == "All" then
			minetest.chat_send_all(player_name.." died at " .. pos_string ..
				", and dropped thier inventory.")
		end
		if death_position_message == "Player" then
			minetest.chat_send_player(player_name, "You died at " .. pos_string ..
				", and dropped your inventory.")
		end
		return
	end

	

	local param2 = minetest.dir_to_facedir(player:get_look_dir())
	minetest.set_node(pos, {name = output, param2 = param2})

	minetest.log("action", player_name .. " dies at " .. pos_string ..
		". grave placed")
	if death_position_message == "All" then
		minetest.chat_send_all(player_name .. " died at " .. pos_string ..
			", and a grave was placed.")
	end

        if death_position_message == "Player" then
		minetest.chat_send_player(player_name, "You died at " .. pos_string ..
			", and a grave was placed.")
	end

	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size("main", 8 * 4)

	for _, list_name in ipairs(player_inventory_lists) do
		for i = 1, player_inv:get_size(list_name) do
			local stack = player_inv:get_stack(list_name, i)
			if inv:room_for_item("main", stack) then
				inv:add_item("main", stack)
			else 
				drop(pos, stack)
			end
		end
		player_inv:set_list(list_name, {})
	end

	meta:set_string("formspec", graves_formspec)
	meta:set_string("owner", player_name)
	meta:set_string("infotext", player_name.."'s grave")
end)
