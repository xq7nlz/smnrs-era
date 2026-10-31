

--- @class RewardRequirePriceConfig
RewardRequirePriceConfig = Class(RewardRequirePriceConfig)

--- @return void
function RewardRequirePriceConfig:Ctor()
    ---@type number
    self.id = nil
    ---@type boolean
    self.isRequirePrice = false
    ---@type List RewardInBound
    self.listReward = nil
    ---@type number
    self.heroFragmentId = nil
    ---@type number
    self.heroScale = nil
    ---@type number
    self.priceRequire = nil
    ---@type number
    self.price = nil
end

function RewardRequirePriceConfig:SetHeroFragmentID()
    self.heroFragmentId = self:GetHeroFragmentID()
end

--- @return number
function RewardRequirePriceConfig:GetHeroFragmentID()
    if (self.heroFragmentId == nil) then
        if (self.listReward == nil or self.listReward:Count() == 0) then
            return nil
        end
        for i = 1, self.listReward:Count() do
            ---@type RewardInBound
            local rewardInBound = self.listReward:Get(i)
            if (rewardInBound.type == ResourceType.HeroFragment) then
                return rewardInBound.id
            end
        end
        return nil
    else
        return self.heroFragmentId
    end
end
