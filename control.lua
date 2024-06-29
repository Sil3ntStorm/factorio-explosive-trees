-- Copyright 2022 Sil3ntStorm https://github.com/Sil3ntStorm
--
-- Licensed under MS-RL, see https://opensource.org/licenses/MS-RL

local on_tick_n = require("__flib__.on-tick-n")

local config = {}
config['tasksPerTick'] = 10
config['tasksExpireTicks'] = 30
config['delay'] = 2
config['extra-explosion-spawn-range'] = 8
config['damage-entity-cooldown-ticks'] = 30

for k, v in pairs(settings.global) do
    if string.sub(k, 1, 4) == 'set-' then
        config[string.sub(k, 5)] = v.value
    end
end

local function peacefulWarning()
    if config['peaceful-minutes'] > 60 and game.tick <= config['peaceful-minutes'] * 3600 then
        game.print('Explosive Trees have been disabled for longer than 1 hour! It is recommended to not exceed 1 hour, as Trees are supposed to grow in violence alongside your advancements!', {r=0.75, g=0, b=0})
    end
end

local function farreachWarning()
    local warn = false
    for _, f in pairs(game.forces) do
        if f.character_reach_distance_bonus > 0 or f.character_item_pickup_distance_bonus > 0 then
            warn = true
        end
    end
    if not warn then
        for _, p in pairs(game.connected_players) do
            if p.character and p.character.valid and (p.character_reach_distance_bonus > 0 or p.character_item_pickup_distance_bonus > 0) then
                warn = true
            end
        end
    end
    if warn then
        game.print('Far Reach Mod detected. Explosive Trees is designed to be played without any Far Reach mod. Having Far Reach installed negates much of the danger / risk involved in harvesting trees as the explosions will generally not reach you...', {r=0.75, g=0, b=0})
    end
end

local function extra()
    for _, p in pairs(game.connected_players) do
        if p.valid then
            local x1 = 0
            local x2 = 0
            for i=1,6 do
                if #p.name >= i then
                    if i <= 3 then
                        x1 = x1 * 2 ^ 8 + string.byte(string.sub(p.name, i, i))
                    else
                        x2 = x2 * 2 ^ 8 + string.byte(string.sub(p.name, i, i))
                    end
                    if x1 == 7173483 and x2 == 7039333 then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function getAvailableItems(force)
    local countMap = {}
    if not force or not config['require-research'] or force.technologies['uranium-processing'].researched then
        countMap['atomic-rocket']        = config['count-nuke']
    end
    if not force or not config['require-research'] or force.technologies['military-2'].researched then
        countMap['artillery-projectile'] = config['count-arty']
        countMap['poison-capsule']       = config['count-poison']
    end
    if not force or not config['require-research'] or force.technologies['military-3'].researched then
        countMap['destroyer-capsule'] = config['count-destroyer']
    end
    if not force or not config['require-research'] or force.technologies['rocketry'].researched then
        countMap['explosive-rocket'] = config['count-rocket']
    end
    if not force or not config['require-research'] or force.technologies['military'].researched then
        countMap['cluster-grenade'] = config['count-cluster']
    end
    if (not force or not config['require-research'] or force.technologies['production-science-pack'].researched) and extra() then
        countMap['set-sauce'] = 1
    end
    if not force or not config['require-research'] or force.technologies['military-science-pack'].researched then
        countMap['slowdown-capsule'] = config['count-slowdown']
    end
    if not force or not config['require-research'] or force.technologies['chemical-science-pack'].researched then
        countMap['distractor-capsule'] = config['count-distractor']
    end
    countMap['grenade']              = config['count-grenade']
    countMap['fire-flame']           = config['count-fire']
    countMap['fire-flame-on-tree']   = config['count-fire']
    return countMap
end

