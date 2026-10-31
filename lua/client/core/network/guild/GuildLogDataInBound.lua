--- @class GuildLogDataInBound
GuildLogDataInBound = Class(GuildLogDataInBound)
GuildLogDataInBound.KEY_GUILD_MEMBER_CHANGE_TIME = "guild_member_change_time"

function GuildLogDataInBound:Ctor()
    self.lastTimeUpdatedLog = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildLogDataInBound:ReadBuffer(buffer)
    --- @type number
    local size = buffer:GetByte()
    --- @type List
    self.listGuildLog = List()
    for _ = 1, size do
        --- @type {firstPlayerId, firstPlayerName, logActionType, createdTimeInSec, secondPlayerId, secondPlayerName}
        local logData = {}
        logData.firstPlayerId = buffer:GetLong()
        logData.firstPlayerName = buffer:GetString()
        logData.logActionType = buffer:GetByte()
        logData.createdTimeInSec = buffer:GetLong()

        if logData.logActionType == GuildLogActionType.ASSIGN_LEADER
                or logData.logActionType == GuildLogActionType.ASSIGN_SUB_LEADER then
            logData.secondPlayerId = buffer:GetLong()
            logData.secondPlayerName = buffer:GetString()
        end
        self.listGuildLog:Insert(logData, 1)
    end
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
end

function GuildLogDataInBound:IsAvailableToRequest()
    return self.lastTimeRequest == nil or (zg.timeMgr:GetServerTime() - self.lastTimeRequest) > TimeUtils.DELAY_REQUEST_10
end

--- @return {firstPlayerId, firstPlayerName, logActionType : GuildLogActionType, createdTimeInSec, secondPlayerId, secondPlayerName}
function GuildLogDataInBound:GetTheLastNotifiableLog()
    for i = 1, self.listGuildLog:Count() do
        --- @type {firstPlayerId, firstPlayerName, logActionType, createdTimeInSec, secondPlayerId, secondPlayerName}
        local logData = self.listGuildLog:Get(i)
        if logData.logActionType == GuildLogActionType.LEAVE_GUILD
                or logData.logActionType == GuildLogActionType.JOIN_GUILD then
            return logData
        end
    end
end

function GuildLogDataInBound.SetLastTimeGuildMemberChange(createdTime, onSuccessCallback, onFailedCallback)
    zg.playerData.remoteConfig.lastTimeUpdatedLog = createdTime
    zg.playerData:SaveRemoteConfig()
    if onSuccessCallback ~= nil then
        onSuccessCallback()
    end
    --local remoteConfigSetOutBound = RemoteConfigSetOutBound()
    --remoteConfigSetOutBound:AddItem(RemoteConfigItemOutBound(GuildLogDataInBound.KEY_GUILD_MEMBER_CHANGE_TIME, RemoteConfigValueType.LONG, createdTime))
    --RemoteConfigSetOutBound.SetValue(remoteConfigSetOutBound, onSuccessCallback, onFailedCallback)
end

function GuildLogDataInBound.GetLastTimeGuildMemberChange(onSuccess, onFailedCallback)
    --- @type GuildLogDataInBound
    local guildLogDataInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_LOG)
    if guildLogDataInBound == nil then
        onFailedCallback()
        return
    end
    guildLogDataInBound.lastTimeUpdatedLog = zg.playerData.remoteConfig.lastTimeUpdatedLog
    if onSuccess ~= nil then
        onSuccess()
    end
    --local successLoadValue = function(lastUpdatedTime)
    --    guildLogDataInBound.lastTimeUpdatedLog = lastUpdatedTime
    --    onSuccess()
    --end
    ----- @param logicCode LogicCode
    --local onFailed = function(logicCode)
    --    if logicCode == LogicCode.REMOTE_CONFIG_KEY_NOT_FOUND then
    --        guildLogDataInBound.lastTimeUpdatedLog = nil
    --        onSuccess()
    --    else
    --        if onFailedCallback ~= nil then
    --            onFailedCallback()
    --        end
    --    end
    --end
    --RemoteConfigSetOutBound.GetValueByKey(GuildLogDataInBound.KEY_GUILD_MEMBER_CHANGE_TIME, successLoadValue, onFailed)
end

function GuildLogDataInBound.Validate(callback)
    --- @type GuildLogDataInBound
    local guildLogDataInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_LOG)
    if guildLogDataInBound == nil or guildLogDataInBound:IsAvailableToRequest() then
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        end
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.GUILD_LOG }, callback, onFailed)
    else
        callback()
    end
end