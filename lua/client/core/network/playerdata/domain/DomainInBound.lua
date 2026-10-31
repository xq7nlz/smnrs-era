require "lua.client.core.network.playerData.domain.DomainsCrewMember"
require "lua.client.core.network.playerData.domain.CrewMemberSearchInfo"
require "lua.client.core.network.playerData.domain.CrewInvitation"
require "lua.client.core.network.playerData.domain.DomainCrewInBound"
require "lua.client.core.network.playerData.domain.DomainFormationInBound"
require "lua.client.core.network.playerData.domain.DomainFormationOutBound"
require "lua.client.core.network.playerData.domain.DomainContributeHeroListInBound"
require "lua.client.core.network.playerData.domain.CrewBattleChallengeOutBound"
require "lua.client.core.network.playerData.domain.DomainRecordData"

--- @class DomainInBound
DomainInBound = Class(DomainInBound)

function DomainInBound:Ctor()
    --- @type number
    self.challengeDay = nil
    --- @type boolean
    self.isInCrew = nil

    --- @type DomainCrewInBound
    self.domainCrewInBound = nil
    --- @type DomainFormationInBound
    self.domainFormationInBound = nil
    --- @type DomainContributeHeroListInBound
    self.domainContributeHeroListInBound = nil

    --- @type number
    self.currentStage = nil

    --- @type Dictionary
    self.memberHeroesDict = Dictionary()
    --- @type Dictionary
    self.predefineTeamDataStageDict = Dictionary()

    --- @type Dictionary
    self.heroResourceMemberDict = Dictionary()

    --- @type DomainRecordData
    self.domainRecordData = DomainRecordData()

    --- @type number
    self.lastTimeUpdated = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function DomainInBound:ReadBuffer(buffer)
    self.challengeDay = buffer:GetInt()

    self.lastTimeRefreshTicket = buffer:GetLong()

    self.domainContributeHeroListInBound = DomainContributeHeroListInBound(buffer)

    self.isInCrew = buffer:GetBool()

    if self.isInCrew then
        self.domainCrewInBound = DomainCrewInBound(buffer)

        self.isReady = buffer:GetBool()

        self.domainFormationInBound = DomainFormationInBound(buffer)

        self:OnSetContributeHeroes(buffer)

        self.currentStage = buffer:GetInt()

        self.lastTimeChallenge = buffer:GetLong()
    end

    self.lastTimeUpdated = zg.timeMgr:GetServerTime()
end

function DomainInBound:RemoveInvitationById(id)
    for i = zg.playerData.domainData.listInvitation:Count(), 1, -1 do
        ---@type CrewInvitation
        local data = zg.playerData.domainData.listInvitation:Get(i)
        if data.crewId == id then
            zg.playerData.domainData.listInvitation:RemoveByIndex(i)
        end
    end
end

---@return boolean
function DomainInBound:IsReady()
    local listMember = self.domainCrewInBound.listMember
    ---@param v DomainsCrewMember
    for i, v in ipairs(listMember:GetItems()) do
        if (v.playerId == PlayerSettingData.playerId) then
            return v.isReady
        end
    end
    XDebug.Error("NILL Current member")
    return false
end

---@param isReady
function DomainInBound:SetReady(isReady)
    local listMember = self.domainCrewInBound.listMember
    ---@param v DomainsCrewMember
    for i, v in ipairs(listMember:GetItems()) do
        if (v.playerId == PlayerSettingData.playerId) then
            v.isReady = isReady
            break
        end
    end
    self.lastTimeReadyChange = zg.timeMgr:GetServerTime()
end

function DomainInBound:RemoveVerifyById(id)
    for i = zg.playerData.domainData.listVerifyDomain:Count(), 1, -1 do
        ---@type CrewApplication
        local data = zg.playerData.domainData.listVerifyDomain:Get(i)
        if data.playerId == id then
            zg.playerData.domainData.listVerifyDomain:RemoveByIndex(i)
        end
    end
end

