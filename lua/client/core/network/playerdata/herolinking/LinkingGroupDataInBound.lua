--- @class LinkingGroupDataInBound
LinkingGroupDataInBound = Class(LinkingGroupDataInBound)

function LinkingGroupDataInBound:Ctor()
    --- @type Dictionary
    self.linkingHeroDataDict = Dictionary()
end

--- @param buffer UnifiedNetwork_ByteBuf
function LinkingGroupDataInBound:ReadBuffer(buffer)
    self.groupId = buffer:GetByte()

    self.linkingHeroDataDict = Dictionary()
    local size = buffer:GetByte()
    for i = 1, size do
        local slot = buffer:GetByte()
        local linkingHeroDataInBound = LinkingHeroDataInBound()
        linkingHeroDataInBound:ReadBuffer(buffer)
        self.linkingHeroDataDict:Add(slot, linkingHeroDataInBound)
    end
end

--- @param heroLinkingSaveOutBound HeroLinkingSaveOutBound
function LinkingGroupDataInBound:OnSaveSuccess(heroLinkingSaveOutBound)
    self.linkingHeroDataDict = Dictionary()
    --- @param v BindingHeroInBound
    for k, v in pairs(heroLinkingSaveOutBound.slotDict:GetItems()) do
        local linkingHeroDataInBound = LinkingHeroDataInBound()
        linkingHeroDataInBound.slot = k
        linkingHeroDataInBound.inventoryId = v.inventory
        linkingHeroDataInBound.isOwnHero = v.isOwnHero
        linkingHeroDataInBound.friendId = v.friendId
        self.linkingHeroDataDict:Add(k, linkingHeroDataInBound)
    end
end

--- @return BonusLinkingTierConfig
function LinkingGroupDataInBound:RemoveHeroFriendInLinkingByFriendId(friendID)
    ---@param v LinkingHeroDataInBound
    for slot, v in pairs(self.linkingHeroDataDict:GetItems()) do
        if v.friendId == friendID then
            self.linkingHeroDataDict:RemoveByKey(slot)
        end
    end
end

--- @return boolean
function LinkingGroupDataInBound:CheckHeroInventoryInLinking(heroInventoryID)
    ---@param v LinkingHeroDataInBound
    for k, v in pairs(self.linkingHeroDataDict:GetItems()) do
        if v.inventoryId == heroInventoryID and v.isOwnHero == true then
            return true, k
        end
    end
    return false
end

--- @return boolean
function LinkingGroupDataInBound:IsAlreadyUseOwnHeroInLinking(inventoryId)
    --- @param v LinkingHeroDataInBound
    for k, v in pairs(self.linkingHeroDataDict:GetItems()) do

    end
end

--- @return boolean
function LinkingGroupDataInBound:CheckHeroIDInLinking(heroID)
    ---@param v LinkingHeroDataInBound
    for _, v in pairs(self.linkingHeroDataDict:GetItems()) do
        if v.isOwnHero == true then
            ---@type HeroResource
            local heroResource = InventoryUtils.GetHeroResourceByInventoryId(v.inventoryId)
            if heroResource.heroId == heroID then
                return true
            end
        else

        end
    end
    return false
end

function LinkingGroupDataInBound:RemoveHeroFromLinking(heroInventoryId)
    local data, slot = self:CheckHeroInventoryInLinking(heroInventoryId)
    if data then
        self.linkingHeroDataDict:RemoveByKey(slot)
    end
end