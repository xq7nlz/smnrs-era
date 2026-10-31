require "lua.client.data.ItemIconData2"

--- @class HeroMaterialEvolveData
HeroMaterialEvolveData = Class(HeroMaterialEvolveData)

--- @return void
--- @param materialId number
--- @param star number
--- @param number number
function HeroMaterialEvolveData:Ctor(materialId, star, number)
    ---@type number
    self.materialId = materialId
    ---@type number
    self.star = star
    ---@type number
    self.number = number
end

function HeroMaterialEvolveData.AddListItemIconData(listBase, listAdd)
    local contain = false
    ---@param item HeroMaterialEvolveData
    for _, item in pairs(listAdd:GetItems()) do
        contain = false
        ---@param v HeroMaterialEvolveData
        for _, v in pairs(listBase:GetItems()) do
            if item.materialId == v.materialId and item.star == v.star then
                v.number = v.number + item.number
                contain = true
                break
            end
        end
        if contain == false then
            listBase:Add(HeroMaterialEvolveData(item.materialId, item.star, item.number))
        end
    end
end

--- @return HeroIconData
--- @param heroResource HeroResource
function HeroMaterialEvolveData:GetHeroIconDataByHeroResource(heroResource)
    local heroId
    local star = self.star
    local faction
    if self.materialId > 10000 then
        heroId = self.materialId
        faction = ClientConfigUtils.GetFactionIdByHeroId(heroId)
    elseif self.materialId > 0 then
        -- sample Faction
        faction = ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId)
        if self.materialId == 2 then
            -- sample Hero
            heroId = heroResource.heroId
        end
    end
    return HeroIconData.CreateInstance(ResourceType.Hero, heroId, star, nil, faction, nil)
end

--- @return HeroIconData
--- @param _heroResource HeroResource
--- @param heroMaterial HeroResource
function HeroMaterialEvolveData:IsMatchHeroResource(_heroResource, heroMaterial)
    local isMatch = false
    ---@type HeroIconData
    local heroIconData = self:GetHeroIconDataByHeroResource(_heroResource)
    if (heroIconData.star == nil or heroIconData.star == heroMaterial.heroStar) then
        if (heroIconData.heroId == nil or heroIconData.heroId == heroMaterial.heroId) then
            local faction = ClientConfigUtils.GetFactionIdByHeroId(heroMaterial.heroId)
            if (heroIconData.faction == nil or heroIconData.faction == faction) then
                isMatch = true
            end
        end
    end
    return isMatch
end

--- @return HeroIconData
--- @param _heroResource HeroResource
--- @param heroMaterial HeroFood
function HeroMaterialEvolveData:IsMatchHeroFood(_heroResource, heroMaterial)
    local isMatch = false
    ---@type HeroIconData
    local heroIconData = self:GetHeroIconDataByHeroResource(_heroResource)
    if (heroIconData.star == nil or heroIconData.star == heroMaterial.star) then
        if heroIconData.heroId == nil then
            if heroIconData.faction == nil
                    or ClientConfigUtils.GetFactionHeroFoodType(heroMaterial.heroFoodType) == heroIconData.faction
                    or ClientConfigUtils.GetFoodMoonSunByFaction(heroIconData.faction) == heroMaterial.heroFoodType then
                isMatch = true
            end
        end
    end
    return isMatch
end

--- @class OrbEvolveData
OrbEvolveData = Class(OrbEvolveData)

--- @return void
--- @param orbId number
--- @param star number
--- @param number number
function OrbEvolveData:Ctor(orbId, number)
    ---@type number
    self.orbId = orbId
    ---@type number
    self.number = number
end

--- @return HeroIconData
--- @param heroResource HeroResource
function OrbEvolveData:GetHeroIconDataByHeroResource(heroResource)
    local heroId = -2
    local faction
    local orbType
    if self.orbId > 0 then
        -- sample Faction
        faction = ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId)
        orbType = ClientConfigUtils.GetOrbByFaction(faction)
        heroId = -1
    end
    if heroId == -2 then
        return HeroIconData.CreateInstance(ResourceType.Hero, heroId, 0, nil, faction, nil)
    else
        return ItemIconData2.CreateInstance(ResourceType.Money, orbType, nil, nil, faction)
    end
end

--- @return HeroIconData
function OrbEvolveData:GetSlotIdSelectByOrbId()
    if self.orbId > 0 then
        return 2
    end
    return 4
end

--- @class HeroEvolvePriceConfig
HeroEvolvePriceConfig = Class(HeroEvolvePriceConfig)

