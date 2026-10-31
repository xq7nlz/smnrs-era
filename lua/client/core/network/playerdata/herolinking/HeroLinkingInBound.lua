require "lua.client.core.network.playerData.heroLinking.LinkingGroupDataInBound"
require "lua.client.core.network.playerData.heroLinking.LinkingHeroDataInBound"
require "lua.client.core.network.playerData.friend.SupportHeroData"

--- @class HeroLinkingInBound
HeroLinkingInBound = Class(HeroLinkingInBound)

function HeroLinkingInBound:Ctor()
    --- @type Dictionary
    self.linkingGroupDataDict = Dictionary()
    --- @type Dictionary
    self.friendSupportHeroDict = Dictionary()
    --- @type Dictionary
    self.dictFriendSupportHeroDict = Dictionary()
    --- @type boolean
    self.needUpdateLinking = false
    --- @type boolean
    self.needUpdateListSupport = false
end

--- @param buffer UnifiedNetwork_ByteBuf
function HeroLinkingInBound:ReadBuffer(buffer)
    self.linkingGroupDataDict = Dictionary()
    self.friendSupportHeroDict = Dictionary()
    self.dictFriendSupportHeroDict = Dictionary()

    local sizeGroup = buffer:GetByte()
    for i = 1, sizeGroup do
        local groupId = buffer:GetByte()
        local linkingGroupDataInBound = LinkingGroupDataInBound()
        linkingGroupDataInBound:ReadBuffer(buffer)
        self.linkingGroupDataDict:Add(groupId, linkingGroupDataInBound)
    end

    local listFriendSupport = buffer:GetByte()
    for i = 1, listFriendSupport do
        local friendId = buffer:GetLong()
        ---@type List
        local listSupportHeroData = NetworkUtils.GetListDataInBound(buffer, SupportHeroData.CreateByBuffer)
        self.friendSupportHeroDict:Add(friendId, listSupportHeroData)

        local dict = Dictionary()
        ---@param v SupportHeroData
        for i, v in ipairs(listSupportHeroData:GetItems()) do
            dict:Add(v.inventoryId, v)
        end
        self.dictFriendSupportHeroDict:Add(friendId, dict)
    end
    self.needUpdateLinking = false
    self.needUpdateListSupport = false
    self:ValidateDataLinking()
    zg.playerData:SetActiveLinking(self:GetDictionaryActiveLinking())
end

--- @return List
function HeroLinkingInBound:ValidateDataLinking()
    ---@param v LinkingGroupDataInBound
    for group, v in pairs(self.linkingGroupDataDict:GetItems()) do
        ---@param linkingHeroDataInBound LinkingHeroDataInBound
        for slot, linkingHeroDataInBound in pairs(v.linkingHeroDataDict:GetItems()) do
            if linkingHeroDataInBound.isOwnHero == false then
                local heroSupport = self:GetSupportHeroDataByFriendIdAndInventoryId(linkingHeroDataInBound.friendId, linkingHeroDataInBound.inventoryId)
                if heroSupport == nil then
                    v.linkingHeroDataDict:RemoveByKey(slot)
                end
            else
                local heroResource = InventoryUtils.GetHeroResourceByInventoryId(linkingHeroDataInBound.inventoryId)
                if heroResource == nil then
                    v.linkingHeroDataDict:RemoveByKey(slot)
                end
            end
        end
    end
end

--- @return List
function HeroLinkingInBound:GetListHeroFriendSupportByFriendId(friendId)
    return self.friendSupportHeroDict:Get(friendId)
end

---@return SupportHeroData
function HeroLinkingInBound:GetSupportHeroDataByFriendIdAndInventoryId(friendId, inventoryId)
    --- @type SupportHeroData
    local supportHeroData = nil
    --- @type Dictionary
    local dict = self.dictFriendSupportHeroDict:Get(friendId)
    if dict ~= nil then
        supportHeroData = dict:Get(inventoryId)
    end
    return supportHeroData
end

---@return LinkingHeroDataInBound
function HeroLinkingInBound:GetLinkingHeroDataByIdAndSlot(groupId, slot)
    --- @type LinkingHeroDataInBound
    local linkingHeroDataInBound
    ---@type LinkingGroupDataInBound
    local linkingGroupDataInBound = self.linkingGroupDataDict:Get(groupId)
    if linkingGroupDataInBound ~= nil then
        linkingHeroDataInBound = linkingGroupDataInBound.linkingHeroDataDict:Get(slot)
    end
    return linkingHeroDataInBound
end

