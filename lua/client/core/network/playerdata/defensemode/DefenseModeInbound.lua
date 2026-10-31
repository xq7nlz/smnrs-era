require "lua.client.core.network.playerData.defenseMode.LandCollectionData"
require "lua.client.core.network.playerData.defenseMode.DefenseClaimIdleOutbound"
require "lua.client.core.network.playerData.defenseMode.IdleDefenseModeData"
require "lua.client.core.network.playerData.defenseMode.challengeResult.DefenseChallengeResultInBound"
require "lua.client.core.network.playerData.defenseMode.defenseRecordData.DefenseRecordData"
require "lua.client.core.network.defenseMode.DefenseChallengeOutBound"

--- @class DefenseModeInbound
DefenseModeInbound = Class(DefenseModeInbound)

--- @return void
function DefenseModeInbound:Ctor()
    --- @type number
    self.lastTimeRequest = nil
    --- @type Dictionary --<land, LandCollectionData>
    self.landCollectionDataMap = Dictionary()
    --- @type Dictionary --<land, List>
    self.idleDataDict = Dictionary()

    --- @type DefenseRecordData
    self.defenseRecordData = DefenseRecordData()

    --- @type DefenseChallengeResultInBound
    self.defenseChallengeResultInBound = nil
    ---@type {land, teamFormationInBound, listAttackerTeamStageConfig}
    self.currentBattleData = {}
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function DefenseModeInbound:ReadBuffer(buffer)
    self.landCollectionDataMap = Dictionary()
    local size = buffer:GetByte()
    if size > 0 then
        for i = 1, size do
            local lanId = buffer:GetShort()
            self.landCollectionDataMap:Add(lanId, LandCollectionData(lanId, buffer))
        end
    end
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
    self.idleDataDict:Clear()
end

function DefenseModeInbound:IsAvailableToRequest()
    return self.lastTimeRequest == nil
end

function DefenseModeInbound.Validate(callback, forceUpdate)
    --- @type DefenseModeInbound
    local defenseModeInbound = zg.playerData:GetMethod(PlayerDataMethod.DEFENSE_MODE)
    if defenseModeInbound == nil
            or defenseModeInbound:IsAvailableToRequest()
            or forceUpdate == true then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.DEFENSE_MODE }, callback)
    else
        if callback then
            callback()
        end
    end
end

--- @return LandCollectionData
--- @param land number
function DefenseModeInbound:GetLandCollectionData(land)
    return self.landCollectionDataMap:Get(land)
end

function DefenseModeInbound:GetIdleDataDictionary()
    for i, v in pairs(self.landCollectionDataMap:GetItems()) do
        self:GetListIdleReward(i)
    end
    return self.idleDataDict
end

