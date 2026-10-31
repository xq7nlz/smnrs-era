--- @class GuildData
GuildData = Class(GuildData)

local GUILD_WAR_SEASON_CHECK_OUT = "last_guild_war_season_check_out"

function GuildData:Ctor()
    --- @type GuildBossMonthlyStatisticsInBound
    self.guildBossMonthlyStatisticsData = nil
    --- @type GuildDungeonStatisticsGetInBound
    self.guildDungeonStatisticsGetInBound = nil
    --- @type List
    self.listGuildSearchInfo = nil
    --- @type List
    self.listGuildRecommendedInfo = nil
    --- @type GuildWarInBound
    self.guildWarOpponentInBound = nil
    --- @type GuildWarRecordData
    self.guildWarRecordData = nil
    --- @type number
    self.lastGuildWarSeasonCheckOut = nil
end

--- @param callbackSuccess function
--- @param forceUpdate boolean
function GuildData:ValidateGuildWarOpponent(callbackSuccess, callbackFail, forceUpdate, showWaiting)
    local returnCallbackSuccess = function()
        if callbackSuccess ~= nil then
            callbackSuccess(self.guildWarOpponentInBound)
        end
    end
    if self.guildWarOpponentInBound == nil
            or self.guildWarOpponentInBound.lastTimeRequest == nil
            or forceUpdate == true then
        local onReceived = function(result)
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                self.guildWarOpponentInBound = GuildWarInBound()
                self.guildWarOpponentInBound:ReadInnerBuffer(buffer)
            end
            local onSuccess = function()
                returnCallbackSuccess()
            end
            --- @param logicCode LogicCode
            local onFailed = function(logicCode)
                if callbackFail ~= nil then
                    callbackFail(logicCode)
                else
                    SmartPoolUtils.LogicCodeNotification(logicCode)
                end
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
        end
        NetworkUtils.Request(OpCode.GUILD_WAR_OPPONENT_FIND, nil, onReceived, showWaiting)
    else
        returnCallbackSuccess()
    end
end

--- @return GuildWarRecordData
function GuildData:GetGuildWarRecordData(battleId)
    if self.guildWarRecordData == nil
            or (battleId ~= nil and self.guildWarRecordData.battleId ~= battleId) then
        require "lua.client.core.network.guildWarRecord.GuildWarRecordData"
        self.guildWarRecordData = GuildWarRecordData(battleId)
    end
    return self.guildWarRecordData
end

function GuildData:SetGuildDungeonSeasonCheckIn(seasonCheckIn, onSuccessCallback, onFailedCallback)
    local returnCallback = function()
        self.lastGuildWarSeasonCheckOut = seasonCheckIn
        if onSuccessCallback ~= nil then
            onSuccessCallback()
        end
    end
    zg.playerData.remoteConfig.lastGuildWarSeasonCheckOut = seasonCheckIn
    zg.playerData:SaveRemoteConfig()
    returnCallback()
    --local remoteConfigSetOutBound = RemoteConfigSetOutBound()
    --remoteConfigSetOutBound:AddItem(RemoteConfigItemOutBound(GUILD_WAR_SEASON_CHECK_OUT, RemoteConfigValueType.LONG, seasonCheckIn))
    --RemoteConfigSetOutBound.SetValue(remoteConfigSetOutBound, returnCallback, onFailedCallback)
end

--- @param callback function
function GuildData:GetLastGuildWarSeasonCheckOut(callback)
    local returnCallback = function(value)
        self.lastGuildWarSeasonCheckOut = value
        if callback ~= nil then
            callback(value)
        end
    end
    if self.lastGuildWarSeasonCheckOut ~= nil then
        returnCallback(self.lastGuildWarSeasonCheckOut)
        return
    end
    local lastGuildWarSeasonCheckOut = zg.playerData.remoteConfig.lastGuildWarSeasonCheckOut
    if lastGuildWarSeasonCheckOut == nil then
        lastGuildWarSeasonCheckOut = -1
    end
    returnCallback(lastGuildWarSeasonCheckOut)
    --local onFailed = function()
    --    returnCallback(-1)
    --end
    --RemoteConfigSetOutBound.GetValueByKey(GUILD_WAR_SEASON_CHECK_OUT, returnCallback, onFailed)
end

return GuildData