# modernEventHandler-lib

This EventHandler simulates modern EventHandlers like those of C#

## Example

```lua
--- Require
---@class ModernEventHandler
local EventHandler = require("EventHandler")

--- Init Event, do not forget that
local testEvent = EventHandler('Test')

--- Add as many callbacks for the Event as required
local callbackID = testEvent:AddCallback(function(parameter)
    print(parameter)
end)

--- Invoke Event
testEvent:invoke('Started Callback with Id: ' .. callbackID)
```

![Executed](Images/Executed.png)
