--- @class HeroResource
HeroResource = Class(HeroResource)

--- @return void
function HeroResource:Ctor()
    --- @type number
    self.inventoryId = nil
    --- @type number
    self.heroId = nil
    --- @type number
    self.heroStar = nil
    --- @type number
    self.heroLevel = nil
    --- @type Dictionary table<slot, id> HeroItemSlot , id
    self.heroItem = nil
    --- @type boolean
    self.isBoss = nil
    --- @type boolean
    self.isHideSkin = nil
end

--- @return void
--- @param inventoryId number
--- @param heroId number
--- @param heroStar number
--- @param heroLevel number
--- @param heroItem number[] table<slot, id>
--- @param isLock boolean
--- @param isHideSkin boolean
function HeroResource:SetData(inventoryId, heroId, heroStar, heroLevel, heroItem, isLock, isHideSkin)
    self.inventoryId = inventoryId
    self.heroId = heroId
    self.heroStar = heroStar
    self.heroLevel = heroLevel
    self.heroItem = heroItem or Dictionary()
    self.isLock = isLock or false
    self.isHideSkin = isHideSkin or false
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function HeroResource:SetDataByBuffer(buffer)
    self.inventoryId = buffer:GetLong()
    self.heroId = buffer:GetInt()
    self.heroStar = buffer:GetByte()
    self.heroLevel = buffer:GetShort()
    local sizeItems = buffer:GetByte()
    self.heroItem = Dictionary()
    for i = 1, sizeItems do
        self.heroItem:Add(buffer:GetByte(), buffer:GetInt())
    end
    --- @type boolean
    self.isLock = buffer:GetBool()
    --- @type boolean
    self.isHideSkin = buffer:GetBool()
end

function HeroResource:IsCanEvolveStar()
    ---@type HeroEvolveConfig
    local heroEvolveConfig = ResourceMgr.GetHeroMenuConfig():GetHeroEvolveConfig()
    return self.heroStar < heroEvolveConfig.heroMaxStar
end

function HeroResource:IsCanEvolveLevel()
    return true
    -----@type HeroLevelCapConfig
    --local heroLevelCap =  ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(self.heroStar)
    --return self.heroLevel == heroLevelCap.levelCap
end

function HeroResource:IsUnlockTalent()
    local idTalent = self.heroItem:Get(SlotEquipmentType.Talent)
    --- @type FeatureConfigInBound
    local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
    local talent = featureConfigInBound:GetFeatureConfigInBound(FeatureType.EVOLVE_STAR_13)
    return self.heroStar >= 13 and (not (idTalent ~= nil and idTalent > 0))
            and talent.featureState == FeatureState.UNLOCK
end

function HeroResource:GetIdleEffectEquip()
    if (self.heroItem == nil) then
        return nil
    end
    local _id = self.heroItem:Get(HeroItemSlot.IDLE_EFFECT)
    if (_id ~= nil) then
        local id = tonumber(_id)
        if (id > 0) then
            return id
        else
            print("id hero", self.heroId, "id effect", _id)
            XDebug.Error("ID EFFECT < 0" .. tostring(id))
        end
    else
    end
    return nil
end

---@return List
function HeroResource:GetListItemUnEquip()
    ---@type List
    local listItem = List()
    for k, v in pairs(self.heroItem:GetItems()) do
        if k <= 4 then
            listItem:Add(ItemIconData.CreateInstance(ResourceType.ItemEquip, v, 1))
        elseif k == HeroItemSlot.ARTIFACT then
            listItem:Add(ItemIconData.CreateInstance(ResourceType.ItemArtifact, v, 1))
        elseif k == HeroItemSlot.SKIN then
            listItem:Add(ItemIconData.CreateInstance(ResourceType.Skin, v, 1))
        end
    end
    return listItem
end

