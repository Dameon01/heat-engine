-- Define the heat wall entity with sprite calls
local function create_heat_wall()
    return {
        type = "wall",
        name = "heat-wall",
        icon = "__heat-engine__/graphics/icons/heat-wall.png",
        icon_size = 64,
        flags = {"placeable-neutral", "player-creation"},
        minable = {mining_time = .5, result = "heat-wall"},
        max_health = 350,
        corpse = "wall-remnants",
        collision_box = {{-0.29, -0.29}, {0.29, 0.29}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},

        resistances = {
            { type = "fire", decrease = 100, percent = 100 },
            { type = "explosion", decrease = 100, percent = 100 },
            { type = "physical", decrease = 50, percent = 50 }
        },

 pictures =
    {
      single =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-single.png",
            priority = "extra-high",
            width = 64,
            height = 86,
            variation_count = 2,
            line_length = 2,
            shift = util.by_pixel(0, -5),
            scale = 0.5,
			tint = {r = 0.5, g = 0.4, b = 0, a = 1}
          },
          {
            filename = "__base__/graphics/entity/wall/wall-single-shadow.png",
            priority = "extra-high",
            width = 98,
            height = 60,
            repeat_count = 2,
            shift = util.by_pixel(10, 17),
            draw_as_shadow = true,
            scale = 0.5
          },
		  {
            filename = "__base__/graphics/entity/wall/wall-single.png",
            priority = "extra-high",
            width = 64,
            height = 86,
            variation_count = 2,
            line_length = 2,
            shift = util.by_pixel(0, -5),
            scale = 0.5,
			tint = {r = 0.7, g = 0.3, b = 0, a = 0.5}, -- Brighter orange tint for glow
            draw_as_glow = true
          }
        }
      },
      straight_vertical =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-vertical.png",
            priority = "extra-high",
            width = 64,
            height = 134,
            variation_count = 5,
            line_length = 5,
            shift = util.by_pixel(0, 8),
            scale = 0.5,
			tint = {r = 1, g = 0.5, b = 0, a = 1}
          },
          {
            filename = "__base__/graphics/entity/wall/wall-vertical-shadow.png",
            priority = "extra-high",
            width = 98,
            height = 110,
            repeat_count = 5,
            shift = util.by_pixel(10, 29),
            draw_as_shadow = true,
            scale = 0.5
          },
		  {
            filename = "__base__/graphics/entity/wall/wall-vertical.png",
            priority = "extra-high",
            width = 64,
            height = 134,
            variation_count = 5,
            line_length = 5,
            shift = util.by_pixel(0, 8),
            scale = 0.5,
			tint = {r = 1, g = 0.3, b = 0, a = 0.5}, -- Brighter orange tint for glow
            draw_as_glow = true
          }
        }
      },
      straight_horizontal =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-horizontal.png",
            priority = "extra-high",
            width = 64,
            height = 92,
            variation_count = 6,
            line_length = 6,
            shift = util.by_pixel(0, -2),
            scale = 0.5,
			tint = {r = 1, g = 0.5, b = 0, a = 1}
          },
          {
            filename = "__base__/graphics/entity/wall/wall-horizontal-shadow.png",
            priority = "extra-high",
            width = 124,
            height = 68,
            repeat_count = 6,
            shift = util.by_pixel(14, 15),
            draw_as_shadow = true,
            scale = 0.5
          },
		  {
            filename = "__base__/graphics/entity/wall/wall-horizontal.png",
            priority = "extra-high",
            width = 64,
            height = 92,
            variation_count = 6,
            line_length = 6,
            shift = util.by_pixel(0, -2),
            scale = 0.5,
			tint = {r = 1, g = 0.3, b = 0, a = 0.5}, -- Brighter orange tint for glow
            draw_as_glow = true
          }
        }
      },
      corner_right_down =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-corner-right.png",
            priority = "extra-high",
            width = 64,
            height = 128,
            variation_count = 2,
            line_length = 2,
            shift = util.by_pixel(0, 7),
            scale = 0.5,
			tint = {r = 1, g = 0.5, b = 0, a = 1}
          },
          {
            filename = "__base__/graphics/entity/wall/wall-corner-right-shadow.png",
            priority = "extra-high",
            width = 124,
            height = 120,
            repeat_count = 2,
            shift = util.by_pixel(17, 28),
            draw_as_shadow = true,
            scale = 0.5
          },
		  {
            filename = "__base__/graphics/entity/wall/wall-corner-right.png",
            priority = "extra-high",
            width = 64,
            height = 128,
            variation_count = 2,
            line_length = 2,
            shift = util.by_pixel(0, 7),
            scale = 0.5,
			tint = {r = 1, g = 0.3, b = 0, a = 0.5}, -- Brighter orange tint for glow
            draw_as_glow = true
          }
        }
      },
      corner_left_down =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-corner-left.png",
            priority = "extra-high",
            width = 64,
            height = 134,
            variation_count = 2,
            line_length = 2,
            shift = util.by_pixel(0, 7),
            scale = 0.5,
			tint = {r = 1, g = 0.5, b = 0, a = 1}
          },
          {
            filename = "__base__/graphics/entity/wall/wall-corner-left-shadow.png",
            priority = "extra-high",
            width = 102,
            height = 120,
            repeat_count = 2,
            shift = util.by_pixel(9, 28),
            draw_as_shadow = true,
            scale = 0.5
          },
		  {
            filename = "__base__/graphics/entity/wall/wall-corner-left.png",
            priority = "extra-high",
            width = 64,
            height = 134,
            variation_count = 2,
            line_length = 2,
            shift = util.by_pixel(0, 7),
            scale = 0.5,
			tint = {r = 1, g = 0.3, b = 0, a = 0.5}, -- Brighter orange tint for glow
            draw_as_glow = true
          }
        }
      },
      t_up =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-t.png",
            priority = "extra-high",
            width = 64,
            height = 134,
            variation_count = 4,
            line_length = 4,
            shift = util.by_pixel(0, 7),
            scale = 0.5,
			tint = {r = 1, g = 0.5, b = 0, a = 1}
          },
          {
            filename = "__base__/graphics/entity/wall/wall-t-shadow.png",
            priority = "extra-high",
            width = 124,
            height = 120,
            repeat_count = 4,
            shift = util.by_pixel(14, 28),
            draw_as_shadow = true,
            scale = 0.5
          },
		  {
            filename = "__base__/graphics/entity/wall/wall-t.png",
            priority = "extra-high",
            width = 64,
            height = 134,
            variation_count = 4,
            line_length = 4,
            shift = util.by_pixel(0, 7),
            scale = 0.5,
			tint = {r = 1, g = 0.3, b = 0, a = 0.5}, -- Brighter orange tint for glow
            draw_as_glow = true
          }
        }
      },
      ending_right =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-ending-right.png",
            priority = "extra-high",
            width = 64,
            height = 92,
            variation_count = 2,
            line_length = 2,
            shift = util.by_pixel(0, -3),
            scale = 0.5,
			tint = {r = 1, g = 0.5, b = 0, a = 1}
          },
          {
            filename = "__base__/graphics/entity/wall/wall-ending-right-shadow.png",
            priority = "extra-high",
            width = 124,
            height = 68,
            repeat_count = 2,
            shift = util.by_pixel(17, 15),
            draw_as_shadow = true,
            scale = 0.5
          },
		  {
            filename = "__base__/graphics/entity/wall/wall-ending-right.png",
            priority = "extra-high",
            width = 64,
            height = 92,
            variation_count = 2,
            line_length = 2,
            shift = util.by_pixel(0, -3),
            scale = 0.5,
			tint = {r = 1, g = 0.3, b = 0, a = 0.5}, -- Brighter orange tint for glow
            draw_as_glow = true
          }
        }
      },
      ending_left =
      {
        layers =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-ending-left.png",
            priority = "extra-high",
            width = 64,
            height = 92,
            variation_count = 2,
            line_length = 2,
            shift = util.by_pixel(0, -3),
            scale = 0.5,
			tint = {r = 1, g = 0.5, b = 0, a = 1}
          },
          {
            filename = "__base__/graphics/entity/wall/wall-ending-left-shadow.png",
            priority = "extra-high",
            width = 102,
            height = 68,
            repeat_count = 2,
            shift = util.by_pixel(9, 15),
            draw_as_shadow = true,
            scale = 0.5
          },
		  {
            filename = "__base__/graphics/entity/wall/wall-ending-left.png",
            priority = "extra-high",
            width = 64,
            height = 92,
            variation_count = 2,
            line_length = 2,
            shift = util.by_pixel(0, -3),
            scale = 0.5,
			tint = {r = 1, g = 0.3, b = 0, a = 0.5}, -- Brighter orange tint for glow
            draw_as_glow = true
          }
        }
      },
      filling =
      {
        filename = "__base__/graphics/entity/wall/wall-filling.png",
        priority = "extra-high",
        width = 48,
        height = 56,
        variation_count = 8,
        line_length = 8,
        shift = util.by_pixel(0, -1),
        scale = 0.5,
		tint = {r = 1, g = 0.3, b = 0, a = 0.5}, -- Brighter orange tint for glow
		draw_as_glow = true
      },
      water_connection_patch =
      {
        sheets =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-patch.png",
            priority = "extra-high",
            width = 116,
            height = 128,
            shift = util.by_pixel(0, -2),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/entity/wall/wall-patch-shadow.png",
            priority = "extra-high",
            width = 144,
            height = 100,
            shift = util.by_pixel(9, 15),
            draw_as_shadow = true,
            scale = 0.5
          }
        }
      },
      gate_connection_patch =
      {
        sheets =
        {
          {
            filename = "__base__/graphics/entity/wall/wall-gate.png",
            priority = "extra-high",
            width = 82,
            height = 108,
            shift = util.by_pixel(0, -7),
            scale = 0.5
          },
          {
            filename = "__base__/graphics/entity/wall/wall-gate-shadow.png",
            priority = "extra-high",
            width = 130,
            height = 78,
            shift = util.by_pixel(14, 18),
            draw_as_shadow = true,
            scale = 0.5
          }
        }
      }
    },

    wall_diode_green =
    {
      sheet =
      {
        filename = "__base__/graphics/entity/wall/wall-diode-green.png",
        priority = "extra-high",
        width = 72,
        height = 44,
        draw_as_glow = true,
        --frames = 4,
        shift = util.by_pixel(-1, -23),
        scale = 0.5
      }
    },
    wall_diode_green_light_top =
    {
      minimum_darkness = 0.3,
      color = {g=1},
      shift = util.by_pixel(0, -30),
      size = 1,
      intensity = 0.2
    },
    wall_diode_green_light_right =
    {
      minimum_darkness = 0.3,
      color = {g=1},
      shift = util.by_pixel(12, -23),
      size = 1,
      intensity = 0.2
    },
    wall_diode_green_light_bottom =
    {
      minimum_darkness = 0.3,
      color = {g=1},
      shift = util.by_pixel(0, -17),
      size = 1,
      intensity = 0.2
    },
    wall_diode_green_light_left =
    {
      minimum_darkness = 0.3,
      color = {g=1},
      shift = util.by_pixel(-12, -23),
      size = 1,
      intensity = 0.2
    },

    wall_diode_red =
    {
      sheet =
      {
        filename = "__base__/graphics/entity/wall/wall-diode-red.png",
        priority = "extra-high",
        width = 72,
        height = 44,
        draw_as_glow = true,
        --frames = 4,
        shift = util.by_pixel(-1, -23),
        scale = 0.5
      }
    },
    wall_diode_red_light_top =
    {
      minimum_darkness = 0.3,
      color = {r=1},
      shift = util.by_pixel(0, -30),
      size = 1,
      intensity = 0.2
    },
    wall_diode_red_light_right =
    {
      minimum_darkness = 0.3,
      color = {r=1},
      shift = util.by_pixel(12, -23),
      size = 1,
      intensity = 0.2
    },
    wall_diode_red_light_bottom =
    {
      minimum_darkness = 0.3,
      color = {r=1},
      shift = util.by_pixel(0, -17),
      size = 1,
      intensity = 0.2
    },
    wall_diode_red_light_left =
    {
      minimum_darkness = 0.3,
      color = {r=1},
      shift = util.by_pixel(-12, -23),
      size = 1,
      intensity = 0.2
    },

    circuit_connector = circuit_connector_definitions["wall"],
    circuit_wire_max_distance = default_circuit_wire_max_distance,
    default_output_signal = {type = "virtual", name = "signal-G"}
  }
  end

data:extend({
    create_heat_wall(),  -- Create the heat wall entity

    -- Define the item for the heat wall
    {
        type = "item",
        name = "heat-wall",
        icon = "__heat-engine__/graphics/icons/heat-wall.png",
        icon_size = 64,
        subgroup = "defensive-structure",
        order = "a[stone-wall]-b[heat-wall]",
        place_result = "heat-wall",
        stack_size = 100
    },

    -- Define the recipe for the heat wall
    {
        type = "recipe",
        name = "heat-wall",
        category = "crafting",
        energy_required = 10,
        enabled = false,
        ingredients = {
			{type = "item", name = "stone", amount = 5},
			{type = "item", name = "iron-plate", amount = 2},
			},
	    results = {
            {type = "item", name = "heat-wall", amount = 2}  -- Adjusted to ensure 2 items are returned
        },
    }
})