--- @return LinkingGroupDataInBound
function HeroLinkingInBound:GetLinkingGroupDataInBound(groupId)
    --- @type LinkingGroupDataInBound
    local linkingGroupDataInBound = self.linkingGroupDataDict:Get(groupId)
    if linkingGroupDataInBound == nil then
        linkingGroupDataInBound = LinkingGroupDataInBound()
        linkingGroupDataInBound.groupId = groupId
        self.linkingGroupDataDict:Add(groupId, linkingGroupDataInBound)
    end
    return linkingGroupDataInBound
end

--- @param linkingHeroDataInBound LinkingHeroDataInBound
function HeroLinkingInBound:GetStarByLinkingHeroDataInBound(linkingHeroDataInBound)
    local star = 0
    if linkingHeroDataInBound.isOwnHero == true then
        ---@type HeroResource
        local heroResource = InventoryUtils.GetHeroResourceByInventoryId(linkingHeroDataInBound.inventoryId)
        star = heroResource.heroStar
    else
        ---@type SupportHeroData
        local supportHeroData = self:GetSupportHeroDataByFriendIdAndInventoryId(linkingHeroDataInBound.friendId, linkingHeroDataInBound.inventoryId)
        star = supportHeroData.star
    end
    return star
end

--- @param linkingGroupDataInBound LinkingGroupDataInBound
function HeroLinkingInBound:GetStarByLinkingGroupDataInBound(linkingGroupDataInBound)
    local star = nil
    for i, v in pairs(linkingGroupDataInBound.linkingHeroDataDict:GetItems()) do
        local starSlot = self:GetStarByLinkingHeroDataInBound(v)
        if star == nil or starSlot < star then
            star = starSlot
        end
    end
    return star
end

--- @param linkingGroupDataInBound LinkingGroupDataInBound
function HeroLinkingInBound:GetCountStarByLinkingGroupDataInBoundAndStar(linkingGroupDataInBound, star)
    local count = 0
    for i, v in pairs(linkingGroupDataInBound.linkingHeroDataDict:GetItems()) do
        local starSlot = self:GetStarByLinkingHeroDataInBound(v)
        if starSlot >= star then
            count = count + 1
        end
    end
    return count
end

--- @return BonusLinkingTierConfig
function HeroLinkingInBound:GetActiveLinking(groupId)
    ---@type List
    local listBonus = List()
    ---@type BonusLinkingTierConfig
    local bonusLinkingTierConfig = nil
    ---@type BonusLinkingTierConfig
    local nextBonusLinkingTierConfig = nil
    --- @type LinkingGroupDataInBound
    local linkingGroupDataInBound = self.linkingGroupDataDict:Get(groupId)
    if linkingGroupDataInBound ~= nil then
        local star = nil
        ---@type ItemLinkingTierConfig
        local itemLinkingTierConfig = ResourceMgr.GetHeroLinkingTierConfig().listItemLinking:Get(groupId)
        if itemLinkingTierConfig == nil then
            XDebug.Error("itemLinkingTierConfig nil: " .. groupId)
            return
        end
        if linkingGroupDataInBound.linkingHeroDataDict:Count() == itemLinkingTierConfig.listHero:Count() then
            star = self:GetStarByLinkingGroupDataInBound(linkingGroupDataInBound)
            if star ~= nil and itemLinkingTierConfig.minStar <= star then
                ---@param v BonusLinkingTierConfig
                for i, v in ipairs(itemLinkingTierConfig.listBonus:GetItems()) do
                    if v.star <= star then
                        listBonus:Add(v)
                        if bonusLinkingTierConfig == nil or bonusLinkingTierConfig.star < v.star then
                            bonusLinkingTierConfig = v
                        end
                    elseif nextBonusLinkingTierConfig == nil or nextBonusLinkingTierConfig.star > v.star then
                        nextBonusLinkingTierConfig = v
                    end
                end
            end
        end
    end
    if bonusLinkingTierConfig == nil then
        ---@type ItemLinkingTierConfig
        local itemLinkingTierConfig = ResourceMgr.GetHeroLinkingTierConfig().listItemLinking:Get(groupId)
        nextBonusLinkingTierConfig = itemLinkingTierConfig.listBonus:Get(1)
    end
    return bonusLinkingTierConfig, listBonus, nextBonusLinkingTierConfig
end

function HeroLinkingInBound:RemoveHeroFriendInLinkingByFriendId(friendID)
    ---@param v LinkingGroupDataInBound
    for i, v in pairs(self.linkingGroupDataDict:GetItems()) do
        v:RemoveHeroFriendInLinkingByFriendId(friendID)
    end
    self.friendSupportHeroDict:RemoveByKey(friendID)
    self.dictFriendSupportHeroDict:RemoveByKey(friendID)
end

