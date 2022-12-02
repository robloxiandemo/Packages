---
sidebar_position: 2
---

# Installation

These Roblox Modules could be acquired using [Wally](https://wally.run/), a package manager designed specifically for Roblox-related project development.

## Wally Configuration
Once Wally has installed, run `wally init` within your project's directory, and then add the various modules that you are looking for (found here as dependencies). For example, the following could be a `wally.toml` file for a project that includes a few of these modules:
```toml
[package]
name = "YourName/YourProject"
version = "0.1.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
Cleanser = "robloxiandemo/cleanser@^0"
Debris = "robloxiandemo/debris@^0"
Math = "robloxiandemo/math@^0"
Player = "robloxiandemo/player@^0"
Signal = "robloxiandemo/signal@^0"
String = "robloxiandemo/string@^0"vvv
Table = "robloxiandemo/table@^0"
Tween = "robloxiandemo/tween@^0"
Vector = "robloxiandemo/vector@^0"
```

To install these dependencies, run `wally install` within your project. Wally will then create a `Package` folder in your directory with the installed dependencies.

## Rojo Configuration
The Package folder created by Wally should be synced into Roblox Studio through your Rojo configuration. For example, a Rojo configuration might have the following entry to sync the `Packages` folder into the ReplicatedStorage:

```json
{
	"name": "roblox-modules-example",

	"tree": {
		"$className": "DataModel",

		"ReplicatedStorage": {
			"$className": "ReplicatedStorage",

			"Packages": {
				"$path": "Packages"
			}
		}
	}
}
```