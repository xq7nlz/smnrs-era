require "lua.client.scene.ui.home.uiEventBossChallenge.eventLayout.UIEventBossChallengeLayout"

--- @class UIEventBossChallengeView : UIBaseView
UIEventBossChallengeView = Class(UIEventBossChallengeView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

--- @param model UIEventBossChallengeModel
function UIEventBossChallengeView:Ctor(model)
    --- @type UIEventBossChallengeConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollLoopTab = nil
    --- @type UILoopScroll
    self.scrollLoopContent = nil

    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type
    self.layout = nil

    --- @type Dictionary
    self.eventTabDict = Dictionary()
    --- @type EventBossChallengeModel
    self.eventModel = nil
    ---@type EventBossChallengeConfig
    self.eventConfig = nil

    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BOSS_CHALLENGE
    --- @type boolean
    self.isReloadingData = nil
    UIBaseView.Ctor(self, model)
    --- @type UIEventBossChallengeModel
    self.model = model
end

function UIEventBossChallengeView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtons()
    self:InitScrollTab()
end

function UIEventBossChallengeView:InitButtons()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.help.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function UIEventBossChallengeView:InitScrollTab()
    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type EventBossChallengeTab
        local eventBossChallengeTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetText(self:GetEventName(eventBossChallengeTab))
        obj:SetSelectState(self:IsTabChosen(eventBossChallengeTab))
        obj:SetIcon(self:GetEventIcon(eventBossChallengeTab))
        obj:SetNotificationFunction(function()
        	return self:GetEventNotification(eventBossChallengeTab)
        end)
        obj:SetEndEventTime(self:GetEventEndTime(eventBossChallengeTab), function()
        	self:OnEventTimeEnded()
        end)
        obj:AddOnSelectListener(function()
            self:OnClickSelectTab(eventBossChallengeTab)
        end)
        --obj:SetPivot(pivotTab)
        self.eventTabDict:Add(eventBossChallengeTab, obj)
    end

    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type EventBossChallengeTab
        local eventBossChallengeTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetSelectState(self:IsTabChosen(eventBossChallengeTab))
    end
    self.scrollLoopTab = UILoopScroll(self.config.scrollTabContent, UIPoolType.EventPackageTabItem,
            onCreateItem, onUpdateItem)
    self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

function UIEventBossChallengeView:InitLocalization()

end

function UIEventBossChallengeView:OnReadyShow(result)
    self.isReloadingData = false
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    self.isOpen = self.eventModel:IsOpening()
    if self.isOpen then
    	self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
    end
    self:CheckEndSeasonDisplay()
    self:CheckResourceOnSeason()
    self.isOpen = true
    self.model:InitListSubEvent()
    if self.isOpen then
        if self.model.listSubEvent:Count() > 0 then
            if result ~= nil and result.tab ~= nil then
                self:OnClickSelectTab(result.tab)
            else
                self:SelectTab(self.model.listSubEvent:Get(1))
            end
            self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
            self:CheckAllNotificationTab()
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
            self:OnReadyHide()
        end
    else
        self:SelectTab(self.model.listSubEvent:Get(1))
    end
end

function UIEventBossChallengeView:CheckEndSeasonDisplay()
    --self.config.VerticalScrollTab.gameObject:SetActive(self.isOpen)
end

function UIEventBossChallengeView:CheckResourceOnSeason()
    local endTime = self.eventModel.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventLunarNewYearEnd or endTime
    if savedEndSeason ~= endTime then
        self:ClearMoneyType()
    end
    zg.playerData.remoteConfig.eventLunarNewYearEnd = endTime
    zg.playerData:SaveRemoteConfig()
end

function UIEventBossChallengeView:ClearMoneyType()
    local clearResource = function(moneyType)
        local currentValue = InventoryUtils.Get(ResourceType.Money, moneyType)
        InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
    end
end

function UIEventBossChallengeView:OnClickSelectTab(eventBossChallengeTab)
    if self:IsTabChosen(eventBossChallengeTab) then
        return
    end
    self:SelectTab(eventBossChallengeTab)
end

function UIEventBossChallengeView:SelectTab(eventBossChallengeTab)
    self:GetLayout(eventBossChallengeTab)
    self.layout:OnShow()
    self:CheckAllNotificationTab()
    self.scrollLoopTab:RefreshCells()
end

--- @param eventBossChallengeTab EventBossChallengeTab
function UIEventBossChallengeView:GetLayout(eventBossChallengeTab)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(eventBossChallengeTab)
    if self.layout == nil then
        if eventBossChallengeTab == EventBossChallengeTab.CHALLENGE_TOWER then
            require "lua.client.scene.ui.home.uiEventBossChallenge.eventLayout.challenge_tower.UIBossChallengeTowerLayout"
            self.layout = UIBossChallengeTowerLayout(self, eventBossChallengeTab, self.config.challenge_tower)
        elseif eventBossChallengeTab == EventBossChallengeTab.PREMIUM_PASS then
            require "lua.client.scene.ui.home.uiEventBossChallenge.eventLayout.premium_pass.UIBossChallengePremiumPassLayout"
            self.layout = UIBossChallengePremiumPassLayout(self, eventBossChallengeTab, self.config.premium_pass)
        elseif eventBossChallengeTab == EventBossChallengeTab.BOSS_PACK then
            require "lua.client.scene.ui.home.uiEventBossChallenge.eventLayout.shop.UIBossChallengeShopLayout"
            self.layout = UIBossChallengeShopLayout(self, eventBossChallengeTab, self.config.boss_pack)
        elseif eventBossChallengeTab == EventBossChallengeTab.BOSS_QUEST then
            require "lua.client.scene.ui.home.uiEventBossChallenge.eventLayout.quest.UIBossChallengeQuestLayout"
            self.layout = UIBossChallengeQuestLayout(self, eventBossChallengeTab, self.config.boss_quest)
        elseif eventBossChallengeTab == EventBossChallengeTab.BOSS_LEADER_BOARD then
            require "lua.client.scene.ui.home.uiEventBossChallenge.eventLayout.leader_board.UIBossChallengeLeaderBoardLayout"
            self.layout = UIBossChallengeLeaderBoardLayout(self, eventBossChallengeTab, self.config.leader_board)
        else
            require "lua.client.scene.ui.home.uiEventBossChallenge.eventLayout.challenge_tower.UIBossChallengeTowerLayout"
            self.layout = UIBossChallengeTowerLayout(self, eventBossChallengeTab, self.config.challenge_tower)
        end
        self.layoutDict:Add(eventBossChallengeTab, self.layout)
    end
end

function UIEventBossChallengeView:DisableCommon()
    self:HideCurrentLayout()
end

function UIEventBossChallengeView:OnClickHelpInfo()
    ---@type EventTimeData
    local timeData = self.eventModel.timeData
    local dayStart = TimeUtils.GetDateMonthYearFromTimestamp(timeData.startTime)
    local dayEnd = TimeUtils.GetDateMonthYearFromTimestamp(timeData.endTime)
    local content = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeHelpInfo("event_boss_challenge_info", dayStart, dayEnd),
            LanguageUtils.LocalizeCommon("event_boss_challenge_tower"),
            LanguageUtils.LocalizeCommon("event_boss_challenge_leader_board"),
            LanguageUtils.LocalizeCommon("event_boss_challenge_quest"),
            LanguageUtils.LocalizeCommon("event_boss_challenge_bundle"))
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

