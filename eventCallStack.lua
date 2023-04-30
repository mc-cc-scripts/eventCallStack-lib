-- Requires
local scm = require("./scm")
local class = scm:load('ccClass')

-- Definitions
---@class CallbackObjects
---@field callback function
---@field context any
---@field callbackID number

---@class EventCallStack
---@field name string
---@field callbackObjects CallbackObjects
---@field globalCallbackID number

-- Local Functions
local function checktypePositive(checkBoolean, errorText)
    if checkBoolean then error(errorText) end
end
local function checktypeNegative(checkBoolean, errorText)
    if not checkBoolean then error(errorText) end
end


-- Main
---@class EventCallStack
local EventCallStack = class(function(eventInstance, name)
    eventInstance.name = name
    eventInstance.callbackObjects = {}
    eventInstance.globalCallbackID = 1
end)


--- Adds Callback to the Call-Queue
---@param callback function
---@param context any | nil the context that will be provided when calling the Callback Functions (first Parameter)
---@return CallbackObjects
function EventCallStack:AddCallback(callback, context)
    ---@class CallbackObjects
    local callbackObj = { ["callback"] = callback, ["context"] = context, ["callbackID"] = self.globalCallbackID }
    checktypePositive(self == nil, 'self reference for the EventCallStack not provided on Invoke event')
    checktypeNegative(type(callback) == "function", "the Callback is not a Function on Event: " .. self.name)
    if type(callback) == "function" then
        self.globalCallbackID = self.globalCallbackID + 1
        table.insert(self.callbackObjects, callbackObj)
    end
    return callbackObj
end

---comment
---@param callbackObject CallbackObjects
---@return boolean success
function EventCallStack:RemoveCallback(callbackObject)
    checktypePositive(self == nil, 'self reference for the EventCallStack not provided on Invoke event')
    checktypeNegative(type(callbackObject) == "table" or type(callbackObject) == "number",
        "could not use type " .. type(callbackObject) .. " to delete any Callbacks")
    if type(callbackObject) == "table" then
        checktypeNegative(type(callbackObject.callbackID) == "number",
            "Could not find callbackID to delete Callback")
    end
    local callbackID = callbackObject.callbackID or callbackObject
    for i, callback in ipairs(self.callbackObjects) do
        if callback.callbackID == callbackID then
            table.remove(self.callbackObjects, i)
            return true
        end
    end
    return false
end

--- Calls all Functions within the Call-Que
---@param ... any any number of parameters for the function
function EventCallStack:invoke(...)
    checktypePositive(self == nil, 'self reference for the EventCallStack not provided on Invoke event')
    for _, callbackObject in pairs(self.callbackObjects) do
        if callbackObject.context then
            callbackObject.callback(callbackObject.context, ...)
        else
            callbackObject.callback(...)
        end
    end
end

return EventCallStack
