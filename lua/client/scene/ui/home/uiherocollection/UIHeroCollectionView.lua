require "lua.client.core.network.hero.HeroLockOutBound"
require "lua.client.scene.ui.utils.uiSelect.UISelectCustomSprite"
require "lua.client.scene.ui.home.uiHeroCollection.UIRegressionView"
require "lua.client.scene.ui.home.uiHeroCollection.UIRecycleView"
require "lua.client.core.network.hero.HeroAllUnlockOutBound"
require "lua.client.core.network.hero.HeroAllUnlockInBound"

local HERO_LIST_TYPE = {
    HERO_LIST = 1,
    GALLERY = 2,
    RECYCLE = 3,
    LINKING = 4,
    REGRESSION = 5,
}

--- @class UIHeroCollectionView : UIBaseView
UIHeroCollectionView = Class(UIHeroCollectionView, UIBaseView)

--- @return void
--- @param model UIHeroCollectionModel
function UIHeroCollectionView:Ctor(model)
    ---@type HeroLinkingInBound
    self.heroLinkingInBound = nil
    ---@type HeroLinkingTierConfig
    self.heroLinkingTierConfig = nil

    --- @type UIHeroCollectionConfig
    self.config = nil

    self.currentTab = nil
    self.tabDict = Dictionary()

    --- @type UISelect
    self.faction = nil

    --- @type UILoopScroll
    self.uiScroll = nil

    --- @type UILoopScroll
    self.uiScrollLinking = nil

    ---@type boolean
    self.cacheData = false

    ---@type boolean
    self.isRecycleTab = false

    ---@type boolean
    self.isLock = false

    ---@type List --<HeroResource>
    self.listHeroChangeLock = List()

    ---@type boolean
    self.cacheHeroLockList = List()

    --- @type boolean
    self.canPlayMotion = nil

    --- @type number
    self.lastFactionTab = nil

    --- @type MotionConfig
    self.motionConfig = MotionConfig(nil, nil, nil, 0.02, 2)

    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIHeroCollectionModel
    self.model = self.model
end

--- @return void
function UIHeroCollectionView:OnReadyCreate()
    ---@type UIHeroCollectionConfig
    self.config = UIBaseConfig(self.uiTransform)
    ---@type UIRegressionView
    self.regressionView = UIRegressionView(self.config.regression)
    self.recycleView = UIRecycleView(self.config.recycle, self)

    self:InitButtonListener()
    self:InitTabs()
    self:InitHero()
    self:InitLinkingItem()
    self:SortByFaction()
end

function UIHeroCollectionView:InitButtonListener()
    self.config.multiEvolveButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickMultiEvolve()
    end)
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttSort.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonSort()
    end)
    self.config.buttonSortArrow.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSortArrow()
    end)
    self.config.sortPannel.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonCloseSort()
    end)
    self.config.buttonLevel.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonSortLevel()
    end)
    self.config.buttonStar.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickButtonSortStar()
    end)
    self.config.buttonLock.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLock()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpButton()
    end)
    self.config.buttonDone.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickDone()
    end)
    self.config.pickHeroList.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIHeroForHire)
    end)
end

function UIHeroCollectionView:InitHero()
    --- @param obj HeroCardItemView
    --- @param index number
    local onUpdateItemHeroCard = function(obj, index)
        ---@type HeroResource
        local heroResource = self.model.heroSort:Get(index + 1)
        local lock = self.isLock == true and (ClientConfigUtils.CheckLockHero(heroResource))
        obj:ActiveMaskLock(lock, U_Vector2(194, 251))
    end
    --- @param obj HeroCardItemView
    --- @param index number
    local onCreateItemHeroCard = function(obj, index)
        onUpdateItemHeroCard(obj, index)
        obj:EnableButton(true)
        ---@type HeroResource
        local heroResource = self.model.heroSort:Get(index + 1)
        ---@type HeroIconData
        local heroData = HeroIconData.CreateByHeroResource(heroResource)
        local noti = heroResource:IsUnlockTalent()

        if heroData then
            obj:SetIconData(heroData, noti)
        end
        if heroResource.isOwned ~= nil then
            obj:SetActiveColor(heroResource.isOwned)
        end
        obj:RemoveAllListeners()
        obj:AddListener(function()
            self:SelectHero(index)
        end)
    end
    self.uiScroll = UILoopScrollAsync(self.config.scroll,
            UIPoolType.HeroCardItemView, onCreateItemHeroCard, onUpdateItemHeroCard)
    self.uiScroll:SetUpMotion(MotionConfig(0, 0, 0, 0.02, 3))
