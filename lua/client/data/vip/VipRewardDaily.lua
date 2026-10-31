require "lua.client.data.Vip.VipRewardData"

local VIP_REWARD_DAILY_PATH = "csv/vip/vip_reward_daily.csv"

--- @class VipRewardDaily : VipRewardData
VipRewardDaily = Class(VipRewardDaily, VipRewardData)

function VipRewardDaily:Ctor()
    VipRewardData.Ctor(self)
    self:ReadData(VIP_REWARD_DAILY_PATH)
end

return VipRewardDaily