---@return List
function HeroResource:GetResourceReset()
    ---@type List
    local resourceList = self:GetListItemUnEquip()
    local gold = 0
    local magicPotion = 0
    local ancientPotion = 0
    local awakenBook = 0
    local dust = 0

    local idIdleEffect = self:GetIdleEffectEquip()
    if (idIdleEffect ~= nil) then
        resourceList:Add(ItemIconData.CreateInstance(ResourceType.IDLE_EFFECT, idIdleEffect, 1))
    end

    if self.heroLevel > 1 then
        for i = 1, self.heroLevel do
            ---@type HeroAltarLevelReward
            local altarLevelReward = ResourceMgr.GetHeroAltarConfig().heroAltarLevelRewardDictionary:Get(i)
            if altarLevelReward == nil then
                break
            end
            ---@type HeroLevelDataConfig
            local heroLevelData = ResourceMgr.GetHeroMenuConfig():GetHeroLevelDataDictionary(i)
            if heroLevelData == nil then
                break
            end
            local goldLevel = MathUtils.Round(altarLevelReward.goldRate * heroLevelData.gold)
            --XDebug.Log(string.format("gold level %s:%s rate%s, value%s, %s", i, goldLevel, altarLevelReward.goldRate, heroLevelData.gold, altarLevelReward.goldRate * heroLevelData.gold))
            gold = gold + goldLevel
            magicPotion = magicPotion + MathUtils.Round(altarLevelReward.magicPotionRate * heroLevelData.magicPotion)
            ancientPotion = ancientPotion + MathUtils.Round(altarLevelReward.ancientPotionRate * heroLevelData.ancientPotion)
            awakenBook = awakenBook + MathUtils.Round(altarLevelReward.awakenBookRate * heroLevelData.awakenBook)
        end
    end
    ---@type HeroAltarStarReward
    local altarStarReward = ResourceMgr.GetHeroAltarConfig().heroAltarStarRewardDictionary:Get(self.heroStar)
    gold = gold + altarStarReward.gold
    --XDebug.Log(string.format("gold star %s:%s", heroResource.heroStar, altarStarReward.gold))
    magicPotion = magicPotion + altarStarReward.magicPotion
    ancientPotion = ancientPotion + altarStarReward.ancientPotion
    awakenBook = awakenBook + altarStarReward.awakenBook
    if self.heroItem:IsContainKey(SlotEquipmentType.Stone) then
        local stoneId = self.heroItem:Get(SlotEquipmentType.Stone)
        ---@type StoneDataConfig
        local stoneDataConfig = ResourceMgr.GetServiceConfig():GetItems().stoneDataEntries:Get(stoneId)
        if stoneDataConfig.group > 0 then
            local goldOfStone = 0
            for i = 1, stoneDataConfig.group do
                ---@type StoneCostConfig
                local stoneCostConfig = ResourceMgr.GetEquipmentConfig().stoneCostDictionary:Get(i)
                goldOfStone = goldOfStone + MathUtils.Round(stoneCostConfig.upgradeGold * stoneCostConfig.disableRate)
                --XDebug.Log(string.format("goldOfStone group %s: %s", i, goldOfStone))
                dust = dust + MathUtils.Round(stoneCostConfig.upgradeDust * stoneCostConfig.disableRate)
            end
            gold = gold + goldOfStone
            dust = dust
        end
    end

    if gold > 0 then
        resourceList:Add(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.GOLD, math.floor(gold)))
    end
    if magicPotion > 0 then
        resourceList:Add(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.MAGIC_POTION, math.floor(magicPotion)))
    end
    if ancientPotion > 0 then
        resourceList:Add(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.ANCIENT_POTION, math.floor(ancientPotion)))
    end
    if dust > 0 then
        resourceList:Add(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.STONE_DUST, math.floor(dust)))
    end
    if awakenBook > 0 then
        resourceList:Add(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.AWAKEN_BOOK, math.floor(awakenBook)))
    end
    return resourceList
end

---@return List
function HeroResource:GetListFood()
    ---@type List
    local resourceList = List()
    ---@type RegressionConfig
    local regressionConfig = ResourceMgr.GetRegressionConfig()
    if self.heroStar > regressionConfig:GetBaseStar() then
        for i = regressionConfig:GetBaseStar() + 1, self.heroStar do
            ---@type RegressionFoodRefund
            local foodRefund = ResourceMgr.GetRegressionConfig():GetDictFoodRefund():Get(i)
            if foodRefund ~= nil then
                HeroMaterialEvolveData.AddListItemIconData(resourceList, foodRefund.listFood)
            end
        end
    end

    return resourceList
