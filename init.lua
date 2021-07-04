minetest.register_craft({
	type = "fuel",
	recipe = "more_fuels:gasoline",
	burntime = 500,
})
minetest.register_craft({
	output = "more_fuels:gasoline",
	recipe = {
			{"more_fuels:refined_oil", "more_fuels:refined_oil", "more_fuels:refined_oil"},
			{"more_fuels:refined_oil", "group:biofuel", "more_fuels:refined_oil"},
			{"more_fuels:refined_oil", "more_fuels:refined_oil", "more_fuels:refined_oil"}
		 }
})



minetest.register_craft({
	type = "fuel",
	recipe = "more_fuels:bucket_oil",
	burntime = 300,
	replacements = {{"more_fuels:bucket_oil", "bucket:bucket_empty"}},
})
minetest.register_craft({
	type = "cooking",
	recipe = "more_fuels:bucket_oil",
	output = "more_fuels:refined_oil",
	cooktime = 60,
})
minetest.register_craftitem("more_fuels:refined_oil", {
	description = "Refined Petroleum",
	inventory_image = "bucket_oil_refined.png",
	stack_max = 1,
})

minetest.register_craft({
	type = "shapeless",
	output = "more_fuels:gasoline 3",
	recipe = {"more_fuels:gasoline_cans"}
})
minetest.register_craft({
	type = "shapeless",
	output = "more_fuels:gasoline_cans",
	recipe = {"more_fuels:gasoline","more_fuels:gasoline", "more_fuels:gasoline"}
})
minetest.register_node("more_fuels:oil_saturated_stone", {
	tiles = {"default_stone.png^[colorize:black:200"},
	is_ground_content = true,
	groups = {crumbly = 3, oil = 3},
	drop = "more_fuels:oil_saturated_stone"
})
minetest.register_ore({
	ore_type       = "puff",
	ore            = "more_fuels:oil_saturated_stone",
	clust_scarcity = 13 * 13 * 13,
	clust_num_ores = 5,
	clust_size     = 3,
	y_max          = 31000,
	y_min          = 1025,
})
minetest.register_craft({
	type = "shapeless",
	recipe = {"more_fuels:oil_saturated_stone", "hammermod:steel_hammer", "bucket:bucket_empty"},
	output = "more_fuels:bucket_oil",
	replacements = {{"hammermod:steel_hammer", "hammermod:steel_hammer"},{"more_fuels:oil_saturated_stone", "default:gravel"}}
})
