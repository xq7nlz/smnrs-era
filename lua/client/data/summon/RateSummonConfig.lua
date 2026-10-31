require "lua.client.data.Summon.RateSummonData"

--- @class RateSummonConfig
RateSummonConfig = Class(RateSummonConfig)

--- @return void
function RateSummonConfig:Ctor()
    --- @type ListGroupRateSummonData
    self.basicSummon = ListGroupRateSummonData.CreateByCsv("csv/summon/basic_summon_rate.csv")
    --- @type ListGroupRateSummonData
    self.heroicSummon = ListGroupRateSummonData.CreateByCsv("csv/summon/premium_summon_rate.csv")
    --- @type ListGroupRateSummonData
    self.friendSummon = ListGroupRateSummonData.CreateByCsv("csv/summon/friend_summon_rate.csv")
    --- @type ListGroupRateSummonData
    self.eventSummon = ListGroupRateSummonData.CreateByCsv("csv/event/event_rate_up/data_1/event_rate_up_cumulative_rate.csv")
end

return RateSummonConfig