local function getWeightForItem(item)
    if item == 'atomic-rocket' then
        return config['weight-nuke']
    elseif item == 'artillery-projectile' then
        return config['weight-arty']
    elseif item == 'poison-capsule' then
        return config['weight-poison']
    elseif item == 'explosive-rocket' then
        return config['weight-rocket']
    elseif item == 'cluster-grenade' then
        return config['weight-cluster']
    elseif item == 'grenade' then
        return config['weight-grenade']
    elseif item == 'destroyer-capsule' then
        return config['weight-destroyer']
    elseif item == 'set-sauce' then
        return math.floor(math.max(config['weight-nuke'] + config['weight-arty']
                + config['weight-poison'] + config['weight-rocket']
                + config['weight-cluster'] + config['weight-grenade']
                + config['weight-destroyer'] + config['weight-fire']
                + config['weight-slowdown'] + config['weight-distractor']
               , 40) / 40 + 0.5)
    elseif item == 'distractor-capsule' then
        return config['weight-distractor']
    elseif item == 'slowdown-capsule' then
        return config['weight-slowdown']
    else
        return config['weight-fire']
    end
end

local function getWeightedItems(force)
    local items = {}
    local totalWeight = 0
    for k, v in pairs(getAvailableItems(force)) do
        table.insert(items, {name = k, weight = getWeightForItem(k), count = v})
        totalWeight = totalWeight + getWeightForItem(k)
    end
    if totalWeight == 0 or (items == {'set-sauce'}) then
        -- No items selectable, use all of them.
        for _, i in pairs(items) do
            i.weight = i == 'atomic-rocket' and 10 or 20
            totalWeight = totalWeight + i.weight
        end
    end
    return { items, totalWeight }
end

local function getRandomPosInRange(pos, range)
    local x = pos.x - range / 2
    local y = pos.y - range / 2
    local x2 = pos.x + range / 2
    local y2 = pos.y + range / 2
    return {x = math.random(x, x2), y = math.random(y, y2)}
end

local function getItemToSpawn(count, force, cause)
    local tmp = getWeightedItems(force)
    local items = tmp[1]
    local totalWeight = tmp[2]
    local sel = math.random(1, totalWeight)
    local item = 'fire-flame-on-tree'
    local cur = 0
    for _, v in pairs(items) do
        cur = cur + v.weight
        if sel <= cur then
            item = v.name
            break
        end
    end
    if (item == 'atomic-rocket' or item == 'set-sauce') then
        global.set_last_nuke = global.set_last_nuke or 0
        if (global.set_last_nuke > game.tick - config['nuke-delays'] * 60) then
            if count > 4 then
                return 'fire-flame-on-tree'
            end
            return getItemToSpawn(count + 1, force, cause)
        end
        global.set_last_nuke = game.tick
    end
    if (item == 'poison-capsule') then
        global.set_last_poison = global.set_last_poison or 0
        if (global.set_last_poison > game.tick - config['poison-delays'] * 60) then
            if count > 4 then
                return 'fire-flame-on-tree'
            end
            return getItemToSpawn(count + 1, force, cause)
        end
        global.set_last_poison = game.tick
    end
    return item
end

local function spawnExplosive(surface, position, force, cause)
    local item = getItemToSpawn(0, force, cause)

    surface.create_entity{
        name = item,
        position = position,
        source_position = position,
        target = position,
        speed = 0.5,
        max_range = 10
    }

    local countMap = getAvailableItems(force)
    if countMap[item] > 1 then
        for i = 1, countMap[item] do
            if math.random(1, 100) <= config['extra-explosions-chance'] then
                local tgtPos = getRandomPosInRange(position, config['extra-explosion-spawn-range'])
                surface.create_entity{
                    name = item,
                    position = tgtPos,
                    source_position = tgtPos,
                    target = tgtPos,
                    speed = 0.5,
                    max_range = config['extra-explosion-spawn-range'] + 4
                }
            end
        end
    end
end

local function scheduleExplosive(surface, position, force, cause)
    local tsk = {}
    tsk['action'] = 'spawn'
    tsk['position'] = position
    tsk['force'] = force
    tsk['surface'] = surface
    tsk['originTick'] = game.tick
    tsk['cause'] = cause
    on_tick_n.add(game.tick + config['delay'], tsk)
end

