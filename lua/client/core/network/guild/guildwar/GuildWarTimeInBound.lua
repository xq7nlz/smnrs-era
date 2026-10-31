--- @class GuildWarTimeInBound
GuildWarTimeInBound = Class(GuildWarTimeInBound)

function GuildWarTimeInBound:Ctor()
    --- @type number
    self.lastTimeRequest = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildWarTimeInBound:ReadBuffer(buffer)
    self.seasonTime = SeasonTime(buffer)
    self.battleTime = BattleTime(buffer)
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
end

function GuildWarTimeInBound.IsAvailableToRequest()
    --- @type GuildWarTimeInBound
    local guildWarTimeInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR_TIME)
    return guildWarTimeInBound == nil
            or guildWarTimeInBound.lastTimeRequest == nil
end

function GuildWarTimeInBound.GetData(callback)
    if GuildWarTimeInBound.IsAvailableToRequest() then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.GUILD_WAR_TIME }, callback)
    else
        callback()
    end
end

--- @return GuildWarPhase
function GuildWarTimeInBound:CurrentPhase()
    local current = zg.timeMgr:GetServerTime()
    if current < self.battleTime.battleStartTime then
        return GuildWarPhase.SPACE
    elseif current <= self.battleTime.battlePhase1End then
        return GuildWarPhase.REGISTRATION
    elseif current <= self.battleTime.battlePhase2End then
        return GuildWarPhase.SETUP_DEFENDER
    elseif current <= self.battleTime.battlePhase3End then
        return GuildWarPhase.BATTLE
    end
end

--- @return number
function GuildWarTimeInBound:GetTimeToCurrentPhaseEnd()
    local current = zg.timeMgr:GetServerTime()
    local phase = self:CurrentPhase()
    if phase == GuildWarPhase.SPACE then
        return self.battleTime.battleStartTime - current
    elseif phase == GuildWarPhase.REGISTRATION then
        return self.battleTime.battlePhase1End - current
    elseif phase == GuildWarPhase.SETUP_DEFENDER then
        return self.battleTime.battlePhase2End - current
    elseif phase == GuildWarPhase.BATTLE then
        return self.battleTime.battlePhase3End - current
    end
    return 0
end

--- @return PlayerDataMethod
function GuildWarTimeInBound.GetPlayerDataMethod()
    return PlayerDataMethod.GUILD_WAR_TIME
end

--- @class SeasonTime
SeasonTime = Class(SeasonTime)

--- @param buffer UnifiedNetwork_ByteBuf
function SeasonTime:Ctor(buffer)
    self.startTime = buffer:GetLong()
    self.endTime = buffer:GetLong()
    self.season = buffer:GetLong()
end

--- @class BattleTime
BattleTime = Class(BattleTime)

--- @param buffer UnifiedNetwork_ByteBuf
function BattleTime:Ctor(buffer)
    self.battleStartTime = buffer:GetLong()
    self.battlePhase1End = buffer:GetLong()
    self.battlePhase2End = buffer:GetLong()
    self.battlePhase3End = buffer:GetLong()
    self.battleId = buffer:GetLong()
end

