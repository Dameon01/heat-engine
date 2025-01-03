local heat_turret_tech =
	util.merge{data.raw.technology["gun-turret"],
		 {
		 effects = {
                       {
                           type = "unlock-recipe",
                           recipe = "heat-turret"
                       },
                       {
                           type = "unlock-recipe",
                           recipe = "gun-turret"
                       },
                   }
               }
		}
data:extend({
    -- Heat Turret Item Definition
    {
        type = "item",
        name = "heat-turret",
        icon = "__base__/graphics/icons/gun-turret.png",
        icon_size = 64,
        subgroup = "defensive-structure",
        order = "b[turret]-b[heat-turret]",
        place_result = "heat-turret",
        stack_size = 10
    },
	{
        type = "item",
        name = "heat-turret-mk2",
        icon = "__base__/graphics/icons/gun-turret.png",
        icon_size = 64,
        subgroup = "defensive-structure",
        order = "b[turret]-b[heat-turret]",
        place_result = "heat-turret-mk2",
        stack_size = 10
    },
    -- Define Custom Ammo Category
    {
        type = "ammo-category",
        name = "heat-ammo"
    },
	{
        type = "ammo",
        name = "heat-bullet",
        icon = "__heat-engine__/graphics/projectiles/heat-bullet.png",
        icon_size = 256,
        scale = 0.25,
		ammo_category = "heat-ammo",
		ammo_type = {
            category = "heat-ammo",
            action = {
                type = "direct",
                action_delivery = {
                    type = "projectile",
                    projectile = "heat-bullet",
                    starting_speed = 0.5
                }
            }
        },
        magazine_size = 10,  -- Size of each ammo stack in the turret
        subgroup = "ammo",
        order = "d[ammo]-a[heat-bullet]",
        stack_size = 200  -- Maximum stack size for inventory
    },
	{
	type = "ammo",
        name = "heat-bomb",
        icon = "__heat-engine__/graphics/projectiles/heat-bullet.png",
        icon_size = 256,
        scale = 0.25,
		ammo_category = "heat-ammo",
		ammo_type = {
            category = "heat-ammo",
            action = {
                type = "direct",
                action_delivery = {
                    type = "projectile",
                    projectile = "heat-bomb",
                    starting_speed = 0.5
                }
            }
        },
        magazine_size = 5,  -- Size of each ammo stack in the turret
        subgroup = "ammo",
        order = "d[ammo]-a[heat-bomb]",
        stack_size = 150  -- Maximum stack size for inventory
	},
	{
        type = "ammo",
        name = "thermal-bullet",
        icon = "__heat-engine__/graphics/projectiles/heat-bullet2.png",
        icon_size = 256,
        scale = 0.25,
		ammo_category = "heat-ammo",
		ammo_type = {
            category = "heat-ammo",
            action = {
                type = "direct",
                action_delivery = {
                    type = "projectile",
                    projectile = "thermal-bullet",
                    starting_speed = 0.5
                }
            }
        },
        magazine_size = 10,  -- Size of each ammo stack in the turret
        subgroup = "ammo",
        order = "d[ammo]-a[heat-bullet]",
        stack_size = 200  -- Maximum stack size for inventory
    },
	{
        type = "ammo",
        name = "cluster-bullet",
        icon = "__heat-engine__/graphics/projectiles/heat-bullet2.png",
        icon_size = 256,
        scale = 0.25,
		ammo_category = "heat-ammo",
		ammo_type = {
            category = "heat-ammo",
            action = {
                type = "direct",
                action_delivery = {
                    type = "projectile",
                    projectile = "cluster-bullet",
                    starting_speed = 0.5
                }
            }
        },
        magazine_size = 10,  -- Size of each ammo stack in the turret
        subgroup = "ammo",
        order = "d[ammo]-a[heat-bomb]",
        stack_size = 200  -- Maximum stack size for inventory
    }
})


local new_heat_turret = table.deepcopy(data.raw["ammo-turret"]["gun-turret"])

-- Customizing new_heat_turret with heat-based attributes
new_heat_turret.name = "heat-turret"
new_heat_turret.icon = "__base__/graphics/icons/gun-turret.png"
new_heat_turret.icon_size = 64
new_heat_turret.max_health = 2000
new_heat_turret.minable = {mining_time = 1, result = "heat-turret"}
new_heat_turret.selectable_in_game = true
new_heat_turret.call_for_help_radius = 40
new_heat_turret.rotation_speed = 0.05
new_heat_turret.tint = {r = 1, g = 0.2, b = 0, a = 0.5}
new_heat_turret.effect_receiver = {uses_module_effects = true, uses_beacon_effects = true, uses_surface_effects = true}
new_heat_turret.module_specification = {
    module_slots = 2, -- Number of slots
    module_info_icon_shift = {0, 0.8} -- Optional: Adjust module icons in UI
}