--- @return List
function DefenseModeInbound:GetListIdleReward(landId)
    ---@type List
    local list = self.idleDataDict:Get(landId)
    if list == nil then
        list = List()
        ---@type LandCollectionData
        local landCollectionData = self.landCollectionDataMap:Get(landId)
        if landCollectionData ~= nil and landCollectionData.stage > 0 then
            ---@type LandConfig
            local landConfig = ResourceMgr.GetDefenseModeConfig():GetLandConfig(landId)
            ---@type LandIdleRewardConfig
            local landIdleRewardConfig = landConfig:GetLandIdleRewardConfig(landCollectionData.stage)
            if landIdleRewardConfig ~= nil then
                ---@param landIdleRewardItemConfig LandIdleRewardItemConfig
                for _, landIdleRewardItemConfig in ipairs(landIdleRewardConfig.listReward:GetItems()) do
                    ---@type IdleDefenseModeData
                    local idleDefenseModeData = IdleDefenseModeData()
                    idleDefenseModeData.landIdleRewardItemConfig = landIdleRewardItemConfig
                    idleDefenseModeData.reward = landIdleRewardItemConfig.rewardInBound:Clone()
                    idleDefenseModeData.reward.number = 0
                    --- @type IdleDurationCampaign
                    local idleDuration = landCollectionData.idleDurationMap:Get(idleDefenseModeData.reward:GetKey())
                    idleDefenseModeData.lastTimeClaim = idleDuration.lastTimeIdle
                    list:Add(idleDefenseModeData)
                end
            else
                XDebug.Warning("NIL LandIdleRewardConfig " .. landCollectionData.stage)
            end

            ---@param idleDefenseModeData IdleDefenseModeData
            for _, idleDefenseModeData in ipairs(list:GetItems()) do
                --- @type IdleDurationCampaign
                local idleDuration = landCollectionData.idleDurationMap:Get(idleDefenseModeData.reward:GetKey())
                for stage, time in pairs(idleDuration.totalTime:GetItems()) do
                    if stage ~= landCollectionData.stage then
                        ---@param landIdleRewardItemConfig LandIdleRewardItemConfig
                        for _, landIdleRewardItemConfig in ipairs(landConfig:GetLandIdleRewardConfig(stage).listReward:GetItems()) do
                            if idleDefenseModeData.reward.type == landIdleRewardItemConfig.rewardInBound.type
                                    and idleDefenseModeData.reward.id == landIdleRewardItemConfig.rewardInBound.id
                                    and time >= landIdleRewardItemConfig.intervalTime then
                                idleDefenseModeData.reward.number = idleDefenseModeData.reward.number
                                        + landIdleRewardItemConfig.rewardInBound.number * math.min(landIdleRewardItemConfig.maxIdleNumber, math.floor(time / landIdleRewardItemConfig.intervalTime))
                            end
                        end
                        --idleDefenseModeData.lastTimeClaim = idleDefenseModeData.lastTimeClaim + time
                    end
                end
            end
        end
        self.idleDataDict:Add(landId, list)
    end
    return list
end

--- @return void
function DefenseModeInbound:CanClaimItem(landId, rewardKey, _serverTime)
    ---@param v IdleDefenseModeData
    for i, v in ipairs(self:GetListIdleReward(landId):GetItems()) do
        if v.reward:GetKey() == rewardKey and v:CanClaim(_serverTime) then
            return true
        end
    end
    return false
end

--- @return void
function DefenseModeInbound:CanClaimLand(landId, _serverTime)
    ---@param v IdleDefenseModeData
    for i, v in ipairs(self:GetListIdleReward(landId):GetItems()) do
        if v:CanClaim(_serverTime) then
            return true
        end
    end
    return false
end

--- @return void
function DefenseModeInbound:CanClaimAll(_serverTime)
    for i, v in ipairs(self.landCollectionDataMap:GetItems()) do
        if self:CanClaimLand(i, _serverTime) then
            return true
        end
    end
    return false
end

--- @return void
function DefenseModeInbound:IsNotificationLand(landId, _serverTime)
    ---@param v IdleDefenseModeData
    for i, v in ipairs(self:GetListIdleReward(landId):GetItems()) do
        if v:IsFull(_serverTime) then
            return true
        end
    end
    return false
end

--- @return boolean
function DefenseModeInbound:HasNotification()
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.DEFENSE, false) == false then
        return false
    end
    local svTime = zg.timeMgr:GetServerTime()
    for i, v in ipairs(self.landCollectionDataMap:GetItems()) do
        if self:IsNotificationLand(i, svTime) then
            return true
        end
    end
    return false
end

--- @return void
--- @param defenseClaimIdleOutbound DefenseClaimIdleOutbound
function DefenseModeInbound:RequestClaim(defenseClaimIdleOutbound, callbackSuccess)
    local listReward = List()
    ---@param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        local size = buffer:GetByte()
        for i = 1, size do
            local reward = RewardInBound.CreateByBuffer(buffer)
            listReward:Add(reward)
        end
    end
    NetworkUtils.RequestAndCallback(OpCode.DEFENSE_MODE_IDLE_CLAIM, defenseClaimIdleOutbound, function()
        if listReward:Count() > 0 then
            PopupUtils.ClaimAndShowRewardList(listReward)
            local timeServer = zg.timeMgr:GetServerTime()
            for _, land in ipairs(defenseClaimIdleOutbound.listLand:GetItems()) do
                ---@type LandCollectionData
                local landCollectionData = self.landCollectionDataMap:Get(land)
                landCollectionData:ClearIdle(timeServer)
                ---@param v IdleDefenseModeData
                for i, v in ipairs(self.idleDataDict:Get(land):GetItems()) do
                    v:Clear(timeServer)
                end
            end
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("can_not_claim"))
        end
    end, SmartPoolUtils.LogicCodeNotification, onBufferReading)
