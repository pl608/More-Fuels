minetest.register_craftitem("more_fuels:gasoline", {
    description = "gasoline can",
    inventory_image = "gasoline_fuel_can.png",
})
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
local has_bucket = minetest.get_modpath("bucket")

local function set_can_wear(itemstack, level, max_level)
	local temp
	if level == 0 then
		temp = 0
	else
		temp = 65536 - math.floor(level / max_level * 65535)
		if temp > 65535 then temp = 65535 end
		if temp < 1 then temp = 1 end
	end
	itemstack:set_wear(temp)
end
local function get_can_level(itemstack)
	if itemstack:get_metadata() == "" then
		return 0
	else
		return tonumber(itemstack:get_metadata())
	end
end
function register_can(d)
	local data = {}
	for k, v in pairs(d) do data[k] = v end
	minetest.register_tool(data.can_name, {
		description = data.can_description,
		inventory_image = data.can_inventory_image,
		stack_max = 1,
		wear_represents = "content_level",
		liquids_pointable = true,
		on_use = function(itemstack, user, pointed_thing)
			minetest.chat_send_all(has_bucket)

			if pointed_thing.type ~= "node" then return end
			local node = minetest.get_node(pointed_thing.under)
			if node.name ~= data.liquid_source_name then return end
			local charge = get_can_level(itemstack)
			if charge == data.can_capacity then return end
			if minetest.is_protected(pointed_thing.under, user:get_player_name()) then
				minetest.log("action", user:get_player_name().." tried to take "..node.name..
					" at protected position "..minetest.pos_to_string(pointed_thing.under).." with a "..data.can_name)
				return
			end
			minetest.remove_node(pointed_thing.under)
			charge = charge + 1
			itemstack:set_metadata(tostring(charge))
			set_can_wear(itemstack, charge, data.can_capacity)
			return itemstack
		end,
		on_place = function(itemstack, user, pointed_thing)
			if pointed_thing.type ~= "node" then return end
			local pos = pointed_thing.under
			local node_name = minetest.get_node(pos).name
			local def = minetest.registered_nodes[node_name] or {}
			if def.on_rightclick and user and not user:get_player_control().sneak then
				return def.on_rightclick(pos, minetest.get_node(pos), user, itemstack, pointed_thing)
			end
			if not def.buildable_to or node_name == data.liquid_source_name then
				pos = pointed_thing.above
				node_name = minetest.get_node(pos).name
				def = minetest.registered_nodes[node_name] or {}
				-- Try to place node above the pointed source, or abort.
				if not def.buildable_to or node_name == data.liquid_source_name then return end
			end
			local charge = get_can_level(itemstack)
			if charge == 0 then return end
			if minetest.is_protected(pos, user:get_player_name()) then
				minetest.log("action", user:get_player_name().." tried to place "..data.liquid_source_name..
					" at protected position "..minetest.pos_to_string(pos).." with a "..data.can_name)
				return
			end
			minetest.set_node(pos, {name=data.liquid_source_name})
			charge = charge - 1
			itemstack:set_metadata(tostring(charge))
			set_can_wear(itemstack, charge, data.can_capacity)
			return itemstack
		end,
		on_refill = function(stack)
			stack:set_metadata(tostring(data.can_capacity))
			set_can_wear(stack, data.can_capacity, data.can_capacity)
			return stack
		end,
	})
end



minetest.register_node("more_fuels:petrolium_src", {
	description = "Petrolium Source",
	drawtype = "liquid",
	waving = 3,
	tiles = {
		{
			name = "oil_water_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "oil_water_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "more_fuels:petrolium_flowing",
	liquid_alternative_source = "more_fuels:petrolium_src",
	liquid_viscosity = 4,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {oil = 3, liquid = 3},
})


minetest.register_node("more_fuels:petrolium_flowing", {
	description = "Flowing Petrolium",
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {"oil_src.png"},
	special_tiles = {
		{
			name = "oil_water_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
		{
			name = "oil_water_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	liquid_renewable = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "more_fuels:petrolium_flowing",
	liquid_alternative_source = "more_fuels:petrolium_src",
	liquid_viscosity = 4,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {oil = 3, liquid = 3, not_in_creative_inventory = 1},
})
register_can({
	can_name = "more_fuels:oil_can",
	can_description = "Petrolium Can",
	can_inventory_image = "oil_can.png",
	can_capacity = 16,
	liquid_source_name = "more_fuels:petrolium_src",
	liquid_flowing_name = "more_fuels:petrolium_flowing",
})

if rawget(_G, "bucket") and bucket.register_liquid then
	bucket.register_liquid(
		"more_fuels:petrolium_src",
		"more_fuels:petrolium_flowing",
		"more_fuels:bucket_oil",
		"bucket_oil.png",
		"Petroleum Bucket"
	)
end

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
--minetest.register_node("more_fuels:propane", {
	--description = "Propane Tank",
	--drawtype = "mesh",
	--tiles = {
		--"propane_texture.png",
	--},
	--mesh = "propane_tank.obj",
	--groups = {cracky = 3},
--})
minetest.register_node("more_fuels:gasoline_cans", {
	drawtype = "mesh",
	description = "Gas Cans (non flamable)",
	tiles = {
		"tank.png",
		"tank_base.png"
	},
	mesh = "tank.obj",
	groups = {
		cracky = 3
	},
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
	replacements = {{"hammermod:steel_hammer", "hammermod:steel_hammer"}}
})