function DomainInBound:RemoveRecommendationById(id)
    for i = zg.playerData.domainData.listRecommendation:Count(), 1, -1 do
        ---@type CrewInvitation
        local data = zg.playerData.domainData.listRecommendation:Get(i)
        if data.crewId == id then
            zg.playerData.domainData.listRecommendation:RemoveByIndex(i)
        end
    end
end

function DomainInBound:GetListFriendSearch(callbackSuccess, callbackFail)
    if (zg.playerData.domainData.listFriendSearchDomain == nil) then
        ---@type List
        local list
        local onBufferReading = function(buffer)
            list = NetworkUtils.GetListDataInBound(buffer, CrewMemberSearchInfo)
            --- @param v CrewMemberSearchInfo
            for k, v in pairs(list:GetItems()) do
                if v.isInCrew == true then
                    list:RemoveByIndex(k)
                end
            end
        end

        local onSuccess = function()
            zg.playerData.domainData.listFriendSearchDomain = list
            if callbackSuccess ~= nil then
                callbackSuccess(zg.playerData.domainData.listFriendSearchDomain)
            end
        end
        --- @param logicCode LogicCode
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if callbackFail then
                callbackFail(logicCode)
            end
        end
        NetworkUtils.RequestAndCallback(OpCode.DOMAINS_MEMBER_SEARCH,
                UnknownOutBound.CreateInstance(PutMethod.Int, DomainMemberSearchType.FRIEND_LIST),
                onSuccess, onFailed, onBufferReading)
    else
        callbackSuccess(zg.playerData.domainData.listFriendSearchDomain)
    end
end

function DomainInBound:GetListGuildSearch(callbackSuccess, callbackFail)
    if (zg.playerData.domainData.listGuildSearch == nil) then
        ---@type List
        local list
        local onBufferReading = function(buffer)
            list = NetworkUtils.GetListDataInBound(buffer, CrewMemberSearchInfo)
            ----- @param v CrewMemberSearchInfo
            --for k, v in pairs(list:GetItems()) do
            --    if v.isInCrew == true then
            --        list:RemoveByIndex(k)
            --    end
            --end
        end

        local onSuccess = function()
            zg.playerData.domainData.listGuildSearch = list
            if callbackSuccess ~= nil then
                callbackSuccess(zg.playerData.domainData.listGuildSearch)
            end
        end
        --- @param logicCode LogicCode
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if callbackFail then
                callbackFail(logicCode)
            end
        end
        NetworkUtils.RequestAndCallback(OpCode.DOMAINS_MEMBER_SEARCH,
                UnknownOutBound.CreateInstance(PutMethod.Int, DomainMemberSearchType.GUILD_MEMBER_LIST),
                onSuccess, onFailed, onBufferReading)
    else
        callbackSuccess(zg.playerData.domainData.listGuildSearch)
    end
end

function DomainInBound:ValidateDomainApplication(callbackSuccess, callbackFail)
    local domainData = zg.playerData.domainData
    if (domainData.listVerifyDomain == nil) then
        ---@type List
        local list
        local onBufferReading = function(buffer)
            require("lua.client.core.network.playerData.domain.CrewApplication")
            list = NetworkUtils.GetListDataInBound(buffer, CrewApplication)
        end

        local onSuccess = function()
            domainData.listVerifyDomain = list
            if callbackSuccess ~= nil then
                callbackSuccess(domainData.listVerifyDomain)
            end
        end
        --- @param logicCode LogicCode
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if callbackFail then
                callbackFail(logicCode)
            end
        end
        NetworkUtils.RequestAndCallback(OpCode.DOMAINS_CREW_APPLICATION_GET,
                UnknownOutBound.CreateInstance(PutMethod.Int, DomainMemberSearchType.GUILD_MEMBER_LIST),
                onSuccess, onFailed, onBufferReading)
    else
        callbackSuccess(domainData.listVerifyDomain)
    end
end

