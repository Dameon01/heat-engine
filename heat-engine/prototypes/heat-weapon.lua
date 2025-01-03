 data.extend({
 -- Heat Pistol
    {
        type = "gun",
        name = "heat-pistol",
        icon = "__base__/graphics/icons/pistol.png", -- Base pistol icon
        icon_size = 64,
        subgroup = "gun",
        order = "a[basic]-b[heat-pistol]",
        attack_parameters = {
            type = "projectile",
            ammo_category = "heat-ammo",
            cooldown = 10,
            movement_slow_down_factor = 0.1,
            projectile_creation_distance = 1.125,
            range = 25,
            magazine_size = 10,
			sound = {
                {
                    filename = "__base__/sound/fight/light-gunshot-1.ogg",
                    volume = 0.7
                }
            }
        },
        stack_size = 1
    },
	{
        type = "recipe",
        name = "heat-pistol",
        enabled = true, -- Available from the start
        ingredients = {
            {type = "item", name = "iron-plate", amount = 5},
            {type = "item", name = "copper-plate", amount = 5}
        },
        results = {{type = "item", name = "heat-pistol", amount = 1}}
    }



})

-- Apply a dark red tint to the heat pistol's sprite
data.raw["gun"]["heat-pistol"].attack_parameters.animation = {
    filename = "__base__/graphics/icons/pistol.png",
    priority = "medium",
    width = 64,
    height = 64,
    scale = 1,
    tint = {r = 0.8, g = 0.2, b = 0.2, a = 1} -- Dark red tint
}
