minetest.register_node("more_fuels:oil_saturated_stone", {
	tiles = {"default_stone.png^[colorize:black:200"},
	is_ground_content = true,
	groups = {crumbly = 3, oil = 3},
	drop = "more_fuels:oil_saturated_stone"
})

minetest.register_ore({
	ore_type       = "puff",
	ore            = "more_fuels:oil_saturated_stone",
	clust_scarcity = 16 * 16 * 16,
	clust_num_ores = 25,
	clust_size     = 5,
	y_max          = 31000,
	y_min          = 1025,
})

minetest.register_craft({
	type = "shapeless",
	recipe = {"more_fuels:oil_saturated_stone", "hammermod:steel_hammer", "bucket:bucket_empty"},
	output = "more_fuels:bucket_oil",
	replacements = {{"hammermod:steel_hammer", "hammermod:steel_hammer"},{"more_fuels:oil_saturated_stone", "default:gravel"}}
})
