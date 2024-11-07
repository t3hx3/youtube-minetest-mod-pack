local S = minetest.get_translator("basket")
local P_EXIST = minetest.get_modpath("pipeworks")

local function get_formspec(name) -- minetest.formspec_escape
	if not(name) or name == "" or name == "Portable Basket" then
		name = S("Portable Basket")
	end
	return "size[8,10]" ..
		"label[0,0.2;" .. S("Name:") .. "]" ..
		"field[1.5,0.3;5,1;infotext;;" .. minetest.formspec_escape(name) .. "]" ..
		"button[7,0;1,1;btn;OK]" ..
		"list[context;main;0,1.3;8,4;]" ..
		"list[current_player;main;0,5.85;8,1;]" ..
		"list[current_player;main;0,7.08;8,3;8]" ..
		"listring[context;main]" ..
		"listring[current_player;main]" ..
		default.get_hotbar_bg(0,5.85)
end

local on_construct = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	meta:set_string("infotext",S("Portable Basket"))
	meta:set_string("formspec",get_formspec())
	inv:set_size("main", 8*4)
end

minetest.register_node("basket:basket",{
	description = S("Portable Basket"),
	tiles = { -- +Y, -Y, +X, -X, +Z, -Z
		"cardboard_box_inner.png^basket_top.png",
		"basket_inner.png",
		"basket_side.png",
		"basket_side.png",
		"basket_side.png",
		"basket_side.png"
	},
	on_construct = on_construct,
	on_place = function(itemstack, placer, pointed_thing)
		local stack = itemstack:peek_item(1)
		local itemstack,pos = minetest.item_place(itemstack, placer, pointed_thing)

		if not pos then return itemstack end
		local stack_meta = stack:get_meta()
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		local inv_table = minetest.deserialize(stack_meta:get_string("inv"))
		if inv_table then
			inv:set_list("main", inv_table)
		end
		local description = stack_meta:get_string("description")
		if description == "" then
			description = S("Portable Basket")
		end
		meta:set_string("infotext",description)
		meta:set_string("formspec",get_formspec(description))

		itemstack:take_item()

		return itemstack
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local name = sender:get_player_name()
		if minetest.is_protected(pos, name) then
			minetest.record_protection_violation(pos, name)
			return
		end
		local meta = minetest.get_meta(pos)
		local description = fields["infotext"]
		if not fields["btn"] then return
		elseif description == "" then
			description = S("Portable Basket")
		end
		meta:set_string("infotext",description)
		meta:set_string("formspec",get_formspec(description))
	end,
	after_place_node = P_EXIST and pipeworks.after_place,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1, tubedevice = 1, tubedevice_receiver = 1},
	tube = {
		insert_object = function(pos, node, stack, direction)
			print("io")
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			return inv:add_item("main", stack)
		end,
		can_insert = function(pos, node, stack, direction)
			print("ci")
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			return inv:room_for_item("main", stack)
		end,
		input_inventory = "main",
		connect_sides = {left = 1, right = 1, back = 1, bottom = 1, top = 1, front = 1}
	},
	on_dig = function(pos, node, digger)
		if not digger:is_player() then return false end
		local digger_inv = digger:get_inventory()
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		local name = digger:get_player_name()
		if minetest.is_protected(pos, name) then
			minetest.record_protection_violation(pos, name)
			return false
		end

		if inv:is_empty("main") then
			if not minetest.is_creative_enabled(name) or not digger_inv:contains_item("main","basket:basket_craftitem") then
				local stack = ItemStack("basket:basket_craftitem")
				if not digger_inv:room_for_item("main",stack) then
					return false
				end
				digger_inv:add_item("main",stack)
			end
			minetest.set_node(pos,{name="air"})
			return true
		end

		local stack = ItemStack("basket:basket")
		local stack_meta = stack:get_meta()
		if not digger_inv:room_for_item("main",stack) then
			return false
		end

		local inv_table_raw = inv:get_list("main")
		local inv_table = {}
		for x,y in ipairs(inv_table_raw) do
			inv_table[x] = y:to_string()
		end
		inv_table = minetest.serialize(inv_table)

		do -- Check the serialized table to avoid accidents
			local inv_table_des = minetest.deserialize(inv_table)
			if not inv_table_des then
				-- If the table is too big, the serialize result might be nil.
				-- That was a bug of advtrains and is now solved.
				-- I'm not gonna use such a complex way to serialize the inventory,
				-- so just reject to dig the node.
				return false
			end
		end

		stack_meta:set_string("inv",inv_table)
		stack_meta:set_string("description",meta:get_string("infotext"))
		digger_inv:add_item("main",stack)
		minetest.set_node(pos,{name="air"})
		return true
	end,
	after_dig_node = P_EXIST and pipeworks.after_dig,
	on_rotate = P_EXIST and pipeworks.on_rotate,
	stack_max = 1,
	on_blast = function() end,
	on_drop = function(itemstack) return itemstack end,
})

minetest.register_node("basket:basket_craftitem",{ -- Empty Baskets: Skip on_place checks
	description = S("Portable Basket"),
	tiles = { -- +Y, -Y, +X, -X, +Z, -Z
		"cardboard_box_inner.png^basket_top.png",
		"basket_inner.png",
		"basket_side.png",
		"basket_side.png",
		"basket_side.png",
		"basket_side.png"
	},
	on_construct = function(pos)
		minetest.set_node(pos,{name="basket:basket"})
	end,
})

if minetest.get_modpath("default") and minetest.get_modpath("farming") then
	minetest.register_craft({
		recipe = {
			{"group:wood","farming:string","group:wood"},
			{"group:wood","","group:wood"},
			{"group:wood","group:wood","group:wood"},
		},
		output = "basket:basket_craftitem"
	})
end
