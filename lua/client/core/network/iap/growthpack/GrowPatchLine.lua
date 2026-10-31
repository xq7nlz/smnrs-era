--- @class GrowPatchLine
GrowPatchLine = Class(GrowPatchLine)

function GrowPatchLine:Ctor()
    self.basicMileStoneDict = Dictionary()
    self.premiumMileStoneDict = Dictionary()
end

--- @param buffer UnifiedNetwork_ByteBuf
function GrowPatchLine:ReadBuffer(buffer)
    local numberBasic = buffer:GetShort()
    for i = 1, numberBasic do
        self.basicMileStoneDict:Add(buffer:GetInt(), buffer:GetInt())
    end
    local numberPremium = buffer:GetShort()
    for i = 1, numberPremium do
        self.premiumMileStoneDict:Add(buffer:GetInt(), buffer:GetInt())
    end
end

--- @param isBasic boolean
--- @param number number
function GrowPatchLine:OnSuccessClaimMilestone(isBasic, number)
    if isBasic then
        local claimedBasic = 0
        if self.basicMileStoneDict:IsContainKey(number) then
            claimedBasic = self.basicMileStoneDict:Get(number)
        end
        self.basicMileStoneDict:Add(number, claimedBasic + 1)
    else
        local claimedPremium = 0
        if self.premiumMileStoneDict:IsContainKey(number) then
            claimedPremium = self.premiumMileStoneDict:Get(number)
        end
        self.premiumMileStoneDict:Add(number, claimedPremium + 1)
    end
end

--- @return number, number
--- @param number number
function GrowPatchLine:GetMilestoneState(number)
    local claimedBasic = 0
    if self.basicMileStoneDict:IsContainKey(number) then
        claimedBasic = self.basicMileStoneDict:Get(number)
    end
    local claimedPremium = 0
    if self.premiumMileStoneDict:IsContainKey(number) then
        claimedPremium = self.premiumMileStoneDict:Get(number)
    end
    return claimedBasic, claimedPremium
end

function GrowPatchLine:GetTotalClaim()
    local totalClaimReward = 0
    for k, v in pairs(self.basicMileStoneDict:GetItems()) do
        if v > 0 then
            totalClaimReward = totalClaimReward + 1
        end
    end
    for k, v in pairs(self.premiumMileStoneDict:GetItems()) do
        if v > 0 then
            totalClaimReward = totalClaimReward + 1
        end
    end
    return totalClaimReward
end