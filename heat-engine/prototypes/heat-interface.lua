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
        },
    }
end

data:extend({
    {
        type = "heat-interface",
        name = "hidden-heat-interface",
        icon = "__heat-engine__/graphics/icons/blank.png",
        icon_size = 64,
        flags = {"placeable-off-grid", "not-on-map"},
        max_temperature = 1000,
        min_temperature_gradient = 0.5,
        max_transfer = "10MW",
		selectable_in_game = false,
		heat_buffer = {
            connections = createConnections("heat"),
            heat_capacity = "400MJ",
            specific_heat = "2kJ",
            max_temperature = 5000,
            max_transfer = "10MW",
        },
    }
})
