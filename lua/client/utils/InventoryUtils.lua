--- @class InventoryUtils
InventoryUtils = Class(InventoryUtils)

--- @return number
--- @param type ResourceType
function InventoryUtils.Get(type, ...)
    --if type == ResourceType.Hero then
    --    XDebug.Log("Get Hero Resource: " .. PlayerData.inventory:Get(type, ...):Count())
    --end
    return zg.playerData:GetInventoryData():Get(type, ...)
end

--- @return RewardInBound
--- @param rewardInBound RewardInBound
function InventoryUtils.GetRewardInBound(rewardInBound)
    local number = zg.playerData:GetInventoryData():Get(rewardInBound.type, rewardInBound.id)
    return RewardInBound.CreateBySingleParam(rewardInBound.type, rewardInBound.id, number, rewardInBound.data)
end

--- @return table
--- @param type ResourceType
function InventoryUtils.AddRegenTimeData(type, ...)
    return zg.playerData:GetInventoryData():AddRegenTime(type, ...)
end

--- @return number
--- @param valueToSet number
function InventoryUtils.SetBattlePassExp(valueToSet)

    local curVal = InventoryUtils.Get(ResourceType.Money, MoneyType.BATTLE_PASS_EXP)
    if (curVal == valueToSet) then
        return
    end
    InventoryUtils.Sub(ResourceType.Money, MoneyType.BATTLE_PASS_EXP, curVal)
    InventoryUtils.Add(ResourceType.Money, MoneyType.BATTLE_PASS_EXP,valueToSet)
end

--- @return table
--- @param type ResourceType
function InventoryUtils.Add(type, ...)
    --if type == ResourceType.Hero then
    --    XDebug.Log("Add Hero Resource: " .. PlayerData.inventory:Get(type, ...):Count())
    --end
    return zg.playerData:GetInventoryData():Add(type, ...)
end

--- @return table
--- @param type ResourceType
function InventoryUtils.Sub(type, ...)
    --if type == ResourceType.Hero then
    --    XDebug.Log("Sub Hero Resource: " .. PlayerData.inventory:Get(type, ...):Count())
    --end
    return zg.playerData:GetInventoryData():Sub(type, ...)
end

--- @param rewardInBound RewardInBound
function InventoryUtils.SubSingleRewardInBound(rewardInBound)
    return zg.playerData:GetInventoryData():Sub(rewardInBound.type, rewardInBound.id, rewardInBound.number, rewardInBound.data)
end

--- @return table
--- @param type ResourceType
function InventoryUtils.IsValid(type, ...)
    return zg.playerData:GetInventoryData():IsValid(type, ...)
end

--- @return boolean
--- @param listRewardInBound List
function InventoryUtils.IsEnoughMultiResourceRequirement(listRewardInBound, isShowPopup)
    if listRewardInBound == nil then
        return false
    end
    if isShowPopup == false then
        for i = 1, listRewardInBound:Count() do
            --- @type RewardInBound
            local rewardInBound = listRewardInBound:Get(i)
            local isValid = InventoryUtils.IsValid(rewardInBound.type, rewardInBound.id, rewardInBound.number)
            if isValid == false then
                return false
            end
        end
        return true
    end
    local resourceNeedList = List()
    for i = 1, listRewardInBound:Count() do
        --- @type RewardInBound
        local rewardInBound = listRewardInBound:Get(i)
        if rewardInBound.type ~= ResourceType.Hero then
            --XDebug.Log(string.format("my reward: %s, need reward: %s", InventoryUtils.Get(rewardInBound.type, rewardInBound.id), rewardInBound.number))
            local value = InventoryUtils.Get(rewardInBound.type, rewardInBound.id) - rewardInBound.number
            if value < 0 then
                local needRewardInBound = RewardInBound.Clone(rewardInBound)
                needRewardInBound.number = -value
                resourceNeedList:Add(needRewardInBound)
            end
        end
    end
    if resourceNeedList:Count() > 0 then
        InventoryUtils.ShowResourceNeedNotification(resourceNeedList)
    end
    return resourceNeedList:Count() == 0
end

