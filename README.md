# Explosive Trees
A mod for [Factorio](https://factorio.com) which adds explosions to trees as they are harvested / chopped down or damaged.

The mod is supposed to make it difficult / costly to gain wood from trees. Due to the necessity for wood in early
game, an option is provided where Trees won't explode. It is recommended to not too high with it as Trees are intended
to go from somewhat harmless at first, but go up with the research you have.

## Notes
The default settings are intentially chosen to make it challenging / costly to get wood from trees, as well as have a
good chance to wipe out entire forests when harvesting trees.

While none of the far reach mods are listed as incompatible (because really they are not), it is strongly recommended
to not use them in conjunction with this mod, as that will completely eliminate the point of this mod.

## Settings
Explanation for some of the settings

### Disable specific actions
To disable certain actions from happening, lower the Weighted chance option for the respective action to 0 in the
mod settings.
However keep in mind that at least one option must be able to happen, otherwise all options are enabled with their
default settings.

### Altering likelihood of actions
The weighted chance of the different actions can be specified with the "Weighted chance" settings, available for each
action that can happen.
Basically each option has the specified number of tickets in the drawing and then a single ticket is drawn from the
pool. The drawn explosion / action is then triggered. If it cannot be triggered (e.g. because of nuke cooldown), fire
is selected instead.
So nukes by default have 10 tickets, whereas everything else is 20 by default, so nuclear explosions have half the chance
of everything else to be selected.

### Chain reactions
To decrease the chance of forests blowing up reduce the "Damaged Tree explosion chance %" which will determine the chance
for a tree that is damaged (e.g. by grenades, poison clouds or anything really) to cause additional explosions, which
will make other Trees explode, causing a chain reaction. You can use decimal points for this setting as well. Anything
below 5% will usually not cause much of a chain reaction.

### Specifying number of explosions per Tree
You can also specify the number of each explosion that happens at most for each harvested tree, if an explosion is going
to happen based on the chance setting.
So if you have Grenade count set to 5 what will happen is the first grenade will happen, then there is an
"Additional explosion chance" percent chance for a 2nd grenade to happen, then then there is the same chance for a 3rd
to happen and so on, up to the maximum of 5.
