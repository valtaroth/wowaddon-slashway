# SlashWay

The game supports native waypoints but most online resources only provide waypoint commands for the most popular navigation addons like TomTom. This addon adds a command using the same format but creates a simple waypoint using the game's native built-in system.

# Usage

```
/way x y [description]
```

or

```
/way #mapid x y [description]
```

or

```
/way here x y [description]
```

Enter a valid `/way` command using the common TomTom-style format in chat to create a native waypoint at the specified location.

For example, the command `/way #630 56.6 66.6 Calamir` will create a waypoint at the world boss Calamir in Azsuna as reported on Wowhead.

Since the description isn't actually used in the waypoint it is optional. The main reason it is supported is to allow copying these common commands from online resources without needing to make any adjustments.

`#mapid` may be replaced with `here` to have the command automatically use the player's current zone for cases where you only get coordinates without the map id. You can also simply omit the map name.

# Known limitations

* Since the game offers no native way of translating a map or zone name to its id, commands like `/way Azsuna 56.6 66.6 Calamir` are currently not supported.

# Changelog

## v0.1.3

* Bumped supported version to 12.1.5
* Reworked command logic to better support common command formats found on Wowhead (i.e. allow omission of map name and allow commas instead of periods)

## v0.1.2

* Bumped supported version to 12.0.1

## v0.1.1

* Fixed installation archive
* Added special `here` support for map id

## v0.1.0

* Initial release
