for _, force in pairs(game.forces) do
    local technologies = force.technologies
    local recipes = force.recipes

    recipes["Battle-Locomotive-1"].enabled = technologies["modular-armor"].researched
    recipes["Battle-Locomotive-2"].enabled = technologies["power-armor"].researched
    recipes["Battle-Locomotive-3"].enabled = technologies["power-armor-mk2"].researched
end