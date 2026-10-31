--[[
NOTE: _method cant access outside file. Dont try to call those method
It will explain how to use Get Add and Sub method

ResourceType Area:
    Hero = 1,
    Money = 2,
    ItemEquip = 3,
    ItemArtifact = 4,
    ItemStone = 5,
    ItemFragment = 6,
    HeroFragment = 7,
    ExpTrain = 8,
Get:
     + Hero :
            self:Get(ResourceType.Hero): HeroList
            self:Get(ResourceType.Hero, heroIndex: number): HeroResource
    + Other :
            self:Get(ResourceType.Money): ClientResourceDict
            self:Get(ResourceType.Money, moneyId): number (quantity coin of MoneyType)
Add:
    + Hero :
            self:Add(ResourceType.Hero, HeroResource): void
    + Other :
            self:Add(ResourceType.Type, resourceId, quantity): void
Sub:
    + Hero :
            self:Sub(ResourceType.Hero, HeroResource): void (remove by RemoveByReference)
            self:Sub(ResourceType.Hero, heroIndex): void (RemoveByIndex)
    + Other :
            self:Sub(ResourceType.Type, resourceId, quantity): void
IsValid:
    + Other :
            self:IsValid(ResourceType.Type, resourceId, quantity): boolean
]]--

require "lua.client.core.inventory.HeroList"
require "lua.client.core.inventory.ClientResourceDict"
require "lua.client.core.inventory.ClientResourceAvatar"
require "lua.client.core.inventory.SkinInventory"
require "lua.client.core.inventory.IdleEffectInventory"

--- @class Inventory
Inventory = Class(Inventory)

--- @return void
function Inventory:Ctor()
    --- @type Dictionary <ResourceType, (HeroList or ItemDict or MoneyDict)>
    self._resourceDict = Dictionary()

    --- @type SkinInventory
    self._skinInventory = SkinInventory()

    --- @type IdleEffectInventory
    self._idleEffectInventory = IdleEffectInventory()
end

------------------------------ GET -----------------------------

--- @return object
--- @param type ResourceType
function Inventory:Get(type, ...)
    if type == nil then
        XDebug.Error("type is nil")
    end
    local resource = self._resourceDict:Get(type)
    if type == ResourceType.Hero then
        if resource == nil then
            resource = HeroList()
            self._resourceDict:Add(type, resource)
        end
        return self:_GetHero(resource, ...)
    elseif type == ResourceType.Avatar then
        if resource == nil then
            resource = ClientResourceAvatar(type)
            self._resourceDict:Add(type, resource)
        end
        return resource
    elseif type == ResourceType.AvatarFrame then
        if resource == nil then
            resource = ClientResourceFrame(type)
            self._resourceDict:Add(type, resource)
        end
        return resource
    else
        if resource == nil then
            resource = ClientResourceDict(type)
            self._resourceDict:Add(type, resource)
        end
        return self:_GetOther(resource, ...)
    end
end

--- @return object
--- @param heroList HeroList <heroId, HeroResource>
function Inventory:_GetHero(heroList, ...)
    local arg = {...}
    if #arg == 0 then
        return heroList
    else
        return heroList:Get(arg[1])  -- get by index
    end
end

--- @return object
--- @param resource Dictionary<moneyId, quantity>
----- @param value object
function Inventory:_GetOther(resource, ...)
    local arg = {...}
    if #arg == 0 then
        return resource
    else
        return resource:Get(arg[1])
    end
end

------------------------------ ADD -----------------------------

--- @return void
--- @param type ResourceType
function Inventory:Add(type, ...)
    if type == nil then
        XDebug.Error("type is nil")
        return
    end
    if type == ResourceType.Skin then
        self._skinInventory.lastTimeRequest = nil
    end

    local resource = self:Get(type)
    if type == ResourceType.Hero then
        self:_AddHero(resource, ...)
    elseif type == ResourceType.EvolveFoodMaterial then
        ---@type PlayerHeroFoodInBound
        local heroFoodInBound = zg.playerData:GetMethod(PlayerDataMethod.HERO_EVOLVE_FOOD)
        if heroFoodInBound ~= nil then
            heroFoodInBound:AddIdAndNumber(...)
        end
    elseif type == ResourceType.Avatar then
        --- @param resource ClientResourceAvatar
        resource:AddByClaim(...)
    elseif type == ResourceType.AvatarFrame then
        --- @param resource ClientResourceFrame
        resource:AddByClaim(...)
    else
        self:_AddToDict(resource, ...)
    end
end