end

function UIHeroCollectionView:SortByFaction()
    --- @param obj UnityEngine_UI_Button
    --- @param isSelect boolean
    local onSelectFaction = function(obj, isSelect)
        if obj ~= nil then
            UIUtils.SetInteractableButton(obj, not isSelect)
            if isSelect then
                self.config.imageSelect.gameObject:SetActive(true)
                self.config.imageSelect.transform:SetParent(obj.transform)
                self.config.imageSelect.transform.localPosition = U_Vector3.zero
            end
        end
    end
    local onChangeSelectFaction = function(indexTab, lastTab)

    end
    local onClickSelectFaction = function()
        self:CheckSort()
    end
    self.faction = UISelectFactionFilter(self.config.selectHero,
            nil, onSelectFaction, onChangeSelectFaction,
            onClickSelectFaction)
    self.faction:SetSprite()
end

function UIHeroCollectionView:InitLinkingItem()
    local listItemLinkingExceptHidden = List()
    listItemLinkingExceptHidden = ResourceMgr.GetHeroLinkingTierConfig():GetLinkingConfigExceptHidden()
    local listCount = listItemLinkingExceptHidden:Count()

    --- @param obj UIHeroLinkingItemView
    --- @param index number
    local onCreateItemLinkingHero = function(obj, index)
        ---@type ItemLinkingTierConfig
        local linkingConfig = listItemLinkingExceptHidden:Get(listCount - index)
        obj:SetData(linkingConfig, self.heroLinkingInBound.linkingGroupDataDict:Get(self.heroLinkingInBound.linkingGroupDataDict:Count() - index), function()
            self.uiScrollLinking:RefreshCells()
            self:UpdateNotiLinking()
        end)
    end

    --- @param obj UIHeroLinkingItemView
    --- @param index number
    local onUpdateItemLinkingHero = function(obj, index)
        obj:ReturnPoolItem()
        onCreateItemLinkingHero(obj, index)
    end
    self.uiScrollLinking = UILoopScroll(self.config.scrollLinking, UIPoolType.UIHeroLinkingItemView, onCreateItemLinkingHero, onUpdateItemLinkingHero)
end

function UIHeroCollectionView:InitTabs()
    self.currentTab = HERO_LIST_TYPE.HERO_LIST
    self.selectTab = function(currentTab)
        if self:IsAvailableOpenTab(currentTab, true) == false then
            return
        end
        self.currentTab = currentTab
        local isHeroOrCollectionTab = currentTab == HERO_LIST_TYPE.HERO_LIST or currentTab == HERO_LIST_TYPE.GALLERY
        if (isHeroOrCollectionTab) then
            self.faction:Select(1)
        else
            self.faction:Select(self.faction.indexTab or 1)
        end
        for k, v in pairs(self.tabDict:GetItems()) do
            v:SetTabState(k == currentTab)
        end
        self:CheckSort()
        local isActive = NotificationCheckUtils.IsCanShowSoftTutRegression()
                and self.currentTab ~= HERO_LIST_TYPE.REGRESSION
        self.config.softTutRegression:SetActive(isActive)
        if (not isHeroOrCollectionTab) then
            self.config.textEmpty.gameObject:SetActive(false)
        else
            self.config.textEmpty.gameObject:SetActive(self.model.heroSort:Count() == 0)
        end
    end
    local addTab = function(heroListTab, localizeFunction)
        self.tabDict:Add(heroListTab, UITabItem(self.config.tabSelect:GetChild(heroListTab - 1),
                self.selectTab, localizeFunction, heroListTab))
    end
    addTab(HERO_LIST_TYPE.HERO_LIST, function()
        return LanguageUtils.LocalizeCommon("hero_list")
    end)
    addTab(HERO_LIST_TYPE.GALLERY, function()
        return LanguageUtils.LocalizeCommon("gallery")
    end)
    addTab(HERO_LIST_TYPE.LINKING, function()
        return LanguageUtils.LocalizeCommon("linking")
    end)
    addTab(HERO_LIST_TYPE.REGRESSION, function()
        return LanguageUtils.LocalizeCommon("regression")
    end)
    addTab(HERO_LIST_TYPE.RECYCLE, function()
        return LanguageUtils.LocalizeCommon("recycle")
    end)
    self.config.tabSelect:GetChild(HERO_LIST_TYPE.REGRESSION - 1).gameObject:SetActive(true)
    self.config.tabSelect:GetChild(HERO_LIST_TYPE.RECYCLE - 1).gameObject:SetActive(true)
