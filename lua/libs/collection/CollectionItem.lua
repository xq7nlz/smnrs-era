require "lua.libs.Class"

--- @class CollectionItem
CollectionItem = Class(CollectionItem)

--- @return void
--- @param data object
function CollectionItem:Ctor(data)
    --- @type object
    self.data = data
end