--- @return void
--- @param type ResourceType
function Inventory:AddRegenTime(type, ...)
    if type == nil then
        XDebug.Error("type is nil")
    end
    local resource = self:Get(type)
    if type == ResourceType.Hero then
        XDebug.Error("Not Support")
    elseif type == ResourceType.EvolveFoodMaterial then
        XDebug.Error("Not Support")
    elseif type == ResourceType.Avatar or type == ResourceType.AvatarFrame then
        XDebug.Error("Not Support")
    else
        self:_AddToDictRegenTime(resource, ...)
    end
end

--- @return void
function Inventory:_AddHero(resource, ...)
    local args = {...}
    if #args == 1 then
        resource:Add(args[1])
    else
        XDebug.Error("data is not valid " .. #args)
    end
end

--- @return void
----- @param resource ResourceType
function Inventory:_AddToDict(resource, ...)
    local args = { ...}
    if #args == 2 then
        resource:Add(args[1], args[2])
    else
        XDebug.Error("data is not valid")
    end
end

--- @return void
----- @param resource ResourceType
function Inventory:_AddToDictRegenTime(resource, ...)
    local args = { ...}
    if #args == 2 then
        resource:AddRegenTimeData(args[1], args[2])
    else
        XDebug.Error("data is not valid")
    end
end

--- @return void
----- @param resource ResourceType
function Inventory:_AddToList(resource, ...)
    local args = { ...}
    if #args >= 1 then
        resource:Add(args[1])
    else
        XDebug.Error("data is not valid")
    end
end

------------------------------ SUB -----------------------------

--- @return void
--- @param type ResourceType
function Inventory:Sub(type, ...)
    assert(type)
    local resource = self:Get(type)
    if type == ResourceType.Hero then
        self:_RemoveHero(resource, ...)
    elseif type == ResourceType.EvolveFoodMaterial then
        ---@type PlayerHeroFoodInBound
        local heroFoodInBound = zg.playerData:GetMethod(PlayerDataMethod.HERO_EVOLVE_FOOD)
        if heroFoodInBound ~= nil then
            heroFoodInBound:SubIdAndNumber(...)
        end
    elseif type == ResourceType.Avatar or type == ResourceType.AvatarFrame then
        self:_SubFromList(resource, ...)
    else
        self:_SubFromDict(resource, ...)
    end
end

--- @return void
----- @param resource ResourceType
function Inventory:_RemoveHero(resource, ...)
    assert(resource)
    local arg = {...}
    if #arg == 1  then
        if type(arg[1]) == 'number' then
            resource:RemoveByInventoryId(arg[1])
        else
            resource:RemoveByReference(arg[1])
        end
    else
        assert(false,"data is not valid " .. #arg)
    end
end

--- @return void
----- @param resource ResourceType
function Inventory:_SubFromDict(resource, ...)
    assert(resource)
    local args = { ...}
    if #args == 2 then
        resource:Sub(args[1], args[2])
    else
        XDebug.Log("data is not valid")
    end
end

--- @return void
----- @param resource ResourceType
function Inventory:_SubFromList(resource, ...)
    local args = { ...}
    if #args == 1 then
        resource:Sub(args[1])
    else
        XDebug.Error("data is not valid")
    end
end

------------------------------ IS VALID -----------------------------

--- @return void
--- @param type ResourceType
function Inventory:IsValid(type, ...)
    assert(type)
    local resource = self:Get(type)
    if type == ResourceType.Hero then
        return self:_IsValidHero(resource, ...)
    elseif type == ResourceType.Avatar or type == ResourceType.AvatarFrame then
        return self:_IsValidList(resource, ...)
    else
        return self:_IsValidDict(resource, ...)
    end
    return false
end

--- @return boolean
--- @param resource HeroList
function Inventory:_IsValidHero(resource, ...)
    local arg = {...}
    if #arg == 1  then
        return resource:IsValid(arg[1])
    else
        XDebug.Error("data is not valid " .. LogUtils.ToDetail(#arg))
        return false, 0
    end
end

--- @return void
----- @param resource ClientResourceDict
function Inventory:_IsValidDict(resource, ...)
    local args = { ...}
    if #args == 2 then
        return resource:IsValid(args[1], args[2])
    else
        XDebug.Error("data is not valid")
        return false
    end
end

--- @return void
----- @param resource ClientResourceAvatar
function Inventory:_IsValidList(resource, ...)
    local args = { ...}
    if #args == 1 then
        return resource:IsValid(args[1])
    else
        XDebug.Error("data is not valid")
        return false
    end
end

--- @return void
function Inventory:Clear()
    self._resourceDict:Clear()
    self._skinInventory.listSkin:Clear()
end

function Inventory:ValidateSkinInventory(callback, forceUpdate)
    self._skinInventory:Validate(callback, forceUpdate)
end

function Inventory:ValidateIdleEffectInventory(callback, forceUpdate)
    self._idleEffectInventory:Validate(callback, forceUpdate)
end

return Inventory