end

function UIHeroCollectionView:InitLocalization()
    self.config.multiEvolveTxt.text = LanguageUtils.LocalizeCommon("multi_evolve")
    self.config.localizeSort.text = LanguageUtils.LocalizeCommon("sort")
    self.config.localizeLevel.text = LanguageUtils.LocalizeCommon("level")
    self.config.localizeStar.text = LanguageUtils.LocalizeCommon("star")
    self.config.localizeSell.text = LanguageUtils.LocalizeCommon("sell")
    self.config.localizeLock.text = LanguageUtils.LocalizeCommon("lock")
    self.config.localizeEditLock.text = LanguageUtils.LocalizeCommon("edit_lock_heroes")
    self.config.localizeDone.text = LanguageUtils.LocalizeCommon("done")
    self.config.localizeSupportHero.text = LanguageUtils.LocalizeCommon("my_support_hero")
    self.config.textEmpty.text = LanguageUtils.LocalizeCommon("empty")

    self.regressionView:InitLocalization()
    self.recycleView:InitLocalization()

    if self.tabDict ~= nil then
        --- @param v UITabItem
        for _, v in pairs(self.tabDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

--- @return void
function UIHeroCollectionView:OnReadyShow(result)
    if result ~= nil then
        self.isRecycleTab = result.isRecycleTab
    else
        self.isRecycleTab = false
    end
    local content = self.config.scrollTab.content
    content.anchoredPosition = U_Vector2(content.anchoredPosition.x,0)
    self.heroLinkingInBound = zg.playerData:GetMethod(PlayerDataMethod.HERO_LINKING)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.canPlayMotion = true
    if self.isLock then
        for i = 1, self.listHeroChangeLock:Count() do
            self.listHeroChangeLock:Get(i).isLock = self.cacheHeroLockList:Get(i)
        end
        self.cacheHeroLockList:Clear()
        self.listHeroChangeLock:Clear()
        self:SetLock(not self.isLock)
    end
    self:Init(result)
    self.model:InitData()
    if self.cacheData == true then
        self.selectTab(self.currentTab)
    elseif self.isRecycleTab then
        self.selectTab(HERO_LIST_TYPE.RECYCLE)
    else
        self.lastFactionTab = nil
        self.selectTab(HERO_LIST_TYPE.HERO_LIST)
    end
    self.config.localizeSort.text = LanguageUtils.LocalizeCommon("level")
    self:FlipIconArrow(true)
    self:ShowLastFactionTab()
    self:SetNumberHero()
    self.cacheData = true
    self:CheckActiveLinkingTab()
    self:CheckActiveRegressionTab()
    self:CheckActiveRecycleTab()
    self:UpdateNotiLinking()
    self:UpdateNotiTalent()
    self:UpdateNotiRecycle()
    self:ListenerUpdateLinking()
end

--- @return void
function UIHeroCollectionView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self:CheckAndInitTutorial()
end

--- @return void
function UIHeroCollectionView:Init(result)

end

function UIHeroCollectionView:SetTabButtons(isEnable)
    for _, v in pairs(self.tabDict:GetItems()) do
        v:SetShowButton(isEnable)
    end
end
--- @return void
function UIHeroCollectionView:Hide()
    UIBaseView.Hide(self)
    self.uiScroll:Hide()
    self.uiScrollLinking:Hide()
    self:RemoveListenerTutorial()
    self.cacheData = false
    self.isRecycleTab = false
    self.lastFactionTab = self.faction.indexTab
    self.faction:Select(nil)
    self:RemoveUpdateLinking()

    zg.playerData:SetActiveLinking(self.heroLinkingInBound:GetDictionaryActiveLinking())
end

--- @return void
function UIHeroCollectionView:CheckSort()
    if self.currentTab == HERO_LIST_TYPE.REGRESSION then
        self.config.textTitle.text = LanguageUtils.LocalizeCommon("regression")
        self.config.linking:SetActive(false)
        self.config.heroList:SetActive(false)
        self.recycleView:Hide()
        self.regressionView:Show()
        self:ShowLinking()
        self:SortLinking()
    elseif self.currentTab == HERO_LIST_TYPE.RECYCLE then
        self.config.textTitle.text = LanguageUtils.LocalizeCommon("recycle")
        self.config.linking:SetActive(false)
        self.config.heroList:SetActive(false)
        self.regressionView:Hide()
        self.recycleView:Show()
        self:ShowLinking()
        self:SortLinking()
    elseif self.currentTab == HERO_LIST_TYPE.LINKING then
        self.config.textTitle.text = LanguageUtils.LocalizeCommon("linking")
        self.config.linking:SetActive(true)
        self.config.heroList:SetActive(false)
        self.recycleView:Hide()
        self.regressionView:Hide()
        self:ShowLinking()
        self:SortLinking()
    else
        if self.currentTab == HERO_LIST_TYPE.GALLERY then
            self.config.textTitle.text = LanguageUtils.LocalizeCommon("gallery")
        else
            self.config.textTitle.text = LanguageUtils.LocalizeCommon("hero_list")
        end
        self.config.linking:SetActive(false)
        self.config.heroList:SetActive(true)
        self.regressionView:Hide()
        self.recycleView:Hide()
        self:Sort()
        self:ShowHeroCollection()
    end
end

--- @return void
function UIHeroCollectionView:SelectHero(index)
    if self.isLock then
        ---@type HeroResource
        local heroResource = self.model.heroSort:Get(index + 1)
        local listLockedFeature = ClientConfigUtils.GetListFeatureLockHeroByInventoryId(heroResource.inventoryId)
        if listLockedFeature:Count() == 1 and listLockedFeature:Get(1) == FeatureType.INVENTORY or listLockedFeature:Count() == 0 then
            self.cacheHeroLockList:Add(heroResource.isLock)
            if heroResource.isLock == true then
                heroResource.isLock = false
            else
                heroResource.isLock = true
            end
            if self.listHeroChangeLock:IsContainValue(heroResource) == false then
                self.listHeroChangeLock:Add(heroResource)
            end
            self:ResizeScroll()
        elseif listLockedFeature and listLockedFeature:Count() > 0 then
            local lockedFeature = LanguageUtils.LocalizeCommon("hero_lock_in_feature")
            local unlockMode = ""
            for _, v in pairs(listLockedFeature:GetItems()) do
                unlockMode = unlockMode .. LanguageUtils.LocalizeFeature(v) .. ", "
            end
            unlockMode = string.sub(unlockMode, 1, string.len(unlockMode) - 2)
            local notiContent = string.format("%s: %s", lockedFeature, UIUtils.SetColorString(UIUtils.red_light, unlockMode))
            SmartPoolUtils.ShowShortNotification(notiContent)
        end
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
        local data = {}
        data.heroSort = self.model.heroSort
        data.index = index + 1
        data.callbackClose = function()
            self.cacheData = true
            PopupMgr.ShowAndHidePopup(UIPopupName.UIHeroCollection, nil, UIPopupName.UIHeroMenu2)
        end
        PopupMgr.ShowAndHidePopup(UIPopupName.UIHeroMenu2, data,
                UIPopupName.UIHeroCollection)
    end
end

--- @return void
function UIHeroCollectionView:ShowLastFactionTab()
    if self.lastFactionTab ~= nil then
        self.faction:Select(self.lastFactionTab)
        self.lastFactionTab = nil
    end
end

--- @return void
function UIHeroCollectionView:GetFaction()
    local faction
    if self.lastFactionTab ~= nil then
        faction = self.lastFactionTab
    else
        faction = self.faction.indexTab
    end
    if faction ~= nil and faction > 1 then
        faction = faction - 1
    else
        faction = nil
    end
    return faction
end

--- @return void
function UIHeroCollectionView:Sort()
    --- @type List

    local listHeroResource
    local faction = self:GetFaction()
    if self.currentTab == HERO_LIST_TYPE.HERO_LIST then
        listHeroResource = self.model.heroList
    else
        if faction == nil then
            faction = 1
        end
        if self.currentTab == HERO_LIST_TYPE.GALLERY then
            for _, heroCollection in ipairs(self.model.heroCollection:GetItems()) do
                heroCollection.isOwned = false;
                for __, heroOwned in pairs(self.model.heroList:GetItems()) do
                    if heroCollection.heroId == heroOwned.heroId then
                        heroCollection.isOwned = true;
                        break ;
                    end
                end
            end
            listHeroResource = self.model.heroCollection
        else
            listHeroResource = self.model.heroCollection
        end
    end
    self.model.heroSort:Clear()
    for i = 1, listHeroResource:Count() do
        ---@type HeroResource
        local heroResource = listHeroResource:Get(i)
        if faction == nil or ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId) == faction then
            self.model.heroSort:Add(heroResource)
        end
    end
    if self.currentTab == HERO_LIST_TYPE.HERO_LIST then
        if PlayerSettingData.sortHeroCollection == SortTypeHero.STAR then
            self.model.heroSort:SortWithMethod(HeroResource.SortStarLevelReverse())
        else
            self.model.heroSort:SortWithMethod(HeroResource.SortLevelStarReverse())
        end
    elseif self.currentTab == HERO_LIST_TYPE.GALLERY then
        self.model.heroSort:SortWithMethod(HeroResource.SortStarLevelReverse())
    end
    self:ResizeScroll(self.model.heroSort:Count())

    if self.canPlayMotion == true then
        self.canPlayMotion = false
        self.uiScroll:PlayMotion()
    end
