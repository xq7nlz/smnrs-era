require "lua.client.core.network.casino.SpinCasinoItemRewardInBound"

--- @class SpinCasinoInBound
SpinCasinoInBound = Class(SpinCasinoInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function SpinCasinoInBound:Ctor(buffer)
    ---@type number
    self.casinoType = buffer:GetByte()
    ---@type boolean
    self.isSingleSpin = buffer:GetBool()
    ---@type List  --<SpinCasinoItemRewardInBound>
    self.rewardItems = NetworkUtils.GetListDataInBound(buffer, SpinCasinoItemRewardInBound)

end

--- @return void
function SpinCasinoInBound:ToString()
    return LogUtils.ToDetail(self)
end