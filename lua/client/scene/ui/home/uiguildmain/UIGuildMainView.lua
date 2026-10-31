require "lua.client.scene.ui.home.uiGuildMain.UIGuildMemberSlotItemView"

--- @class UIGuildMainView : UIBaseView
UIGuildMainView = Class(UIGuildMainView, UIBaseView)

--- @return void
--- @param model UIGuildMainModel
function UIGuildMainView:Ctor(model)
    --- @type UIGuildMainConfig
    self.config = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type GuildBasicInfoInBound
    self.guildBasicInfo = nil
    --- @type GuildApplicationInBound
    self.guildApplicationInBound = nil
    --- @type MotionConfig
    self.motionConfig = MotionConfig()
    --- @type boolean
    self.canPlayMotion = nil
    UIBaseView.Ctor(self, model)
    --- @type UIGuildMainModel
    self.model = model
end

--- @return void
function UIGuildMainView:OnReadyCreate()
    ---@type UIGuildMainConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:_InitButtonListener()

    self:_InitScrollView()

    uiCanvas:SetBackgroundSize(self.config.bg)
end

--- @return void
function UIGuildMainView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("guild_hall")
    self.config.localizeRecruit.text = LanguageUtils.LocalizeCommon("recruit")
    self.config.localizeApplication.text = LanguageUtils.LocalizeCommon("application")
    self.config.localizeCheckin.text = LanguageUtils.LocalizeCommon("checkin")
    self.config.textLevel.text = LanguageUtils.LocalizeCommon("level")
    self.config.textQuest.text = LanguageUtils.LocalizeCommon("quest")
end

function UIGuildMainView:_InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonCheckin.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCheckIn()
    end)
    self.config.buttonRecruit.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRecruit()
    end)
    self.config.buttonLog.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickGuildLog()
    end)
    self.config.buttonSetting.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSetting()
    end)
    self.config.buttonApplication.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickApplication()
    end)
    self.config.buttonGuildShop.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickGuildShop()
    end)
    self.config.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
    self.config.buttonQuest.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickQuest()
    end)
end


function UIGuildMainView:_InitScrollView()
    --- @param obj UIGuildMemberSlotItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type GuildMemberInBound
        local memberInfo = self.guildBasicInfo:GetMemberByIndex(dataIndex)
        if memberInfo ~= nil then
            obj.popupName = UIPopupName.UIGuildMain
            obj:SetData(memberInfo, self.guildBasicInfo:GetMemberRoleById(memberInfo.playerId),
                    zg.timeMgr:GetServerTime(),
                    function()
                        self:OnSelectMember(memberInfo)
                    end)
        end
    end
    --- @param obj UIGuildMemberSlotItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        onCreateItem(obj, index)
    end
    self.uiScroll = UILoopScroll(self.config.memberScroll, UIPoolType.MemberSlotItemView, onCreateItem, onUpdateItem)
    self.uiScroll:SetUpMotion(MotionConfig())
end


function UIGuildMainView:OnClickQuest()
    if self.guildQuestModel ~= nil then
        if  self.guildQuestModel.isInGuild and self.guildQuestModel.isHaveEventTime and self.guildQuestModel.isInEventTime then
            local data = {}
            data.guildQuestModel = self.guildQuestModel
            PopupMgr.ShowPopup(UIPopupName.UIGuildQuest,data)

        else
            if self.guildQuestModel.isHaveEventTime then
                local remainTime
                if self.guildQuestModel.timeData.startTime >= zg.timeMgr:GetServerTime() then
                    remainTime = self.guildQuestModel.timeData.startTime - zg.timeMgr:GetServerTime()
                else
                    remainTime= self.guildQuestModel.eventTimePlan.startTime - zg.timeMgr:GetServerTime()
                end
                local content =  string.format("%s %s",LanguageUtils.LocalizeCommon("will_open_in"),
                        UIUtils.SetColorString(UIUtils.green_dark,
                                TimeUtils.GetDeltaTime( remainTime, 4)))
                SmartPoolUtils.ShowShortNotification(content)
            else
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("guild_quest_end"))
            end
        end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("guild_quest_end"))
    end
end