end

--- @return void
function UIHeroCollectionView:SortLinking()
    self.heroLinkingTierConfig = ResourceMgr.GetHeroLinkingTierConfig()
    local listShowLinking = List()

    --- @param v ItemLinkingTierConfig
    for _, v in pairs(self.heroLinkingTierConfig.listItemLinking:GetItems()) do
        if v.isHide ~= true then
            listShowLinking:Add(v)
        end
    end
    self.uiScrollLinking:Resize(listShowLinking:Count())
end

--- @return void
function UIHeroCollectionView:ShowHeroList()
    self.config.selectHero:GetChild(0).gameObject:SetActive(true)
    self.uiScroll.scroll.gameObject:SetActive(true)
    self.uiScrollLinking.scroll.gameObject:SetActive(false)
    self.config.textNumberHero.gameObject:SetActive(true)
    self.config.buttSort.gameObject:SetActive(true)
    self:SetNumberHero()
    self:SetLock(false)
end

function UIHeroCollectionView:SetNumberHero()
    self.config.textNumberHero.text = UIUtils.SetColorString(UIUtils.brown, self.model.heroList:Count()) .. "/" .. ClientConfigUtils.MAX_HERO
end

function UIHeroCollectionView:OnClickMultiEvolve()
    local data = {}
    data.callbackCloseAfterEvolve = function()
        self.model:InitData()
        self:Sort()
        self:SetNumberHero()
    end
    PopupMgr.ShowPopup(UIPopupName.UIMultiEvolve, data)
