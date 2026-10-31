--- @class GuildRequest
GuildRequest = Class(GuildRequest)

--- @return void
--- @param guidId number
--- @param callback function
function GuildRequest.RequestJoin(guidId, callback)
    local onSuccess = function()
        if callback ~= nil then
            callback()
        end
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("send_request_successful"))
    end
    --- @param logicCode LogicCode
    local onFailed = function(logicCode)
        if logicCode == LogicCode.GUILD_PLAYER_IN_BLOCK_DURATION then
            local guildConfig = ResourceMgr.GetGuildDataConfig().guildConfig
            local message = LanguageUtils.LocalizeLogicCode(logicCode)
            --- @type GuildBasicInfoInBound
            local guildBasicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
            local timeInSec = (guildBasicInfoInBound.lastLeaveGuildInSec + guildConfig.leaveGuildBlockDuration) - zg.timeMgr:GetServerTime()
            local timeInMin = math.floor(timeInSec / TimeUtils.SecondAMin)
            SmartPoolUtils.ShowShortNotification(string.format(message, timeInMin))
        else
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
    NetworkUtils.RequestAndCallback(OpCode.GUILD_REQUEST_JOIN, UnknownOutBound.CreateInstance(PutMethod.Int, guidId), onSuccess, onFailed)
end
