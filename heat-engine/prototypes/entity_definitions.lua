local utilities = "__heat-engine__/utilities"
local ENTITYPATH = "__heat-engine__/graphics/entity/"

local function single_sprite(filename)
    return {
        filename = ENTITYPATH .. filename,
        width = 256,
        height = 256,
        scale = 0.5
        }

end

local pipe_sprites = {
    straight_vertical = single_sprite("heat-engine.png"),
    straight_horizontal = single_sprite("heat-engine.png"),
    corner_right_down = single_sprite("heat-engine.png"),
    corner_left_down = single_sprite("heat-engine.png"),
    corner_right_up = single_sprite("heat-engine.png"),
    corner_left_up = single_sprite("heat-engine.png"),
    t_up = single_sprite("heat-engine.png"),
    t_right = single_sprite("heat-engine.png"),
    t_down = single_sprite("heat-engine.png"),
    t_left = single_sprite("heat-engine.png"),
    ending_up = single_sprite("heat-engine.png"),
    ending_right = single_sprite("heat-engine.png"),
    ending_down = single_sprite("heat-engine.png"),
    ending_left = single_sprite("heat-engine.png"),
    cross = single_sprite("heat-engine.png"),
    single = single_sprite("heat-engine.png")
}

local heat_sprites = {
    straight_vertical = single_sprite("heat-engineglow.png"),
    straight_horizontal = single_sprite("heat-engineglow.png"),
    corner_right_down = single_sprite("heat-engineglow.png"),
    corner_left_down = single_sprite("heat-engineglow.png"),
    corner_right_up = single_sprite("heat-engineglow.png"),
    corner_left_up = single_sprite("heat-engineglow.png"),
    t_up = single_sprite("heat-engineglow.png"),
    t_right = single_sprite("heat-engineglow.png"),
    t_down = single_sprite("heat-engineglow.png"),
    t_left = single_sprite("heat-engineglow.png"),
    ending_up = single_sprite("heat-engineglow.png"),
    ending_right = single_sprite("heat-engineglow.png"),
    ending_down = single_sprite("heat-engineglow.png"),
    ending_left = single_sprite("heat-engineglow.png"),
    cross = single_sprite("heat-engineglow.png"),
    single = single_sprite("heat-engineglow.png")
}

local function createConnections(connection_type)
    return {
        {
            type = connection_type,
            position = {0, -1},
            direction = defines.direction.north
        },
        {
            type = connection_type,
            position = {0, 1},
            direction = defines.direction.south
        },
        {
            type = connection_type,
            position = {-1, 0},
            direction = defines.direction.west
        },
        {
            type = connection_type,
            position = {1, 0},
            direction = defines.direction.east
        }
    }
end

