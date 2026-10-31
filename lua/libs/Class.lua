--[[

Helper function to implement object oriented class objects. Returns a lua object
that has its __call metatable function set so that it can be used as a function to
create new "instances" of the class type.

Usage:

    SomeClass = Appkit.Class(SomeClass)

    -- An instance is created like so
    local instance = SomeClass(world)

    -- Class types receive an initRate function call
    function SomeClass:Ctor(world)
        -- Perform initialization
        self.world = world
        -- etc
    end

]]--
-- Returns a class object that can be used to instantiate class objects. If
-- super is provided, then the class will copy all pairs (variables and
-- functions) from super.
--- @class Class
function Class(class, super)
    -- For hot swapping if no class exists, one will be created
    -- otherwise the existing class will be updated.
    if class == nil then
        class = {}

        -- object constructor
        local meta = {}
        meta.__call = function(_, ...)
            local object = {}
            setmetatable(object, class)
            if object.Ctor then
                object:Ctor(...)
            end
            return object
        end
        setmetatable(class, meta)
    end

    -- Deep copy the super class functions onto the new class
    -- so that they can be overridden later.
    if super ~= nil then
        for k, v in pairs(super) do
            class[k] = v
        end
    end

    -- Setup prototype behavior so that class functions are called if instance
    -- does not define/override them.
    class.__index = class

    return class
end