function UIGuildMainView:OnClickCheckIn()
    local onReceived = function(result)
        local onSuccess = function()
            self:ClaimCheckInReward()
            local guildInfo = self.guildBasicInfo.guildInfo
            local isGuildLevelUp = self.guildBasicInfo:SetCheckInMember(PlayerSettingData.playerId, ResourceMgr.GetGuildDataConfig().guildBonusExpCheckIn)
            if isGuildLevelUp == true then
                guildInfo.guildExp = guildInfo.guildExp - self.guildBasicInfo:GetMaxExpToRaiseLevel()
                guildInfo.guildLevel = guildInfo.guildLevel + 1
                self.model.guildLevelUnit = ResourceMgr.GetGuildDataConfig().guildLevel:GetGuildLevelUnitConfig(guildInfo.guildLevel)
            end
            self:ShowGuildLevelExp()
            self.uiScroll:RefreshCells()
            self.guildBasicInfo.isAvailableToCheckIn = false
            self:CheckShowButtonCheckIn()
            self.guildBasicInfo.lastTimeRequest = zg.timeMgr:GetServerTime()
        end
        --- @param logicCode LogicCode
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if logicCode == LogicCode.GUILD_MEMBER_ALREADY_CHECK_IN then
                self:EnableButtonCheckIn(false)
            end
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.GUILD_CHECK_IN, nil, onReceived)
end

function UIGuildMainView:ClaimCheckInReward()
    --- @type ItemIconData
    local checkInReward = ResourceMgr.GetGuildDataConfig():GetCheckInRewardConfig():GetIconData()
    checkInReward:AddToInventory()
    SmartPoolUtils.ShowReward1Item(checkInReward)
end

function UIGuildMainView:OnClickRecruit()
    PopupMgr.ShowPopup(UIPopupName.UIGuildRecruit)
end

function UIGuildMainView:OnClickGuildLog()
    local callback = function()
        PopupMgr.ShowPopup(UIPopupName.UIGuildLog)
        --- @type GuildLogDataInBound
        local guildLogDataInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_LOG)
        local lastNotifiableLog = guildLogDataInBound:GetTheLastNotifiableLog()
        if lastNotifiableLog ~= nil
                and lastNotifiableLog.createdTimeInSec ~= guildLogDataInBound.lastTimeUpdatedLog then
            local onSuccess = function()
                guildLogDataInBound.lastTimeUpdatedLog = lastNotifiableLog.createdTimeInSec
                self.config.notifyLog:SetActive(false)
            end
            GuildLogDataInBound.SetLastTimeGuildMemberChange(lastNotifiableLog.createdTimeInSec, onSuccess)
        end
    end
    GuildLogDataInBound.Validate(callback)
end

function UIGuildMainView:OnClickSetting()
    PopupMgr.ShowPopup(UIPopupName.UIGuildFoundation, { ["isSetting"] = true, ["avatar"] = self.guildBasicInfo.guildInfo.guildAvatar })
end

function UIGuildMainView:OnClickApplication()
    PopupMgr.ShowPopup(UIPopupName.UIGuildApplication)
    --- @type GuildApplicationInBound
    local guildApplicationInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_APPLICATION)
    --- @type GuildApplicationItemInBound
    local lastCreateApplication = guildApplicationInBound.listApplicationItem:Get(guildApplicationInBound.listApplicationItem:Count())
    if lastCreateApplication ~= nil
            and guildApplicationInBound.lastSavedCreatedApplication < lastCreateApplication.createdTime then
        local onSuccess = function()
            guildApplicationInBound.lastSavedCreatedApplication = lastCreateApplication.createdTime
            self.config.notiApplications:SetActive(false)
        end
        GuildApplicationInBound.SetLastCreatedGuildApplication(lastCreateApplication.createdTime, onSuccess)
    end
end

function UIGuildMainView:OnReadyShow()
    self.guildQuestModel = nil
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
            require "lua.client.core.network.playerData.guildQuest.GuildQuestData"
            self.guildQuestModel = GuildQuestData(buffer)
    end
    NetworkUtils.RequestAndCallback(OpCode.EVENT_GUILD_QUEST_DATA_GET,nil, nil,nil,onBufferReading)
    self.canPlayMotion = true
    self:ShowGuildInfo()
    self:RemoveGuildMemberKickEvent()
    self.serverNotificationListener = RxMgr.guildMemberKicked:Subscribe(RxMgr.CreateFunction(self, self.OnServerNotification))
    self.updateGuildInfoListener = RxMgr.updateGuildInfo:Subscribe(RxMgr.CreateFunction(self, self.CallUpdateGuildInfo))
end