end
--- @return void
function UIHeroCollectionView:SetLock(isLock)
    self.isLock = isLock
    self.config.buttonLock.gameObject:SetActive(not isLock)
    self.config.buttSort.gameObject:SetActive(not isLock)
    self.config.buttonBack.gameObject:SetActive(not isLock)
    self.config.multiEvolveButton.gameObject:SetActive(false)
    self:SetTabButtons(not isLock)
    self.config.localizeEditLock.gameObject:SetActive(isLock)
    self.config.buttonDone.gameObject:SetActive(isLock)

    self:ResizeScroll()
end

--- @return void
function UIHeroCollectionView:ShowHeroCollection()
    local checkShowWithType = self.currentTab == HERO_LIST_TYPE.HERO_LIST and not self.isLock
    self.config.selectHero:GetChild(0).gameObject:SetActive(self.currentTab == HERO_LIST_TYPE.HERO_LIST)
    self.uiScroll.scroll.gameObject:SetActive(true)
    self.uiScrollLinking.scroll.gameObject:SetActive(false)
    if self.currentTab == HERO_LIST_TYPE.GALLERY then
        local indexFaction = self.faction.indexTab or 1
        if indexFaction == 1 then
            indexFaction = 2
        end
        self.faction:Select(indexFaction)
    end
    self.config.textNumberHero.gameObject:SetActive(checkShowWithType)
    self.config.buttSort.gameObject:SetActive(checkShowWithType)
    self.config.localizeSortBy.gameObject:SetActive(checkShowWithType)
    self.config.multiEvolveButton.gameObject:SetActive(false)
    self.config.buttonLock.gameObject:SetActive(checkShowWithType)
    self:FlipIconArrow(true)
