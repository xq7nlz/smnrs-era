require "lua.client.core.network.playerData.common.DynamicRewardInBound"

--- @class CasinoItemInBound
CasinoItemInBound = Class(CasinoItemInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function CasinoItemInBound:Ctor(buffer)
    ---@type number
    self.id = buffer:GetByte()
    ---@type RewardInBound
    self.reward = RewardInBound.CreateByBuffer(buffer)
    ---@type number
    self.rate = buffer:GetFloat()
    ---@type boolean
    self.isClaim = buffer:GetBool()
    ---@type boolean
    self.isSingleClaim = buffer:GetBool()
    --XDebug.Log("CasinoItemInBound" .. LogUtils.ToDetail(self) .. "reward " .. LogUtils.ToDetail(self.reward))
end

--- @return void
function CasinoItemInBound:ToString()
    return LogUtils.ToDetail(self)
end