function UIGuildMainView:ShowButtonByRole()
    local selfRole = self.guildBasicInfo.guildInfo.selfRole
    self.config.buttonRecruit.gameObject:SetActive(selfRole == GuildRole.LEADER or selfRole == GuildRole.SUB_LEADER)
    self.config.buttonApplication.gameObject:SetActive(selfRole ~= GuildRole.MEMBER)
end

--- @return void
function UIGuildMainView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIGuildArea, nil, self.model.uiName)
end

function UIGuildMainView:RemoveGuildMemberKickEvent()
    if self.serverNotificationListener ~= nil then
        self.serverNotificationListener:Unsubscribe()
        self.serverNotificationListener = nil
    end
    if self.updateGuildInfoListener ~= nil then
        self.updateGuildInfoListener:Unsubscribe()
        self.updateGuildInfoListener = nil
    end
end

function UIGuildMainView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UIGuildMainView:Hide()
    UIBaseView.Hide(self)
    self:RemoveGuildMemberKickEvent()
end

--- @param forceUpdate boolean
function UIGuildMainView:ShowGuildInfo(forceUpdate)
    local callback = function()
        --- @type GuildBasicInfoInBound
        self.guildBasicInfo = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
        --- @type GuildLevelUnit
        self.model.guildLevelUnit = ResourceMgr.GetGuildDataConfig().guildLevel:GetGuildLevelUnitConfig(self.guildBasicInfo.guildInfo.guildLevel)
        local guildInfoInBound = self.guildBasicInfo.guildInfo

        self.config.textGuildName.text = guildInfoInBound.guildName
        self.config.textGuildId.text = string.format("<color=#A48D6F>%s:</color> %d", LanguageUtils.LocalizeCommon("id"), guildInfoInBound.guildId)
        self.config.guildSubscription.text = guildInfoInBound.guildDescription

        self:ShowGuildMemberCount(guildInfoInBound.listGuildMember:Count())
        self:ShowGuildLevelExp()
        self.uiScroll:Resize(guildInfoInBound.listGuildMember:Count())
        self:PlayMotion()
        self.config.iconLogo.sprite = ResourceLoadUtils.LoadGuildIcon(guildInfoInBound.guildAvatar)

        self:ShowButtonByRole()
        self:CheckShowButtonCheckIn()
        self:CheckAllNotification()
    end
    GuildBasicInfoInBound.Validate(callback, forceUpdate)
end

function UIGuildMainView:ShowGuildLevelExp()
    local guildInfoInBound = self.guildBasicInfo.guildInfo
    self.config.textLevelValue.text = tostring(guildInfoInBound.guildLevel)

    local maxGuildLevel = ResourceMgr.GetGuildDataConfig().guildLevel:GetGuildMaxLevel()
    if guildInfoInBound.guildLevel >= maxGuildLevel then
        self.config.textExp.text = LanguageUtils.LocalizeCommon("max")
        self.config.expSlider.fillAmount = 1
    else
        self.config.textExp.text = string.format("%d/%d", guildInfoInBound.guildExp, self.guildBasicInfo:GetMaxExpToRaiseLevel())
        self.config.expSlider.fillAmount = guildInfoInBound.guildExp / self.guildBasicInfo:GetMaxExpToRaiseLevel()
    end
end

function UIGuildMainView:OnGuildMemberChange()
    self:ShowGuildInfo(true)
    if self.guildBasicInfo.guildInfo.selfRole == GuildRole.LEADER
            or self.guildBasicInfo.guildInfo.selfRole == GuildRole.SUB_LEADER then
        --- @type GuildLogDataInBound
        local guildLogDataInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_LOG)
        guildLogDataInBound.lastTimeRequest = nil
    end
end

--- @param memId number
function UIGuildMainView:GetRoleName(memId)
    --- @type GuildRole
    local memberRole = self.guildBasicInfo:GetMemberRoleById(memId)
    return GuildRole.RoleName(memberRole)
end

--- @param memberInfo GuildMemberInBound
function UIGuildMainView:OnSelectMember(memberInfo)
    if PlayerSettingData.playerId == memberInfo.playerId then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("player_already_show_info"))
        return
    end
    --- @param otherPlayerInfoInBound OtherPlayerInfoInBound
    local onLoadMemberDefenderTeam = function(otherPlayerInfoInBound)
        PopupMgr.ShowPopup(UIPopupName.UIGuildMemberInfo,
                { ["guildMemberInBound"] = memberInfo,
                  ["selfRole"] = self.guildBasicInfo.guildInfo.selfRole,
                  ["memberRole"] = self.guildBasicInfo:GetMemberRoleById(memberInfo.playerId),
                  ["otherPlayerInfoInBound"] = otherPlayerInfoInBound })
    end
    NetworkUtils.SilentRequestOtherPlayerInfoInBoundByGameMode(memberInfo.playerId, GameMode.ARENA, onLoadMemberDefenderTeam)
