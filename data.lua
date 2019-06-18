require "config"

local m = "__Battle_Locomotives__"
local utd = util.table.deepcopy

Senpais.Functions.Create.Battle_Locomotive = function( mu, n, i, h, w, s, c, g, su, o, st, ig, t )
	local te = utd( data.raw["locomotive"]["locomotive"] )
	te.name = n
	te.icon = i
	te.minable.result = n
	te.max_health = h
	te.weight = w
	te.max_speed = s
	te.max_power = mu * 600 .. "kW"

	for _, l in pairs( te.pictures.layers ) do
		if l.apply_runtime_tint == true then
			for i = 1, 8 do
				l.filenames[i] = m .. "/graphics/mask-" .. i .. ".png"
			end
			for i = 1, 16 do
				l.hr_version.filenames[i] = m .. "/graphics/hr-mask-" .. i .. ".png"
			end
			break
		end
	end

	te.color = c

	if g ~= nil then
		te.equipment_grid = g
	end

	local ti = utd( data.raw["item-with-entity-data"]["locomotive"] )
	ti.name = n
	ti.icon = i
	ti.subgroup = su
	ti.order = o
	ti.place_result = n
	ti.stack_size = st

	local tr = utd( data.raw["recipe"]["locomotive"] )
	tr.name = n
	tr.ingredients = ig
	tr.result = n

	data:extend{ te, ti, tr }

	table.insert( data.raw["technology"][t].effects, { type = "unlock-recipe", recipe = n } )
end

Senpais.Functions.Create.Grid = function( n, w, h, c )
	local g = utd( data.raw["equipment-grid"]["large-equipment-grid"] )
	g.name = n
	g.width = w
	g.height = h
	g.equipment_categories = c

	data:extend{ g }
end

if not data.raw["equipment-grid"]["Battle-Grid-01"] then
	Senpais.Functions.Create.Grid( "Battle-Grid-01", 5, 5, { "Battle-Laser", "armor" } )
end

if not data.raw["equipment-grid"]["Battle-Grid-02"] then
	Senpais.Functions.Create.Grid( "Battle-Grid-02", 10, 10, { "Battle-Laser", "armor" } )
end

if not data.raw["equipment-grid"]["Battle-Grid-03"] then
	Senpais.Functions.Create.Grid( "Battle-Grid-03", 15, 15, { "Battle-Laser", "armor" } )
end

Senpais.Functions.Create.Battle_Locomotive
(
	1,
	"Battle-Loco-1",
	m .. "/graphics/Battle-Loco-1.png",
	1000,
	2000,
	1.2,
	{ r = 213, g = 105, b = 33 },
	"Battle-Grid-01",
	"transport",
	"a[train-system]-fba[Battle-Loco-1]",
	5,
	{ { "locomotive", 1 }, { "modular-armor", 1 } },
	"modular-armor"
)

data.raw["locomotive"]["Battle-Loco-1"].resistances = utd( data.raw["armor"]["modular-armor"].resistances )

Senpais.Functions.Create.Battle_Locomotive
(
	2,
	"Battle-Loco-2",
	m .. "/graphics/Battle-Loco-2.png",
	1500,
	4000,
	1.4,
	{ r = 101, g = 33, b = 213 },
	"Battle-Grid-02",
	"transport",
	"a[train-system]-fbb[Battle-Loco-2]",
	5,
	{ { "Battle-Loco-1", 1 }, { "power-armor", 1 } },
	"power-armor"
)

data.raw["locomotive"]["Battle-Loco-2"].resistances = utd( data.raw["armor"]["power-armor"].resistances )

Senpais.Functions.Create.Battle_Locomotive
(
	3,
	"Battle-Loco-3",
	m .. "/graphics/Battle-Loco-3.png",
	2000,
	6000,
	1.6,
	{ r = 196, g = 0, b = 74 },
	"Battle-Grid-03",
	"transport",
	"a[train-system]-fbc[Battle-Loco-3]",
	5,
	{ { "Battle-Loco-2", 1 }, { "power-armor-mk2", 1 } },
	"power-armor-mk2"
)

data.raw["locomotive"]["Battle-Loco-3"].resistances = utd( data.raw["armor"]["power-armor-mk2"].resistances )

if not data.raw["active-defense-equipment"]["laser-2"] then
	
	local le = utd( data.raw["active-defense-equipment"]["personal-laser-defense-equipment"] )
	le.name = "laser-2"
	le.sprite.filename = m .. "/graphics/laser-2.png"
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
	
	local li = utd( data.raw["item"]["personal-laser-defense-equipment"] )
	li.name = "laser-2"
	li.icon = m .. "/graphics/laser-2-i.png"
	li.placed_as_equipment_result = "laser-2"
	li.order = "d[active-defense]-ab[laser-2]"
	
	local lr = utd( data.raw["recipe"]["personal-laser-defense-equipment"] )
	lr.name = "laser-2"
	lr.ingredients =
	{
		{ "personal-laser-defense-equipment", 1 },
		{ "processing-unit", 10 },
		{ "steel-plate", 50 },
		{ "laser-turret", 5 }
	}
	lr.result = "laser-2"
	
	local lt = utd( data.raw["technology"]["personal-laser-defense-equipment"] )
	lt.name = "personal-laser-defense-equipment-2"
	lt.prerequisites = { "personal-laser-defense-equipment" }
	lt.effects = { { type = "unlock-recipe", recipe = "laser-2" } }
	lt.unit.count = 250
	
	data:extend{ { type = "equipment-category", name = "Battle-Laser" }, le, li, lr, lt }
end

if not data.raw["technology"]["braking-force-8"] then
	local bf8 = utd( data.raw["technology"]["braking-force-7"] )
	bf8.name = "braking-force-8"
	bf8.effects = { { type = "train-braking-force-bonus", modifier = 0.30 } }
	bf8.prerequisites = { "braking-force-7" }
	bf8.unit.count = 800

	data:extend{ bf8 }
end

if not data.raw["technology"]["braking-force-9"] then
	local bf9 = utd( data.raw["technology"]["braking-force-7"] )
	bf9.name = "braking-force-9"
	bf9.effects = { { type = "train-braking-force-bonus", modifier = 0.50 } }
	bf9.prerequisites = { "braking-force-8" }
	bf9.unit.count = 1000

	data:extend{ bf9 }
end