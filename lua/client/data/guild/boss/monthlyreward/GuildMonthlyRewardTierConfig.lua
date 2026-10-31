--- @class GuildMonthlyRewardTierConfig
GuildMonthlyRewardTierConfig = Class(GuildMonthlyRewardTierConfig)

function GuildMonthlyRewardTierConfig:Ctor()
    --- @type number
    self.tier = nil
    --- @type number
    self.minGuildLevel = nil
    --- @type number
    self.maxGuildLevel = nil
    --- @type number
    self.minDamageToGainReward = nil
end