new_heat_turret.allowed_effects = {"attack", "shooting-speed", "range"}
new_heat_turret.module_category = "turret-enhancement"

-- Attack parameters with custom projectile
new_heat_turret.attack_parameters = {
    type = "projectile",
    ammo_category = "heat-ammo",
    cooldown = 5,
    projectile_creation_distance = 5,
    range = 30,
    damage_modifier = 2,
    projectile_center = {0, -0.0875},
    ammo_type = {
        category = "heat-ammo",
        action = {
            type = "direct",
            action_delivery = {
                type = "projectile",
                force = "enemy",
				projectile = "heat-bullet",
                starting_speed = 0.5
            }
        }
    }
}

-- Custom animations with scaling adjustments
if new_heat_turret.folded_animation then
  for _, layer in pairs(new_heat_turret.folded_animation.layers or {new_heat_turret.folded_animation}) do
    layer.scale = 0.5
  end
end

if new_heat_turret.preparing_animation then
  for _, layer in pairs(new_heat_turret.preparing_animation.layers or {new_heat_turret.preparing_animation}) do
    layer.scale = 0.5
  end
end

if new_heat_turret.prepared_animation then
  for _, layer in pairs(new_heat_turret.prepared_animation.layers or {new_heat_turret.prepared_animation}) do
    layer.scale = 0.5
  end
end

if new_heat_turret.folding_animation then
  for _, layer in pairs(new_heat_turret.folding_animation.layers or {new_heat_turret.folding_animation}) do
    layer.scale = 0.5
  end
end

-- Additional properties
new_heat_turret.resistances = {
    { type = "fire", decrease = 100, percent = 100 },
    { type = "explosion", decrease = 100, percent = 100 }
}
new_heat_turret.light = {
    intensity = 0.5,
    size = 10,
    color = { r = 1, g = 0.5, b = 0, a = 1 }
}

local new_heat_turret2 = table.deepcopy(data.raw["ammo-turret"]["gun-turret"])

-- Customizing new_heat_turret with heat-based attributes
new_heat_turret2.name = "heat-turret-mk2"
new_heat_turret2.icon = "__base__/graphics/icons/gun-turret.png"
new_heat_turret2.icon_size = 64
new_heat_turret2.max_health = 2000
new_heat_turret2.minable = {mining_time = 1, result = "heat-turret-mk2"}
new_heat_turret2.selectable_in_game = true
new_heat_turret2.call_for_help_radius = 40
new_heat_turret2.rotation_speed = 0.05
new_heat_turret2.tint = {r = 1, g = 0.2, b = 0.1, a = 0.5}
new_heat_turret2.effect_receiver = {uses_module_effects = true, uses_beacon_effects = true, uses_surface_effects = true}
new_heat_turret2.module_specification = {
    module_slots = 2, -- Number of slots
    module_info_icon_shift = {0, 0.8} -- Optional: Adjust module icons in UI
}

new_heat_turret2.allowed_effects = {"attack", "shooting-speed", "range"}
new_heat_turret2.module_category = "turret-enhancement"

-- Attack parameters with custom projectile
new_heat_turret2.attack_parameters = {
    type = "projectile",
    ammo_category = "heat-ammo",
    cooldown = 5,
    projectile_creation_distance = 5,
    range = 30,
	damage_modifier = 2.5,
    projectile_center = {0, -0.0875},
    ammo_type = {
        category = "heat-ammo",
        action = {
            type = "direct",
            action_delivery = {
                type = "projectile",
                force = "enemy",
				projectile = "heat-bomb",
                starting_speed = 0.5
            }
        }
    }
}

-- Custom animations with scaling adjustments
if new_heat_turret2.folded_animation then
  for _, layer in pairs(new_heat_turret2.folded_animation.layers or {new_heat_turret2.folded_animation}) do
    layer.scale = 0.5
  end
end

if new_heat_turret2.preparing_animation then
  for _, layer in pairs(new_heat_turret2.preparing_animation.layers or {new_heat_turret2.preparing_animation}) do
    layer.scale = 0.5
  end
end

if new_heat_turret2.prepared_animation then
  for _, layer in pairs(new_heat_turret2.prepared_animation.layers or {new_heat_turret2.prepared_animation}) do
    layer.scale = 0.5
  end
end