function DomainInBound:GetListIdSearch(friendId, callbackSuccess, callbackFail)
    ---@type List
    local list
    local onBufferReading = function(buffer)
        list = NetworkUtils.GetListDataInBound(buffer, CrewMemberSearchInfo)
    end

    local onSuccess = function()
        if callbackSuccess ~= nil then
            callbackSuccess(list)
        end
    end
    --- @param logicCode LogicCode
    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
        if callbackFail then
            callbackFail(logicCode)
        end
    end
    NetworkUtils.RequestAndCallback(OpCode.DOMAINS_MEMBER_SEARCH,
            UnknownOutBound.CreateInstance(PutMethod.Int, DomainMemberSearchType.FRIEND_ID, PutMethod.Long, friendId),
            onSuccess, onFailed, onBufferReading)
end

function DomainInBound:ValidateListInvitation(callbackSuccess, callbackFail, forceUpdate)
    if zg.playerData.domainData.listInvitation == nil or forceUpdate == true then
        ---@type List
        local list
        local onBufferReading = function(buffer)
            list = NetworkUtils.GetListDataInBound(buffer, CrewInvitation)
        end

        local onSuccess = function()
            zg.playerData.domainData.listInvitation = list
            if callbackSuccess ~= nil then
                callbackSuccess(zg.playerData.domainData.listInvitation)
            end
        end
        --- @param logicCode LogicCode
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if callbackFail then
                callbackFail(logicCode)
            end
        end
        NetworkUtils.RequestAndCallback(OpCode.DOMAINS_MEMBER_INVITATIONS_GET, nil,
                onSuccess, onFailed, onBufferReading)
    else
        callbackSuccess(zg.playerData.domainData.listInvitation)
    end
end

function DomainInBound:ValidateListRecommendation(callbackSuccess, callbackFail, needRequest, showNoti)
    --- @type {lastTimeUpdateRecommend}
    local domainData = zg.playerData.domainData
    if domainData.listRecommendation == nil
            or needRequest == true
            or domainData.lastTimeUpdateRecommend == nil
            or (zg.timeMgr:GetServerTime() - domainData.lastTimeUpdateRecommend >= 10) then
        ---@type List
        local list
        local onBufferReading = function(buffer)
            list = NetworkUtils.GetListDataInBound(buffer, CrewInvitation)
        end

        local onSuccess = function()
            domainData.listRecommendation = list
            if callbackSuccess ~= nil then
                callbackSuccess(domainData.listRecommendation)
            end
            domainData.lastTimeUpdateRecommend = zg.timeMgr:GetServerTime()

            if showNoti == true then
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("data_updated"))
            end
        end
        --- @param logicCode LogicCode
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if callbackFail then
                callbackFail(logicCode)
            end
        end
        NetworkUtils.RequestAndCallback(OpCode.DOMAINS_CREW_RECOMMENDATION_GET, nil,
                onSuccess, onFailed, onBufferReading)
    else
        if domainData.lastTimeUpdateRecommend ~= nil then
            local timeLeft = 10 - (zg.timeMgr:GetServerTime() - domainData.lastTimeUpdateRecommend)
            if timeLeft > 0 and showNoti == true then
                zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
                SmartPoolUtils.ShowShortNotification(string.format("%s: %ss",
                        LanguageUtils.LocalizeCommon("try_again_few_seconds"), timeLeft))
            end
        end
        callbackSuccess(domainData.listRecommendation)
    end
end

function DomainInBound:SetListHeroDomain(listInventoryId, callbackSuccess, callbackFail)
    local domainContributeHeroListInBound = DomainContributeHeroListInBound()
    domainContributeHeroListInBound.listHeroContribute = listInventoryId

    local onSuccess = function()
        self.domainContributeHeroListInBound = domainContributeHeroListInBound
        if callbackSuccess ~= nil then
            callbackSuccess(listInventoryId)
        end
    end
    --- @param logicCode LogicCode
    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
        if callbackFail then
            callbackFail(logicCode)
        end
    end
    NetworkUtils.RequestAndCallback(OpCode.DOMAINS_CONTRIBUTE_HERO_SAVE,
            domainContributeHeroListInBound,
            onSuccess, onFailed, nil)
end

