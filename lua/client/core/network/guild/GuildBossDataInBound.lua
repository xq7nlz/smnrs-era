require "lua.client.core.network.guild.GuildBossDefenderTeamInBound"

--- @class GuildBossDataInBound
GuildBossDataInBound = Class(GuildBossDataInBound)

function GuildBossDataInBound:Ctor()
    --- @type BattleTeamInfo
    self.battleTeamInfo = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildBossDataInBound:ReadBuffer(buffer)
    --- @type boolean
    self.isHaveGuildBoss = buffer:GetBool()
    --- @type number
    self.selectedBossId = nil
    --- @type GuildBossDefenderTeamInBound
    self.guildBoss = nil
    --- @type boolean
    self.isHavePreviousGuildBoss = nil
    --- @type GuildBossDefenderTeamInBound
    self.previousGuildBoss = nil

    if self.isHaveGuildBoss == true then
        self.selectedBossId = buffer:GetByte()
        self.guildBoss = GuildBossDefenderTeamInBound(buffer)

        --- @type boolean
        self.isHavePreviousGuildBoss = buffer:GetBool()
        if self.isHavePreviousGuildBoss == true then
            self.previousGuildBoss = GuildBossDefenderTeamInBound(buffer)
        end
    end
    --- @type number
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
    self:GetBattleTeamInfo()
end

function GuildBossDataInBound:IsAvailableToRequest()
    return self.lastTimeRequest == nil or (zg.timeMgr:GetServerTime() - self.lastTimeRequest >= 10)
end

function GuildBossDataInBound.NeedRequest()
    --- @type GuildBossDataInBound
    local guildBossDataInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BOSS)
    return guildBossDataInBound == nil or guildBossDataInBound:IsAvailableToRequest()
end

--- @param callback function
--- @param forceUpdate boolean
function GuildBossDataInBound.Validate(callback, forceUpdate)
    if GuildBossDataInBound.NeedRequest() or forceUpdate == true then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.GUILD_BOSS }, callback, SmartPoolUtils.LogicCodeNotification)
    else
        callback()
    end
end

function GuildBossDataInBound:GetBattleTeamInfo()
    if self.guildBoss ~= nil then
        self.battleTeamInfo = DefenderTeamData.GetBattleTeamInfoByPredefineTeam(self.guildBoss.predefineTeam)
    else
        self.battleTeamInfo = nil
    end
end