if new_heat_turret2.folding_animation then
  for _, layer in pairs(new_heat_turret2.folding_animation.layers or {new_heat_turret2.folding_animation}) do
    layer.scale = 0.5
  end
end

-- Additional properties
new_heat_turret2.resistances = {
    { type = "fire", decrease = 100, percent = 100 },
    { type = "explosion", decrease = 100, percent = 100 }
}
new_heat_turret2.light = {
    intensity = 0.5,
    size = 10,
    color = { r = 1, g = 0.5, b = 0, a = 1 }
}

-- Defining projectile and explosion for the turret
local heat_bullet_projectile = {
    type = "projectile",
    name = "heat-bullet",
    acceleration = 0.01,
    starting_speed = 1.5,
    collision_box = {{-0.05, -0.05}, {0.05, 0.05}},
    animation = {
        filename = "__heat-engine__/graphics/projectiles/heat-bullet.png",
        width = 256,
        height = 256,
        frame_count = 1,
        priority = "high",
		scale = 0.0156
    },
    action = {
          type = "direct",
        action_delivery = {
            type = "instant",
            target_effects = {
                {
                    type = "nested-result",
                    action = {
                        type = "area",
                        radius = 5,
                        force = "enemy",
			action_delivery = {
                            type = "instant",
                            target_effects = {
                                {
                                    type = "damage",
                                    damage = { amount = 5, type = "fire" }
                                }
                            }
                        }
                    }
                },
                {
                    type = "nested-result",
                    action = {
                        type = "area",
                        radius = 5,
                        force = "enemy",
			action_delivery = {
                            type = "instant",
                            target_effects = {
                                {
                                    type = "damage",
                                    damage = { amount = 5, type = "physical" }
                                }
                            }
                        }
                    }
                },
                {
                    type = "nested-result",
                    action = {
                        type = "area",
                        radius = 5,
                        force = "enemy",
			action_delivery = {
                            type = "instant",
                            target_effects = {
                                {
                                    type = "damage",
                                    damage = { amount = 5, type = "explosion" }
                                }
                            }
                        }
                    }
                },
                {
                    type = "create-entity",
                    entity_name = "small-explosion"
                }
            }
        }
    },
    light = {intensity = 0.5, size = 8}
}

local heat_bullet_explosion = {
    type = "explosion",
    name = "small-explosion",
    animations = {
        {
            filename = "__heat-engine__/graphics/explosion/small-explosion.png",
            priority = "high",
            width = 45,
            height = 75,
            frame_count = 14,
            line_length = 14,
            shift = {0, 0},
            animation_speed = 0.1
        }
    },
    sound = {
        {
            filename = "__heat-engine__/graphics/sounds/explosion.ogg",
            volume = 1.0
        }
    },
     created_effect = {
        type = "area",
        radius = 5,
        force = "enemy",
	action_delivery = {
            type = "instant",
            target_effects = {
                {
                    type = "create-entity",
                    entity_name = "fire-flame",
                    trigger_created_entity = true,
                    check_buildability = true
                }
            }
        }
    }
}
local heat_bomb_projectile = {
    type = "projectile",
    name = "heat-bomb",
    acceleration = 0.1,
    starting_speed = 1.5,
    collision_box = {{-0.05, -0.05}, {0.05, 0.05}},
    animation = {
        filename = "__heat-engine__/graphics/projectiles/heat-bullet.png",
        width = 256,
        height = 256,
        frame_count = 1,
        priority = "high",
		scale = 0.0156
    },
    action = {
          type = "direct",
        action_delivery = {
            type = "instant",
            target_effects = {
                {
                    type = "nested-result",
                    action = {
                        type = "area",
                        radius = 10,
                        force = "enemy",
			action_delivery = {
                            type = "instant",
                            target_effects = {
                                {
                                    type = "damage",
                                    damage = { amount = 10, type = "fire" }
                                }
                            }
                        }
                    }
                },
                {
                    type = "nested-result",
                    action = {
                        type = "area",
                        radius = 10,
                        force = "enemy",
			action_delivery = {
                            type = "instant",
                            target_effects = {
                                {
                                    type = "damage",
                                    damage = { amount = 10, type = "physical" }
                                }
                            }
                        }
                    }
                },
                {
                    type = "nested-result",
                    action = {
                        type = "area",
                        radius = 10,
                        force = "enemy",
			action_delivery = {
                            type = "instant",
                            target_effects = {
                                {
                                    type = "damage",
                                    damage = { amount = 10, type = "explosion" }
                                }
                            }
                        }
                    }
                },
                {
                    type = "create-entity",
                    entity_name = "small-explosion"
                }
            }
        }
    },
    light = {intensity = 0.5, size = 8}
}

