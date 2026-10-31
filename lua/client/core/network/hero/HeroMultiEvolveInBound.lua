--- @class HeroMultiEvolveInBound
HeroMultiEvolveInBound = Class(HeroMultiEvolveInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function HeroMultiEvolveInBound:Ctor(buffer)
    ---@type List
    self.rewardItems = NetworkUtils.GetRewardInBoundList(buffer)
end

--- @return void
function HeroMultiEvolveInBound:ToString()
    return LogUtils.ToDetail(self)
end