--- @return void
function HeroEvolvePriceConfig:Ctor()
    ---@type number
    self.star = 0
    ---@type number
    self.gold = 0
    ---@type number
    self.magicPotion = 0
    ---@type number
    self.awakenBook = 0
    ---@type List --HeroMaterialEvolveData
    self.heroMaterialEvolveData = List()
    ---@type List --HeroMaterialEvolveData
    self.orbEvolveData = List()
end

--- @return void
function HeroEvolvePriceConfig:GetListResource()
    local list = List()
    if self.gold > 0 then
        list:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GOLD, self.gold))
    end
    if self.magicPotion > 0 then
        list:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.MAGIC_POTION, self.magicPotion))
    end
    if self.awakenBook > 0 then
        list:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.AWAKEN_BOOK, self.awakenBook))
    end
    return list
end

--- @return void
function HeroEvolvePriceConfig:GetListMoney()
    local list = List()
    if self.gold > 0 then
        list:Add(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.GOLD, self.gold))
    end
    if self.magicPotion > 0 then
        list:Add(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.MAGIC_POTION, self.magicPotion))
    end
    if self.awakenBook > 0 then
        list:Add(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.AWAKEN_BOOK, self.awakenBook))
    end
    return list
end

--- @return void
--- @param data string
function HeroEvolvePriceConfig:ParseCsv(data)
    self.star = tonumber(data.star)
    self.gold = tonumber(data.gold)
    self.magicPotion = tonumber(data.magic_potion)
    self.awakenBook = tonumber(data.awaken_book)
    self.heroMaterialEvolveData = List()
    self.orbEvolveData = List()
    if tonumber(data.material_id_1) ~= nil then
        self.heroMaterialEvolveData:Add(HeroMaterialEvolveData(tonumber(data.material_id_1), tonumber(data.material_star_1), tonumber(data.material_number_1)))
    end
    if tonumber(data.material_id_2) ~= nil then
        self.heroMaterialEvolveData:Add(HeroMaterialEvolveData(tonumber(data.material_id_2), tonumber(data.material_star_2), tonumber(data.material_number_2)))
    end
    if tonumber(data.material_id_3) ~= nil then
        self.heroMaterialEvolveData:Add(HeroMaterialEvolveData(tonumber(data.material_id_3), tonumber(data.material_star_3), tonumber(data.material_number_3)))
    end
    if tonumber(data.material_id_4) ~= nil then
        self.heroMaterialEvolveData:Add(HeroMaterialEvolveData(tonumber(data.material_id_4), tonumber(data.material_star_4), tonumber(data.material_number_4)))
    end
    if tonumber(data.orb_type_1) ~= nil then
        self.orbEvolveData:Add(OrbEvolveData(tonumber(data.orb_type_1),tonumber(data.orb_number_1)))
    end
    if tonumber(data.orb_type_2) ~= nil then
        self.orbEvolveData:Add(OrbEvolveData(tonumber(data.orb_type_2),tonumber(data.orb_number_2)))
    end
end

--- @return List --<HeroFood>
function HeroEvolvePriceConfig:GetListFood(heroResource)
    local list = List()
    ---@param heroMaterialEvolveData HeroMaterialEvolveData
    for i, heroMaterialEvolveData in ipairs(self.heroMaterialEvolveData:GetItems()) do
        ---@type HeroIconData
        local heroIconData = heroMaterialEvolveData:GetHeroIconDataByHeroResource(heroResource)
        local add = function(foodType)
            ---@type HeroFood
            local itemIconData = nil
            ---@param item HeroFood
            for i, item in ipairs(list:GetItems()) do
                if item.heroFoodType == foodType and item.star == heroIconData.star then
                    itemIconData = item
                end
            end
            if itemIconData == nil then
                list:Add(HeroFood(foodType, heroIconData.star, 1))
            else
                itemIconData.quantity = itemIconData.quantity + 1
            end
        end
        if heroIconData.faction ~= nil then
            add(ClientConfigUtils.GetFoodFactionByFaction(heroIconData.faction))
        end
        if heroIconData.faction == nil or ClientConfigUtils.GetFoodMoonSunByFaction(heroIconData.faction) == HeroFoodType.MOON then
            add(HeroFoodType.MOON)
        end
        if heroIconData.faction == nil or ClientConfigUtils.GetFoodMoonSunByFaction(heroIconData.faction) == HeroFoodType.SUN then
            add(HeroFoodType.SUN)
        end
    end
    return list
end