local heat_bomb_explosion = {
    type = "explosion",
    name = "small-explosion",
    animations = {
        {
            filename = "__heat-engine__/graphics/explosion/small-explosion.png",
            priority = "high",
            width = 45,
            height = 75,
            frame_count = 14,
            line_length = 14,
            shift = {0, 0},
            animation_speed = 0.5
        }
    },
    sound = {
        {
            filename = "__heat-engine__/graphics/sounds/explosion.ogg",
            volume = 1.0
        }
    },
     created_effect = {
        type = "area",
        radius = 10,
        force = "enemy",
	action_delivery = {
            type = "instant",
            target_effects = {
                {
                    type = "create-entity",
                    entity_name = "fire-flame",
                    trigger_created_entity = true,
                    check_buildability = true
                }
            }
        }
    }
}

local thermal_bullet_projectile = {
    type = "projectile",
    name = "thermal-bullet",
    acceleration = 0.01,
    starting_speed = 1.5,
    collision_box = {{-0.05, -0.05}, {0.05, 0.05}},
    animation = {
        filename = "__heat-engine__/graphics/projectiles/heat-bullet2.png",
        width = 256,
        height = 256,
        frame_count = 1,
        priority = "high",
		scale = 0.0156
    },
    action = {
          type = "direct",
        action_delivery = {
            type = "instant",
            target_effects = {
                {
                    type = "nested-result",
                    action = {
                        type = "area",
                        radius = 5,
                        force = "enemy",
			action_delivery = {
                            type = "instant",
                            target_effects = {
                                {
                                    type = "damage",
                                    damage = { amount = 15, type = "fire" }
                                }
                            }
                        }
                    }
                },
                {
                    type = "nested-result",
                    action = {
                        type = "area",
                        radius = 5,
                        force = "enemy",
			action_delivery = {
                            type = "instant",
                            target_effects = {
                                {
                                    type = "damage",
                                    damage = { amount = 15, type = "physical" }
                                }
                            }
                        }
                    }
                },
                {
                    type = "nested-result",
                    action = {
                        type = "area",
                        radius = 5,
                        force = "enemy",
			action_delivery = {
                            type = "instant",
                            target_effects = {
                                {
                                    type = "damage",
                                    damage = { amount = 15, type = "acid" }
                                }
                            }
                        }
                    }
                },
                {
                    type = "create-entity",
                    entity_name = "small-explosion"
                }
            }
        }
    },
    light = {intensity = 0.5, size = 8}
}

local thermal_bullet_explosion = {
    type = "explosion",
    name = "small-explosion",
    animations = {
        {
            filename = "__heat-engine__/graphics/explosion/small-explosion.png",
            priority = "high",
            width = 45,
            height = 75,
            frame_count = 14,
            line_length = 14,
            shift = {0, 0},
            animation_speed = 0.1
        }
    },
    sound = {
        {
            filename = "__heat-engine__/graphics/sounds/explosion.ogg",
            volume = 1.0
        }
    },
     created_effect = {
        type = "area",
        radius = 5,
        force = "enemy",
	action_delivery = {
            type = "instant",
            target_effects = {
                {
                    type = "create-entity",
                    entity_name = "fire-flame",
                    trigger_created_entity = true,
                    check_buildability = true
                }
            }
        }
    }
}

local cluster_bullet_projectile = {
    type = "projectile",
    name = "cluster-bullet",
    acceleration = 0.01,
    starting_speed = 1.5,
    collision_box = {{-0.05, -0.05}, {0.05, 0.05}},
    animation = {
        filename = "__heat-engine__/graphics/projectiles/heat-bullet2.png",
        width = 256,
        height = 256,
        frame_count = 1,
        priority = "high",
		scale = 0.0156
    },
    action = {
          type = "direct",
        action_delivery = {
            type = "instant",
            target_effects = {
                {
                    type = "nested-result",
                    action = {
                        type = "area",
                        radius = 5,
                        force = "enemy",
			action_delivery = {
                            type = "instant",
                            target_effects = {
                                {
                                    type = "damage",
                                    damage = { amount = 25, type = "fire" }
                                }
                            }
                        }
                    }
                },
                {
                    type = "nested-result",
                    action = {
                        type = "area",
                        radius = 5,
                        force = "enemy",
			action_delivery = {
                            type = "instant",
                            target_effects = {
                                {
                                    type = "damage",
                                    damage = { amount = 25, type = "physical" }
                                }
                            }
                        }
                    }
                },
                {
                    type = "nested-result",
                    action = {
                        type = "area",
                        radius = 5,
                        force = "enemy",
			action_delivery = {
                            type = "instant",
                            target_effects = {
                                {
                                    type = "damage",
                                    damage = { amount = 25, type = "explosion" }
                                }
                            }
                        }
                    }
                },
                {
                    type = "create-entity",
                    entity_name = "small-explosion"
                }
            }
        }
    },
    light = {intensity = 0.5, size = 8}
}