end

---@return List
function HeroResource:GetResourceRegression()
    ---@type List
    local resourceList = List()
    ---@type RegressionConfig
    local regressionConfig = ResourceMgr.GetRegressionConfig()
    if self.heroStar > regressionConfig:GetBaseStar() then
        for i = regressionConfig:GetBaseStar() + 1, self.heroStar do
            ---@type HeroEvolvePriceConfig
            local heroEvolvePrice = ResourceMgr.GetHeroMenuConfig():GetHeroEvolvePriceConfig(self.heroId, i)
            ClientConfigUtils.AddListItemIconData(resourceList, heroEvolvePrice:GetListMoney())
        end
    end
    ClientConfigUtils.AddListItemIconData(resourceList, self:GetResourceReset())
    return resourceList
end

---@return List
function HeroResource:GetResourceAltar()
    ---@type List
    local resourceList = self:GetResourceReset()
    ---@type HeroAltarStarReward
    local altarStarReward = ResourceMgr.GetHeroAltarConfig().heroAltarStarRewardDictionary:Get(self.heroStar)
    if altarStarReward.heroShard > 0 then
        resourceList:Add(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.HERO_SHARD, math.floor(altarStarReward.heroShard)))
    end
    return resourceList
end

function HeroResource:IsCanConvert()
    return self.heroStar <= 5 and self.heroStar >= 4
end

function HeroResource:IsConverting()
    ---@type ProphetTreeInBound
    local prophetTreeInBound = zg.playerData:GetMethod(PlayerDataMethod.PROPHET_TREE)
    return prophetTreeInBound.isConverting and prophetTreeInBound.heroInventoryId == self.inventoryId
end

--- @return HeroResource
--- @param data HeroResource
function HeroResource.Clone(data)
    local itemDict = Dictionary()
    if data.heroItem then
        for i, v in pairs(data.heroItem:GetItems()) do
            itemDict:Add(i, v)
        end
    end
    return HeroResource.CreateInstance(data.inventoryId, data.heroId, data.heroStar, data.heroLevel, itemDict, data.isLock, data.isHideSkin)
end

--- @return HeroResource
--- @param inventoryId number
--- @param heroId number
--- @param heroStar number
--- @param heroLevel number
--- @param heroItem number[] table<slot, id>
function HeroResource.CreateInstance(inventoryId, heroId, heroStar, heroLevel, heroItem, isLock, isHideSkin)
    local inst = HeroResource()
    inst:SetData(inventoryId, heroId, heroStar, heroLevel, heroItem, isLock, isHideSkin)
    return inst
end

--- @return HeroResource
--- @param buffer UnifiedNetwork_ByteBuf
function HeroResource.CreateInstanceByBuffer(buffer)
    local inst = HeroResource()
    inst:SetDataByBuffer(buffer)
    return inst
end

--- @return HeroResource
--- @param json UnifiedNetwork_ByteBuf
function HeroResource.CreateInstanceByJson(json)
    assert(json)
    local inventoryId = json['0']
    local heroId = json['1']
    local heroStar = json['2']
    local heroLevel = json['3']
    local heroItem = Dictionary()
    for slot, itemId in pairs(json['4']) do
        heroItem:Add(tonumber(slot), itemId)
    end
    local isLock = json['5']
    local isHideSkin = json['6']
    return HeroResource.CreateInstance(inventoryId, heroId, heroStar, heroLevel, heroItem, isLock, isHideSkin)
end

--- @return HeroResource
--- @param heroBattleInfo
function HeroResource.CreateInstanceByHeroBattleInfo(heroBattleInfo)
    return HeroResource.CreateInstance(nil, heroBattleInfo.heroId, heroBattleInfo.star, heroBattleInfo.level)
end

--- @return number
---@param heroResource HeroResource
function HeroResource.GetStarMethod(heroResource)
    return heroResource.heroStar
end

--- @return number
---@param heroResource HeroResource
function HeroResource.GetStarMethodReverse(heroResource)
    return -heroResource.heroStar
end

--- @return number
---@param heroResource HeroResource
function HeroResource.GetTierMethod(heroResource)
    return ResourceMgr.GetHeroesConfig():GetHeroTier():GetHeroTier(heroResource.heroId)