end

--- @return void
function UIHeroCollectionView:ShowLinking()
    self.uiScrollLinking.scroll.gameObject:SetActive(true)
    self.uiScroll.scroll.gameObject:SetActive(false)
    self.faction:Select(1)
    self.config.textNumberHero.gameObject:SetActive(false)
    self.config.buttSort.gameObject:SetActive(false)
    self.config.localizeSortBy.gameObject:SetActive(false)
    self.config.buttonLock.gameObject:SetActive(false)
end

--- @return void
function UIHeroCollectionView:ListenerUpdateLinking()
    self:RemoveUpdateLinking()
    ---@type Subscription
    self.listenerUpdateLinking = RxMgr.notificationRequestLinking:Merge(RxMgr.notificationRequestListSupportHero):Subscribe(function()
        self:RemoveCoroutineUpdateLinking()
        self.coroutineRequestLinking = Coroutine.start(function()
            coroutine.waitforseconds(1)
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.HERO_LINKING }, function()
                self:UpdateNotiLinking()
                if self.uiScrollLinking.scroll.gameObject.activeInHierarchy then
                    self.uiScrollLinking:RefreshCells()
                end
            end, nil, false)
            self:RemoveCoroutineUpdateLinking()
        end)
    end)
end

--- @return void
function UIHeroCollectionView:RemoveCoroutineUpdateLinking()
    if self.coroutineRequestLinking ~= nil then
        Coroutine.stop(self.coroutineRequestLinking)
        self.coroutineRequestLinking = nil
    end
end

--- @return void
function UIHeroCollectionView:RemoveUpdateLinking()
    if self.listenerUpdateLinking ~= nil then
        self.listenerUpdateLinking:Unsubscribe()
        self.listenerUpdateLinking = nil
    end
end

--- @return void
function UIHeroCollectionView:ViewSortPanel()
    if PlayerSettingData.sortHeroCollection == SortTypeHero.STAR then
        self.config.localizeSort.text = LanguageUtils.LocalizeCommon("star")
        self.config.chooseButton.transform.position = self.config.buttonStar.transform.position
        self:EnableSortButton(self.config.buttonLevel, true)
        self:EnableSortButton(self.config.buttonStar, false)
    else
        self.config.localizeSort.text = LanguageUtils.LocalizeCommon("level")
        self:FlipIconArrow(true)
        self.config.chooseButton.transform.position = self.config.buttonLevel.transform.position
        self:EnableSortButton(self.config.buttonLevel, false)
        self:EnableSortButton(self.config.buttonStar, true)
    end
end

--- @return void
function UIHeroCollectionView:OnClickButtonSort()
    self.config.sortPannel.gameObject:SetActive(true)
    self:ViewSortPanel()
end

