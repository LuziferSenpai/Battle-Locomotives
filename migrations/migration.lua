game.reload_script()

for _, f in pairs( game.forces ) do
	f.reset_recipes()
	f.reset_technologies()
	local t = f.technologies
	local r = f.recipes
	if t["modular-armor"].researched then
		if r["Battle-Loco-1"] then r["Battle-Loco-1"].enabled = true end
	end
	if t["power-armor"].researched then
		if r["Battle-Loco-2"] then r["Battle-Loco-2"].enabled = true end
	end
	if t["power-armor-mk2"].researched then
		if r["Battle-Loco-3"] then r["Battle-Loco-3"].enabled = true end
	end
end