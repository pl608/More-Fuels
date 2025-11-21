--check if the dependencies are installed
local has_bucket = minetest.get_modpath("bucket")
local has_technic = minetest.get_modpath("technic")
--define functions
if has_technic then
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
end
--register the can API
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
      --debug?
			--minetest.chat_send_all(has_bucket)
			if pointed_thing.type ~= "node" then return end
      --allow collection of fuels in cans
			local node = minetest.get_node(pointed_thing.under)
			if node.name ~= data.liquid_source_name then return end
			local charge = get_can_level(itemstack)
			if charge == data.can_capacity then return end
      --check if theres a fuel robber ;)
			if minetest.is_protected(pointed_thing.under, user:get_player_name()) then
				minetest.log("action", user:get_player_name().." tried to take "..node.name..
					" at protected position "..minetest.pos_to_string(pointed_thing.under).." with a "..data.can_name)
				return
			end
      --remove the fuel source and give the can a bit more durability
			minetest.remove_node(pointed_thing.under)
			charge = charge + 1
			itemstack:set_metadata(tostring(charge))
			set_can_wear(itemstack, charge, data.can_capacity)
			return itemstack
		end,
		on_place = function(itemstack, user, pointed_thing)
      --place the oil from the fuel can
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
      --is there a fuel litterer? ;)
			if minetest.is_protected(pos, user:get_player_name()) then
				minetest.log("action", user:get_player_name().." tried to place "..data.liquid_source_name..
					" at protected position "..minetest.pos_to_string(pos).." with a "..data.can_name)
				return
			end
      --place the fuel source
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

--register gasoline
minetest.register_craftitem("more_fuels:gasoline", {
    description = "gasoline can",
    inventory_image = "gasoline_fuel_can.png",
})
--register butaine
minetest.register_craftitem("more_fuels:butain",{
   description = "Butain Canister",
   inventory_image = "butain_fuel.png"
})
register_can({
	can_name = "more_fuels:oil_can",
	can_description = "Petrolium Can",
	can_inventory_image = "oil_can.png",
	can_capacity = 16,
	liquid_source_name = "more_fuels:petrolium_src",
	liquid_flowing_name = "more_fuels:petrolium_flowing",
})

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

--add support for petrolium as a fuel for vehicles
if rawget(_G, "bucket") and bucket.register_liquid then
	bucket.register_liquid(
		"more_fuels:petrolium_src",
		"more_fuels:petrolium_flowing",
		"more_fuels:bucket_oil",
		"bucket_oil.png",
		"Petroleum Bucket"
	)
end
if rawget(_G, "trike") and trike.fuel then
	trike.fuel = {['biofuel:biofuel'] = 1,['biofuel:bottle_fuel'] = 1,['biofuel:phial_fuel'] = 0.25, ['biofuel:fuel_can'] = 10, ["more_fuels:gasoline"] = 10}
end

--propane not implemented
--[[
minetest.register_node("more_fuels:propane", {
  description = "Propane Tank",
  drawtype = "mesh",
  tiles = {
    "propane_texture.png",
  },
  mesh = "propane_tank.obj",
  groups = {cracky = 3},
})
--]]
local has_elements = minetest.get_modpath("elements")
--register hydrogen
if has_elements then
  minetest.register_craft({
  	type = "fuel",
  	recipe = "elements:hydrogen",
	  burntime = 500,
  })
end

--register gas
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
  
--register Bio Diesel
minetest.register_craftitem(":biofuel:fuel_can", {
	description = "Bio Diesel",
	inventory_image = "Deisel.png"
})

-- register the register support function ;)
local function register_support(name, namestring)
	if rawget(_G, namestring) and name.fuel then
		name.fuel = {['biofuel:biofuel'] = 1,['biofuel:bottle_fuel'] = 1,['biofuel:phial_fuel'] = 0.25, ['biofuel:fuel_can'] = 10, ["more_fuels:gasoline"] = 10}
	end
end

--run this thing
dofile(minetest.get_modpath("more_fuels") .. DIR_DELIM .. "vehicles.lua") 