end

--- @return void
function DefenseModeInbound:ClaimIdle(land, callbackSuccess)
    if land ~= nil and self:CanClaimLand(land, zg.timeMgr:GetServerTime()) then
        local defenseClaimIdleOutbound = DefenseClaimIdleOutbound()
        defenseClaimIdleOutbound.listLand:Add(land)
        self:RequestClaim(defenseClaimIdleOutbound, callbackSuccess)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("can_not_claim"))
    end
end

--- @return void
function DefenseModeInbound:ClaimAll(callbackSuccess)
    local defenseClaimIdleOutbound = DefenseClaimIdleOutbound()
    local timeServer = zg.timeMgr:GetServerTime()
    for land, v in ipairs(self.landCollectionDataMap:GetItems()) do
        if self:CanClaimLand(land, timeServer) then
            defenseClaimIdleOutbound.listLand:Add(land)
        end
    end
    if defenseClaimIdleOutbound.listLand:Count() > 0 then
        self:RequestClaim(defenseClaimIdleOutbound, callbackSuccess)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("can_not_claim"))
    end
end

--- @return void
function DefenseModeInbound:ClaimItem(land, key, callbackSuccess)
    if self:CanClaimItem(land, key, zg.timeMgr:GetServerTime()) then
        local listReward = List()
        ---@param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            local size = buffer:GetByte()
            for i = 1, size do
                local reward = RewardInBound.CreateByBuffer(buffer)
                listReward:Add(reward)
            end
        end
        NetworkUtils.RequestAndCallback(OpCode.DEFENSE_MODE_IDLE_ITEM_CLAIM, UnknownOutBound.CreateInstance(PutMethod.Short, land, PutMethod.String, key), function()
            if listReward:Count() > 0 then
                PopupUtils.ClaimAndShowRewardList(listReward)
                local timeServer = zg.timeMgr:GetServerTime()
                ---@type LandCollectionData
                local landCollectionData = self.landCollectionDataMap:Get(land)
                ---@type IdleDurationCampaign
                local idleDuration = landCollectionData.idleDurationMap:Get(key)
                if idleDuration ~= nil then
                    idleDuration:Clear(timeServer)
                end
                ---@param v IdleDefenseModeData
                for _, v in ipairs(self.idleDataDict:Get(land):GetItems()) do
                    if v.reward:GetKey() == key then
                        v:Clear(timeServer)
                        break
                    end
                end
                if callbackSuccess ~= nil then
                    callbackSuccess()
                end
            else
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("can_not_claim"))
            end
        end, SmartPoolUtils.LogicCodeNotification, onBufferReading)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("can_not_claim"))
    end
end

---@param battleFormationOutBound BattleFormationOutBound
function DefenseModeInbound.ChallengeDefense(battleFormationOutBound, land, stage, callbackSuccess, callbackFailed)
    --- @type DefenseModeInbound
    local defenseModeInbound = zg.playerData:GetMethod(PlayerDataMethod.DEFENSE_MODE)
    local selectedData = {}
    selectedData.land = land
    selectedData.stage = stage
    defenseModeInbound.defenseRecordData.selectedData = selectedData
    --- @param logicCode LogicCode
    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
        if callbackFailed then
            callbackFailed(logicCode)
        end
    end
    local onBufferReading = function(buffer)
        defenseModeInbound.defenseChallengeResultInBound = DefenseChallengeResultInBound(buffer)
        callbackSuccess(defenseModeInbound.defenseChallengeResultInBound)
    end
    NetworkUtils.RequestAndCallback(OpCode.DEFENSE_MODE_CHALLENGE,
            DefenseChallengeOutBound(battleFormationOutBound, land, stage),
            nil, onFailed, onBufferReading)
end

---@param data {land, teamFormationInBound}
function DefenseModeInbound:SaveCurrentBattleData(data)
    self.currentBattleData = data
end

---@return {land, teamFormationInBound}
function DefenseModeInbound:GetCurrentBattleData()
    return self.currentBattleData
end