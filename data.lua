-- Copyright 2022 Sil3ntStorm https://github.com/Sil3ntStorm
--
-- Licensed under MS-RL, see https://opensource.org/licenses/MS-RL

local smoke_animations = require("__base__.prototypes.entity.smoke-animations")

local smoke = table.deepcopy(data.raw.explosion['atomic-fire-smoke'])
smoke.name = "set-sauce-fire-smoke"
smoke.animations[1].filename = "__explosive-trees__/graphics/smoke.png"

local smoke_proj = table.deepcopy(data.raw.projectile["atomic-bomb-wave-spawns-fire-smoke-explosion"])
smoke_proj.name = "set-sauce-fire-smoke-spawn"
smoke_proj.action[1].action_delivery.target_effects[1].entity_name = smoke.name

local stripes =
    {
      {
        filename = "__explosive-trees__/graphics/nuke-explosion-1.png",
        width_in_frames = 5,
        height_in_frames = 5
      },
      {
        filename = "__explosive-trees__/graphics/nuke-explosion-2.png",
        width_in_frames = 5,
        height_in_frames = 5
      },
      {
        filename = "__explosive-trees__/graphics/nuke-explosion-3.png",
        width_in_frames = 5,
        height_in_frames = 5
      },
      {
        filename = "__explosive-trees__/graphics/nuke-explosion-4.png",
        width_in_frames = 5,
        height_in_frames = 5
      }
    }
local hr_stripes =
    {
      {
        filename = "__explosive-trees__/graphics/hr-nuke-explosion-1.png",
        width_in_frames = 5,
        height_in_frames = 5
      },
      {
        filename = "__explosive-trees__/graphics/hr-nuke-explosion-2.png",
        width_in_frames = 5,
        height_in_frames = 5
      },
      {
        filename = "__explosive-trees__/graphics/hr-nuke-explosion-3.png",
        width_in_frames = 5,
        height_in_frames = 5
      },
      {
        filename = "__explosive-trees__/graphics/hr-nuke-explosion-4.png",
        width_in_frames = 5,
        height_in_frames = 5
      }
    }
local nuke_shockwave =
  {
    {
      filename = "__explosive-trees__/graphics/nuke-shockwave-1.png",
      draw_as_glow = true,
      priority = "high",
      flags = {"smoke"},
      line_length = 8,
      width = 66,
      height = 68,
      frame_count = 32,
      animation_speed = 0.5,
      shift = util.by_pixel(-1,0),
      hr_version =
      {
        filename = "__explosive-trees__/graphics/hr-nuke-shockwave-1.png",
        draw_as_glow = true,
        priority = "high",
        flags = {"smoke"},
        line_length = 8,
        width = 132,
        height = 136,
        frame_count = 32,
        animation_speed = 0.5,
        shift = util.by_pixel(-0.5,0),
        scale = 1.5
      }
    },
    {
      filename = "__explosive-trees__/graphics/nuke-shockwave-2.png",
      draw_as_glow = true,
      priority = "high",
      flags = {"smoke"},
      line_length = 8,
      width = 56,
      height = 64,
      frame_count = 32,
      animation_speed = 0.5,
      shift = util.by_pixel(-1,0),
      hr_version =
      {
        filename = "__explosive-trees__/graphics/hr-nuke-shockwave-2.png",
        draw_as_glow = true,
        priority = "high",
        flags = {"smoke"},
        line_length = 8,
        width = 110,
        height = 128,
        frame_count = 32,
        animation_speed = 0.5,
        shift = util.by_pixel(0,3),
        scale = 1.5
      }
    }
  }

local explo = table.deepcopy(data.raw.explosion['nuke-explosion'])
explo.animations.stripes = stripes
explo.animations.hr_version.stripes = hr_stripes
explo.name = 'set-sauce-explosion'

local cluster = table.deepcopy(data.raw.explosion['cluster-nuke-explosion'])
cluster.name = 'set-sauce-cluster-explosion'
cluster.animations = smoke_animations.trivial_nuke_smoke({
      tint = {r = 0.698, g = 0, b = 0.698, a = 0.500},
      scale = 2.5,
      fade_in_duration = 10,
      duration = 20,
      fade_away_duration = 20,
      spread_duration = 100,
      start_scale = 2.5,
      end_scale = 1.5,})

local cluster_proj = table.deepcopy(data.raw.projectile["atomic-bomb-wave-spawns-cluster-nuke-explosion"])
cluster_proj.name = 'set-sauce-cluster-projectile'
cluster_proj.action[1].action_delivery.target_effects[1].entity_name = cluster.name

local shock = table.deepcopy(data.raw.explosion['atomic-nuke-shockwave'])
shock.name = "set-sauce-nuke-shockwave"
shock.animations = nuke_shockwave

local shock_proj = table.deepcopy(data.raw.projectile["atomic-bomb-wave-spawns-nuke-shockwave-explosion"])
shock_proj.name = "set-sauce-nuke-shock-spawn"
shock_proj.action[1].action_delivery.target_effects[1].entity_name = shock.name

local multi = 8
local rocket = table.deepcopy(data.raw.projectile["atomic-rocket"])
local effects = {}
table.insert(effects, table.deepcopy(rocket.action.action_delivery.target_effects[1]))
local aa = table.deepcopy(rocket.action.action_delivery.target_effects[3])
aa.entity_name = explo.name
table.insert(effects, aa)
local a = table.deepcopy(rocket.action.action_delivery.target_effects[4])
a.max_distance = a.max_distance * multi
a.strength = a.strength * multi
a.ease_out_duration = math.min(255, a.ease_out_duration * multi)
table.insert(effects, a)
local b = table.deepcopy(rocket.action.action_delivery.target_effects[5])
b.max_distance = b.max_distance * multi
b.audible_distance_modifier = b.audible_distance_modifier * multi
table.insert(effects, b)

table.insert(effects, { type = "damage", damage = { amount = 40, type = "explosion" }})
table.insert(effects, table.deepcopy(rocket.action.action_delivery.target_effects[8]))

local e = table.deepcopy(rocket.action.action_delivery.target_effects[14])
e.action.repeat_count = e.action.repeat_count * multi * 0.2
e.action.radius = e.action.radius * multi * 0.2
e.action.action_delivery.projectile = cluster_proj.name
table.insert(effects, e)

local c = table.deepcopy(rocket.action.action_delivery.target_effects[15])
c.action.action_delivery.projectile = smoke_proj.name
c.action.radius = c.action.radius * multi
c.action.repeat_count = c.action.repeat_count * multi
table.insert(effects, c)

local d = table.deepcopy(rocket.action.action_delivery.target_effects[16])
d.action.action_delivery.projectile = shock_proj.name
d.action.radius = d.action.radius * multi * 1.2
d.action.repeat_count = d.action.repeat_count * multi * 1.9
table.insert(effects, d)


rocket.name = 'set-sauce'
rocket.action.action_delivery.target_effects = effects
data:extend({explo})
data:extend({cluster})
data:extend({cluster_proj})
data:extend({smoke})
data:extend({smoke_proj})
data:extend({shock})
data:extend({shock_proj})
data:extend({rocket})

if false then
    local ammo = table.deepcopy(data.raw.ammo['atomic-bomb'])
    ammo.name = 'set-sauce-ammo'
    ammo.ammo_type.action.action_delivery.projectile = 'set-sauce'
    data:extend({ammo})
end