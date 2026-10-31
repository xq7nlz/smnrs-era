--- @class SelectionRewardsConfig
SelectionRewardsConfig = Class(SelectionRewardsConfig)

function SelectionRewardsConfig:Ctor()
    --- @type Dictionary
    self.rewardDict = Dictionary()
end

--- @param itemIconData ItemIconData
function SelectionRewardsConfig:AddSelectionReward(selectionId, itemIconData)
    if self.rewardDict:Get(selectionId) == nil then
        local rewardList = List()
        rewardList:Add(itemIconData)
        self.rewardDict:Add(selectionId, rewardList)
    else
        self.rewardDict:Get(selectionId):Add(itemIconData)
    end
    return self.rewardDict
end

--- @return List|ItemIconData
function SelectionRewardsConfig:GetRewardsBySelectionId(selectionId)
    if self.rewardDict:Get(selectionId) ~= nil then
        return self.rewardDict:Get(selectionId)
    end
    return List()
end

--- @return List|ItemIconData
function SelectionRewardsConfig:GetDefaultRewards()
    if self.rewardDict:Get(-1) ~= nil then
        return self.rewardDict:Get(-1)
    end
    return List()
end

function SelectionRewardsConfig:GetAllRewardsBySelectionId(selectionId)
    local rewardList = List()
    for i, itemIconData in ipairs(self:GetRewardsBySelectionId(selectionId):GetItems()) do
        rewardList:Add(itemIconData)
    end
    for i, itemIconData in ipairs(self:GetDefaultRewards():GetItems()) do
        rewardList:Add(itemIconData)
    end
    return rewardList
end

return SelectionRewardsConfig