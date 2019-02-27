require "config"

local MODNAME = "__Battle_Locomotives__"
local dc = util.table.deepcopy

local function fil( l, e )
	if l.filenames then
		for i, f in pairs( l.filenames ) do
			l.filenames[i] = string.gsub( f, "__base__/graphics/entity/" .. e, MODNAME .. "/graphics/" )
		end
	end
	if l.filename then
		l.filename = string.gsub( l.filename, "__base__/graphics/entity/" .. e , MODNAME .. "/graphics/" )
	end
end

local function mif( l, e )
	for _, la in pairs( l ) do
		if la.apply_runtime_tint == true then
			fil( la, e )
			if la.hr_version then
				fil( la.hr_version, e )
			end
		end 
	end
end

Senpais.Functions.Create.Battle_Locomotive = function( m, n, i, h, w, s, c, g, su, o, st, ig, t )
	local te = dc( data.raw["locomotive"]["locomotive"] )
	te.name = n
	te.icon = i
	te.minable.result = n
	te.max_health = h
	te.weight = w
	te.max_speed = s
	te.max_power = m * 600 .. "kW"

	mif( te.pictures.layers, "diesel-locomotive" )

	te.color = c
	te.equipment_grid = g

	local ti = dc( data.raw["item-with-entity-data"]["locomotive"] )
	ti.name = n
	ti.icon = i
	ti.subgroup = su
	ti.order = o
	ti.place_result = n
	ti.stack_size = st

	local tr = dc( data.raw["recipe"]["locomotive"] )
	tr.name = n
	tr.ingredients = ig
	tr.result = n

	data:extend{ te, ti, tr }

	table.insert( data.raw["technology"][t].effects, { type = "unlock-recipe", recipe = n } )
end

Senpais.Functions.Create.Grid = function( n, w, h, c )
	local g = dc( data.raw["equipment-grid"]["large-equipment-grid"] )
	g.name = n
	g.width = w
	g.height = h
	g.equipment_categories = c

	data:extend{ g }
end

local temp = { "Battle-Laser", "armor" }

if not data.raw["equipment-grid"]["Battle-Grid-01"] then
	Senpais.Functions.Create.Grid( "Battle-Grid-01", 5, 5, temp )
	Senpais.Functions.Create.Grid( "Battle-Grid-02", 10, 10, temp )
	Senpais.Functions.Create.Grid( "Battle-Grid-03", 15, 15, temp )
end

temp = "modular-armor"
Senpais.Functions.Create.Battle_Locomotive( 1, "Battle-Loco-1", MODNAME .. "/graphics/Battle-Loco-1.png", 1000, 2000, 1.2, { r = 213, g = 105, b = 33 }, "Battle-Grid-01", "transport", "a[train-system]-fba[Battle-Loco-1]", 5, { { "locomotive", 1 }, { temp, 1 } }, temp )
data.raw["locomotive"]["Battle-Loco-1"].resistances = dc( data.raw["armor"][temp].resistances )

temp = "power-armor"
Senpais.Functions.Create.Battle_Locomotive( 2, "Battle-Loco-2", MODNAME .. "/graphics/Battle-Loco-2.png", 1500, 4000, 1.4, { r = 101, g = 33, b = 213 }, "Battle-Grid-02", "transport", "a[train-system]-fbb[Battle-Loco-2]", 5, { { "locomotive", 1 }, { temp, 1 } }, temp )
data.raw["locomotive"]["Battle-Loco-2"].resistances = dc( data.raw["armor"][temp].resistances )

temp = "power-armor-mk2"
Senpais.Functions.Create.Battle_Locomotive( 3, "Battle-Loco-3", MODNAME .. "/graphics/Battle-Loco-3.png", 2000, 6000, 1.6, { r = 196, g = 0, b = 74 }, "Battle-Grid-03", "transport", "a[train-system]-fbc[Battle-Loco-3]", 5, { { "Battle-Loco-2", 1 }, { temp, 1 } }, "power-armor-2" )
data.raw["locomotive"]["Battle-Loco-3"].resistances = dc( data.raw["armor"][temp].resistances )

if not data.raw["active-defense-equipment"]["laser-2"] then
	temp = "laser-2"
	
	local le = dc( data.raw["active-defense-equipment"]["personal-laser-defense-equipment"] )
	le.name = temp
	le.sprite.filename = MODNAME .. "/graphics/" .. temp .. ".png"
	le.energy_source.buffer_capacity = "750kJ"
	le.attack_parameters =
	{
		type = "beam",
		cooldown = 20,
		range = 30,
		damage_modifier = 8,
		ammo_type =
		{
			category = "laser-turret",
			energy_consumption = "200kJ",
			action =
			{
				type = "direct",
				action_delivery =
				{
					type = "beam",
					beam = "laser-beam",
					max_length = 30,
					duration = 20,
					source_offset = { 0, -1.31439 }
				}	
			}
		}
	}
	le.categories = { "Battle-Laser" }
	
	local li = dc( data.raw["item"]["personal-laser-defense-equipment"] )
	li.name = temp
	li.icon = MODNAME .. "/graphics/" .. temp .. "-i.png"
	li.placed_as_equipment_result = temp
	li.order = "d[active-defense]-ab[" .. temp .. "]"
	
	local lr = dc( data.raw["recipe"]["personal-laser-defense-equipment"] )
	lr.name = temp
	lr.ingredients = { { "personal-laser-defense-equipment", 1 }, { "processing-unit", 10 }, { "steel-plate", 50 }, { "laser-turret", 5 } }
	lr.result = temp
	
	local lt = dc( data.raw["technology"]["personal-laser-defense-equipment"] )
	lt.name = "personal-laser-defense-equipment-2"
	lt.prerequisites = { "personal-laser-defense-equipment" }
	lt.effects = { { type = "unlock-recipe", recipe = temp } }
	lt.unit.count = 250
	
	data:extend{ { type = "equipment-category", name = "Battle-Laser" }, le, li, lr, lt }
end

if not data.raw["technology"]["braking-force-9"] then
	local bf8 = dc( data.raw["technology"]["braking-force-7"] )
	bf8.name = "braking-force-8"
	bf8.effects = { { type = "train-braking-force-bonus", modifier = 0.30 } }
	bf8.prerequisites = { "braking-force-7" }
	bf8.unit.count = 800

	local bf9 = dc( data.raw["technology"]["braking-force-7"] )
	bf9.name = "braking-force-9"
	bf9.effects = { { type = "train-braking-force-bonus", modifier = 0.50 } }
	bf9.prerequisites = { "braking-force-8" }
	bf9.unit.count = 1000

	data:extend{ bf8, bf9 }
end