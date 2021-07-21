--refined oil
minetest.register_craftitem("more_fuels:refined_oil", {
	description = "Refined Petroleum",
	inventory_image = "bucket_oil_refined.png",
	stack_max = 1,
})

--regular oil
minetest.register_craft({
	type = "cooking",
	recipe = "more_fuels:bucket_oil",
	output = "more_fuels:refined_oil",
	cooktime = 60,
})

minetest.register_craft({
	type = "fuel",
	recipe = "more_fuels:bucket_oil",
	burntime = 300,
	replacements = {{"more_fuels:bucket_oil", "bucket:bucket_empty"}},
})

--gasoline
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
	type = "shapeless",
	output = "more_fuels:gasoline_cans",
	recipe = {"more_fuels:gasoline","more_fuels:gasoline", "more_fuels:gasoline"}
})

minetest.register_craft({
	type = "shapeless",
	output = "more_fuels:gasoline 3",
	recipe = {"more_fuels:gasoline_cans"}
})

