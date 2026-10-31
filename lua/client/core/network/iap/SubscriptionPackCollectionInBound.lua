--- @class SubscriptionPackCollectionInBound
SubscriptionPackCollectionInBound = Class(SubscriptionPackCollectionInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function SubscriptionPackCollectionInBound:Ctor(buffer)
    if buffer then
        self:ReadBuffer(buffer)
    else
        self.subscriptionDurationDict = Dictionary()
        self.subscriptionTrialDurationDict = Dictionary()
        self.subscriptionTrialAvailabilityDict = Dictionary()
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function SubscriptionPackCollectionInBound:ReadBuffer(buffer)
    --- @param buffer UnifiedNetwork_ByteBuf
    --- @param durationDict Dictionary
    local readDuration = function(buffer, durationDict)
        --- @type number
        local durationSize = buffer:GetShort()
        for _ = 1, durationSize do
            local packId = buffer:GetInt()
            local packDurationInDays = buffer:GetInt()

            durationDict:Add(packId, packDurationInDays)

            if self.allowSkipVideo == false and packDurationInDays > 0 then
                self.allowSkipVideo = ResourceMgr.GetPurchaseConfig():GetCashShop():GetSubscription(packId).allowSkipVideo
            end
        end
    end

    self.subscriptionDurationDict = Dictionary()
    readDuration(buffer, self.subscriptionDurationDict)

    self.subscriptionTrialDurationDict = Dictionary()
    readDuration(buffer, self.subscriptionTrialDurationDict)

    local subscriptionTrialAvailableSize = buffer:GetShort()
    self.subscriptionTrialAvailabilityDict = Dictionary()
    for _ = 1, subscriptionTrialAvailableSize do
        local packId = buffer:GetInt()
        local isAvailableToTrial = buffer:GetBool()
        self.subscriptionTrialAvailabilityDict:Add(packId, isAvailableToTrial)
    end
end
