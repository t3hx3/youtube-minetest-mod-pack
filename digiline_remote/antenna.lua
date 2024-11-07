--[[
               __
_____    _____/  |_  ____   ____   ____ _____
\__  \  /    \   __\/ __ \ /    \ /    \\__  \
 / __ \|   |  \  | \  ___/|   |  \   |  \/ __ \_
(____  /___|  /__|  \___  >___|  /___|  (____  /
     \/     \/          \/     \/     \/     \/
--]]

local max_radius = tonumber(minetest.settings:get("digiline_remote_max_radius")) or 16

minetest.register_node("digiline_remote:antenna", {
	description = "Antenna",
	tiles = {"default_steel_block.png^digiline_remote_waves.png"},
	groups = {cracky=3, digiline_remote_receive = 1},
	sounds = default.node_sound_metal_defaults(),
	digiline = {
		receptor = {action = function() end},
		effector = {
			action = function(pos, node, channel, msg)
				local meta = minetest.get_meta(pos)
				local radius = tonumber(meta:get_string("radius"))
				if meta:get_string("send_nodes") == "true" then
					digiline_remote.send_to_node(pos, channel, msg, radius, true)
				end
				if meta:get_string("send_entities") == "true" then
					digiline_remote.send_to_entity(pos, channel, msg, radius)
				end
			end
		},
	},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
				"size[3,1]"..
				"field[0.2,0.5;1,1;radius;radius;${radius}]"..
				"label[2,0;send to:]"..
				"checkbox[2,0.1;send_nodes;nodes]"..
				"checkbox[2,0.4;send_entities;entities]"..
				"button_exit[0.95,0.5;1,1;save;OK]")
		meta:set_string("radius", "3")
		meta:set_string("send_nodes", "false")
		meta:set_string("send_entities", "false")
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.get_meta(pos)
		if fields.radius and fields.radius ~= "" then
			local radius = tonumber(fields.radius)
			if radius then
				radius = math.min(radius, max_radius)
				radius = math.max(radius, -max_radius)
				meta:set_string("radius", tostring(radius))
			else
				minetest.chat_send_player(sender:get_player_name(),
						"The radius has to be a number.")
			end
		end
		if fields.send_nodes ~= nil then
			meta:set_string("send_nodes", fields.send_nodes)
		end
		if fields.send_entities ~= nil then
			meta:set_string("send_entities", fields.send_entities)
		end
		if fields.send_entities ~= nil or fields.send_nodes ~= nil then
			local b_nodes = fields.send_nodes or meta:get_string("send_nodes")
			local b_ents = fields.send_entities or meta:get_string("send_entities")
			meta:set_string("formspec",
					"size[3,1]"..
					"field[0.2,0.5;1,1;radius;radius;${radius}]"..
					"label[2,0;send to:]"..
					"checkbox[2,0.1;send_nodes;nodes;"..b_nodes.."]"..
					"checkbox[2,0.4;send_entities;entities;"..b_ents.."]"..
					"button_exit[0.95,0.5;1,1;save;OK]")
		end
	end,
	_on_digiline_remote_receive = function(pos, channel, msg)
		digilines.receptor_send(pos, digilines.rules.default, channel, msg)
	end,
})

minetest.register_craft({
	output = "digiline_remote:antenna",
	recipe = {
		{"default:steel_ingot", "digiline_remote:antenna_item", "default:steel_ingot"},
		{"default:steel_ingot", "digilines:wire_std_00000000",  "default:steel_ingot"},
	},
})
