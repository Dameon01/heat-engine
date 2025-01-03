-- Constants
local pulse_interval = 60 -- Ticks between each frame change
local leach_radius = 10
local range = 10 -- Range to boost nearby turrets
local turret_types = {"ammo-turret", "electric-turret", "fluid-turret"} -- Types of turrets to boost

-- Initialization for global variables
local function initialize_storage()
    storage = storage or {}
    storage.heat_engines = type(storage.heat_engines) == "table" and storage.heat_engines or {}
    storage.heat_walls = type(storage.heat_walls) == "table" and storage.heat_walls or {}
    storage.heat_turrets = type(storage.heat_turrets) == "table" and storage.heat_turrets or {}
	storage.heat_turret_mk2s = type(storage.heat_turret_mk2s) == "table" and storage.heat_turret_mk2s or {}
	storage.ticker = storage.ticker or 0
end

local function on_init()
    initialize_storage()
end

local function on_configuration_changed(data)
    initialize_storage()
end




-- Generate heat ammo for players
local function generate_heat_ammo_for_player(player)
    if not player.character then
        log("Warning: Player does not have a character.")
        return
    end

    local inventory = player.get_main_inventory()
    if not inventory or not inventory.valid then
        log("Warning: Player inventory is invalid.")
        return
    end

    local has_heat_pistol = false
    if player.character and player.character.get_inventory(defines.inventory.character_guns) then
        local weapon_inventory = player.character.get_inventory(defines.inventory.character_guns)
        for i = 1, #weapon_inventory do
            local weapon = weapon_inventory[i]
            if weapon and weapon.valid_for_read and weapon.name == "heat-pistol" then
                has_heat_pistol = true
                break
            end
        end
    end

    if not has_heat_pistol then
        return
    end

    local current_count = inventory.get_item_count("heat-bullet")
    local max_count = 200





    local nearby_entities = player.surface.find_entities_filtered({
        area = {
            {player.position.x - leach_radius, player.position.y - leach_radius},
            {player.position.x + leach_radius, player.position.y + leach_radius}
        },
        force = player.force
    })

    if current_count < max_count then
        for _, entity in pairs(nearby_entities) do
            if entity.valid and entity.temperature then
                local temperature = entity.temperature or 0
                local needed_heat = 5
                local ammo_to_generate = math.min(10, max_count - current_count)

                if temperature >= needed_heat * ammo_to_generate then
                    entity.temperature = temperature - needed_heat * ammo_to_generate

                    -- Insert heat bullets with matching quality
                    local inserted_count = inventory.insert({
                        name = "heat-bullet",
                        count = ammo_to_generate,

                    })

                    log("Generated " .. inserted_count .. " heat-bullets with quality " .. (pistol_quality or "N/A") .. " for player.")
                    break
                end
            end
        end
    end
end

-- Define target items and their maximum counts
local TARGET_ITEMS = {
    ["heat-bullet"] = 200, -- Item name = Maximum allowed count
    ["heat-bomb"] = 150    -- Another item with a different max count
}

