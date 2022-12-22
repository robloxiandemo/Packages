We'd love to have you assist us via contributions to this project!

## Documentation

Our documentation is maintained via [Moonwave](https://eryn.io/moonwave/).

## Coding Style

### Coding Style
Follow Quenty's Roblox coding styling guide found [here](https://gist.github.com/Quenty/2c405855526cdb4c8ec7f2f332e4f7d9), as well as Roblox's general stylying guide found [here](https://roblox.github.io/lua-style-guide/).

### Document Organization Guidelines

Situates your code in the following order:

1. Class / Module Luau Documentation.
2. Services.
3. `require` statement.
4. Module requires, using strings.
5. Constants.
7. Class definition.
8. Return statement.

Sample:
```lua
--[=[
	@class MyClass
]=]

local Signal: { [any]: any } = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages")["Signal"])
```