end

function UIGuildMainView:OnServerNotification()
    self:OnLeftGuild()
    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("guild_was_kicked"))
end

function UIGuildMainView:ShowGuildMemberCount(memberCount)
    self.config.textMember.text = string.format("<color=#A48D6F>%s:</color> %d/%d", LanguageUtils.LocalizeCommon("member"), memberCount, self.model.guildLevelUnit.maxMember)
end

function UIGuildMainView:OnClickGuildShop()
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.BLACK_MARKET) then
        TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.GUILD, "shop")
        PopupMgr.ShowAndHidePopup(UIPopupName.UIMarket, {
            ["marketType"] = MarketType.GUILD_MARKET,
            ["callbackClose"] = function()
                PopupMgr.ShowAndHidePopup(self.model.uiName, nil, UIPopupName.UIMarket)
            end
        }, self.model.uiName)
    end
end

function UIGuildMainView:OnClickHelpInfo()
    local info = LanguageUtils.LocalizeHelpInfo("guild_info")
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

function UIGuildMainView:CheckShowButtonCheckIn()
    self:EnableButtonCheckIn(self.guildBasicInfo.isAvailableToCheckIn)
end

function UIGuildMainView:CheckAllNotification()
    self:_CheckShowNotifyApplication()
end

--- @param fixedActive boolean
function UIGuildMainView:_CheckShowNotifyApplication(fixedActive)
    if fixedActive ~= nil then
        self.config.notiApplications:SetActive(fixedActive)
    end
    if self.guildBasicInfo.guildInfo.selfRole ~= GuildRole.MEMBER then
        local callback = function()
            self.guildApplicationInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_APPLICATION)
            local callbackNotify = function(isNotified)
                self.config.notiApplications:SetActive(isNotified)
                self:_CheckNotificationLog()
            end
            self.guildApplicationInBound:CheckNotify(callbackNotify)
        end
        GuildApplicationInBound.Validate(callback)
    end
end

--- @param fixedActive boolean
function UIGuildMainView:_CheckNotificationLog(fixedActive)
    if fixedActive ~= nil then
        self.config.notifyLog:SetActive(fixedActive)
        return
    end
    self.config.notifyLog:SetActive(false)
    local callback = function()
        local selfRole = self.guildBasicInfo.guildInfo.selfRole
        if selfRole == GuildRole.LEADER or selfRole == GuildRole.SUB_LEADER then
            local onSuccess = function()
                --- @type GuildLogDataInBound
                local guildLogDataInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_LOG)
                local lastNotifiableLog = guildLogDataInBound:GetTheLastNotifiableLog()
                if lastNotifiableLog == nil then
                    return
                end
                if lastNotifiableLog.createdTimeInSec ~= guildLogDataInBound.lastTimeUpdatedLog then
                    self.config.notifyLog:SetActive(true)
                end
            end
            GuildLogDataInBound.GetLastTimeGuildMemberChange(onSuccess, nil)
        end
    end
    GuildLogDataInBound.Validate(callback)
end

--- @param isEnable boolean
function UIGuildMainView:EnableButtonCheckIn(isEnable)
    self.config.buttonCheckin.gameObject:SetActive(isEnable)
end

function UIGuildMainView:OnLeftGuild()
    --- @type GuildWarInBound
    local guildWarInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR)
    if guildWarInBound ~= nil then
        guildWarInBound:OnLeftGuild()
    end
    GuildBasicInfoInBound.Validate(nil, true)
    PopupUtils.BackToMainArea()
end

--- @param data {fixedActiveGuildLogNotify : boolean, forceShowGuildInfo : boolean}
function UIGuildMainView:CallUpdateGuildInfo(data)
    self:OnGuildMemberChange()
    if data ~= nil then
        local fixedActiveGuildLogNotify = data.fixedActiveGuildLogNotify
        self:_CheckNotificationLog(fixedActiveGuildLogNotify)

        if data.forceShowGuildInfo == true then
            self:ShowGuildInfo(true)
        end
    end
end

function UIGuildMainView:PlayMotion()
    if self.canPlayMotion == true then
        self.uiScroll:PlayMotion()
        self.canPlayMotion = false
    end
end