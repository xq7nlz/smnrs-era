require "lua.client.core.network.guild.GuildDungeonChallengeOutBound"

--- @class GuildDungeonInBound
GuildDungeonInBound = Class(GuildDungeonInBound)

function GuildDungeonInBound:Ctor()
    self:Init()
end

function GuildDungeonInBound:Init()
    self.guildDungeonDetailDict = Dictionary()
end

--- @param buffer UnifiedNetwork_ByteBuf
function GuildDungeonInBound:ReadBuffer(buffer)
    --- @type boolean
    self.isHaveGuildBoss = buffer:GetBool()
    --- @type number
    self.currentStage = buffer:GetInt()
    --- @type number
    self.numberClearedStages = buffer:GetInt()
    --- @type number
    self.currentTotalScore = buffer:GetLong()
    --- @type number
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
end

--- @return GuildDungeonDefenderTeamInBound
--- @param stage number
function GuildDungeonInBound:GetStageDetailData(stage)
    return self.guildDungeonDetailDict:Get(stage)
end

function GuildDungeonInBound:IsAvailableToRequest()
    return self.lastTimeRequest == nil or (zg.timeMgr:GetServerTime() - self.lastTimeRequest >= 10)
end

--- @return boolean
function GuildDungeonInBound.NeedRequest()
    --- @type GuildDungeonInBound
    local guildDungeonInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_DUNGEON)
    return guildDungeonInBound == nil or guildDungeonInBound:IsAvailableToRequest()
end

--- @param callback function
--- @param forceUpdate boolean
function GuildDungeonInBound.Validate(callback, forceUpdate)
    if GuildDungeonInBound.NeedRequest() or forceUpdate == true then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.GUILD_DUNGEON }, callback, SmartPoolUtils.LogicCodeNotification)
    else
        callback()
    end
end

--- @return GuildDungeonDefenderTeamInBound
--- @param stage number
--- @param callback function
function GuildDungeonInBound.LoadStageDetailData(stage, callback)
    --- @param data GuildDungeonDefenderTeamInBound
    local returnResult = function(data)
        if callback ~= nil then
            callback(data)
        end
    end
    --- @type GuildDungeonInBound
    local guildDungeonInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_DUNGEON)
    local data = guildDungeonInBound:GetStageDetailData(stage)
    if data == nil or data:NeedUpdate() then
        local onReceived = function(result)
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                local stageDetailData = GuildDungeonDefenderTeamInBound(buffer)
                guildDungeonInBound.guildDungeonDetailDict:Add(stage, stageDetailData)
                returnResult(stageDetailData)
            end
            --- @param logicCode LogicCode
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
                returnResult(nil)
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, nil, onFailed)
        end
        NetworkUtils.Request(OpCode.GUILD_DUNGEON_DETAIL_GET, UnknownOutBound.CreateInstance(PutMethod.Int, stage), onReceived)
    else
        returnResult(data)
    end
end

--- @param uiFormationTeamData UIFormationTeamData
--- @param bossCreatedTime number
--- @param numberChallenge number
--- @param onSuccessCallback function
function GuildDungeonInBound.ChallengeBoss(uiFormationTeamData, bossCreatedTime, numberChallenge, onSuccessCallback, onFailedCallback)
    local onReceived = function(result)
        --- @type BattleResultInBound
        local battleResultInBound
        local smashUsed = 1
        local rewardEvent
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            battleResultInBound = BattleResultInBound.CreateByBuffer(buffer)
            smashUsed = buffer:GetByte()
            rewardEvent = NetworkUtils.GetInjectorRewardInBoundList(buffer)
        end
        local onSuccess = function()
            if onSuccessCallback ~= nil then
                onSuccessCallback(battleResultInBound, smashUsed, rewardEvent)
            end
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if onFailedCallback then
                onFailedCallback()
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    --zg.playerData:CheckDataLinking(function ()
        NetworkUtils.Request(OpCode.GUILD_DUNGEON_CHALLENGE,
                GuildDungeonChallengeOutBound(uiFormationTeamData, bossCreatedTime, numberChallenge), onReceived)
    --end, true)
end