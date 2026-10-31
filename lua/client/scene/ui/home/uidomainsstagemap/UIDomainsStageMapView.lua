require "lua.client.scene.ui.home.uiDomainsStageMap.stageItem.DomainStageItem"

--- @class UIDomainsStageMapView : UIBaseView
UIDomainsStageMapView = Class(UIDomainsStageMapView, UIBaseView)

local IslandCount = 5
local DomainDifficult = {
    NORMAL = 1,
    HARD = 2,
}

--- @param model UIDomainsStageMapModel
function UIDomainsStageMapView:Ctor(model)
    --- @type UIDomainsStageMapConfig
    self.config = nil
    --- @type Dictionary
    self.stageItemDict = Dictionary()
    --- @type DomainInBound
    self.domainInBound = nil
    --- @type DailyTeamDomainConfig
    self.dailyTeamDomainConfig = nil
    --- @type DomainRewardDayConfig
    self.domainRewardDayConfig = nil
    --- @type number
    self.nextStage = nil
    --- @type ItemsTableView
    self.itemsTableView = nil
    --- @type List
    self.listAllowClassesData = List()

    UIBaseView.Ctor(self, model)
    --- @type UIDomainsStageMapModel
    self.model = model
end

---@return DomainsCrewMember
function UIDomainsStageMapView:GetLeaderCrewBasicInfo()
    local leaderId = self.domainInBound.domainCrewInBound.leaderId
    --- @type List -- DomainsCrewMember
    local listMember = self.domainInBound.domainCrewInBound.listMember
    for i, v in ipairs(listMember:GetItems()) do
        if (v.playerId == leaderId) then
            return v
        end
    end
    return nil
end

function UIDomainsStageMapView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtons()

    self:InitUpdateTime()

    self:InitStageItem()

    self.itemsTableView = ItemsTableView(self.config.tableIconClass, nil, UIPoolType.SimpleButtonView)

    uiCanvas:SetBackgroundSize(self.config.normalBackground)
    uiCanvas:SetBackgroundSize(self.config.hardBackground)
end

function UIDomainsStageMapView:InitStageItem()
    local createItem = function(stage, root)
        local domainStageItem = DomainStageItem(root)
        UIUtils.SetParent(domainStageItem.config.transform, self.config.stages:GetChild(stage - 1))
        self.stageItemDict:Add(stage, domainStageItem)
    end
    createItem(1, self.config.domainStageItem)
    createItem(5, self.config.domainStageItem5)
end

function UIDomainsStageMapView:InitUpdateTime()
    self:InitUpdateTimeNextDay(function(timeNextDay, isSetTime)
        self.config.textTimer.text = string.format("%s %s",
                LanguageUtils.LocalizeCommon("will_end_in"), timeNextDay)
        if isSetTime == true then
            UIUtils.AlignText(self.config.textTimer)
        end
    end)
end

