--- @class HeroEvolveInBound
HeroEvolveInBound = Class(HeroEvolveInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function HeroEvolveInBound:Ctor(buffer)
    ---@type List
    self.rewardItems = NetworkUtils.GetRewardInBoundList(buffer)
end

--- @return void
function HeroEvolveInBound:ToString()
    return LogUtils.ToDetail(self)
end