--- @param eventBossChallengeTab EventBossChallengeTab
function UIEventBossChallengeView:GetEventName(eventBossChallengeTab)
    if eventBossChallengeTab == EventBossChallengeTab.BOSS_LEADER_BOARD then
        return LanguageUtils.LocalizeCommon("event_boss_challenge_leader_board_title")
    elseif eventBossChallengeTab == EventBossChallengeTab.BOSS_QUEST then
        return LanguageUtils.LocalizeCommon("event_boss_challenge_boss_quest")
    elseif eventBossChallengeTab == EventBossChallengeTab.BOSS_PACK then
        return LanguageUtils.LocalizeCommon("event_boss_challenge_shop")
    elseif eventBossChallengeTab == EventBossChallengeTab.CHALLENGE_TOWER then
        return LanguageUtils.LocalizeCommon("event_boss_challenge_challenge_tower")
    elseif eventBossChallengeTab == EventBossChallengeTab.PREMIUM_PASS then
        return LanguageUtils.LocalizeCommon("event_boss_challenge_premium_pass")
    else
        return LanguageUtils.LocalizeCommon("event_boss_challenge_leader_board")
    end
end

--- @param eventBossChallengeTab EventBossChallengeTab
function UIEventBossChallengeView:IsTabChosen(eventBossChallengeTab)
    return self.layout ~= nil and self.layout.eventBossChallengeTab == eventBossChallengeTab
end

--- @param eventBossChallengeTab EventBossChallengeTab
function UIEventBossChallengeView:GetEventIcon(eventBossChallengeTab)
    return ResourceLoadUtils.LoadEventKazetsu(eventBossChallengeTab)
end

--- @param eventBossChallengeTab EventBossChallengeTab
function UIEventBossChallengeView:GetEventNotification(eventBossChallengeTab)
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    return self.eventModel:IsTabNotified(eventBossChallengeTab)
end

function UIEventBossChallengeView:GetEventEndTime()
    return self.eventModel.timeData.endTime
end

function UIEventBossChallengeView:OnEventTimeEnded()
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventModel:GetType(), ["isAdded"] = false })
end

function UIEventBossChallengeView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UIEventBossChallengeView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventBossChallengeView:CheckAllNotificationTab()
    local updateModel = function()
    	self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    end

    EventInBound.ValidateEventModel(updateModel)
    --- @param v EventBossChallengeTab
    --- @param v UIEventPackageTabItem
    for k, v in pairs(self.eventTabDict:GetItems()) do
        self:UpdateNotificationByTab(k)
    end
end

--- @param eventBossChallengeTab EventBossChallengeTab
function UIEventBossChallengeView:UpdateNotificationByTab(eventBossChallengeTab)
    --- @type UIEventPackageTabItem
    local objTab = self.eventTabDict:Get(eventBossChallengeTab)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventBossChallengeView:OnEventStateChange(data)
    local isAdded = data.isAdded
    if isAdded == false and self.isReloadingData ~= true then
        self.isReloadingData = true
        EventInBound.ValidateEventModel(function()
            ---@type EventNewYearModel
            local eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
            if eventModel:IsOpening() then
                self:HideCurrentLayout()
                self:RemoveListener()
                self:OnReadyShow()
            else
                if PopupUtils.IsPopupShowing(self.model.uiName) == false then
                    return
                end
                PopupMgr.HidePopup(self.model.uiName)
                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
            end
        end, true)
    end
end

function UIEventBossChallengeView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListener()

    self:HideCurrentLayout()

    self:HideScrollTab()
end

function UIEventBossChallengeView:HideScrollTab()
    self.scrollLoopTab:Hide()
    self.eventTabDict:Clear()
end

function UIEventBossChallengeView:RemoveListener()
    if self.eventListener ~= nil then
        self.eventListener:Unsubscribe()
        self.eventListener = nil
    end
end

function UIEventBossChallengeView:HideCurrentLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end