function UIDomainsStageMapView:InitButtons()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelp()
    end)
    self.config.buttonChat.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChat()
    end)
    self.config.buttonChangeLeader.onClick:AddListener(function()
        self:OnClickChangeLeader()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonDifficult.onClick:AddListener(function()
        self:OnClickChangeDifficult()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function UIDomainsStageMapView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIDomainsStageMapView:OnClickHelp()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("domains_info"))
end

function UIDomainsStageMapView:InitLocalization()
    self.config.textChat.text = LanguageUtils.LocalizeCommon("chat")
    self.config.textAllowedClasses.text = LanguageUtils.LocalizeCommon("allowed_class")
    self.config.textChangeLeader.text = LanguageUtils.LocalizeCommon("change_crew")
    self.config.textLeader.text = LanguageUtils.LocalizeCommon("crew")
    self.config.textDifficult.text = LanguageUtils.LocalizeCommon("difficult")
end

--- @param data {callbackClose : function}
function UIDomainsStageMapView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)
    self.domainInBound = zg.playerData:GetMethod(PlayerDataMethod.DOMAIN)
    self.day = self.domainInBound.challengeDay

    self.dailyTeamDomainConfig = ResourceMgr.GetDomainConfig():GetDomainConfigByDay(self.day)
    self.domainRewardDayConfig = ResourceMgr.GetDomainConfig():GetDomainRewardDayConfig(self.day)

    self.nextStage = self.domainInBound.currentStage + 1
    if self.nextStage > IslandCount then
        self.difficult = DomainDifficult.HARD
    else
        self.difficult = DomainDifficult.NORMAL
    end

    self:ShowStageIslandByDifficult(self.difficult)
    self:ShowBackgroundByDifficult(self.difficult)
    self:ShowListAllowClasses()

    self:InitListener()

    self:CheckShowChallengeOver()
    self:CheckNotificationChat()
    self:ShowLeaderInfo()
    --if PopupUtils.IsPopupShowing(UIPopupName.UIDomainStageInfo) then
    --    PopupMgr.HidePopup(UIPopupName.UIDomainStageInfo)
    --end
end

function UIDomainsStageMapView:InitListener()
    if self.listenerDomain == nil then
        self.listenerDomain = RxMgr.domainUpdated:Subscribe(RxMgr.CreateFunction(self, self.DomainUpdated))
    end
    if self.listenerChatMessage == nil then
        self.listenerChatMessage = RxMgr.notificationUnreadChatMessage:Subscribe(RxMgr.CreateFunction(self, self.CheckNotificationChat))
    end
end

function UIDomainsStageMapView:ShowStageIslandByDifficult(difficult)
    local isNormal = true
    if difficult > DomainDifficult.NORMAL then
        isNormal = false
    end
    local index = (difficult - 1) * IslandCount + 1
    local stageCount = difficult * IslandCount
    for i = index, stageCount do
        --- @type DomainStageItem
        local stageItem = self:GetStageItem(i - (difficult - 1) * 5)
        local stageStatus = StageStatus.VALUE(i, self.nextStage)
        stageItem:SetState(i, stageStatus, isNormal)
        stageItem:SetCallback(function()
            self:OnSelectStage(i, stageStatus)
        end)
    end
end

function UIDomainsStageMapView:Hide()
    UIBaseView.Hide(self)

    if self.listenerDomain then
        self.listenerDomain:Unsubscribe()
        self.listenerDomain = nil
    end

    if self.listenerChatMessage then
        self.listenerChatMessage:Unsubscribe()
        self.listenerChatMessage = nil
    end
end

function UIDomainsStageMapView:ShowBackgroundByDifficult(difficult)
    local isNormal = true
    if difficult > DomainDifficult.NORMAL then
        isNormal = false
    end
    self.config.normalBackground.gameObject:SetActive(isNormal)
    self.config.hardBackground.gameObject:SetActive(not isNormal)
end

function UIDomainsStageMapView:OnClickChangeDifficult()
    if self.difficult == DomainDifficult.NORMAL then
        self.difficult = DomainDifficult.HARD
    else
        self.difficult = DomainDifficult.NORMAL
    end
    self:ShowBackgroundByDifficult(self.difficult)
    self:ShowStageIslandByDifficult(self.difficult)
end

function UIDomainsStageMapView:OnClickChat()
    local show = function()
        PopupMgr.ShowPopup(UIPopupName.UIChat, ChatLayoutType.DOMAINS)
    end
    ChatData.OnValidateMainMenuChat(show)
end

--- @return DomainStageItem
function UIDomainsStageMapView:GetStageItem(stage)
    --- @type DomainStageItem
    local stageItem = self.stageItemDict:Get(stage)
    if stageItem == nil then
        local anchor = self.config.stages:GetChild(stage - 1)
        local object = U_GameObject.Instantiate(self.config.domainStageItem, anchor)
        stageItem = DomainStageItem(object.transform)
        self.stageItemDict:Add(stage, stageItem)
    end
    return stageItem
