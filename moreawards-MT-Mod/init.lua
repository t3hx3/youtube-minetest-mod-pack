
--Boots of Swiftness awards
--Lightning Fast
if minetest.get_modpath("speed_boots") then
		awards.register_award("award_lightning_fast",{
		title = ("Lightning Fast"),
		description = ("Craft 5 boots of swiftness."),
		icon = "speed_boots_inv.png",
		difficulty = 0.9,
		trigger = {
			type = "craft",
			item = "speed_boots:boots_speed",
			target = 5
		}
	})
end

--3D Armor awards (in the future i want to add achievements with multiple item requirements. just don't know how to atm)
--Trying to be a Tree Monster
if minetest.get_modpath("3d_armor") then
		awards.register_award("award_armor_wood",{
		title = ("Trying to be a Tree Monster"),
		description = ("Craft 4 wooden chestplates."),
		icon = "shields_inv_shield_wood.png",
		difficulty = 0.03,
		trigger = {
			type = "craft",
			item = "3d_armor:chestplate_wood",
			target = 4
		}
	})
--Jumbo Cactus
		awards.register_award("award_armor_cactus",{
		title = ("Jumbo Cactus"),
		description = ("Craft 4 cactus chestplates."),
		icon = "shields_inv_shield_cactus.png",
		difficulty = 0.03,
		trigger = {
			type = "craft",
			item = "3d_armor:chestplate_cactus",
			target = 4
		}
	})
--Iron Man
		awards.register_award("award_armor_steel",{
		title = ("Iron Man"),
		description = ("Craft 4 steel chestplates."),
		icon = "shields_inv_shield_steel.png",
		difficulty = 0.5,
		trigger = {
			type = "craft",
			item = "3d_armor:chestplate_iron",
			target = 4
		}
	})
--Comedy Gold
		awards.register_award("award_armor_gold",{
		title = ("Comedy Gold"),
		description = ("Craft 4 gold chestplates."),
		icon = "shields_inv_shield_gold.png",
		difficulty = 0.9,
		trigger = {
			type = "craft",
			item = "3d_armor:chestplate_gold",
			target = 4
		}
	})
--Covered in Diamonds
		awards.register_award("award_armor_diamond",{
		title = ("Covered in Diamonds"),
		description = ("Craft 4 diamond chestplates."),
		icon = "shields_inv_shield_diamond.png",
		difficulty = 0.9,
		trigger = {
			type = "craft",
			item = "3d_armor:chestplate_diamond",
			target = 4
		}
	})
--Upgrades, people. Upgrades.	
		awards.register_award("award_shield_enhanced",{
		title = ("Upgrades, people. Upgrades."),
		description = ("Enhance your shield using steel ingots."),
		icon = "shields_inv_shield_enhanced_wood.png",
		difficulty = 0.5,
		trigger = {
			type = "craft",
			item = "shields:shield_enhanced_wood",
			target = 1
		}
	})	

end

--Baked Clay awards
--Adobe Maker
if minetest.get_modpath("bakedclay") then
		awards.register_award("award_clay_natural",{
		title = ("Adobe Maker"),
		description = ("Place 100 blocks of natural clay."),
		icon = "baked_clay_natural.png",
		difficulty = 0.04,
		trigger = {
			type = "place",
			node = "bakedclay:natural",
			target = 100
		}
	})
--The Grass is Greener on the other Side
		awards.register_award("award_clay_flower1",{
		title = ("The Grass is Greener on the other Side"),
		description = ("Harvest your first reed mannagrass."),
		icon = "baked_clay_mannagrass.png",
		difficulty = 0.009,
		trigger = {
			type = "dig",
			node = "bakedclay:mannagrass",
			target = 1
		}
	})
--Thistles and Thimbles	
		awards.register_award("award_clay_flower2",{
		title = ("Thistles and Thimbles"),
		description = ("Harvest your first thistle."),
		icon = "baked_clay_thistle.png",
		difficulty = 0.04,
		trigger = {
			type = "dig",
			node = "bakedclay:thistle",
			target = 1
		}
	})
--This Isn't a Geranium...	
		awards.register_award("award_clay_flower3",{
		title = ("This Isn't a Geranium..."),
		description = ("Harvest your first blue delphinium."),
		icon = "baked_clay_delphinium.png",
		difficulty = 0.04,
		trigger = {
			type = "dig",
			node = "bakedclay:delphinium",
			target = 1
		}
	})
--Looks More Magenta than Pink
		awards.register_award("award_clay_flower4",{
		title = ("Looks More Magenta than Pink"),
		description = ("Harvest your first lazarus bell."),
		icon = "baked_clay_lazarus.png",
		difficulty = 0.04,
		trigger = {
			type = "dig",
			node = "bakedclay:lazarus",
			target = 1
		}
	})
--99 Shades of Grey
		awards.register_award("award_clay_glazed",{
		title = ("99 Shades of Grey"),
		description = ("Place 100 blocks of white glazed terracotta."),
		icon = "baked_clay_terracotta_white.png",
		difficulty = 0.3,
		trigger = {
			type = "place",
			node = "bakedclay:terracotta_white",
			target = 100
		}
	})
end

--Bonemeal Awards
--Bona Fide
if minetest.get_modpath("bonemeal") then
		awards.register_award("award_bonemeal",{
		title = ("Bona Fide"),
		description = ("Craft 50 bonemeal."),
		icon = "bonemeal_item.png",
		difficulty = 0.6,
		trigger = {
			type = "craft",
			item = "bonemeal:bonemeal",
			target = 50
		}
	})
--Master Composter	
		awards.register_award("award_fertiliser",{
		title = ("Master Composter"),
		description = ("Craft 100 fertiliser."),
		icon = "bonemeal_fertiliser.png",
		difficulty = 0.6,
		trigger = {
			type = "craft",
			item = "bonemeal:fertiliser",
			target = 100
		}
	})
--Made of Seeds	
		awards.register_award("award_mulch",{
		title = ("Made of Seeds"),
		description = ("Craft 50 mulch."),
		icon = "bonemeal_mulch.png",
		difficulty = 0.6,
		trigger = {
			type = "craft",
			item = "bonemeal:mulch",
			target = 50
		}
	})
end


--Carpets
if minetest.get_modpath("carpets") then
--Like Sheets of Paper
		awards.register_award("award_carpet_white",{
		title = ("Like Sheets of Paper"),
		description = ("Craft 320 white carpets."),
		icon = "wool_white.png",
		difficulty = 0.1,
		trigger = {
			type = "craft",
			item = "carpets:wool_white",
			target = 320
		}
	})
end

--Cups
if minetest.get_modpath("cups") then
--Third Place Triathlete
		awards.register_award("award_cups_bronze",{
		title = ("Third Place Triathlete"),
		description = ("Craft 12 bronze cups."),
		icon = "cups_bronze.png",
		difficulty = 0.5,
		trigger = {
			type = "craft",
			item = "cups:cup_bronze",
			target = 12
		}
	})
--Gold Rank Player	
		awards.register_award("award_cups_gold",{
		title = ("Gold Rank Player"),
		description = ("Craft 14 golden cups."),
		icon = "cups_gold.png",
		difficulty = 0.5,
		trigger = {
			type = "craft",
			item = "cups:cup_gold",
			target = 14
		}
	})
--Better than First
		awards.register_award("award_cups_diamond",{
		title = ("Better than First"),
		description = ("Craft 16 diamond cups."),
		icon = "cups_diamond.png",
		difficulty = 0.5,
		trigger = {
			type = "craft",
			item = "cups:cup_gold",
			target = 14
		}
	})
end

--Cups and More Ores
if minetest.get_modpath("cups") and minetest.get_modpath("moreores") then
--Silver Medal
		awards.register_award("award_cups_silver",{
		title = ("Silver Medal"),
		description = ("Craft 15 silver cups."),
		icon = "cups_silver.png",
		difficulty = 0.5,
		trigger = {
			type = "craft",
			item = "cups:cup_silver",
			target = 15
		}
	})
end

--More Ores
if minetest.get_modpath("moreores") then
--First Silver Find
		awards.register_award("award_silver_ore",{
		title = ("First Silver Find"),
		description = ("Mine your first silver ore."),
		icon = "moreores_silver_lump.png",
		difficulty = 0.9,
		trigger = {
			type = "dig",
			node = "moreores:mineral_silver",
			target = 1
		}
	})
--First Mithril Find
		awards.register_award("award_mithril_ore",{
		title = ("First Mithril Find"),
		description = ("Mine your first mithril ore."),
		icon = "moreores_mithril_lump.png",
		difficulty = 0.9,
		trigger = {
			type = "dig",
			node = "moreores:mineral_silver",
			target = 1
		}
	})
end

--More Ores and Carts
if minetest.get_modpath("moreores") and minetest.get_modpath("carts") then
--The Way Forward
	awards.register_award("award_on_the_way_copper", {
		title = ("The Way Forward"),
		description = ("Place 100 copper rails."),
		icon = "moreores_copper_rail.png",
		difficulty = 0.1,
		trigger = {
			type = "place",
			node = "moreores:copper_rail",
			target = 100
		}
	})
end

--More Ores and 3D Armor
if minetest.get_modpath("moreores") and minetest.get_modpath("3d_armor") then
--Master of Mithril
	awards.register_award("award_armor_mithril", {
		title = ("Master of Mithril"),
		description = ("Craft 4 mithril chestplates."),
		icon = "shields_inv_shield_mithril.png",
		difficulty = 1,
		trigger = {
			type = "craft",
			node = "3d_armor:chestplate_mithril",
			target = 4
		}
	})
end

--Quartz
if minetest.get_modpath("quartz") then
--First Quartz Find
		awards.register_award("award_quartz_ore",{
		title = ("First Quartz Find"),
		description = ("Mine your first quartz ore."),
		icon = "quartz_crystal_full.png",
		difficulty = 0.9,
		trigger = {
			type = "dig",
			node = "quartz:quartz_ore",
			target = 1
		}
	})
--Rome Wasn't Built in a Day	
		awards.register_award("award_quartz_block",{
		title = ("Rome Wasn't Built in a Day"),
		description = ("Place 100 blocks of quartz."),
		icon = "quartz_block.png",
		difficulty = 0.09,
		trigger = {
			type = "place",
			node = "quartz:block",
			target = 100
		}
	})
--Rome Was Built in 448,585 Days	
		awards.register_award("award_quartz_chiseled",{
		title = ("Rome Was Built in 448,585 Days"),
		description = ("Place 100 blocks of chiseled quartz."),
		icon = "quartz_chiseled.png",
		difficulty = 0.09,
		trigger = {
			type = "place",
			node = "quartz:chiseled",
			target = 100
		}
	})
--Pillar Up	
		awards.register_award("award_quartz_pillar",{
		title = ("Pillar Up"),
		description = ("Place 100 blocks of quartz pillars."),
		icon = "quartz_pillar_side.png",
		difficulty = 0.09,
		trigger = {
			type = "place",
			node = "quartz:pillar",
			target = 100
		}
	})
--Rest in Pieces	
		awards.register_award("award_quartz_crystal_piece",{
		title = ("Rest in Pieces"),
		description = ("Craft 360 quartz crystal pieces."),
		icon = "quartz_crystal_piece.png",
		difficulty = 0.03,
		trigger = {
			type = "craft",
			item = "quartz:quartz_crystal_piece",
			target = 360
		}
	})
end
