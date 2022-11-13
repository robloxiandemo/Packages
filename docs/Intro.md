# Getting Started With Roblox Modules!

These Roblox Modules could be acquired using [Wally](https://wally.run/), a package manager designed specifically for Roblox-related project development.

## Wally Configuration
Once Wally has installed, run `wally init` within your project's directory, and then add the various modules that you are looking for (found here as dependencies). For example, the following could be a `wally.toml` file for a project that includes a few of these modules:
```toml
[package]
name = "Your_Name/Your_Project"
version = "0.1.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
Cleanser = "robloxiandemo/cleanser@^0"
ProfileService = "robloxiandemo/profileservice-demo@^0"
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

## Usage Example
The installed dependencies could now be used in scripts (example):
```lua
--// Types
type table = {[any]: any}

--// Reference the folder with Packages:
local Packages: Folder = game:GetService("ReplicatedStorage")["Packages"]

--// Require the modules:
local Cleanser: table = require(Packages["Cleanser"])
local Signal: table = require(Packages["Signal"])

--// Use the modules:
local function NewInstance(): Instance
	local NumberValue: NumberValue = Instance.new("NumberValue")
	NumberValue.Name = "NumberValue"
	NumberValue.Value = 1e+3
	NumberValue.Parent = Packages

	return (NumberValue) :: Instance
end

local function CountTableEntries(Table: table): number
	local Count: number = 0

	for _: number, Value: Object in pairs(Table) do
		Count += 1
	end

	return (Count)
end

local Cleanser: table = Cleanser.New()

--// Cleanser:Add(Task) works as well!
Cleanser:Grant(NewInstance)

--// Cleanser:DelayedDestroy(Time) works as well!
Cleanser:TimedDestroy(2)

print("The cleanser has officially deleted!")

local TableSignal: table = Signal.New()

TableSignal:Connect(function(Data: any?): any?
	local TotalEntries: number = CountTableEntries(Data)

	print(TotalEntries)
end)

TableSignal:Fire({

	"A",
	"B",
	"C"

})
```