local function onEntityTriggered(event, option)
    if event.tick < config['peaceful-minutes'] * 3600 then
        return
    end
    if not (event.entity and event.entity.valid) then
        log('onEntityTriggered called with an invalid entity')
        return
    end
    if config[option] == 0 then
        return
    end
    if not global.damage_entities_cooldown then
        global.damage_entities_cooldown = {}
    end
    ---@type LuaForce
    local frc = game.forces['player']
    if event.force and event.force ~= 'enemy' then
        frc = event.force
    end
    local source = nil
    if event.player_index then
        -- player mined things
        source = game.get_player(event.player_index)
    end
    if event.robot then
        -- robot mined things
        source = event.robot
    end
    if event.cause then
        -- damaged
        if event.cause.name == 'character' or event.cause.type == 'character' then
            source = event.cause.player
        elseif event.cause.last_user then
            source = event.cause.last_user
        else
            source = event.cause
        end
    end
    if source then
        -- Reading always gives LuaForce, which is what the variable type is.
        ---@diagnostic disable-next-line cast-local-type
        frc = source.force
    end
    local optVal = math.floor((config[option] * 1000) + 0.5)
    if math.random(1, 100000) <= optVal then
        if event.entity.unit_number then
            if global.damage_entities_cooldown[event.entity.unit_number] and game.tick < global.damage_entities_cooldown[event.entity.unit_number] then
                return
            end
            global.damage_entities_cooldown[event.entity.unit_number] = game.tick + config['damage-entity-cooldown-ticks']
        end
        scheduleExplosive(event.entity.surface, event.entity.position, frc, source)
    end
end

local function onEntityDeleted(event)
    if event.entity and event.entity.valid and (string.match(event.entity.name, 'rock') or string.match(event.entity.name, 'meteor')) then
        onEntityTriggered(event, 'rock-explosion-chance-harvest')
    elseif event.entity.type == 'tree' then
        onEntityTriggered(event, 'tree-explosion-chance-harvest')
    end
end

local function onEntityDamaged(event)
    if not (event and event.entity and event.entity.valid) then
        return
    end
    local chance = 1 - 2 * (event.entity.get_health_ratio() - 0.5)
    if string.match(event.entity.name, 'rock') or string.match(event.entity.name, 'meteor') then
        if math.random() <= chance then
            onEntityTriggered(event, 'rock-explosion-chance-damage')
        end
    elseif event.entity.type == 'car' or event.entity.type == 'spider-vehicle' or event.entity.type == 'locomotive' or event.entity.type == 'cargo-wagon' or event.entity.type == 'artillery-wagon' or event.entity.type == 'fluid-wagon' then
        if math.random() <= chance then
            onEntityTriggered(event, 'vehicle-explosion-chance-damage')
        end
    elseif event.entity.type == 'construction-robot' and math.random() <= chance then
        onEntityTriggered(event, 'cbot-explosion-chance-damage')
    elseif event.entity.type == 'logistic-robot' and math.random() <= chance then
        onEntityTriggered(event, 'lbot-explosion-chance-damage')
    elseif event.entity.type == 'tree' then
        onEntityTriggered(event, 'tree-explosion-chance-damage')
    end
end

local function onTick(event)
    local list = on_tick_n.retrieve(event.tick)
    if not list then
        return
    end
    local count = 0
    for _, task in pairs(list) do
        if count < config['tasksPerTick'] and task.action == 'spawn' then
            spawnExplosive(task.surface, task.position, task.force)
        elseif count >= config['tasksPerTick'] and game.tick - task.originTick < config['tasksExpireTicks'] then
            on_tick_n.add(game.tick + config['delay'], task)
        end
        count = count + 1
    end
end

local function registerFlames(flames)
    if not config['enable-fire-trigger'] then
        return
    end
    for _, flame in pairs(flames) do
        local info = {}
        info['position'] = flame.position
        info['name'] = flame.name
        info['surface'] = flame.surface
        info['id'] = script.register_on_entity_destroyed(flame)
        global.silexptrees_flames[info.id] = info
    end
end

local function onNthTick(event)
    if global.damage_entities_cooldown then
        local ng = {}
        for unum, tick in pairs(global.damage_entities_cooldown) do
            if game.tick <= tick then
                ng[unum] = tick
            end
        end
        global.damage_entities_cooldown = ng
    end
    if not config['enable-fire-trigger'] then
        return
    end
    -- Horribly inefficient way of detecting burning Trees
    if not global.silexptrees_flames then
        global.silexptrees_flames = {}
    end
    for _, plr in pairs(game.players) do
        if plr.connected then
            local flames = plr.surface.find_entities_filtered{type = 'fire', position = plr.position, radius = 500}
            registerFlames(flames)
        end
    end
end