data:extend({
    -- Energy Interface (hidden)
{
    type = "electric-energy-interface",
    name = "hidden-energy-interface",
    icon = "__base__/graphics/icons/accumulator.png",
    icon_size = 64,
    flags = {"placeable-neutral", "player-creation"},
    max_health = 10000,
    resistances = {
        { type = "physical", percent = 100 },
        { type = "impact", percent = 100 },
        { type = "explosion", percent = 100 },
        { type = "fire", percent = 100 }
    },
    collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
	collision_mask = {layers = {item = true, object = true, player = true, water_tile = true, is_object = true, is_lower_object = true}},
	selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    selectable_in_game = false,
	energy_source = {
        type = "electric",
        usage_priority = "primary-output",
        buffer_capacity = "100MJ",
        max_input_flow_limit = "1MW",
        max_output_flow_limit = "1MW",
        drain = "0W",
        energy_usage = "0kW"
    },
    energy_production = "100kW",
    picture = {
        filename = "__heat-engine__/graphics/entity/heat-engineglow.png",
        priority = "extra-high",
        width = 1,
        height = 1
    },
    connection_points = {
        {
            shadow = {
                copper = {0, 0},
                green = {0, 0},
                red = {0, 0}
            },
            wire = {
                copper = {0, 0},
                green = {0, 0},
                red = {0, 0}
            }
        }
    },
    copper_wire_picture = {
        filename = "__base__/graphics/entity/small-electric-pole/copper-wire.png",
        priority = "extra-high",
        width = 224,
        height = 46,
        direction_count = 1,
        shift = {0, -0.71875}
    },
    circuit_wire_connection_point = {
        shadow = { red = {0, 0}, green = {0, 0} },
        wire = { red = {0, 0}, green = {0, 0} }
    },
    circuit_wire_max_distance = 9,
    default_output_signal = nil,
    vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65}
},


    -- Heat Pipe Entity (with resistances)
    {
        type = "heat-pipe",
        name = "heat-engine",
        icon = "__heat-engine__/graphics/entity/heat-engine.png",
        icon_size = 64,
        flags = {"placeable-neutral", "player-creation"},
        minable = {mining_time = 1, result = "heat-engine"},
        max_health = 3000,
        corpse = "medium-remnants",
        dying_explosion = "medium-explosion",
        resistances = {
            { type = "physical", percent = 80 },
            { type = "impact", percent = 50 },
            { type = "explosion", percent = 50 },
            { type = "fire", percent = 100 }
        },
        collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
        selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
        picture = {

                {
                    filename = "__heat-engine__/graphics/entity/heat-engine.png",
                    width = 256,
                    height = 256,
					frame_count = 1,
					shift = {0, 0},
                    scale = 0.5
                },
				{
                    filename = "__heat-engine__/graphics/entity/heat-engineglow.png",
                    width = 256,
                    height = 256,
					frame_count = 1,
					draw_as_glow = true,
                    shift = {0, 0},
                    scale = 0.5
                }

        },
        connection_sprites = pipe_sprites,
        heat_glow_sprites = heat_sprites,
        minimum_glow_temperature = 200,
        heat_buffer = {
            max_temperature = 5000,
            min_working_temperature = 15,
            specific_heat = "100kJ",
            max_transfer = "100GW",
            min_temperature = 15,
            connections = createConnections("heat")
        },
        heat_glow_light = {
            minimum_darkness = 0.3,
            color = {r = 1, g = 155/255, b = 0.05, a = 0},
            shift = {-0.6, 3.5},
            size = 2.5,
            intensity = 0.3,
            add_perspective = true
       }
    },

    -- Recipe and Technology Unlocks (ensure these match your actual mod content)
    {
        type = "item",
        name = "heat-engine",
        icon = "__heat-engine__/graphics/icons/heat-engine.png",
        subgroup = "energy",
        order = "b[steam-power]-d[heat-engine]",
        place_result = "heat-engine",
        icon_size = 64,
        stack_size = 10
    },
    {
        type = "item",
        name = "hidden-energy-interface",
        icon =  "__heat-engine__/graphics/icons/steam-tech.png",
        subgroup = "energy",
        order = "b[steam-power]-d[heat-engine]",
        place_result = "hidden-energy-interface",
        icon_size = 64,
        stack_size = 10

    },
    {
        type = "recipe",
        name = "heat-engine",
		category = "crafting",
        energy_required = 10,
        enabled = false,

            ingredients = {
                {type = "item", name = "steam-engine", amount = 1},
                {type = "item", name = "copper-plate", amount = 5},
                {type = "item", name = "iron-plate", amount = 5}
            },
            results = {{type = "item", name = "heat-engine", amount = 1}}

	},

    {
        type = "technology",
        name = "heat-engine",
        icon = "__heat-engine__/graphics/icons/heat-engine.png",
        icon_size = 64,
        category = "basic-crafting",
        prerequisites = {"advanced-material-processing", "engine"},
        unit = {
            count = 25,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1}
            },
            time = 30
        },
        effects = {
    { type = "unlock-recipe", recipe = "heat-engine" },
    { type = "unlock-recipe", recipe = "heat-wall" }

			}
	}

})
