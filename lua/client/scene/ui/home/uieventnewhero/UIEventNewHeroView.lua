require "lua.client.scene.ui.home.uiEventNewHero.eventHeroNewLayout.UIEventNewHeroLayout"

--- @class UIEventNewHeroView : UIBaseView
UIEventNewHeroView = Class(UIEventNewHeroView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

function UIEventNewHeroView:Ctor(model)
    --- @type UIEventNewHeroConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollLoopTab = nil
    --- @type UILoopScroll
    self.scrollLoopContent = nil

    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIEventNewHeroLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()

    ---@type UnityEngine_Sprite
    self.defaultBg = nil
    ---@type UnityEngine_Sprite
    self.defaultCol = nil

    --- @type boolean
    self.isReloadingData = nil
    UIBaseView.Ctor(self, model)
    --- @type UIEventNewHeroModel
    self.model = model
end

function UIEventNewHeroView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self.defaultBg = self.config.backGround.sprite
    self.defaultCol = self.config.bgColumn1.sprite
    self:_InitButtonListener()
    self:_InitScrollTab()
end

function UIEventNewHeroView:InitLocalization()
    if self.layoutDict ~= nil then
        --- @param v UIEventNewHeroLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIEventNewHeroView:_InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
end

function UIEventNewHeroView:_InitScrollTab()
    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local index = index + 1
        --- @type EventPopupModel
        local eventPopupModel = self.model.eventDataList:Get(index)
        --- @type EventTimeType
        local eventTimeType = eventPopupModel.timeData.eventType
        obj:SetText(self:_GetEventName(eventTimeType))
        obj:SetSelectState(self:_IsTabChosen(eventTimeType))
        obj:SetIcon(self:GetEventTabIcon(eventPopupModel))
        obj:SetNotificationFunction(function()
            return eventPopupModel:HasNotification()
        end)
        obj:SetEndEventTime(eventPopupModel.timeData.endTime, function()
            RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
        end)
        obj:AddOnSelectListener(function()
            self:OnClickSelectTab(eventTimeType)
        end)
        obj:SetPivot(pivotTab)
        self.eventTabDict:Add(eventTimeType, obj)
    end

    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local index = index + 1
        --- @type EventPopupModel
        local eventPopupModel = self.model.eventDataList:Get(index)
        --- @type EventTimeType
        local eventTimeType = eventPopupModel.timeData.eventType
        obj:SetSelectState(self:_IsTabChosen(eventTimeType))
    end
    self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
    self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param eventTimeType EventTimeType
function UIEventNewHeroView:_IsTabChosen(eventTimeType)
    return self.layout ~= nil and self.layout.eventTimeType == eventTimeType
end

function UIEventNewHeroView:OnReadyShow(result)
    self.model:GetData()
    if self.model.eventDataList:Count() == 0 then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        self:OnReadyHide()
        return
    end
    self.scrollLoopTab:Resize(self.model.eventDataList:Count())
    self.scrollLoopTab:PlayMotion()
    self:SetupBg()

    if result ~= nil and result.eventType ~= nil then
        self:SelectTab(result.eventType)
    else
        --- @type EventPopupModel
        local eventPopupModel = self.model.eventDataList:Get(1)
        self:SelectTab(eventPopupModel.timeData.eventType)
    end
    self.layout:PlayMotion()

    self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
    self.notificationEvent = RxMgr.notificationEventPopup:Subscribe(RxMgr.CreateFunction(self, self.UpdateNotificationOnTabs))
end

function UIEventNewHeroView:SetupBg()
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_SUMMON)
    local dataId = eventModel.timeData.dataId

    local bg = ResourceLoadUtils.LoadTexture("BgEventNewHero", tostring(dataId), ComponentName.UnityEngine_Sprite)
    if bg == nil then
        self.config.backGround.sprite = self.defaultBg
    else
        self.config.backGround.sprite = bg
    end

    local bg = ResourceLoadUtils.LoadTexture("CollumnEventNewHero", tostring(dataId), ComponentName.UnityEngine_Sprite)

    self.config.bgColumn1.sprite = bg
    self.config.bgColumn2.sprite = bg

    local posCol1 = self.config.bgColumn1.rectTransform.anchoredPosition3D
    local posCol2 = self.config.bgColumn2.rectTransform.anchoredPosition3D
    if dataId == 4 then
        self.config.bgColumn1.rectTransform.sizeDelta = U_Vector2(self.config.bgColumn1.sprite.bounds.size.x * 100,
                self.config.bgColumn1.rectTransform.sizeDelta.y)
        self.config.bgColumn1.rectTransform.anchoredPosition3D = U_Vector3(-524.4, posCol1.y, 0)

        self.config.bgColumn2.rectTransform.sizeDelta = U_Vector2(self.config.bgColumn2.sprite.bounds.size.x * 100,
                self.config.bgColumn2.rectTransform.sizeDelta.y)
        self.config.bgColumn2.rectTransform.anchoredPosition3D = U_Vector3(861, posCol2.y, 0)
    else
        self.config.bgColumn1.rectTransform.sizeDelta = U_Vector2(self.config.bgColumn1.sprite.bounds.size.x * 100,
                self.config.bgColumn1.rectTransform.sizeDelta.y)
        self.config.bgColumn1.rectTransform.anchoredPosition3D = U_Vector3(-617.4, posCol1.y, 0)

        self.config.bgColumn2.rectTransform.sizeDelta = U_Vector2(self.config.bgColumn2.sprite.bounds.size.x * 100,
                self.config.bgColumn2.rectTransform.sizeDelta.y)
        self.config.bgColumn2.rectTransform.anchoredPosition3D = U_Vector3(947.82, posCol2.y, 0)
    end