--- @return void
function UIHeroCollectionView:OnClickSortArrow()
    self:FlipIconArrow()
    local localScaleY = self.config.iconMiniArrow.transform.localScale.y
    if PlayerSettingData.sortHeroCollection == SortTypeHero.STAR then
        if localScaleY < 0 then
            self.model.heroSort:SortWithMethod(HeroResource.SortStarLevel())
        else
            self.model.heroSort:SortWithMethod(HeroResource.SortStarLevelReverse())
        end
    else
        if localScaleY < 0 then
            self.model.heroSort:SortWithMethod(HeroResource.SortLevelStar())
        else
            self.model.heroSort:SortWithMethod(HeroResource.SortLevelStarReverse())
        end
    end
    self:ResizeScroll(self.model.heroSort:Count())
end

--- @return void
---@param arrowDown boolean
function UIHeroCollectionView:FlipIconArrow(arrowDown)
    ---@type UnityEngine_Vector3
    local localScale = self.config.iconMiniArrow.transform.localScale
    if arrowDown then
        localScale.y = math.abs(localScale.y)
    else
        localScale.y = localScale.y * -1
    end
    self.config.iconMiniArrow.transform.localScale = localScale
end

--- @return void
function UIHeroCollectionView:OnClickButtonCloseSort()
    self.config.sortPannel.gameObject:SetActive(false)
end

--- @return void
function UIHeroCollectionView:OnClickButtonSortLevel()
    self:OnClickButtonCloseSort()
    PlayerSettingData.sortHeroCollection = SortTypeHero.LEVEL
    PlayerSetting.SaveData()
    self:ViewSortPanel()
    self:Sort()
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    self.config.localizeSort.text = LanguageUtils.LocalizeCommon("level")
    self:FlipIconArrow(true)
end

--- @return void
function UIHeroCollectionView:OnClickButtonSortStar()
    self:OnClickButtonCloseSort()
    PlayerSettingData.sortHeroCollection = SortTypeHero.STAR
    PlayerSetting.SaveData()
    self:ViewSortPanel()
    self:Sort()
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    self.config.localizeSort.text = LanguageUtils.LocalizeCommon("star")
    self:FlipIconArrow(true)
end

--- @return void
---@param button UnityEngine_UI_Button
---@param enable boolean
function UIHeroCollectionView:EnableSortButton(button, enable)
    UIUtils.SetInteractableButton(button, enable)
    ---@type UnityEngine_UI_Image
    local image = button:GetComponent(ComponentName.UnityEngine_UI_Image)
    if image ~= nil then
        image.raycastTarget = enable
    end
end

----- @return void
function UIHeroCollectionView:OnClickLock()
    self:SetLock(true)
end

----- @return void
function UIHeroCollectionView:OnClickHelpButton()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("linking_info"))
end

----- @return void
function UIHeroCollectionView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

----- @return void
function UIHeroCollectionView:OnClickDone()
    self:SetLock(false)
    if self.listHeroChangeLock:Count() > 0 then
        local heroLockOutBound = HeroLockOutBound()
        ---@param v HeroResource
        for _, v in pairs(self.listHeroChangeLock:GetItems()) do
            if v.isLock == true then
                heroLockOutBound.listLock:Add(v.inventoryId)
            else
                heroLockOutBound.listUnlock:Add(v.inventoryId)
            end
        end
        NetworkUtils.RequestAndCallback(OpCode.HERO_LOCK, heroLockOutBound)
        self.listHeroChangeLock:Clear()
        self.cacheHeroLockList:Clear()
    end
end

