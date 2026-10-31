require "lua.client.core.network.playerData.defenseMode.defenseRecordData.DefensePlayerRecordItemData"
require "lua.client.core.network.playerData.defenseMode.defenseRecordData.DefenseLandRecordData"
require "lua.client.core.network.playerData.defenseMode.defenseRecordData.DefenseBasicRecordInBound"
require "lua.client.core.network.playerData.defenseMode.defenseRecordData.DefenseWaveRecordBasicItem"
require "lua.client.core.network.defenseMode.DefenseBattleRecordInBound"

--- @class DefenseRecordData
DefenseRecordData = Class(DefenseRecordData)

function DefenseRecordData:Ctor()
    --- @type {land, stage, wave, road, recordId, isPlayerRecord, listWaveBasicRecord}
    self.selectedData = {}
    --- @type {road, wave}
    self.nextRecord = {}
    --- @type Dictionary
    self.landRecordDict = Dictionary()
    --- @type DefenseBattleRecordInBound
    self.defenseBattleRecordInBound = nil

    --- @type Dictionary
    self.detailRecordDict = Dictionary()
end

function DefenseRecordData:GetListStageRecord(isPlayerRecord, land, stage, callback)
    --- @type DefenseLandRecordData
    local landRecordData = self.landRecordDict:Get(land)
    if landRecordData == nil then
        landRecordData = DefenseLandRecordData(land)
        self.landRecordDict:Add(land, landRecordData)
    end
    landRecordData:GetListStageRecord(isPlayerRecord, land, stage, callback)
end

function DefenseRecordData:GetWaveRecordBasic(isPlayerRecord, land, stage, recordId, callback)
    local listWaveRecordBasic = self.detailRecordDict:Get(recordId)
    if listWaveRecordBasic == nil then
        local onReceived = function(result)
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                listWaveRecordBasic = NetworkUtils.GetListDataInBound(buffer, DefenseWaveRecordBasicItem)
            end
            local onSuccess = function()
                self.detailRecordDict:Add(recordId, listWaveRecordBasic)
                callback(listWaveRecordBasic)
            end
            local onFailed = function(logicCode)
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
        end
        NetworkUtils.Request(OpCode.DEFENSE_RECORD_DETAIL_GET, UnknownOutBound.CreateInstance(
                PutMethod.Bool, isPlayerRecord, PutMethod.Short, land, PutMethod.Int, stage, PutMethod.String, recordId), onReceived)
    else
        callback(listWaveRecordBasic)
    end
end

function DefenseRecordData:PlayRecord(isPlayerRecord, land, stage, road, wave, recordId, listWaveBasicRecord)
    self.selectedData.isPlayerRecord = isPlayerRecord
    self.selectedData.land = land
    self.selectedData.stage = stage
    self.selectedData.road = road
    self.selectedData.wave = wave
    self.selectedData.recordId = recordId
    self.selectedData.listWaveBasicRecord = listWaveBasicRecord
    self.defenseBattleRecordInBound = nil
end

function DefenseRecordData.RequestAndPlayRecord(isPlayerRecord, land, stage, recordId, wave, tower, listWaveBasicRecord, callback)
    --- @param defenseBattleRecordInBound DefenseBattleRecordInBound
    local callbackSuccess = function(defenseBattleRecordInBound)
        if listWaveBasicRecord ~= nil then
            if wave > 1 then
                --- @type DefenseWaveRecordBasicItem
                local defenseWaveRecordBasicItem = listWaveBasicRecord:Get(wave - 1)
                defenseBattleRecordInBound.teamHeroState.heroStates = defenseWaveRecordBasicItem:GetListHeroState(tower)
            else
                defenseBattleRecordInBound.teamHeroState.heroStates = List()
            end
        end
        DefenseRecordData.SetUpReplayRecord(isPlayerRecord, land, stage, tower, wave, recordId, defenseBattleRecordInBound, listWaveBasicRecord)
    end
    DefenseRecordData.RequestPlayableRecord(isPlayerRecord, land, stage, recordId, wave, tower, callbackSuccess)
end

function DefenseRecordData.RequestPlayableRecord(isPlayerRecord, land, stage, recordId, wave, road, callbackSuccess)
    local onReceived = function(result)
        ---@type DefenseBattleRecordInBound
        local defenseBattleRecordInBound = nil
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            defenseBattleRecordInBound = DefenseBattleRecordInBound(buffer)
        end
        local onSuccess = function()
            --- @type DefenseModeInbound
            local defenseModeInbound = zg.playerData:GetMethod(PlayerDataMethod.DEFENSE_MODE)
            defenseModeInbound.defenseRecordData.defenseBattleRecordInBound = defenseBattleRecordInBound

            if callbackSuccess ~= nil then
                callbackSuccess(defenseBattleRecordInBound)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, LanguageUtils.LocalizeLogicCode)
    end
    NetworkUtils.Request(OpCode.DEFENSE_BATTLE_RECORD_DETAIL_GET,
            UnknownOutBound.CreateInstance(PutMethod.Bool, isPlayerRecord, PutMethod.Short, land, PutMethod.Int, stage,
                    PutMethod.String, recordId, PutMethod.Byte, wave, PutMethod.Byte, road),
            onReceived)
end

--- @param defenseBattleRecordInBound DefenseBattleRecordInBound
function DefenseRecordData.SetUpReplayRecord(isPlayerRecord, land, stage, tower, wave, recordId, defenseBattleRecordInBound, listWaveBasicRecord)
    local gameMode = GameMode.DEFENSE_MODE_RECORD
    ---@type LandConfig
    local landConfig = ResourceMgr.GetDefenseModeConfig():GetLandConfig(land)
    ---@type List
    local listAttackerTeamStageConfig = landConfig:GetListAttackerTeamStageConfig(stage, tower)
    ---@type AttackerTeamStageConfig
    local attackerTeamStageConfig = listAttackerTeamStageConfig:Get(wave)
    ---@type BattleTeamInfo
    local attackerTeamInfo = attackerTeamStageConfig:GetBattleTeamInfo(BattleConstants.ATTACKER_TEAM_ID)
    local defenderTeamInfo = defenseBattleRecordInBound.playerInfoInBound:CreateBattleTeamInfo(nil, BattleConstants.DEFENDER_TEAM_ID)
    --- @param heroState HeroStateInBound
    for _, heroState in ipairs(defenseBattleRecordInBound.teamHeroState.heroStates:GetItems()) do
        defenderTeamInfo:SetState(gameMode, heroState.isFrontLine, heroState.position, heroState.hp, heroState.power)
    end
    defenderTeamInfo:RemoveUninitializedHeroes()
    defenderTeamInfo:SetDefenderTowerLevel(defenseBattleRecordInBound.towerLevel)
    defenderTeamInfo:SetLandId(land)
    local seedInBound = defenseBattleRecordInBound.seed
    ClientBattleData.skipForReplay = true
    zg.playerData.rewardList = nil
    ---@type RandomHelper
    local randomHelper = RandomHelper()
    randomHelper:SetSeed(seedInBound.seed)
    --XDebug.Log(LogUtils.ToDetail(defenderTeamInfo))
    zg.battleMgr:RunCalculatedBattleScene(attackerTeamInfo, defenderTeamInfo, gameMode, randomHelper)

    --- @type DefenseModeInbound
    local defenseModeInbound = zg.playerData:GetMethod(PlayerDataMethod.DEFENSE_MODE)
    defenseModeInbound.defenseRecordData:PlayRecord(isPlayerRecord, land, stage, tower, wave, recordId, listWaveBasicRecord)
end