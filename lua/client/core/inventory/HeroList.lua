require "lua.client.core.inventory.HeroResource"

--- @class HeroList
HeroList = Class(HeroList)

--- @return void
function HeroList:Ctor()
    --- @type List
    self._heroList = List()
end

--- @return void
--- @param jsonHeroDatabase table
function HeroList:InitDatabase(jsonHeroDatabase)
    if jsonHeroDatabase ~= nil then
        self._heroList:Clear()
        for key, hero in ipairs(jsonHeroDatabase) do
            self._heroList:Add(HeroResource.CreateInstanceByJson(hero))
        end
        self:SortHeroDataBase()
    else
        assert(false, "db is nil")
    end
end

--- @return HeroResource List
function HeroList:GetItems()
    return self._heroList:GetItems()
end

--- @return HeroResource
--- @param index number
function HeroList:Get(index)
    if index > self._heroList:Count() then
        assert(false, "out of range: " .. index .. " " .. self._heroList:Count())
    end
    return self._heroList:Get(index)
end

--- @return number
function HeroList:Count()
    return self._heroList:Count()
end

--- @return void
--- @param heroResource HeroResource
function HeroList:Add(heroResource)
    assert(heroResource)
    local count = self._heroList:Count()
    if count == 0 or self:SortHeroMethod(heroResource, self._heroList:Get(count)) > 0 then
        self._heroList:Add(heroResource)
    else
        local minIndex = 1
        local maxIndex = self._heroList:Count()
        local index = 1
        while maxIndex - minIndex > 1 do
            index = math.floor((minIndex + maxIndex)/2)
            if self:SortHeroMethod(heroResource, self._heroList:Get(index)) < 0 then
                maxIndex = index
            else
                minIndex = index
            end
        end
        if minIndex == 1 and self:SortHeroMethod(heroResource, self._heroList:Get(minIndex)) < 0 then
            maxIndex = minIndex
        end
        self._heroList:Insert(heroResource, maxIndex)
    end
end

--- @return void
--- @param heroList List
function HeroList:AddAll(heroList)
    assert(heroList)
    --self._heroList:AddAll(heroList)
    --self:SortHeroDataBase()

    ---@param hero HeroResource
    for _, hero in pairs(heroList:GetItems()) do
        self:Add(hero)
    end
end

--- @return void
--- @param heroResource HeroResource
function HeroList:RemoveByReference(heroResource)
    self._heroList:RemoveByReference(heroResource)
end

--- @return void
--- @param inventoryId number
function HeroList:RemoveByInventoryId(inventoryId)
    ---@param heroResource HeroResource
    for _, heroResource in pairs(self._heroList:GetItems()) do
        if heroResource.inventoryId == inventoryId then
            self._heroList:RemoveByReference(heroResource)
            break
        end
    end
end

--- @return boolean
--- @param quantity number
function HeroList:IsValid(quantity)
    local result = quantity + self._heroList:Count() <= ClientConfigUtils.MAX_HERO
    return result, result and quantity or ClientConfigUtils.MAX_HERO - self._heroList:Count()
end

--- @return void
function HeroList:SortHeroDataBase()
    self._heroList:Sort(self, self.SortHeroMethod)
end

--- @return number
--- @param x HeroResource
--- @param y HeroResource
function HeroList:SortHeroMethod(x, y)
    if x.heroStar > y.heroStar then
        return -1
    elseif x.heroStar < y.heroStar then
        return 1
    else
        if x.heroLevel > y.heroLevel then
            return -1
        elseif x.heroLevel < y.heroLevel then
            return 1
        else
            local faction1 = ClientConfigUtils.GetFactionIdByHeroId(x.heroId)
            local faction2 = ClientConfigUtils.GetFactionIdByHeroId(y.heroId)
            if faction1 < faction2 then
                return -1
            elseif faction1 > faction2 then
                return 1
            else
                if x.heroId < y.heroId then
                    return -1
                elseif x.heroId > y.heroId then
                    return 1
                else
                    if x.inventoryId < y.inventoryId then
                        return -1
                    else
                        return 1
                    end
                end
            end
        end
    end
end