--- @return boolean
--- @param  data RewardInBound
function InventoryUtils.IsEnoughSingleResourceRequirement(data, isShowPopup)
    if isShowPopup == false then
        return InventoryUtils.IsValid(data.type, data.id, data.number)
    end
    local resourceNeedList = List()
    if data.type == ResourceType.Hero then
        XDebug.Log("InventoryUtils.IsEnoughResourceRequirement appear ResourceType.Hero")
    end
    local needRewardInBound = RewardInBound.Clone(data)
    local value = InventoryUtils.Get(needRewardInBound.type, needRewardInBound.id) - needRewardInBound.number
    --XDebug.Log(string.format("type: %s, id: %s, real: %s" ,needRewardInBound.type, needRewardInBound.id ,InventoryUtils.Get(needRewardInBound.type, needRewardInBound.id)))
    if value < 0 then
        needRewardInBound.number = -value
        resourceNeedList:Add(needRewardInBound)
    end
    local isValid = value >= 0
    if resourceNeedList:Count() > 0 then
        InventoryUtils.ShowResourceNeedNotification(resourceNeedList)
    end
    return isValid
end

--- @param listResourcesRequire List
function InventoryUtils.ShowResourceNeedNotification(listResourcesRequire)
    zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    local resourceCount = listResourcesRequire:Count()
    if resourceCount > 1 then
        local data = {}
        data.listItem = listResourcesRequire
        PopupMgr.ShowPopup(UIPopupName.UIPopupNotificationResource, data)
    elseif resourceCount == 1 then
        --- @type RewardInBound
        local resourceRequire = listResourcesRequire:Get(1)
        SmartPoolUtils.ShowRewardNotification(resourceRequire)
    end
end

--- @return void
function InventoryUtils.Clear()
    --XDebug.Warning("Clear Inventory")
    zg.playerData:GetInventoryData():Clear()
end

--- @return HeroResource
--- @param inventoryId number
function InventoryUtils.GetHeroResourceByInventoryId(inventoryId, listHeroResource)
    listHeroResource = listHeroResource or InventoryUtils.Get(ResourceType.Hero)
    ---@param heroResource HeroResource
    for index, heroResource in pairs(listHeroResource:GetItems()) do
        if heroResource.inventoryId == inventoryId then
            return heroResource, index
        end
    end
    return nil
end

--- @return List -- id : number
--- @param equipmentType EquipmentType
function InventoryUtils.GetEquipment(equipmentType, sort, rarity)
    ---@type ClientResourceDict
    local itemDic = InventoryUtils.Get(ResourceType.ItemEquip)
    local dic = List()
    for k, v in pairs(itemDic:GetItems()) do
        local typeItem = (math.floor(k / 1000))
        ---@type EquipmentDataEntry
        local equipmentDataConfig = ResourceMgr.GetServiceConfig():GetItems().equipmentDataEntries:Get(k)
        if v > 0 and (equipmentType == nil or typeItem == equipmentType) and (rarity == nil or equipmentDataConfig.rarity == rarity) then
            dic:Add(k)
        end
    end
    if sort == 1 then
        dic:SortWithMethod(SortUtils._EquipmentSortTier)
    elseif sort == -1 then
        dic:SortWithMethod(SortUtils._EquipmentSortTierFlip)
    end
    return dic
end

--- @return List -- id : number
--- @param resourceType ResourceType
function InventoryUtils.GetListResource(resourceType)
    ---@type ClientResourceDict
    local itemDic = InventoryUtils.Get(resourceType)
    local dic = List()
    for k, v in pairs(itemDic:GetItems()) do
        if v > 0 then
            dic:Add(k)
        end
    end
    dic:SortWithMethod(SortUtils.SortMoneyType)
    return dic
end

--- @return List -- id : number
--- @param sort boolean
function InventoryUtils.GetListHeroFragment(sort)
    local dic = InventoryUtils.GetListResource(ResourceType.HeroFragment)
    if sort == 1 then
        dic:SortWithMethod(SortUtils._HeroFragmentSortFactionAndStar)
    elseif sort == -1 then
        dic:SortWithMethod(SortUtils._HeroFragmentSortFactionAndStarFlip)
    end
    return dic
end

--- @return List -- id : number
--- @param sort boolean
function InventoryUtils.GetListArtifactFragment(sort)
    local dic = InventoryUtils.GetListResource(ResourceType.ItemFragment)
    if sort == 1 then
        dic:SortWithMethod(SortUtils._ArtifactFragmentSortRarity)
    elseif sort == -1 then
        dic:SortWithMethod(SortUtils._ArtifactFragmentSortRarityFlip)
    end
    return dic
end

--- @return number
function InventoryUtils.GetArtifactFaction(itemId)
    local type =  ResourceType.ItemArtifact
    local itemData = ResourceMgr.GetServiceConfig():GetItemData(type, itemId)
    ---@param v StatChangerItemOption---
    for _, v in pairs(itemData.optionList:GetItems()) do
        if v.type == ItemOptionType.STAT_CHANGE and v.affectedHeroFaction:Count() > 0 then
            return v.affectedHeroFaction:Get(1)
        end
    end