--- @param buffer UnifiedNetwork_ByteBuf
function DomainInBound:OnSetContributeHeroes(buffer, isInBattle)
    self.memberHeroesDict:Clear()
    self.heroResourceMemberDict:Clear()

    local memberCount = buffer:GetByte()
    for _ = 1, memberCount do
        local memberId = buffer:GetLong()
        local listHeroResource = NetworkUtils.GetListDataInBound(buffer, HeroResource.CreateInstanceByBuffer)
        self.memberHeroesDict:Add(memberId, listHeroResource)

        for k = 1, listHeroResource:Count() do
            local heroResource = listHeroResource:Get(k)
            self.heroResourceMemberDict:Add(heroResource, memberId)
        end
    end

    self.predefineTeamDataStageDict:Clear()
    local stageCount = buffer:GetByte()

    for _ = 1, stageCount do
        local stage = buffer:GetInt()
        self.predefineTeamDataStageDict:Add(stage, PredefineTeamData.CreateByBuffer(buffer))
    end

    if isInBattle ~= nil and self.domainCrewInBound ~= nil then
        self.domainCrewInBound.isInBattle = true
    end
end

--- @return boolean
function DomainInBound:IsInBattle()
    return self.domainCrewInBound.isInBattle
end

function DomainInBound:IsClearAllStages()
    --- @type DomainRewardDayConfig
    local domainRewardDayConfig = ResourceMgr.GetDomainConfig():GetDomainRewardConfig():GetDomainRewardDayConfig(self.challengeDay)
    return self.currentStage == domainRewardDayConfig:StageCount()
end

function DomainInBound:IsValidShowChallengeOver()
    if self.isInCrew == false or self:IsInBattle() == false or self:IsClearAllStages() == false then
        return false
    end
    local lastTimeChallengeDomain = zg.playerData.remoteConfig.lastTimeChallengeDomain

    if lastTimeChallengeDomain == nil then
        return true
    end
    if lastTimeChallengeDomain < self.lastTimeChallenge then
        return true
    end
    return false
end

--- @return List -- HeroResource
function DomainInBound:GetTeamListHeroResource()
    local listHeroResource = List()
    --- @param listHero List
    for memberId, listHero in pairs(self.memberHeroesDict:GetItems()) do
        for i, v in ipairs(listHero:GetItems()) do
            ---@type HeroResource
            local heroResource = HeroResource.Clone(v)
            heroResource.memberId = memberId
            listHeroResource:Add(heroResource)
        end
    end
    return listHeroResource
end

--- @return PredefineTeamData
function DomainInBound:GetPredefineTeam(stage)
    return self.predefineTeamDataStageDict:Get(stage)
end

function DomainInBound.Validate(callback, forceUpdate)
    if forceUpdate == true or DomainInBound.IsAvailableToRequest() then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.DOMAIN }, callback)
    else
        if callback then
            callback()
        end
    end
end

function DomainInBound.IsAvailableToRequest()
    --- @type DomainInBound
    local domainInBound = zg.playerData:GetMethod(PlayerDataMethod.DOMAIN)
    return domainInBound.lastTimeUpdated == nil
            or (zg.timeMgr:GetServerTime() - domainInBound.lastTimeUpdated) > TimeUtils.SecondAMin
end

function DomainInBound.RequestCreateTeam(name, desc, isFastCreate, callback)
    local onSuccess = function()
        DomainInBound.Validate(callback, true)
    end
    NetworkUtils.RequestAndCallback(OpCode.DOMAINS_CREW_CREATE,
            UnknownOutBound.CreateInstance(PutMethod.String, name,
                    PutMethod.LongString, desc, PutMethod.Bool, isFastCreate), onSuccess, SmartPoolUtils.LogicCodeNotification, nil)
end

--- @return void
--- @param crewId number
--- @param callback function
function DomainInBound.RequestJoin(crewId, callback)
    local onSuccess = function()
        if callback ~= nil then
            callback()
        end
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("send_request_successful"))
    end
    NetworkUtils.RequestAndCallback(OpCode.DOMAINS_CREW_APPLICATION_SEND, UnknownOutBound.CreateInstance(PutMethod.Int, crewId),
            onSuccess, SmartPoolUtils.LogicCodeNotification)
end

--- @return PlayerDataMethod
function DomainInBound.GetPlayerDataMethod()
    return PlayerDataMethod.DOMAIN
end

return DomainInBound