-- Event handler for inventory changes
script.on_event(defines.events.on_player_main_inventory_changed, function(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    -- Get the player's inventory
    local inventory = player.get_main_inventory()
    if not inventory then return end

    -- Loop through each target item
    for item_name, max_count in pairs(TARGET_ITEMS) do
        -- Get the current count of the item
        local current_count = inventory.get_item_count(item_name)

        -- Check if the count exceeds the maximum allowed
        if current_count > max_count then
            -- Calculate the excess
            local excess_count = current_count - max_count

            -- Remove the excess items
            inventory.remove({name = item_name, count = excess_count})

            -- Notify the player (optional)
            player.print("Excess " .. item_name .. " (" .. excess_count .. " items) has been removed to maintain the limit of " .. max_count .. ".")
        end
    end
end)


local function on_built_entity(event)
    -- Ensure storage is properly initialized
    if not storage then
        log("Storage was not initialized, calling initialize_storage.")
        initialize_storage()
    end

local created_entity = event.created_entity or event.entity
    if created_entity and created_entity.valid then
        if created_entity.name == "heat-engine" then
            local position = created_entity.position
            local surface = created_entity.surface

            -- Create the electric energy interface as part of the heat engine setup
            local electric_energy_interface = surface.create_entity({
                name = "hidden-energy-interface",
                type = "electric-energy-interface",
                position = {position.x + 1, position.y},
                force = created_entity.force,
                create_build_effect_smoke = false,
                render_player_index = event.player_index,
                visible = false
            })

            if electric_energy_interface and electric_energy_interface.valid then
                electric_energy_interface.operable = false
                electric_energy_interface.minable = false

                -- Make sure the heat_engines table exists before inserting
                storage.heat_engines = storage.heat_engines or {}

                -- Register heat engine and buffer as a pair
                table.insert(storage.heat_engines, {engine = created_entity, interface = electric_energy_interface})
                log("Registered heat engine with electric buffer at " .. serpent.line(position))
            else
                log("Failed to create electric buffer for heat engine at " .. serpent.line(position))
            end

        elseif created_entity.name == "heat-wall" then
            -- Register the heat wall
            storage.heat_walls = storage.heat_walls or {}
            table.insert(storage.heat_walls, created_entity)
            log("Registered heat wall at " .. serpent.line(created_entity.position))

        elseif created_entity.name == "heat-turret" then
            -- Register the heat turret
            storage.heat_turrets = storage.heat_turrets or {}
            table.insert(storage.heat_turrets, created_entity)
            log("Registered heat turret at " .. serpent.line(created_entity.position))

		elseif created_entity.name == "heat-turret-mk2" then
            -- Register the heat turret
            storage.heat_turret_mk2s = storage.heat_turret_mk2s or {}
            table.insert(storage.heat_turret_mk2s, created_entity)
            log("Registered heat turret mk2 at " .. serpent.line(created_entity.position))

		else
            log("Unhandled entity type: " .. (created_entity.name or "unknown"))
        end
    end
end

local function on_entity_removed(event)
    local removed_entity = event.entity

    local entity_data_map = {
        ["heat-engine"] = storage.heat_engines,
        ["heat-wall"] = storage.heat_walls,
        ["heat-turret"] = storage.heat_turrets,
		["heat-turret-mk2"] = storage.heat_turret_mk2s,
    }

    if removed_entity and removed_entity.valid then
        local storage_list = entity_data_map[removed_entity.name]

        if storage_list then
            for index = #storage_list, 1, -1 do
                local listed_entity = storage_list[index]

                -- Special handling for heat-engine to destroy the associated hidden interface
                if removed_entity.name == "heat-engine" then
                    if listed_entity.engine == removed_entity then
                        -- Destroy the hidden interface associated with this heat engine
                        local hidden_interface = listed_entity.interface
                        if hidden_interface and hidden_interface.valid then
                            hidden_interface.destroy()
                            log("Destroyed hidden interface associated with removed heat engine at " ..
                                serpent.line(removed_entity.position))
                        end

                        -- Remove the heat engine entry from storage
                        table.remove(storage_list, index)
                        log("Removed heat engine from data table at position " ..
                            serpent.line(removed_entity.position))
                        break
                    end


				elseif listed_entity == removed_entity then
                    -- Generic removal for heat-wall and heat-turret and heat turret mk2 and turret boost beacons
                    table.remove(storage_list, index)
                    log("Removed entity: " .. (removed_entity.name or "unknown") ..
                        " from data table at position " .. serpent.line(removed_entity.position))
                    break
                end
            end
        end
    end
end



local function leech_heat_for_turret(heat_turret)
    if not heat_turret.valid then
        log("Invalid heat turret detected during leeching.")
        return
    end


    local heat_needed_per_bullet = 2
    local ammo_inventory = heat_turret.get_inventory(defines.inventory.turret_ammo)
    if not ammo_inventory or not ammo_inventory.valid then
        log("No ammo inventory for heat turret")
        return
    end

    local current_ammo_count = ammo_inventory.get_item_count("heat-bullet")
    local max_ammo_count = 200
    local ammo_to_generate = math.min(10, max_ammo_count - current_ammo_count)

    if ammo_to_generate <= 0 then
        log("Ammo inventory already full or unable to add more ammo")
        return
    end

    local total_heat_needed = ammo_to_generate * heat_needed_per_bullet

    local nearby_sources = heat_turret.surface.find_entities_filtered({
        area = {
            {heat_turret.position.x - leach_radius, heat_turret.position.y - leach_radius},
            {heat_turret.position.x + leach_radius, heat_turret.position.y + leach_radius}
        },
        force = heat_turret.force
    })




    for _, source in pairs(nearby_sources) do
        if source.valid and source.temperature then
            local available_heat = source.temperature or 0
            if available_heat >= total_heat_needed then
                source.temperature = available_heat - total_heat_needed

                -- Insert ammo with matching quality
                local inserted_count = ammo_inventory.insert({
                    name = "heat-bullet",
                    count = ammo_to_generate

                })

                if inserted_count > 0 then
                    log("Inserted " .. inserted_count .. " heat-bullets into turret ammo inventory at position {x = " .. heat_turret.position.x .. ", y = " .. heat_turret.position.y .. "}")
                end
                return true
            else
                log("Not enough available heat to generate ammo for turret at position {x = " .. heat_turret.position.x .. ", y = " .. heat_turret.position.y .. "}")
            end
        end
    end
    return false
end

local function leech_heat_for_turret_mk2(heat_turret_mk2)
    if not heat_turret_mk2.valid then
        log("Invalid heat turret Mk2 detected during leeching.")
        return
    end

    local heat_needed_per_bomb = 5 -- Adjust the heat needed per bomb as appropriate
    local ammo_inventory = heat_turret_mk2.get_inventory(defines.inventory.turret_ammo)
    if not ammo_inventory or not ammo_inventory.valid then
        log("No ammo inventory for heat turret Mk2")
        return
    end
	local current_ammo_count = ammo_inventory.get_item_count("heat-bomb")
    local max_ammo_count = 150 -- Set max ammo count for heat bombs
    local ammo_to_generate = math.min(5, max_ammo_count - current_ammo_count) -- Adjust generation amount

    if ammo_to_generate <= 0 then
        log("Ammo inventory for Mk2 already full or unable to add more ammo")
        return
    end

    local total_heat_needed = ammo_to_generate * heat_needed_per_bomb

    local nearby_sources = heat_turret_mk2.surface.find_entities_filtered({
        area = {
            {heat_turret_mk2.position.x - leach_radius, heat_turret_mk2.position.y - leach_radius},
            {heat_turret_mk2.position.x + leach_radius, heat_turret_mk2.position.y + leach_radius}
        },
        force = heat_turret_mk2.force
    })



    for _, source in pairs(nearby_sources) do
        if source.valid and source.temperature then
            local available_heat = source.temperature or 0
            if available_heat >= total_heat_needed then
                source.temperature = available_heat - total_heat_needed

                -- Insert ammo with matching quality
                local inserted_count = ammo_inventory.insert({
                    name = "heat-bomb",
                    count = ammo_to_generate

                })

                if inserted_count > 0 then
                    log("Inserted " .. inserted_count .. " heat-bombs into turret Mk2 ammo inventory at position {x = " .. heat_turret_mk2.position.x .. ", y = " .. heat_turret_mk2.position.y .. "}")
                end
                return true
            else
                log("Not enough available heat to generate ammo for turret Mk2 at position {x = " .. heat_turret_mk2.position.x .. ", y = " .. heat_turret_mk2.position.y .. "}")
            end
        end
    end
    return false
end


local function leech_heat_for_wall(heat_wall)
    if not heat_wall.valid then
        return
    end

    local heat_needed = 1
    local nearby_sources = heat_wall.surface.find_entities_filtered({
        area = {
            {heat_wall.position.x - leach_radius, heat_wall.position.y - leach_radius},
            {heat_wall.position.x + leach_radius, heat_wall.position.y + leach_radius}
        },
        force = heat_wall.force
    })

    local total_heat_collected = 0
    for _, source in pairs(nearby_sources) do
        if source.valid and source.temperature then
            local available_heat = source.temperature or 0
            local heat_to_leech = math.min(available_heat, heat_needed - total_heat_collected)

            source.temperature = available_heat - heat_to_leech
            total_heat_collected = total_heat_collected + heat_to_leech

            if total_heat_collected >= heat_needed then
                local radius = 10
                local damage = 20

                local enemies = heat_wall.surface.find_entities_filtered({
                    area = {
                        {heat_wall.position.x - radius, heat_wall.position.y - radius},
                        {heat_wall.position.x + radius, heat_wall.position.y + radius}
                    },
                    force = "enemy"
                })

                for _, enemy in pairs(enemies) do
                    if enemy.valid and enemy.health then
                        enemy.damage(damage, heat_wall.force, "fire")
                    end
                end
                break
            end
        end
    end
end

local function generate_electricity_from_heat(engine_data)
    local heat_engine = engine_data.engine
    local electric_energy_interface = engine_data.interface

    if not (heat_engine and heat_engine.valid) or not (electric_energy_interface and electric_energy_interface.valid) then
        return
    end

    local temperature = heat_engine.temperature or 0
    if temperature <= 0 then
        log("No heat available for generating electricity at engine {x = " .. heat_engine.position.x .. ", y = " .. heat_engine.position.y .. "}")
        return
    end

    local rate_multiplier = 500
    local energy_generated = temperature * rate_multiplier

    local buffer_capacity = energy_production or 0
    local current_energy = electric_energy_interface.energy or 0

    if buffer_capacity > 0 and (current_energy + energy_generated) <= buffer_capacity then
        electric_energy_interface.energy = current_energy + energy_generated
        local heat_consumed = energy_generated / 70000
        heat_engine.temperature = math.max(0, temperature - heat_consumed)
        log("Generated " .. energy_generated .. "W of energy from heat engine at position {x = " .. heat_engine.position.x .. ", y = " .. heat_engine.position.y .. "}")
    else
        log("Cannot generate energy as buffer limits are exceeded at {x = " .. heat_engine.position.x .. ", y = " .. heat_engine.position.y .. "}")
    end
end

local function on_tick(event)
    if event.tick % pulse_interval == 0 then
        -- Process heat engines
        if type(storage.heat_engines) == "table" then
            for _, heat_engine in ipairs(storage.heat_engines) do
                if heat_engine and heat_engine.engine and heat_engine.engine.valid then
                    if heat_engine.interface and heat_engine.interface.valid then
                        generate_electricity_from_heat(heat_engine)
                    else
                        log("Hidden interface for heat-engine at position {x = " .. heat_engine.engine.position.x .. ", y = " .. heat_engine.engine.position.y .. "} is invalid.")
                    end
                else
                    log("Heat engine entity invalid or removed.")
                end
            end
        else
            log("Heat engines table is not properly initialized.")
        end

        -- Process heat walls
        if type(storage.heat_walls) == "table" then
            for _, heat_wall in ipairs(storage.heat_walls) do
                if heat_wall and heat_wall.valid then
                    leech_heat_for_wall(heat_wall)
                else
                    log("Heat wall entity invalid or removed.")
                end
            end
        else
            log("Heat walls table is not properly initialized.")
        end

        -- Process heat turrets
        if type(storage.heat_turrets) == "table" then
            for _, heat_turret in ipairs(storage.heat_turrets) do
                if heat_turret and heat_turret.valid then
                    leech_heat_for_turret(heat_turret)
                else
                    log("Heat turret entity invalid or removed.")
                end
            end
        else
            log("Heat turrets table is not properly initialized.")
        end

		if type(storage.heat_turret_mk2s) == "table" then
            for _, heat_turret_mk2 in ipairs(storage.heat_turret_mk2s) do
                if heat_turret_mk2 and heat_turret_mk2.valid then
                    leech_heat_for_turret_mk2(heat_turret_mk2)
                else
                    log("Heat turret mk2 entity invalid or removed.")
                end
            end
        else
            log("Heat turrets mk2 table is not properly initialized.")
        end



        -- Generate ammo for players
        for _, player in pairs(game.connected_players) do
            if player.valid then
                generate_heat_ammo_for_player(player)
            end
        end
	end
    -- Increment ticker
    storage.ticker = (storage.ticker or 0) + 1
end

-- Register event functions
local function on_load()
    script.on_event(defines.events.on_tick, on_tick)
    script.on_event(defines.events.on_built_entity, on_built_entity)
	script.on_event(defines.events.on_robot_built_entity, on_built_entity)
    script.on_event(defines.events.on_entity_died, on_entity_removed)
    script.on_event(defines.events.on_player_mined_entity, on_entity_removed)
    script.on_event(defines.events.on_robot_mined_entity, on_entity_removed)
    script.on_event(defines.events.script_raised_destroy, on_entity_removed)
end

script.on_load(on_load)
script.on_init(on_init)
script.on_configuration_changed(on_configuration_changed)
script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_robot_built_entity, on_built_entity)
script.on_event(defines.events.script_raised_built, on_built_entity)
script.on_event(defines.events.script_raised_revive, on_built_entity)
script.on_event(defines.events.on_tick, on_tick)
script.on_event(defines.events.on_entity_died, on_entity_removed)
script.on_event(defines.events.on_player_mined_entity, on_entity_removed)
script.on_event(defines.events.on_robot_mined_entity, on_entity_removed)
script.on_event(defines.events.script_raised_destroy, on_entity_removed)
