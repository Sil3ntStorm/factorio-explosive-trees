-- Copyright 2022 Sil3ntStorm https://github.com/Sil3ntStorm
--
-- Licensed under MS-RL, see https://opensource.org/licenses/MS-RL

data:extend({
    {
        name = 'set-tree-explosion-chance-harvest',
        type = 'double-setting',
        setting_type = 'runtime-global',
        default_value = 40,
        minimum_value = 0,
        maximum_value = 100,
        order = 'a'
    },
    {
        name = 'set-tree-explosion-chance-damage',
        type = 'double-setting',
        setting_type = 'runtime-global',
        default_value = 10,
        minimum_value = 0,
        maximum_value = 50,
        order = 'b'
    },
    {
        name = 'set-extra-explosions-chance',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 60,
        minimum_value = 10,
        maximum_value = 100,
        order = 'c'
    },
    {
        name = 'set-nuke-delays',
        type = 'double-setting',
        setting_type = 'runtime-global',
        default_value = 3.33,
        minimum_value = 1,
        maximum_value = 600,
        order = 'd'
    },
    {
        name = 'set-poison-delays',
        type = 'double-setting',
        setting_type = 'runtime-global',
        default_value = 2,
        minimum_value = 0,
        maximum_value = 600,
        order = 'e'
    },
    {
        name = 'set-enable-nuke',
        type = 'bool-setting',
        setting_type = 'runtime-global',
        default_value = true,
        order = 'ca'
    },
    {
        name = 'set-enable-fire-trigger',
        type = 'bool-setting',
        setting_type = 'runtime-global',
        default_value = false,
        order = 'caa'
    },
    {
        name = 'set-require-research',
        type = 'bool-setting',
        setting_type = 'runtime-global',
        default_value = true,
        order = '9'
    },
    {
        name = 'set-peaceful-minutes',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 10,
        minimum_value = 0,
        maximum_value = 240,
        order = 'c9'
    },
    {
        name = 'set-weight-fire',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 20,
        minimum_value = 0,
        maximum_value = 100,
        order = 'gaa'
    },
    {
        name = 'set-count-fire',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 15,
        minimum_value = 1,
        maximum_value = 50,
        order = 'gba'
    },
    {
        name = 'set-weight-grenade',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 20,
        minimum_value = 0,
        maximum_value = 100,
        order = 'gab'
    },
    {
        name = 'set-count-grenade',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 5,
        minimum_value = 1,
        maximum_value = 50,
        order = 'gbb'
    },
    {
        name = 'set-weight-cluster',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 20,
        minimum_value = 0,
        maximum_value = 100,
        order = 'gac'
    },
    {
        name = 'set-count-cluster',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 2,
        minimum_value = 1,
        maximum_value = 50,
        order = 'gbc'
    },
    {
        name = 'set-weight-rocket',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 20,
        minimum_value = 0,
        maximum_value = 100,
        order = 'gad'
    },
    {
        name = 'set-count-rocket',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 3,
        minimum_value = 1,
        maximum_value = 50,
        order = 'gbd'
    },
    {
        name = 'set-weight-arty',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 20,
        minimum_value = 0,
        maximum_value = 100,
        order = 'gae'
    },
    {
        name = 'set-count-arty',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 3,
        minimum_value = 1,
        maximum_value = 50,
        order = 'gbe'
    },
    {
        name = 'set-weight-poison',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 20,
        minimum_value = 0,
        maximum_value = 100,
        order = 'gaf'
    },
    {
        name = 'set-count-poison',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 1,
        minimum_value = 1,
        maximum_value = 50,
        order = 'gbf'
    },
    {
        name = 'set-weight-destroyer',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 20,
        minimum_value = 0,
        maximum_value = 100,
        order = 'gag'
    },
    {
        name = 'set-count-destroyer',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 1,
        minimum_value = 1,
        maximum_value = 50,
        order = 'gbg'
    },
    {
        name = 'set-weight-slowdown',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 20,
        minimum_value = 0,
        maximum_value = 100,
        order = 'gai'
    },
    {
        name = 'set-count-slowdown',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 3,
        minimum_value = 1,
        maximum_value = 50,
        order = 'gbi'
    },
    {
        name = 'set-weight-distractor',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 20,
        minimum_value = 0,
        maximum_value = 100,
        order = 'gaj'
    },
    {
        name = 'set-count-distractor',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 1,
        minimum_value = 1,
        maximum_value = 50,
        order = 'gbj'
    },
    {
        name = 'set-weight-nuke',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 10,
        minimum_value = 0,
        maximum_value = 100,
        order = 'gah'
    },
    {
        name = 'set-count-nuke',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 1,
        minimum_value = 1,
        maximum_value = 50,
        order = 'gbh'
    },
    {
        name = 'set-rock-explosion-chance-harvest',
        type = 'double-setting',
        setting_type = 'runtime-global',
        default_value = 40,
        minimum_value = 0,
        maximum_value = 100,
        order = 'bg'
    },
    {
        name = 'set-rock-explosion-chance-damage',
        type = 'double-setting',
        setting_type = 'runtime-global',
        default_value = 10,
        minimum_value = 0,
        maximum_value = 50,
        order = 'bh'
    },
    {
        name = 'set-vehicle-explosion-chance-damage',
        type = 'double-setting',
        setting_type = 'runtime-global',
        default_value = 10,
        minimum_value = 0,
        maximum_value = 50,
        order = 'bi'
    },
    {
        name = 'set-cbot-explosion-chance-damage',
        type = 'double-setting',
        setting_type = 'runtime-global',
        default_value = 10,
        minimum_value = 0,
        maximum_value = 50,
        order = 'bk'
    },
    {
        name = 'set-lbot-explosion-chance-damage',
        type = 'double-setting',
        setting_type = 'runtime-global',
        default_value = 10,
        minimum_value = 0,
        maximum_value = 50,
        order = 'bl'
    }
})
