--- @class SummonResultInBound
SummonResultInBound = Class(SummonResultInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function SummonResultInBound:Ctor(buffer)
    --- @type SummonType
    self.summonType = buffer:GetByte()
    self.isSingleSummon = buffer:GetBool()
    self.isUseGem = buffer:GetBool()
    self.isFreeSummon = buffer:GetBool()
    self.inventoryHeroList = NetworkUtils.GetListDataInBound(buffer, HeroResource.CreateInstanceByBuffer)
    InventoryUtils.Get(ResourceType.Hero):AddAll(self.inventoryHeroList)
end

--- @return List
function SummonResultInBound:GetSum10()
    local dataList = List()
    --- @type HeroResource
    local pickedHero
    local pickedIndex
    --- @param data HeroResource
    for i, data in ipairs(self.inventoryHeroList:GetItems()) do
        local heroResource = self:GetHeroResource(data)
        dataList:Add({ ['index'] = i, ['heroIconData'] = HeroIconData.CreateByHeroResource(heroResource) })

        if pickedHero == nil or pickedHero.heroStar < heroResource.heroStar or
                (pickedHero.heroStar == heroResource.heroStar and ResourceMgr.GetHeroesConfig():GetHeroTier():Compare(pickedHero.heroId, heroResource.heroId) == -1)
        then
            pickedHero = heroResource
            pickedIndex = i
        end
    end
    return dataList, pickedHero, pickedIndex
end

--- @return HeroResource
function SummonResultInBound:GetSum1()
    local heroResource = self.inventoryHeroList:Get(1)
    return self:GetHeroResource(heroResource)
end

--- @param heroResource HeroResource
function SummonResultInBound:GetHeroResource(heroResource)
    return HeroResource.CreateInstance(heroResource.inventoryId, heroResource.heroId, heroResource.heroStar, -1)
end

--- @return void
function SummonResultInBound:ToString()
    return LogUtils.ToDetail(self)
end

--- @return HeroResource
function SummonResultInBound:HasHero5Star()
    --- @param data HeroResource
    for i, data in ipairs(self.inventoryHeroList:GetItems()) do
        if data.heroStar == 5 then
            return true
        end
    end
    return false
end

--
--- @return HeroResource
function SummonResultInBound:HasHero5StarRedBorder()
    --- @param data HeroResource
    for i, data in ipairs(self.inventoryHeroList:GetItems()) do
        if data.heroStar == 5 and data.GetTierMethod(data) >= 6 then
            return true
        end
    end
    return false
end