end

--- @param stageStatus StageStatus
function UIDomainsStageMapView:OnSelectStage(stage, stageStatus)
    --- @type {callbackBattle, callbackRecord, predefineTeamData}
    local data = {}
    data.day = self.day
    data.stage = stage
    data.listReward = self.domainRewardDayConfig:GetRewardByStage(stage)
    data.predefineTeamData = self.domainInBound:GetPredefineTeam(stage)

    if stageStatus == StageStatus.PASSED then
        data.callbackRecord = function()
            self:OnClickRecord(stage)
        end
    elseif stageStatus == StageStatus.CURRENT then
        if self.domainInBound.domainCrewInBound.leaderId == PlayerSettingData.playerId then
            data.callbackBattle = function()
                PopupMgr.HidePopup(UIPopupName.UIDomainStageInfo)
                self:OnClickBattle(stage)
            end
        end
        data.callbackRecord = function()
            self:OnClickRecord(stage)
        end
    end
    PopupMgr.ShowPopup(UIPopupName.UIDomainStageInfo, data)
end

function UIDomainsStageMapView:ShowListAllowClasses()
    self.listAllowClassesData:Clear()

    for i = 1, self.dailyTeamDomainConfig.classRequire:Count() do
        local classData = {}
        local classId = self.dailyTeamDomainConfig.classRequire:Get(i)
        classData.icon = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconClassHeroes, classId)
        classData.callback = function()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeClass(classId))
        end
        self.listAllowClassesData:Add(classData)
    end

    self.itemsTableView:SetData(self.listAllowClassesData)
    self.itemsTableView:SetSize(75, 75)
end

function UIDomainsStageMapView:OnClickBattle(stage)
    local predefineTeamData = self.domainInBound:GetPredefineTeam(stage)

    local data = {}
    data.stage = stage
    data.gameMode = GameMode.DOMAINS
    data.listHeroResource = self.domainInBound.currentStage
    data.battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(predefineTeamData)

    --- @param uiFormationTeamData UIFormationTeamData
    data.callbackPlayBattle = function(uiFormationTeamData, callback)
        zg.playerData.rewardList = nil

        local crewBattleChallengeOutBound = CrewBattleChallengeOutBound()
        crewBattleChallengeOutBound:SetFormationTeamData(stage, uiFormationTeamData)

        local onReceived = function(result)
            ---@type BattleResultInBound
            local battleResult
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                battleResult = BattleResultInBound.CreateByBuffer(buffer)
            end
            local onSuccess = function()
                InventoryUtils.Sub(ResourceType.Money, MoneyType.DOMAIN_CHALLENGE_STAMINA, 1)

                if callback ~= nil then
                    callback(nil, nil, nil, nil, battleResult.battleLog)
                end
                DomainInBound.Validate(nil, true)
            end
            zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
            NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
        end
        NetworkUtils.Request(OpCode.CREW_CHALLENGE, crewBattleChallengeOutBound, onReceived)
    end
    data.callbackClose = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIDomainsStageMap, nil, UIPopupName.UIFormation)
        PopupMgr.ShowPopup(UIPopupName.UIDomainStageInfo)
    end
    PopupMgr.ShowAndHidePopup(UIPopupName.UIFormation, data, self.model.uiName)
end