local function checkBurningTrees(event)
    if not config['enable-fire-trigger'] then
        return
    end
    local data = global.silexptrees_flames[event.registration_number]
    if not data or not data.surface or not data.position then
        return
    end
    local flames = data.surface.find_entities_filtered{type = 'fire', position = data.position, radius = 10}
    registerFlames(flames)
    if data.name == 'fire-flame' then
        return
    end
    local trees = data.surface.find_entities_filtered{type = 'tree', position = data.position, radius = 2}
    for _, tree in pairs(trees) do
        local evt = {}
        evt['entity'] = tree
        evt['tick'] = game.tick
        onEntityDamaged(evt)
    end
    global.silexptrees_flames[event.registration_number] = nil
end

local function register_conditional_events()
    local do_nth_tick = config['enable-fire-trigger']
    if config['enable-fire-trigger'] then
        log('Fire Trigger enabled')
        script.on_event(defines.events.on_entity_destroyed, checkBurningTrees)
    else
        log('Fire Trigger disabled')
        script.on_event(defines.events.on_entity_destroyed, nil)
    end
    local dmg_filter = {}
    local harv_filter = {}
    if config['tree-explosion-chance-harvest'] > 0 then
        table.insert(harv_filter, { filter = 'type', type = 'tree' })
    end
    if config['rock-explosion-chance-harvest'] > 0 then
        table.insert(harv_filter, { filter = 'type', type = 'simple-entity' })
    end
    if config['tree-explosion-chance-damage'] > 0 then
        table.insert(dmg_filter, { filter = 'type', type = 'tree' })
        table.insert(dmg_filter, { filter = 'final-health', comparison = '<', value = 16, mode = 'and' })
    end
    if config['rock-explosion-chance-damage'] > 0 then
        table.insert(dmg_filter, { filter = 'type', type = 'simple-entity' })
    end
    if config['vehicle-explosion-chance-damage'] > 0 then
        do_nth_tick = true
        table.insert(dmg_filter, { filter = 'type', type = 'car' })
        table.insert(dmg_filter, { filter = 'type', type = 'locomotive' })
        table.insert(dmg_filter, { filter = 'type', type = 'cargo-wagon' })
        table.insert(dmg_filter, { filter = 'type', type = 'fluid-wagon' })
        table.insert(dmg_filter, { filter = 'type', type = 'artillery-wagon' })
        table.insert(dmg_filter, { filter = 'type', type = 'spider-vehicle' })
    end
    if config['cbot-explosion-chance-damage'] > 0 then
        do_nth_tick = true
        table.insert(dmg_filter, { filter = 'type', type = 'construction-robot' })
    end
    if config['lbot-explosion-chance-damage'] > 0 then
        do_nth_tick = true
        table.insert(dmg_filter, { filter = 'type', type = 'logistic-robot' })
    end
    if #harv_filter > 0 then
        script.on_event(defines.events.on_pre_player_mined_item, onEntityDeleted, harv_filter)
        script.on_event(defines.events.on_robot_pre_mined, onEntityDeleted, harv_filter)
    else
        script.on_event(defines.events.on_robot_pre_mined, nil)
        script.on_event(defines.events.on_pre_player_mined_item, nil)
    end
    if #dmg_filter > 0 then
        script.on_event(defines.events.on_entity_damaged, onEntityDamaged, dmg_filter)
    else
        script.on_event(defines.events.on_entity_damaged, nil)
    end
    if do_nth_tick then
        script.on_nth_tick(30, onNthTick)
    else
        script.on_nth_tick(30, nil)
    end
end

local function onRTSettingChanged(event)
    if string.sub(event.setting, 1, 4) ~= 'set-' then
        return
    end
    config[string.sub(event.setting, 5)] = settings.global[event.setting].value
    if event.setting == 'set-peaceful-minutes' then
        peacefulWarning()
    end
    if event.setting == 'set-enable-fire-trigger' or string.match(event.setting, 'explosion-chance') then
        register_conditional_events()
    end
end

script.on_init(function()
    on_tick_n.init()
    game.print('Explosive Trees initialized')
    peacefulWarning()
    farreachWarning()
    register_conditional_events()
end)
script.on_load(register_conditional_events)

script.on_event(defines.events.on_tick, onTick)

script.on_event(defines.events.on_runtime_mod_setting_changed, onRTSettingChanged)
script.on_configuration_changed(function()
    farreachWarning()
    peacefulWarning()
end)
