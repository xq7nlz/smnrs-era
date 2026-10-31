require "lua.client.core.network.guildWarRecord.PlayerGuildWarRecord"
require "lua.client.core.network.guildWarRecord.GuildWarRecord"

--- @class GuildWarRecordData
GuildWarRecordData = Class(GuildWarRecordData)

--- @return void
--- @param battleId number
function GuildWarRecordData:Ctor(battleId)
    self.battleId = battleId
    --- @type Dictionary
    self.playerRecordDict = Dictionary()

    --- @type number
    self.challengeSlot = nil
    --- Cache Record
    --- @type boolean
    self.isAllyAttackerRecord = nil
    --- @type GuildWarRecord
    self.guildWarRecord = nil

    --- @type {medalGain, condition1, condition2, condition3}
    self.challengeResult = {}
end

--- @param isAlly boolean
--- @param guildWarRecord GuildWarRecord
function GuildWarRecordData:SetPlayRecord(isAlly, guildWarRecord)
    self.isAllyAttackerRecord = isAlly
    self.guildWarRecord = guildWarRecord
    self.challengeSlot = guildWarRecord.defenderTeamPosition

    if guildWarRecord.isAttackWin then
        self.challengeResult = {}
        self.challengeResult.medalGain = guildWarRecord.medalChange
        self.challengeResult.condition1 = true
        ---@type GuildWarConfig
        local guildWarConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarConfig()
        local heroDead = 0
        --- @type BattleResult
        local battleResult = ClientBattleData.battleResult
        --- @type List
        local attacker = battleResult.attackerTeamLog.afterLogs

        local attackerList = List()
        if type(attacker) == "table" then
            for k, v in pairs(attacker) do
                attackerList:Add(v)
            end
        end

        for i = 1, attackerList:Count() do
            --- @type HeroStatusLog
            local heroStatusLog = attackerList:Get(i)
            if heroStatusLog.hpPercent == 0 then
                heroDead = heroDead + 1
            end
        end
        self.challengeResult.condition2 = heroDead <= guildWarConfig.minAttackerHeroDeadRequirement
        self.challengeResult.condition3 = battleResult.numberRounds <= guildWarConfig.maxRoundRequirement
    end
end

--- @param playerId number
function GuildWarRecordData:IsContainPlayerRecord(playerId)
    --- @type PlayerGuildWarRecord
    local record = self.playerRecordDict:Get(playerId)
    return record ~= nil and record:IsAvailableToRequest() == false
end

--- @return GuildWarRecordData
--- @param buffer UnifiedNetwork_ByteBuf
function GuildWarRecordData.CreateByBuffer(buffer)
    local data = GuildWarRecordData()
    data.listRecord = NetworkUtils.GetListDataInBound(buffer, GuildWarRecord.CreateByBuffer)
    return data
end

--- @param playerId number
function GuildWarRecordData:GetPlayerRecord(playerId)
    return self.playerRecordDict:Get(playerId)
end

--- @param battleResultInBound BattleResultInBound
--- @param numberRounds number
--- @param opponentGuildWarInBound GuildWarPlayerInBound
function GuildWarRecordData:OnSuccessChallenge(battleResultInBound, numberRounds, opponentGuildWarInBound)
    self.challengeSlot = opponentGuildWarInBound.positionInGuildWarBattle
    self.playerRecordDict:RemoveByKey(PlayerSettingData.playerId)
    self.playerRecordDict:RemoveByKey(opponentGuildWarInBound.compactPlayerInfo.playerId)

    self.challengeResult = {}
    ---@type GuildWarConfig
    local guildWarConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarConfig()
    local heroDead = 0
    --- @type List
    local listAttackerState = battleResultInBound.heroStateAttacker
    for i = 1, listAttackerState:Count() do
        --- @type HeroStateInBound
        local heroStateInBound = listAttackerState:Get(i)
        if heroStateInBound.hp == 0 then
            heroDead = heroDead + 1
        end
    end
    local opponentPlayerGuildWarInBound = zg.playerData:GetGuildData().guildWarOpponentInBound:FindSelectedMemberByPosition(self.challengeSlot)
    local medalLeft = opponentPlayerGuildWarInBound.medalHoldDefense
    local medalGain = 0
    self.challengeResult.condition1 = battleResultInBound.isWin == true
    self.challengeResult.condition2 = self.challengeResult.condition1 and heroDead <= guildWarConfig.minAttackerHeroDeadRequirement
    self.challengeResult.condition3 = self.challengeResult.condition1 and numberRounds <= guildWarConfig.maxRoundRequirement
    if self.challengeResult.condition1 then
        medalGain = medalGain + 1
    end
    if self.challengeResult.condition2 then
        medalGain = medalGain + 1
    end
    if self.challengeResult.condition3 then
        medalGain = medalGain + 1
    end
    medalGain = MathUtils.Clamp(medalGain, 0, medalLeft)
    self.challengeResult.medalGain = medalGain

    opponentGuildWarInBound.medalHoldDefense = medalLeft - medalGain
end

--- @param battleId number
--- @param playerId number
--- @param callback function
function GuildWarRecordData:RequestGuildWarPlayerRecord(battleId, playerId, callback)
    if self.battleId ~= battleId then
        self.playerRecordDict = Dictionary()
        self.battleId = battleId
    end
    --- @type PlayerGuildWarRecord
    local record = self.playerRecordDict:Get(playerId)
    local setListRecord = function(listRecord)
        record:SetListRecord(listRecord)
        self.playerRecordDict:Add(playerId, record)
        callback(record)
    end
    --- @param listRecord List
    local filterReceivedListRecord = function(listRecord)
        for i = listRecord:Count(), 1, -1 do
            --- @type GuildWarRecord
            local record = listRecord:Get(i)
            if record.battleId ~= self.battleId
                    or record.teamRecordAttack.playerId == playerId then
                listRecord:RemoveByIndex(i)
            end
        end
        return listRecord
    end
    if record == nil or zg.timeMgr:GetServerTime() - record.lastTimeRequest > TimeUtils.SecondAMin then
        record = PlayerGuildWarRecord()
        --- @param listRecord
        local onSuccess = function(listRecord)
            local newListRecord = filterReceivedListRecord(listRecord)
            setListRecord(newListRecord)
        end
        --- @param logicCode LogicCode
        local onFailed = function(logicCode)
            setListRecord(nil)
        end
        GuildWarRecordData.RequestListRecord(playerId, onSuccess, onFailed)
    else
        callback(record)
    end
end

function GuildWarRecordData.RequestListRecord(playerId, onSuccess, onFailed)
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            local listRecord = NetworkUtils.GetListDataInBound(buffer, GuildWarRecord.CreateByBuffer)
            onSuccess(listRecord)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, nil, onFailed)
    end
    NetworkUtils.Request(OpCode.RECORD_LIST_GET, UnknownOutBound.CreateInstance(PutMethod.Byte, GameMode.GUILD_WAR, PutMethod.Long, playerId), onReceived, false)
end