function UIDomainsStageMapView:OnClickRecord(stage)
    DomainRecordData.Validate(function()
        zg.playerData.rewardList = nil

        local domainStageRecordData = self.domainInBound.domainRecordData:GetStageRecordData(stage)
        if domainStageRecordData == nil then
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeLogicCode(LogicCode.RECORD_NOT_FOUND))
            return
        end

        --- @type PredefineTeamData
        local predefineTeamData = self.domainInBound:GetPredefineTeam(stage)
        --- @type BattleTeamInfo
        local attackerTeamInfo = domainStageRecordData.compactPlayerInfo:CreateBattleTeamInfo()
        --- @type BattleTeamInfo
        local defenderTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(predefineTeamData)
        local randomHelper = RandomHelper()
        randomHelper:SetSeed(domainStageRecordData.seedInBound.seed)
        zg.battleMgr:RunVirtualBattle(attackerTeamInfo, defenderTeamInfo, GameMode.DOMAINS, randomHelper, RunMode.FASTEST, domainStageRecordData.battleLog)
        if domainStageRecordData == BattleConstants.ATTACKER_TEAM_ID
                and ClientBattleData.battleResult.winnerTeam ~= BattleConstants.ATTACKER_TEAM_ID then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("play_record_failed"))
            zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
            return
        end
        PopupMgr.HidePopup(self.model.uiName)

        zg.playerData.rewardList = nil
        zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
        ClientBattleData.skipForReplay = true
        randomHelper:SetSeed(domainStageRecordData.seedInBound.seed)
        zg.battleMgr:RunCalculatedBattleScene(attackerTeamInfo, defenderTeamInfo, GameMode.DOMAINS, randomHelper, nil, domainStageRecordData.battleLog)
    end)
end

--- @param data {}
function UIDomainsStageMapView:DomainUpdated(data)
    local serverNotificationType = data.serverNotificationType
    if serverNotificationType == ServerNotificationType.DOMAINS_CREW_CHALLENGE_UPDATED then
        self:OnReadyShow()

        PopupMgr.HidePopup(UIPopupName.UIDomainStageInfo)

        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("data_updated"))

        self.domainInBound.domainRecordData.lastTimeUpdated = nil
    elseif (serverNotificationType == ServerNotificationType.DOMAINS_CREW_UPDATED) then
        self:ShowLeaderInfo()
        -- XDebug.Log("show noti here")
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("domain_leader_updated"))
    else
        XDebug.Error("Need define " .. serverNotificationType)
    end
end

function UIDomainsStageMapView:CheckShowChallengeOver()
    if self.domainInBound:IsValidShowChallengeOver() then
        PopupMgr.ShowAndHidePopup(UIPopupName.UIDomainChallengeOver, nil, UIPopupName.UIChat, UIPopupName.UIDomainStageInfo)
    end

    zg.playerData.remoteConfig.lastTimeChallengeDomain = self.domainInBound.lastTimeChallenge
    zg.playerData:SaveRemoteConfig()
end

function UIDomainsStageMapView:CheckNotificationChat()
    local chatData = zg.playerData:GetChatData()
    chatData:CheckNotificationDomains()
    self.config.notifyChat:SetActive(chatData.isNotifyDomainTeam)

    if chatData.isNotifyDomainTeam ~= true then
        ChatRequest.SubscribeChat()
    end
end
function UIDomainsStageMapView:OnClickChangeLeader()
    PopupMgr.ShowPopup(UIPopupName.UIGuildChangeLeaderInGame)
end
function UIDomainsStageMapView:ShowLeaderInfo()
    ---@type DomainsCrewMember
    local leader = self:GetLeaderCrewBasicInfo()
    local leaderId = self.domainInBound.domainCrewInBound.leaderId
    local meIsLeader = PlayerSettingData.playerId == leaderId

    if self.iconVip == nil then
        self.iconVip = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.iconUser)
    end
    if (meIsLeader) then
        ---@type BasicInfoInBound
        local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
        self.iconVip:SetData(basicInfoInBound.avatarData:GetAvatar(), basicInfoInBound.level, basicInfoInBound.avatarData:GetFrame())
        self.config.textLeaderName.text = basicInfoInBound.name
    else
        self.iconVip:SetData(leader.avatarData:GetAvatar(), leader.playerLevel, leader.avatarData:GetFrame())
        self.config.textLeaderName.text = leader.playerName
    end

    self.config.buttonChangeLeader.gameObject:SetActive(meIsLeader)
end