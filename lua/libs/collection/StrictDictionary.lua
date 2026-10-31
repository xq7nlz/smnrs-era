require "lua.libs.Class"
require "lua.libs.collection.Dictionary"

--- @class StrictDictionary
StrictDictionary = Class(StrictDictionary, Dictionary)

---------------------------------------- Getters ----------------------------------------

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param key object
--- @param value object
function StrictDictionary:Add(key, value)
    Dictionary.Add(self, key, value)
end