end

--- @return number
---@param heroResource HeroResource
function HeroResource.GetTierMethodReverse(heroResource)
    return -ResourceMgr.GetHeroesConfig():GetHeroTier():GetHeroTier(heroResource.heroId)
end

--- @return number
---@param heroResource HeroResource
function HeroResource.GetLevelMethod(heroResource)
    return heroResource.heroLevel
end

--- @return number
---@param heroResource HeroResource
function HeroResource.GetLevelMethodReverse(heroResource)
    return -heroResource.heroLevel
end

--- @return number
---@param heroResource HeroResource
function HeroResource.GetFactionMethod(heroResource)
    --XDebug.Log("FACTION IS " .. ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId))
    return ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId)
end

--- @return number
---@param heroResource HeroResource
function HeroResource.GetIdMethod(heroResource)
    return heroResource.heroId
end

--- @return number
---@param heroResource HeroResource
function HeroResource.GetInventoryIdMethod(heroResource)
    return heroResource.inventoryId
end

--- @return function
function HeroResource.SortStar()
    if HeroResource.sortStar == nil then
        HeroResource.sortStar = SortUtils.CreateSortMethod(HeroResource.GetStarMethod)
    end
    return HeroResource.sortStar
end

--- @return function
function HeroResource.SortStarLevel()
    if HeroResource.sortStarLevel == nil then
        HeroResource.sortStarLevel = SortUtils.CreateSortMethod(HeroResource.GetStarMethod, HeroResource.GetLevelMethod,
                HeroResource.GetTierMethod, HeroResource.GetFactionMethod, HeroResource.GetIdMethod, HeroResource.GetInventoryIdMethod)
    end
    return HeroResource.sortStarLevel
end

--- @return function
function HeroResource.SortStarLevelReverse()
    if HeroResource.sortStarLevelReverse == nil then
        HeroResource.sortStarLevelReverse = SortUtils.CreateSortMethod(HeroResource.GetStarMethodReverse, HeroResource.GetLevelMethodReverse,
                HeroResource.GetTierMethodReverse, HeroResource.GetFactionMethod, HeroResource.GetIdMethod, HeroResource.GetInventoryIdMethod)
    end
    return HeroResource.sortStarLevelReverse
end

--- @return function
function HeroResource.SortTierStarLevelReverse()
    if HeroResource.sortStarLevelReverse == nil then
        HeroResource.sortStarLevelReverse = SortUtils.CreateSortMethod(HeroResource.GetTierMethodReverse, HeroResource.GetStarMethodReverse, HeroResource.GetLevelMethodReverse,
                HeroResource.GetFactionMethod, HeroResource.GetIdMethod, HeroResource.GetInventoryIdMethod)
    end
    return HeroResource.sortStarLevelReverse
end

--- @return function
function HeroResource.SortLevelStar()
    if HeroResource.sortLevelStar == nil then
        HeroResource.sortLevelStar = SortUtils.CreateSortMethod(HeroResource.GetLevelMethod, HeroResource.GetStarMethod,
                HeroResource.GetTierMethod, HeroResource.GetFactionMethod, HeroResource.GetIdMethod, HeroResource.GetInventoryIdMethod)
    end
    return HeroResource.sortLevelStar
end

--- @return function
function HeroResource.SortLevelStarReverse()
    if HeroResource.sortLevelStarReverse == nil then
        HeroResource.sortLevelStarReverse = SortUtils.CreateSortMethod(HeroResource.GetLevelMethodReverse, HeroResource.GetStarMethodReverse,
                HeroResource.GetTierMethodReverse, HeroResource.GetFactionMethod, HeroResource.GetIdMethod, HeroResource.GetInventoryIdMethod)
    end
    return HeroResource.sortLevelStarReverse
end

function HeroResource:OnSuccessResetHero()
    self.heroLevel = 1
    --- @param k HeroItemSlot
    for k, v in pairs(self.heroItem:GetItems()) do
        if k < HeroItemSlot.TALENT_1 then
            self.heroItem:RemoveByKey(k)
        end
    end
end

return HeroResource