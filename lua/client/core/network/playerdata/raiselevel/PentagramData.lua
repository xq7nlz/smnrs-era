--- @class PentagramData
PentagramData = Class(PentagramData)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function PentagramData:Ctor(buffer)
    self.lowestLevel = nil
    self.pentaGramHeroList = nil
    self.inventoryIdPentaGramDic = nil
    self.lowestLevelList = nil
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function PentagramData:ReadBuffer(buffer)
    self.pentaGramHeroList = List()
    self.inventoryIdPentaGramDic = Dictionary()
    self.lowestLevelList = List()
    self.lowestLevel = buffer:GetShort()
    local size = buffer:GetByte()
    for i = 1, size do
        local inventoryId = buffer:GetLong()
        self.pentaGramHeroList:Add(inventoryId)
        self.inventoryIdPentaGramDic:Add(inventoryId, i)
        -- XDebug.Log("level: " .. tostring(InventoryUtils.GetHeroResourceByInventoryId(inventoryId).heroLevel))
        self.lowestLevelList:Add(InventoryUtils.GetHeroResourceByInventoryId(inventoryId).heroLevel)
    end
end

function PentagramData:UpdateLowestLevelInUpgradeLevel(heroResource)
    local level = heroResource.heroLevel
    local id = heroResource.inventoryId
    if not self:IsInPentaGram(id) then
        if self.lowestLevelList:Count() >= 5 then
            for i = 1, self.lowestLevelList:Count() do
                ---type number
                local data = self.lowestLevelList:Get(i)
                if data == self.lowestLevel then
                    self.lowestLevelList:RemoveByIndex(i)
                    self.inventoryIdPentaGramDic:RemoveByKey(self.pentaGramHeroList:Get(i))
                    self.pentaGramHeroList:RemoveByIndex(i)
                    break ;
                end
            end
            local min = level
            self.pentaGramHeroList:Add(id)
            self.lowestLevelList:Add(level)
            self.inventoryIdPentaGramDic:Add(id, 1)
            for i = 1, self.lowestLevelList:Count() do
                ---type number
                local data = self.lowestLevelList:Get(i)
                if data < min then
                    min = data
                end
            end
            self.lowestLevel = min
        else
            self.lowestLevel = level
            self.pentaGramHeroList:Add(id)
            self.lowestLevelList:Add(level)
            self.inventoryIdPentaGramDic:Add(id, 1)
        end
    else
        self.lowestLevelList:Clear()
        local min = level
        for i = 1, self.pentaGramHeroList:Count() do
            local inventoryId = self.pentaGramHeroList:Get(i)
            ---@type HeroResource
            local heroResource = InventoryUtils.GetHeroResourceByInventoryId(inventoryId)
            if (heroResource ~= nil) then
                local heroLevel = heroResource.heroLevel
                self.lowestLevelList:Add(heroLevel)
                if heroLevel < min then
                    min = heroLevel
                end
            else
                XDebug.Log("ERROR WARNING HERO RESOURCE NIL HERE")
            end
        end
        self.lowestLevel = min
    end
end

function PentagramData:UpdateLowestLevelInReset(heroResource)
    local level = heroResource.heroLevel
    local id = heroResource.inventoryId
    if self.lowestLevelList:Count() >= 5 then
        if self:IsInPentaGram(id) then
            self.pentaGramHeroList:Clear()
            self.lowestLevelList:Clear()
            self.inventoryIdPentaGramDic:Clear()
            ---@type HeroList
            local listHeroResource = InventoryUtils.Get(ResourceType.Hero)
            --- @type List --<HeroResource>
            local heroSort = List()
            for i = 1, listHeroResource:Count() do
                ---@type HeroResource
                local heroResource = listHeroResource:Get(i)
                heroSort:Add(heroResource)
            end
            heroSort:SortWithMethod(HeroResource.SortLevelStarReverse())
            for i = 1, 5 do
                ---@type HeroResource
                local data = heroSort:Get(i)
                if data.heroLevel > 0 then
                    self.pentaGramHeroList:Add(data.inventoryId)
                    self.lowestLevelList:Add(data.heroLevel)
                    self.inventoryIdPentaGramDic:Add(data.inventoryId, 1)
                end
            end
            local min = 1000
            for i = 1, self.lowestLevelList:Count() do
                ---type number
                local data = self.lowestLevelList:Get(i)
                if data < min then
                    min = data
                end
            end
            self.lowestLevel = min
        end
    else
        self.lowestLevel = level
        self.pentaGramHeroList:Add(id)
        self.lowestLevelList:Add(level)
        self.inventoryIdPentaGramDic:Add(id, 1)
    end
end

function PentagramData:UpdateLowestLevelInEvolve()
    self.pentaGramHeroList:Clear()
    self.lowestLevelList:Clear()
    self.inventoryIdPentaGramDic:Clear()
    ---@type HeroList
    local listHeroResource = InventoryUtils.Get(ResourceType.Hero)
    --- @type List --<HeroResource>
    local heroSort = List()
    for i = 1, listHeroResource:Count() do
        ---@type HeroResource
        local heroResource = listHeroResource:Get(i)
        heroSort:Add(heroResource)
    end
    heroSort:SortWithMethod(HeroResource.SortLevelStarReverse())
    local count = heroSort:Count() >= 5 and 5 or heroSort:Count()
    for i = 1, count do
        ---@type HeroResource
        local data = heroSort:Get(i)
        if data.heroLevel > 0 then
            self.pentaGramHeroList:Add(data.inventoryId)
            self.lowestLevelList:Add(data.heroLevel)
            self.inventoryIdPentaGramDic:Add(data.inventoryId, 1)
        end
    end
    local min = 1000
    for i = 1, self.lowestLevelList:Count() do
        ---type number
        local data = self.lowestLevelList:Get(i)
        if data < min then
            min = data
        end
    end
    self.lowestLevel = min
end

function PentagramData:IsInPentaGram(inventoryId)
    return self.inventoryIdPentaGramDic:IsContainKey(inventoryId)
end

function PentagramData:GetLowestHero()
    return self.lowestLevel
end