end

function UIEventNewHeroView:SelectTab(eventTimeType)
    self:GetLayout(eventTimeType)
    self.layout:OnShow()
    self.scrollLoopTab:RefreshCells()
end

function UIEventNewHeroView:OnClickSelectTab(eventTimeType)
    if self:_IsTabChosen(eventTimeType) then
        return
    end
    self:SelectTab(eventTimeType)
end

--- @param eventTimeType EventTimeType
function UIEventNewHeroView:GetLayout(eventTimeType)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(eventTimeType)
    if self.layout == nil then
        if eventTimeType == EventTimeType.EVENT_NEW_HERO_QUEST then
            require "lua.client.scene.ui.home.uiEventNewHero.eventHeroNewLayout.quest.UIEventNewHeroQuestLayout"
            self.layout = UIEventNewHeroQuestLayout(self, eventTimeType, self.config.questAnchor)
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_LOGIN then
            require "lua.client.scene.ui.home.uiEventNewHero.eventHeroNewLayout.login.UIEventNewHeroLoginLayout"
            self.layout = UIEventNewHeroLoginLayout(self, eventTimeType, self.config.loginAnchor)
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_BUNDLE then
            require "lua.client.scene.ui.home.uiEventNewHero.eventHeroNewLayout.bundle.UIEventNewHeroBundleLayout"
            self.layout = UIEventNewHeroBundleLayout(self, eventTimeType, self.config.bundleAnchor)
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_COLLECTION then
            require "lua.client.scene.ui.home.uiEventNewHero.eventHeroNewLayout.collection.UIEventNewHeroCollectionLayout"
            self.layout = UIEventNewHeroCollectionLayout(self, eventTimeType, self.config.collectionAnchor)
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_EXCHANGE then
            require "lua.client.scene.ui.home.uiEventNewHero.eventHeroNewLayout.exchange.UIEventNewHeroExchangeLayout"
            self.layout = UIEventNewHeroExchangeLayout(self, eventTimeType, self.config.exchangeAnchor)
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_SPIN then
            require "lua.client.scene.ui.home.uiEventNewHero.eventHeroNewLayout.spin.UIEventNewHeroSpinLayout"
            self.layout = UIEventNewHeroSpinLayout(self, eventTimeType, self.config.spinAnchor)
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_BOSS_CHALLENGE then
            require "lua.client.scene.ui.home.uiEventNewHero.eventHeroNewLayout.bossChallenge.UIEventNewHeroBossChallengeLayout"
            self.layout = UIEventNewHeroBossChallengeLayout(self, eventTimeType, self.config.bossChallenge)
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_BOSS_LEADER_BOARD then
            require "lua.client.scene.ui.home.uiEventNewHero.eventHeroNewLayout.leaderBoard.UIEventNewHeroBossLeaderBoardLayout"
            self.layout = UIEventNewHeroBossLeaderBoardLayout(self, eventTimeType, self.config.bossLeaderBoard)
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_TREASURE then
            require "lua.client.scene.ui.home.uiEventNewHero.eventHeroNewLayout.treasure.UIEventNewHeroTreasureLayout"
            self.layout = UIEventNewHeroTreasureLayout(self, eventTimeType, self.config.treasureAnchor)
        elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_SKIN_BUNDLE then
            require "lua.client.scene.ui.home.uiEventNewHero.eventHeroNewLayout.skinBundle.UIEventNewHeroSkinBundleLayout"
            self.layout = UIEventNewHeroSkinBundleLayout(self, eventTimeType, self.config.skinBundle)
        else
            XDebug.Error("Missing layout type " .. eventTimeType)
            return nil
        end
        self.layoutDict:Add(eventTimeType, self.layout)
    end
