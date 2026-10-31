require "lua.client.data.Vip.VipRewardData"

local VIP_REWARD_INSTANT_PATH = "csv/vip/vip_reward_instant.csv"

--- @class VipRewardInstant : VipRewardData
VipRewardInstant = Class(VipRewardInstant, VipRewardData)

function VipRewardInstant:Ctor()
    VipRewardData.Ctor(self)
    self:ReadData(VIP_REWARD_INSTANT_PATH)
end

return VipRewardInstant