--- @return boolean
function HeroLinkingInBound:IsAlreadyUseOwnHeroOtherLinking(inventoryId, groupId, slotId)
    --- @param k number
    --- @param v LinkingGroupDataInBound
    for k, v in pairs(self.linkingGroupDataDict:GetItems()) do
        --- @param y LinkingHeroDataInBound
        for x, y in pairs(v.linkingHeroDataDict:GetItems()) do
            if y.isOwnHero == true and y.inventoryId == inventoryId and (x ~= slotId or k ~= groupId) then
                return true
            end
        end
    end
    return false
end

--- @return boolean
function HeroLinkingInBound:IsAlreadyUseFriendHeroOtherLinking(friendId, inventoryId, groupId, slotId)
    --- @param k number
    --- @param v LinkingGroupDataInBound
    for k, v in pairs(self.linkingGroupDataDict:GetItems()) do
        --- @param y LinkingHeroDataInBound
        for x, y in pairs(v.linkingHeroDataDict:GetItems()) do
            if y.isOwnHero == false and y.friendId == friendId and y.inventoryId == inventoryId and (x ~= slotId or k ~= groupId) then
                return true
            end
        end
    end
    return false
end

--- @return List
function HeroLinkingInBound:GetListBonusLinkingByHeroId(heroID)
    local listBonus = List()
    local heroLinkingTierConfig = ResourceMgr.GetHeroLinkingTierConfig()
    ---@param v LinkingGroupDataInBound
    for groupId, v in pairs(self.linkingGroupDataDict:GetItems()) do
        ---@type ItemLinkingTierConfig
        local itemLinkingTierConfig = heroLinkingTierConfig.listItemLinking:Get(groupId)
        if itemLinkingTierConfig == nil then
            XDebug.Error("itemLinkingTierConfig not found: " .. groupId)
        else
            if itemLinkingTierConfig.listHero:IsContainValue(heroID) then
                ---@type List
                local _, list = self:GetActiveLinking(groupId)
                for _, bonusLinkingTierConfig in ipairs(list:GetItems()) do
                    if bonusLinkingTierConfig ~= nil then
                        for _, v in ipairs(bonusLinkingTierConfig.listBonus:GetItems()) do
                            listBonus:Add(v)
                        end
                    end
                end
            end
        end
    end
    return listBonus
end

--- @return boolean
function HeroLinkingInBound:IsContainSelfHeroInLinking(inventoryId)
    --- @param v LinkingGroupDataInBound
    for k, v in pairs(self.linkingGroupDataDict:GetItems()) do
        --- @param y LinkingHeroDataInBound
        for x, y in pairs(v.linkingHeroDataDict:GetItems()) do
            if y.isOwnHero and y.inventoryId == inventoryId then
                return true
            end
        end
    end
    return false
end

--- @return Dictionary
function HeroLinkingInBound:GetDictionaryActiveLinking()
    local dict = Dictionary()
    for groupId, _ in pairs(self.linkingGroupDataDict:GetItems()) do
        ---@type BonusLinkingTierConfig
        local bonusLinkingTierConfig = self:GetActiveLinking(groupId)
        if bonusLinkingTierConfig ~= nil then
            dict:Add(groupId, bonusLinkingTierConfig.level)
        end
    end
    return dict
end

--- @return List -- HeoResource
function HeroLinkingInBound:GetListAvailableSelfHeroAtLinkingSlot(groupId, slotId)
    local listOwnHero = List()
    local linkingConfig = ResourceMgr.GetHeroLinkingTierConfig()
    local requireStar, requireId = linkingConfig:GetStarIdByGroupSlot(groupId, slotId)

    --- @type List
    local listHero = InventoryUtils.Get(ResourceType.Hero)
    for i = 1, listHero:Count() do
        --- @type HeroResource
        local heroResource = listHero:Get(i)
        if heroResource.heroStar >= requireStar and heroResource.heroId == requireId then
            if self:IsAlreadyUseOwnHeroOtherLinking(heroResource.inventoryId, groupId, slotId) == false then
                listOwnHero:Add(heroResource:Clone())
            end
        end
    end
    return listOwnHero
end