end

function UIEventNewHeroView:DisableCommon()
    self:EnableButtonLeaderBoard(false)

    self:EnableNotifyLeaderBoard(false)

    self:HideCurrentLayout()
end

function UIEventNewHeroView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_new_hero_info"))
end

--- @param eventTimeType EventTimeType
function UIEventNewHeroView:_GetEventName(eventTimeType)
    --- @type EventPopupModel
    local eventPopupModel = self.model.eventDataDict:Get(eventTimeType)
    local dataId = eventPopupModel.timeData.dataId
    if eventTimeType == EventTimeType.EVENT_NEW_HERO_QUEST then
        return LanguageUtils.LocalizeCommon("new_hero_quest_" .. dataId)
    elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_LOGIN then
        return LanguageUtils.LocalizeCommon("new_hero_login_" .. dataId)
    elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_COLLECTION then
        return LanguageUtils.LocalizeCommon("new_hero_collection_" .. dataId)
    elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_EXCHANGE then
        return LanguageUtils.LocalizeCommon("new_hero_exchange_" .. dataId)
    elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_BUNDLE then
        return LanguageUtils.LocalizeCommon("new_hero_bundle_" .. dataId)
    elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_SPIN then
        return LanguageUtils.LocalizeCommon("new_hero_spin_" .. dataId)
    elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_BOSS_CHALLENGE then
        return LanguageUtils.LocalizeCommon("new_hero_boss_challenge_" .. dataId)
    elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_BOSS_LEADER_BOARD then
        return LanguageUtils.LocalizeCommon("new_hero_boss_leader_board_" .. dataId)
    elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_TREASURE then
        return LanguageUtils.LocalizeCommon("new_hero_treasure_" .. dataId)
    elseif eventTimeType == EventTimeType.EVENT_NEW_HERO_SKIN_BUNDLE then
        return LanguageUtils.LocalizeCommon("new_hero_skin_bundle_" .. dataId)
    else
        return LanguageUtils.LocalizeCommon("new_hero_quest_" .. dataId)
    end
end

--- @param eventTimeType EventTimeType
function UIEventNewHeroView:UpdateNotificationByTab(eventTimeType)
    --- @type UIEventPackageTabItem
    local objTab = self.eventTabDict:Get(eventTimeType)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

function UIEventNewHeroView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UIEventNewHeroView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventNewHeroView:CheckAllNotificationTab()
    --- @param k EventTimeType
    for k, _ in pairs(self.eventTabDict:GetItems()) do
        self:UpdateNotificationByTab(k)
    end
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventNewHeroView:OnEventStateChange(data)
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

function UIEventNewHeroView:Hide()
    UIBaseView.Hide(self)

    self:RemoveListener()

    self:HideCurrentLayout()

    self:HideScrollTab()
end

function UIEventNewHeroView:RemoveListener()
    if self.eventListener ~= nil then
        self.eventListener:Unsubscribe()
        self.eventListener = nil
    end
    if self.notificationEvent ~= nil then
        self.notificationEvent:Unsubscribe()
        self.notificationEvent = nil
    end
end

function UIEventNewHeroView:HideScrollTab()
    self.scrollLoopTab:Hide()
    self.eventTabDict:Clear()
end

function UIEventNewHeroView:HideCurrentLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end

--- @param eventPopupModel EventPopupModel
function UIEventNewHeroView:GetEventTabIcon(eventPopupModel)
    local dataId = eventPopupModel.timeData.dataId
    local eventTimeType = eventPopupModel.timeData.eventType
    local spriteName = string.format("icon_event_time_%s_%s", eventTimeType, dataId)

    return ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconEventTime, spriteName)
end

function UIEventNewHeroView:EnableButtonLeaderBoard(isEnable)
    self.config.buttonLeaderBoard.gameObject:SetActive(isEnable)
end

function UIEventNewHeroView:EnableNotifyLeaderBoard(isEnable)
    self.config.notifyLeaderBoard.gameObject:SetActive(isEnable)
end

function UIEventNewHeroView:SetOnClickLeaderBoard(callback)
    self.config.buttonLeaderBoard.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if callback then
            callback()
        end
    end)
end
