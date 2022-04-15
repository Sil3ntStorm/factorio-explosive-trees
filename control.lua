-- Copyright 2022 Sil3ntStorm https://github.com/Sil3ntStorm
--
-- Licensed under MS-RL, see https://opensource.org/licenses/MS-RL

local on_tick_n = require("__flib__.on-tick-n")

local lastNuke = 0
local lastPoison = 0
local config = {}
config['tasksPerTick'] = 10
config['tasksExpireTicks'] = 30
config['delay'] = 2
config['extra-explosion-spawn-range'] = 8

for k, v in pairs(settings.global) do
    if string.sub(k, 1, 4) == 'set-' then
        config[string.sub(k, 5)] = v.value
    end
end

local function onRTSettingChanged(event)
    if string.sub(event.setting, 1, 4) ~= 'set-' then
        return
    end
    config[string.sub(event.setting, 5)] = settings.global[event.setting].value
end

local function getAvailableItems(force)
    local countMap = {}
    if config['enable-nuke'] and (not force or not config['require-research'] or force.technologies['uranium-processing'].researched) then
        countMap['atomic-rocket']        = 1
    end
    if not force or not config['require-research'] or force.technologies['military-2'].researched then
        countMap['artillery-projectile'] = 3
        countMap['poison-capsule']       = 1
    end
    if not force or not config['require-research'] or force.technologies['rocketry'].researched then
        countMap['explosive-rocket']     = 3
    end
    if not force or not config['require-research'] or force.technologies['military'].researched then
        countMap['cluster-grenade']      = 2
    end
    countMap['grenade']              = 5
    countMap['fire-flame']           = 10
    countMap['fire-flame-on-tree']   = 12
    return countMap
end

local function getRandomPosInRange(pos, range)
    local x = pos.x - range / 2
    local y = pos.y - range / 2
    local x2 = pos.x + range / 2
    local y2 = pos.y + range / 2
    return {x = math.random(x, x2), y = math.random(y, y2)}
end

local function getItemToSpawn(count, force)
    local stuffs = {}
    for k,_ in pairs(getAvailableItems(force)) do
        stuffs[#stuffs + 1] = k
    end
    local item = stuffs[math.random(1, #stuffs)]
    if (item == 'atomic-rocket') then
        if (lastNuke > game.tick - config['nuke-delay']) then
            if count > 4 then
                return 'fire-flame-on-tree'
            end
            return getItemToSpawn(count + 1, force)
        end
        lastNuke = game.tick
    end
    if (item == 'poison-capsule') then
        if (lastPoison > game.tick - config['poison-delay']) then
            if count > 4 then
                return 'fire-flame-on-tree'
            end
            return getItemToSpawn(count + 1, force)
        end
        lastPoison = game.tick
    end
    return item
end

local function spawnExplosive(surface, position, force)
    local item = getItemToSpawn(0, force)

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

local function scheduleExplosive(surface, position, force)
    local tsk = {}
    tsk['action'] = 'spawn'
    tsk['position'] = position
    tsk['force'] = force
    tsk['surface'] = surface
    tsk['originTick'] = game.tick
    on_tick_n.add(game.tick + config['delay'], tsk)
end

local function onEntityTriggered(event, option)
    if event.tick < config['peaceful-ticks'] then
        return
    end
    if not (event.entity and event.entity.valid) then
        log('onEntityTriggered called with an invalid entity')
        return
    end
    if config[option] == 0 then
        return
    end
    local frc = game.forces['player']
    if event.force and event.force ~= 'enemy' then
        frc = event.force
    end
    if math.random(1, 100) <= config[option] then
        scheduleExplosive(event.entity.surface, event.entity.position, frc)
    end
end

local function onEntityDeleted(event)
    onEntityTriggered(event, 'tree-explosion-chance-harvest')
end

local function onEntityDamaged(event)
    onEntityTriggered(event, 'tree-explosion-chance-damage')
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
    local data = global.silexptrees_flames[event.registration_number]
    local flames = data.surface.find_entities_filtered{type = 'fire', position = data.position, radius = 10}
    registerFlames(flames)
    if data.name == 'fire-flame' then
        return
    end
    local trees = data.surface.find_entities_filtered{type = 'tree', position = data.position, radius = 1}
    for _, tree in pairs(trees) do
        local evt = {}
        evt['entity'] = tree
        evt['tick'] = game.tick
        onEntityDamaged(evt)
    end
    global.silexptrees_flames[event.registration_number] = nil
end

script.on_init(function()
    on_tick_n.init()
    game.print('Explosive Trees initialized')
end)

script.on_event(defines.events.on_tick, onTick)

script.on_nth_tick(30, onNthTick)
script.on_event(defines.events.on_entity_destroyed, checkBurningTrees)

script.on_event(defines.events.on_runtime_mod_setting_changed, onRTSettingChanged)

script.on_event(defines.events.on_pre_player_mined_item, onEntityDeleted , {{ filter = 'type', type = 'tree' }})
script.on_event(defines.events.on_robot_pre_mined, onEntityDeleted, {{ filter = 'type', type = 'tree' }})
script.on_event(defines.events.on_entity_damaged, onEntityDamaged, {{ filter = 'type', type = 'tree'}, { filter = 'final-health', comparison = '<', value = 16, mode = 'and' }})
