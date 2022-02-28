-- Copyright 2022 Sil3ntStorm https://github.com/Sil3ntStorm
--
-- Licensed under MS-RL, see https://opensource.org/licenses/MS-RL

data:extend({
    {
        name = 'set-tree-explosion-chance-harvest',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 40,
        minimum_value = 0,
        maximum_value = 100,
        order = 'a'
    },
    {
        name = 'set-tree-explosion-chance-damage',
        type = 'int-setting',
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
        name = 'set-nuke-delay',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 200,
        minimum_value = 100,
        maximum_value = 800,
        order = 'd'
    },
    {
        name = 'set-poison-delay',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 120,
        minimum_value = 50,
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
        name = 'set-require-research',
        type = 'bool-setting',
        setting_type = 'runtime-global',
        default_value = true,
        order = '9'
    },
    {
        name = 'set-peaceful-ticks',
        type = 'int-setting',
        setting_type = 'runtime-global',
        default_value = 7200,
        minimum_value = 0,
        maximum_value = 18000,
        order = 'f'
    }
})
