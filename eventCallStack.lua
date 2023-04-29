-- Requires
local scm = require("./scm")
local class = scm:load('ccClass')
local function checktypePositive(checkBoolean, errorText)
    if checkBoolean then error(errorText) end
end
local function checktypeNegative(checkBoolean, errorText)
    if not checkBoolean then error(errorText) end
end

---@class EventCallStack
local EventCallStack

EventCallStack = class(function(eventInstance, name, callbacks)
    eventInstance.name = name
    eventInstance.callbacks = {}
    eventInstance.eventFilter = {}
    if (callbacks ~= nil) then
        for i, callback in ipairs(callbacks) do
            eventInstance.callbacks[tonumber(i)] = callback
        end
    end
    eventInstance.callbackID = #eventInstance.callbacks
end)

function EventCallStack:AddCallback(callback)
    if type(callback) == "function" then
        self.callbackID = self.callbackID + 1
        table.insert(self.callbacks, callback)
    end
    return self.callbackID
end

function EventCallStack:invoke(...)
    checktypePositive(self == nil, 'self reference not provided on Invoke event of ' .. self.name)
    for _, func in ipairs(self.callbacks) do
        func(...)
    end
end

return EventCallStack
