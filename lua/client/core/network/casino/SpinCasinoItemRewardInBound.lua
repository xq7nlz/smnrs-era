require "lua.client.core.network.playerData.common.DynamicRewardInBound"

--- @class SpinCasinoItemRewardInBound
SpinCasinoItemRewardInBound = Class(SpinCasinoItemRewardInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function SpinCasinoItemRewardInBound:Ctor(buffer)
    ---@type number
    self.id = buffer:GetByte()
    ---@type RewardInBound
    self.reward = RewardInBound.CreateByBuffer(buffer)
end

--- @return void
function SpinCasinoItemRewardInBound:ToString()
    return LogUtils.ToDetail(self)
end