end
--- @return List -- id : number
function InventoryUtils.GetArtifactByFaction(sort, rarity, faction)
    ---@type ClientResourceDict
    local itemDic = InventoryUtils.Get(ResourceType.ItemArtifact)
    local dic = List()
    for k, v in pairs(itemDic:GetItems()) do
        ---@type ArtifactDataEntry
        local artifactDataEntry = ResourceMgr.GetServiceConfig():GetItems().artifactDataEntries:Get(k)
        local itemID = artifactDataEntry.id
        local _faction = InventoryUtils.GetArtifactFaction(itemID)

        if (v > 0 and (rarity == nil or artifactDataEntry.rarity == rarity)) and (faction == nil or faction == _faction) then
            dic:Add(k)
        end
    end
    if sort ~= nil then
        if sort == 1 then
            dic:SortWithMethod(SortUtils._ArtifactSortRarityAndStar)
        elseif sort == -1 then
            dic:SortWithMethod(SortUtils._ArtifactSortRarityAndStarFlip)
        end
    end
    return dic
end

--- @return List -- id : number
function InventoryUtils.GetArtifact(sort, rarity)
    ---@type ClientResourceDict
    local itemDic = InventoryUtils.Get(ResourceType.ItemArtifact)
    local dic = List()
    for k, v in pairs(itemDic:GetItems()) do
        ---@type ArtifactDataEntry
        local artifactDataConfig = ResourceMgr.GetServiceConfig():GetItems().artifactDataEntries:Get(k)
        if v > 0 and (rarity == nil or artifactDataConfig.rarity == rarity) then
            dic:Add(k)
        end
    end
    if sort ~= nil then
        if sort == 1 then
            dic:SortWithMethod(SortUtils._ArtifactSortRarityAndStar)
        elseif sort == -1 then
            dic:SortWithMethod(SortUtils._ArtifactSortRarityAndStarFlip)
        end
    end
    return dic
end

--- @return List -- id : number
function InventoryUtils.GetSkin(sort, rarity, faction)
    ---@type ClientResourceDict
    local itemDic = InventoryUtils.Get(ResourceType.Skin)
    local dic = List()
    for k, v in pairs(itemDic:GetItems()) do
        ---@type SkinDataEntry
        local skin = ResourceMgr.GetServiceConfig():GetItems().skinDataEntries:Get(k)
        if skin ~= nil then
            if v > 0 and (rarity == nil or skin.rarity == rarity)
                    and (faction == nil
                    or faction == ClientConfigUtils.GetFactionIdByHeroId(ClientConfigUtils.GetHeroIdBySkinId(skin.id))) then
                dic:Add(k)
            end
        else
            XDebug.Error("Nil" .. k)
        end
    end
    if sort ~= nil then
        if sort == 1 then
            dic:SortWithMethod(SortUtils._SkinSortRarity)
        end
    end
    return dic
end

--- @return List -- id : number
function InventoryUtils.GetWeapon()
    return self:GetEquipment(EquipmentType.Weapon)
end

--- @return List -- id : number
function InventoryUtils.GetArmor()
    return self:GetEquipment(EquipmentType.Armor)
end

--- @return List -- id : number
function InventoryUtils.GetRing()
    return self:GetEquipment(EquipmentType.Accessory)
end

--- @return List -- id : number
function InventoryUtils.GetHelm()
    return self:GetEquipment(EquipmentType.Helm)
end

--- @return boolean
function InventoryUtils.CanUseFreeTurnArena()
    return false
    --return InventoryUtils.GetMoney(MoneyType.ARENA_FREE_CHALLENGE_TURN) > 0
end

--- @return number
--- @param moneyType MoneyType
function InventoryUtils.GetMoney(moneyType)
    assert(moneyType)
    return InventoryUtils.Get(ResourceType.Money, moneyType)
end

--- @return boolean
---@param list List
function InventoryUtils.AddListItemIconData(list)
    ---@param v ItemIconData
    for _, v in pairs(list:GetItems()) do
        v:AddToInventory()
    end
end

function InventoryUtils.ValidateSkinInventory(callback, forceUpdate)
    zg.playerData:GetInventoryData():ValidateSkinInventory(callback, forceUpdate)
end

function InventoryUtils.ValidateIdleEffectInventory(callback, forceUpdate)
    zg.playerData:GetInventoryData():ValidateIdleEffectInventory(callback, forceUpdate)
end