local cluster_bullet_explosion = {
    type = "explosion",
    name = "small-explosion",
    animations = {
        {
            filename = "__heat-engine__/graphics/explosion/small-explosion.png",
            priority = "high",
            width = 45,
            height = 75,
            frame_count = 14,
            line_length = 14,
            shift = {0, 0},
            animation_speed = 0.1
        }
    },
    sound = {
        {
            filename = "__heat-engine__/graphics/sounds/explosion.ogg",
            volume = 1.0
        }
    },
     created_effect = {
        type = "area",
        radius = 5,
        force = "enemy",
	action_delivery = {
            type = "instant",
            target_effects = {
                {
                    type = "create-entity",
                    entity_name = "fire-flame",
                    trigger_created_entity = true,
                    check_buildability = true
                }
            }
        }
    }
}

-- Heat turret recipe definition
local heat_turret_recipe = {

	type = "recipe",
    name = "heat-turret",
    enabled = false,
    ingredients = {
        {type = "item", name = "iron-plate", amount = 2},
        {type = "item", name = "copper-plate", amount = 2},
        {type = "item", name = "copper-cable", amount = 2}
    },
    energy_required = 10,
    results = {{ type = "item", name = "heat-turret", amount = 1}}


}

local heat_turret_recipe2 = {

	type = "recipe",
    name = "heat-turret-mk2",
    enabled = false,
    ingredients = {
        {type = "item", name = "heat-turret", amount = 1},
        {type = "item", name = "steel-plate", amount = 5},
            },
    energy_required = 10,
    results = {{ type = "item", name = "heat-turret-mk2", amount = 1}}


}

local thermal_bullet_recipe = {

	type = "recipe",
    name = "thermal-bullet",
    enabled = false,
    ingredients = {
        {type = "item", name = "iron-plate", amount = 5},
        {type = "item", name = "coal", amount = 50},
        {type = "item", name = "heat-bullet", amount = 200}
    },
    energy_required = 10,
    results = {{ type = "item", name = "thermal-bullet", amount = 20}}


}

local cluster_bullet_recipe = {

	type = "recipe",
    name = "cluster-bullet",
    enabled = false,
    ingredients = {
        {type = "item", name = "steel-plate", amount = 5},
        {type = "item", name = "uranium-238", amount = 5},
        {type = "item", name = "heat-bomb", amount = 150}
    },
    energy_required = 10,
    results = {{ type = "item", name = "cluster-bullet", amount = 20}}


}
local heat_bullet_upgrade_tech1 = {
	type = "technology",
	name = "physical-heat-rounds1",
	icon = "__heat-engine__/graphics/projectiles/heat-bullet2.png",
	icon_size = 256,
	prerequisites = {

        "military-science-pack"

    },
    unit = {
        count = 250,
		ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
			{"military-science-pack", 1}
        },
        time = 60
    },

	effects = {
        {
            type = "unlock-recipe",
            recipe = "thermal-bullet"
        }
    },

    order = "s-o-h"
}
local heat_bullet_upgrade_tech2 = {
	type = "technology",
	name = "physical-heat-rounds2",
	icon = "__heat-engine__/graphics/projectiles/heat-bullet2.png",
	icon_size = 256,
	prerequisites = {
        "utility-science-pack",

    },
    unit = {
        count = 375,
		ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
			{"military-science-pack", 1},
			{"utility-science-pack", 1},
			{"chemical-science-pack", 1}
        },
        time = 60
    },

	effects = {
        {
            type = "unlock-recipe",
            recipe = "cluster-bullet"
        }
    },

    order = "s-o-h"
}
data:extend({
 new_heat_turret,
 new_heat_turret2,
 heat_bullet_projectile,
 heat_bullet_explosion,
 heat_bomb_projectile,
 heat_bomb_explosion,
 heat_turret_recipe,
 heat_turret_recipe2,
 heat_turret_tech,
 cluster_bullet_recipe,
 thermal_bullet_recipe,
 cluster_bullet_projectile,
 thermal_bullet_projectile,
 cluster_bullet_explosion,
 thermal_bullet_explosion,
 heat_bullet_upgrade_tech1,
 heat_bullet_upgrade_tech2

 })