--- @return void
--- @param tutorial UITutorialView
--- @param step number
function UIHeroCollectionView:ShowTutorial(tutorial, step)
    if step == TutorialStep.SELECT_HERO_IN_COLLECTION then
        tutorial:ViewFocusCurrentTutorial(self.uiScroll.scroll.content:GetChild(0):
        GetComponent(ComponentName.UnityEngine_UI_Button), 0.5, nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.BACK_HERO_COLLECTION then
        tutorial:ViewFocusCurrentTutorial(self.config.buttonBack, 0.5,
                self.config.buttonBack.transform:GetChild(0), nil, tutorial:GetHandType(TutorialHandType.MOVE_CLICK))
    end
end

--- @return void
function UIHeroCollectionView:UpdateNotiLinking()
    NotificationCheckUtils.CheckNotiHeroLinking(self.config.notiLinking)
end

--- @return void
function UIHeroCollectionView:UpdateNotiTalent()
    NotificationCheckUtils.CheckNotiTalent(self.config.notyHeroList)
end

--- @return void
function UIHeroCollectionView:UpdateNotiRecycle()
    NotificationCheckUtils.CheckNotiRecycle(self.config.notiRecycle)
end

function UIHeroCollectionView:CheckActiveLinkingTab()
    local timeOpen = FeatureItemInBound.GetTimeOpenIn(FeatureType.HERO_LINKING)
    --- @type FeatureConfigInBound
    local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
    local linkingItem = featureConfigInBound:GetFeatureConfigInBound(FeatureType.HERO_LINKING)
    --- @type UITabItem
    local tabItem = self.tabDict:Get(HERO_LIST_TYPE.LINKING)
    if tabItem ~= nil then
        tabItem:SetActive(linkingItem:IsAvailableToShowButton() and timeOpen <= 0)
    end
end

function UIHeroCollectionView:CheckActiveRegressionTab()
    --- @type FeatureConfigInBound
    local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
    --- @type FeatureItemInBound
    local data = featureConfigInBound:GetFeatureConfigInBound(FeatureType.REGRESSION)
    --- @type UITabItem
    local tabItem = self.tabDict:Get(HERO_LIST_TYPE.REGRESSION)
    if tabItem ~= nil then
        tabItem:SetActive(data:IsAvailableToShowButton()
                and ClientConfigUtils.CheckUnlockFeatureAndNotification(ResourceMgr.GetMajorFeatureLock().dict:GetItems(), FeatureType.REGRESSION, false))
    end
end

function UIHeroCollectionView:CheckActiveRecycleTab()
    --- @type UITabItem
    local tabItem = self.tabDict:Get(HERO_LIST_TYPE.RECYCLE)
    if tabItem ~= nil then
        tabItem:SetActive(true)
    end
end

function UIHeroCollectionView:IsAvailableToShowTab(tab)
    if tab == HERO_LIST_TYPE.REGRESSION
            or tab == HERO_LIST_TYPE.LINKING then
        --- @type FeatureConfigInBound
        local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
        --- @type FeatureItemInBound
        local featureItemInBound
        if tab == HERO_LIST_TYPE.REGRESSION then
            featureItemInBound = featureConfigInBound:GetFeatureConfigInBound(FeatureType.REGRESSION)
        elseif tab == HERO_LIST_TYPE.RECYCLE then
            return true
        elseif tab == HERO_LIST_TYPE.LINKING then
            featureItemInBound = featureConfigInBound:GetFeatureConfigInBound(FeatureType.HERO_LINKING)
        end
        return featureItemInBound:IsAvailableToShowButton()
    end
    return true
end

function UIHeroCollectionView:IsAvailableOpenTab(tab, isShowNotify)
    if tab == HERO_LIST_TYPE.REGRESSION
            or tab == HERO_LIST_TYPE.LINKING then
        --- @type FeatureConfigInBound
        local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
        --- @type FeatureItemInBound
        local featureItemInBound
        if tab == HERO_LIST_TYPE.REGRESSION then
            featureItemInBound = featureConfigInBound:GetFeatureConfigInBound(FeatureType.REGRESSION)
        elseif tab == HERO_LIST_TYPE.RECYCLE then
            return true
        elseif tab == HERO_LIST_TYPE.LINKING then
            featureItemInBound = featureConfigInBound:GetFeatureConfigInBound(FeatureType.HERO_LINKING)
        end
        return featureItemInBound:IsAvailableToGoFeature(isShowNotify)
    end
    return true
end

function UIHeroCollectionView:ResizeScroll(size)
    if size ~= nil then
        self.uiScroll:Resize(size, self.canPlayMotion)
        self.config.textEmpty.gameObject:SetActive(size == 0)
    else
        self.uiScroll:RefreshCells()
        self.config.textEmpty.gameObject:SetActive(self.model.heroSort:Count() == 0)
    end
end