--- @return List -- {}
function HeroLinkingInBound:GetListAvailableFriendHeroSupport(groupId, slotId)
    local linkingConfig = ResourceMgr.GetHeroLinkingTierConfig()
    local requireStar, requireId = linkingConfig:GetStarIdByGroupSlot(groupId, slotId)

    local linkingHeroDataInBound = self:GetLinkingHeroDataByIdAndSlot(groupId, slotId)
    local inventoryId
    local friendId
    if linkingHeroDataInBound ~= nil and linkingHeroDataInBound.isOwnHero == false then
        inventoryId = linkingHeroDataInBound.inventoryId
        friendId = linkingHeroDataInBound.friendId
    end

    --- @type PlayerFriendInBound
    local playerFriendInBound = zg.playerData:GetMethod(PlayerDataMethod.FRIEND)

    --- @type List
    local listFriendHeroData = List()

    --- @param k number
    --- @param v List
    for k, v in pairs(self.friendSupportHeroDict:GetItems()) do
        for i = 1, v:Count() do
            --- @type SupportHeroData
            local supportHeroData = v:Get(i)
            if supportHeroData.heroId == requireId and supportHeroData.star >= requireStar then
                --- @type {heroResource : HeroResource, playerName, isOwnHero : boolean, friendId}
                local dataItems = {}
                local friendData = playerFriendInBound:GetFriendDataByFriendId(k)
                if friendData ~= nil then
                    dataItems.playerName = friendData.friendName
                else
                    dataItems.playerName = ""
                end
                dataItems.heroResource = HeroResource.CreateInstance(supportHeroData.inventoryId, supportHeroData.heroId, supportHeroData.star)
                dataItems.isOwnHero = false
                dataItems.friendId = k
                if self:IsAlreadyUseFriendHeroOtherLinking(friendId, inventoryId, groupId, slotId) == false then
                    listFriendHeroData:Add(dataItems)
                end
            end
        end
    end
    return listFriendHeroData
end

function HeroLinkingInBound:GetCountListFriendHeroUseInGroup(groupId)
    --- @type LinkingGroupDataInBound
    local linkingGroupDataInBound = self:GetLinkingGroupDataInBound(groupId)
    local friendHeroUse = 0
    --- @param v LinkingHeroDataInBound
    for k, v in pairs(linkingGroupDataInBound.linkingHeroDataDict:GetItems()) do
        if v.isOwnHero == false then
            friendHeroUse = friendHeroUse + 1
        end
    end
    return friendHeroUse
end

--- @return boolean
function HeroLinkingInBound:IsNotificationLinkingSlot(groupId, slot, _nextBonus)
    local isNoti = false
    ---@type LinkingHeroDataInBound
    local linkingHeroDataInBound = nil
    ---@type BonusLinkingTierConfig
    local nextBonus = _nextBonus
    if nextBonus == nil then
        local _, _, _nextBonus = self:GetActiveLinking(groupId)
        nextBonus = _nextBonus
    end
    if nextBonus ~= nil then
        linkingHeroDataInBound = self:GetLinkingHeroDataByIdAndSlot(groupId, slot)
        local star = nil
        if linkingHeroDataInBound ~= nil then
            if linkingHeroDataInBound.isOwnHero == true then
                ---@type HeroResource
                local heroResource = InventoryUtils.GetHeroResourceByInventoryId(linkingHeroDataInBound.inventoryId)
                star = heroResource.heroStar
            else
                ---@type SupportHeroData
                local supportHeroData = self:GetSupportHeroDataByFriendIdAndInventoryId(linkingHeroDataInBound.friendId, linkingHeroDataInBound.inventoryId)
                star = supportHeroData.star
            end
        end
        if star == nil or star < nextBonus.star then
            ---@type List
            local listOwnHero = self:GetListAvailableSelfHeroAtLinkingSlot(groupId, slot)
            ---@type List
            local listSupportHero = self:GetListAvailableFriendHeroSupport(groupId, slot)
            ---@param v HeroResource
            for _, v in ipairs(listOwnHero:GetItems()) do
                if v.heroStar >= nextBonus.star then
                    isNoti = true
                    break
                end
            end
            if isNoti == false then
                local linkingConfig = ResourceMgr.GetHeroLinkingTierConfig()
                --- @type ItemLinkingTierConfig
                local itemLinkingTierConfig = linkingConfig:GetItemLinkingByGroup(groupId)
                local friendHeroUse = self:GetCountListFriendHeroUseInGroup(groupId)
                if friendHeroUse < itemLinkingTierConfig.listHero:Count() - 1
                        or (linkingHeroDataInBound ~= nil and linkingHeroDataInBound.isOwnHero == false) then
                    ---@param v
                    for _, v in ipairs(listSupportHero:GetItems()) do
                        if v.heroResource.heroStar >= nextBonus.star then
                            isNoti = true
                            break
                        end
                    end
                end
            end
        end
    end
    return isNoti
end

function HeroLinkingInBound:RemoveHeroFromLinking(heroInventoryId)
    --- @param v LinkingGroupDataInBound
    for k, v in pairs(self.linkingGroupDataDict:GetItems()) do
        v:RemoveHeroFromLinking(heroInventoryId)
    end
    self.linkingGroupDataDict:RemoveByKey(heroInventoryId)
end