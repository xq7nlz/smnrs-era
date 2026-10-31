--- @class GuildWarRemoteConfig
GuildWarRemoteConfig = Class(GuildWarRemoteConfig)

--- @return void
function GuildWarRemoteConfig:Ctor()
    ---@type number
    self.battleId = nil
    ---@type number
    self.seasonId = nil
end