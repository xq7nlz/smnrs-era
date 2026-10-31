--- @class SortUtils
SortUtils = Class(SortUtils)

--- @return function
--- @param function
function SortUtils.CreateSortMethod(...)
    local arg = {...}
    local count = #arg
    assert(count > 0, "CreateMultipleSort nil param")
    local sortFunc = {}
    for i = count, 1, -1 do
        local equalSort
        if i < count then
            equalSort = sortFunc[i+1]
        end
        sortFunc[i] = function(item1, item2)
            local v1 = arg[i](item1)
            local v2 = arg[i](item2)
            if v1 > v2 then
                return 1
            elseif v1 < v2 then
                return -1
            elseif equalSort ~= nil then
                return equalSort(item1, item2)
            else
                return -1
            end
        end
    end
    return sortFunc[1]
end

--- @return number
function SortUtils._ArtifactSortRarityAndStar(x, y)
    local item1 = ResourceMgr.GetServiceConfig():GetItems().artifactDataEntries:Get(x)
    local item2 = ResourceMgr.GetServiceConfig():GetItems().artifactDataEntries:Get(y)
    if (item2.rarity > item1.rarity) or (item2.rarity == item1.rarity and item2.star > item1.star) or (item2.rarity == item1.rarity and item2.star == item1.star and y > x) then
        return 1
    else
        return -1
    end
end

--- @return number
function SortUtils._ArtifactSortRarityAndStarFlip(x, y)
    local item1 = ResourceMgr.GetServiceConfig():GetItems().artifactDataEntries:Get(x)
    local item2 = ResourceMgr.GetServiceConfig():GetItems().artifactDataEntries:Get(y)
    if (item2.rarity > item1.rarity) or (item2.rarity == item1.rarity and item2.star > item1.star) or (item2.rarity == item1.rarity and item2.star == item1.star and y > x) then
        return -1
    else
        return 1
    end
end

--- @return number
function SortUtils._SkinSortRarity(x, y)
    ---@type SkinDataEntry
    local item1 = ResourceMgr.GetServiceConfig():GetItems().skinDataEntries:Get(x)
    ---@type SkinDataEntry
    local item2 = ResourceMgr.GetServiceConfig():GetItems().skinDataEntries:Get(y)
    if (item2.rarity > item1.rarity) or (item2.rarity == item1.rarity and y > x) then
        return 1
    else
        return -1
    end
end

--- @return number
function SortUtils._EquipmentSortTier(x, y)
    local tier = ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:Get(x).tier
    local newTier = ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:Get(y).tier
    if (newTier > tier) or (newTier == tier and y > x) then
        return 1
    else
        return -1
    end
end

--- @return number
function SortUtils._EquipmentSortTierFlip(x, y)
    local tier = ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:Get(x).tier
    local newTier = ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:Get(y).tier
    if (newTier > tier) or (newTier == tier and y > x) then
        return -1
    else
        return 1
    end
end


--- @return number
function SortUtils._HeroFragmentSortFactionAndStar(x, y)
    local idHero1 = ClientConfigUtils.GetHeroIdByFragmentHeroId(x)
    local star1 = ClientConfigUtils.GetHeroFragmentStar(x)
    local faction1 = ClientConfigUtils.GetFactionFragmentIdByHeroId(x)
    local isFragmentRed1 = ClientConfigUtils.IsFragmentRedBorder(x)
    local idHero2 = ClientConfigUtils.GetHeroIdByFragmentHeroId(y)
    local star2 = ClientConfigUtils.GetHeroFragmentStar(y)
    local faction2 = ClientConfigUtils.GetFactionFragmentIdByHeroId(y)
    local isFragmentRed2 = ClientConfigUtils.IsFragmentRedBorder(y)
    if isFragmentRed1 == true and isFragmentRed2 == false then
        return -1
    elseif isFragmentRed1 == false and isFragmentRed2 == true then
        return 1
    end

    if idHero1 ~= nil and idHero2 == nil then
        return 1
    elseif idHero1 == nil and idHero2 ~= nil then
        return -1
    end
    if (star2 > star1) or (star1 == star2 and faction2 > faction1) or (star1 == star2 and faction2 == faction1 and isFragmentRed1 == isFragmentRed2 and idHero2 > idHero1) then
        return 1
    else
        return -1
    end
end


--- @return number
function SortUtils._HeroFragmentSortFactionAndStarFlip(x, y)
    local idHero1 = ClientConfigUtils.GetHeroIdByFragmentHeroId(x)
    local star1 = ClientConfigUtils.GetHeroFragmentStar(x)
    local faction1 = ClientConfigUtils.GetFactionFragmentIdByHeroId(x)
    local idHero2 = ClientConfigUtils.GetHeroIdByFragmentHeroId(y)
    local star2 = ClientConfigUtils.GetHeroFragmentStar(y)
    local faction2 = ClientConfigUtils.GetFactionFragmentIdByHeroId(y)
    if idHero1 ~= nil and idHero2 == nil then
        return -1
    elseif idHero1 == nil and idHero2 ~= nil then
        return 1
    end
    if (star2 > star1) or (star1 == star2 and faction2 > faction1) or (star1 == star2 and faction2 == faction1 and idHero2 > idHero1) then
        return -1
    else
        return 1
    end
end

--- @return number
function SortUtils._ArtifactFragmentSortRarity(x, y)
    if y > x then
        return 1
    else
        return -1
    end
end


--- @return number
function SortUtils._ArtifactFragmentSortRarityFlip(x, y)
    if y > x then
        return -1
    else
        return 1
    end
end

--- @return number
---@param x TavernQuestInBound
---@param y TavernQuestInBound
function SortUtils.SortTavernQuest(x, y)
    if y.questState > x.questState then
        return -1
    elseif y.questState < x.questState then
        return 1
    else
        if x.questState == TavernQuestState.WAITING then
            if y.isLock ~= x.isLock then
                if y.isLock == true then
                    return -1
                else
                    return 1
                end
            else
                if y.star > x.star then
                    return 1
                else
                    return -1
                end
            end
        else
            if y.star > x.star then
                return -1
            else
                return 1
            end
        end
    end
end

--- @return number
function SortUtils.SortMoneyType(x, y)
    if y > x then
        return -1
    else
        return 1
    end
end

--- @return number
---@param x HeroCompanionBuffData
---@param y HeroCompanionBuffData
function SortUtils.SortCompanionBuff(x, y)
    if y.id > x.id then
        return 1
    else
        return -1
    end
end

--- @return number
---@param x number
---@param y number
function SortUtils.SortCluster(x, y)
    if (x > y) then
        return -1
    else
        return 1
    end
end