---
sidebar_position: 3
---

# Examples

## Usage Example
The installed dependencies could be used in scripts in this format (example):
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

local TableSignal: table = Signal.New("TestSignal")

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