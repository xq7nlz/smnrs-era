require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDailyCheckin.DailyRewardPageView"
require "lua.client.scene.ui.home.uiWelcomeBack.WelcomeBackLoginLayout.DailyRewardWelcomeBackPageView"

--- @class WelcomeBackLoginLayout : UIWelcomeBackLayout
WelcomeBackLoginLayout = Class(WelcomeBackLoginLayout, UIWelcomeBackLayout)

local TIME_PAGE_MOVE = 0.3
local RANGE_MOVE = 100
local DAY_PER_PAGE = 7

--- @param view UIEventEasterEggView
--- @param welcomeBackTab WelcomeBackTab
--- @param anchor UnityEngine_RectTransform
function WelcomeBackLoginLayout:Ctor(view, welcomeBackTab, anchor)
    --- @type WelcomeBackInBound
    self.welcomeBackInBound = nil
    --- @type WelcomeBackLoginConfig
    self.eventConfig = nil
    --- @type XmasDailyCheckin
    self.layoutConfig = nil
    --- @type number
    self.currentPage = 1
    --- @type DailyRewardWelcomeBackPageView
    self.currentPageView = nil
    --- @type UISelect
    self.uiSelectPage = nil

    ---@type boolean
    self.isNewLogin = false
    UIWelcomeBackLayout.Ctor(self, view, welcomeBackTab, anchor)
    self:SetUpButtonPage()
end

function WelcomeBackLoginLayout:SetUpButtonPage()
    if self.uiSelectPage == nil then
        --- @param obj UIBlackMarketPageConfig
        --- @param isSelect boolean
        local onSelect = function(obj, isSelect)
            UIUtils.SetInteractableButton(obj.button, false)
            obj.imageOn:SetActive(isSelect)
        end

        --- @param indexTab number
        local onChangePage = function(indexTab, lastTab)
            --if lastTab ~= nil and self.model.currentPage ~= indexTab then
            --    self.model.currentPage = indexTab
            --end
        end
        self.uiSelectPage = UISelect(self.layoutConfig.pagesAnchor, UIBaseConfig, onSelect, onChangePage)
    end
end

function WelcomeBackLoginLayout:OnShow()
    self.welcomeBackInBound = self.view.welcomeBackInBound
    self.eventConfig = self.welcomeBackInBound:GetLoginDataConfig()
    self.pageDict = self.eventConfig:GetLoginConfig()
    self.maxPage = self.pageDict:Count()
    self.isNewLogin = self.eventConfig:IsNewLogin()
    if self.cache == nil then
        self:InitTileDay()
        self.cache = true
    end
    UIWelcomeBackLayout.OnShow(self)
    self:FillReward()
    self:UpdateView()
    self:UpdateButtons()
    self.uiSelectPage:SetPagesCount(self.maxPage)
    self.uiSelectPage:Select(self.currentPage)
end

function WelcomeBackLoginLayout:OnHide()
    UIWelcomeBackLayout.OnHide(self)
    self.currentPage = 1
    self.page1:ReturnPools()
    --self.page2:ReturnPools()
    self:RemoveUpdateTime()
end

function WelcomeBackLoginLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("welcome_back_login", self.anchor)
    UIWelcomeBackLayout.InitLayoutConfig(self, inst)
    self.centerPosition = U_Vector3.zero
    self.nextPosition = U_Vector3(1350, 0, 0)
    self.backPosition = U_Vector3(-1350, 0, 0)
    self:InitButtons()
    self:InitLocalization()
    self:InitTimeView()
end

function WelcomeBackLoginLayout:GetCurrentPage()
    return self.page1
    --if self.page1 == self.currentPageView then
    --    return self.page1
    --end
    --return self.page2
end
function WelcomeBackLoginLayout:GetCurrentAndNext()
    local current = nil
    local next = nil
    if self.page1 == self.currentPageView then
        current = self.page1
        next = self.page2
    else
        current = self.page2
        next = self.page1
    end
    return current, next
end

function WelcomeBackLoginLayout:InitTimeView()
    self.timeCountDownContainer = SmartPool.Instance:SpawnTransform(AssetType.UIPool, UIPoolType.TimeCountDown)
    self.textTimeCountDown = self.timeCountDownContainer:GetComponentInChildren(ComponentName.UnityEngine_UI_Text)
    self.textTimeCountDown:GetComponent(ComponentName.UnityEngine_RectTransform).sizeDelta = U_Vector2(120, 50)
    self.timeCountDownContainer:SetParent(self.layoutConfig.transform)
    self.timeCountDownContainer.transform.localPosition = U_Vector3(0, 0, 0)
    self.timeCountDownContainer.transform.localScale = U_Vector3(1.2, 1.2, 1.2)
    self.timeCountDownContainer.gameObject:SetActive(false)
end

function WelcomeBackLoginLayout:FillReward()
    self.currentPage = math.floor(self.welcomeBackInBound.lastClaimDay / DAY_PER_PAGE + 1)
    if self.currentPage > self.maxPage then
        self.currentPage = self.maxPage
    end
    self.page1:FillData(self.pageDict:Get(self.currentPage), self.currentPage)
    self.currentPageView = self.page1
    self:SetDefaultPosition()
end

function WelcomeBackLoginLayout:SetDefaultPosition()
    --self.page2.config.gameObject:SetActive(false)
    self.page1.config.gameObject:SetActive(true)
    --self.page2.config.transform.localPosition = self.nextPosition
    self.page1.config.transform.localPosition = self.centerPosition
end

function WelcomeBackLoginLayout:UpdateButtons()
    self.layoutConfig.buttonClaim.gameObject:SetActive(not self.isNewLogin)
    self.layoutConfig.next.gameObject:SetActive(self.isNewLogin)
    self.layoutConfig.back.gameObject:SetActive(self.isNewLogin)
    if self.isNewLogin then
        if self.maxPage > 1 then
            if self.currentPage <= 1 then
                self.layoutConfig.back.gameObject:SetActive(false)
                self.layoutConfig.next.gameObject:SetActive(true)
            elseif self.currentPage >= self.maxPage then
                self.layoutConfig.back.gameObject:SetActive(true)
                self.layoutConfig.next.gameObject:SetActive(false)
            else
                self.layoutConfig.back.gameObject:SetActive(true)
                self.layoutConfig.next.gameObject:SetActive(true)
            end
        else
            self.layoutConfig.back.gameObject:SetActive(false)
            self.layoutConfig.next.gameObject:SetActive(false)
        end
    end
end

function WelcomeBackLoginLayout:NextPage()
    local touch = TouchUtils.Spawn("EasterEgg.NextPage")
    self.currentPage = self.currentPage + 1
    self.uiSelectPage:Select(self.currentPage)
    self:UpdateButtons()
    local current, next = self:GetCurrentAndNext()
    Coroutine.start(function()
        next:SetPosition(self.nextPosition)
        next:FillData(self.pageDict:Get(self.currentPage), self.currentPage)
        next:SetEnable(true)
        current:SetEnable(true)
        current:Move(self.backPosition, TIME_PAGE_MOVE, function()
            current:SetEnable(false)
        end)
        local center = self.centerPosition
        center.x = center.x - RANGE_MOVE
        next:Move(center, TIME_PAGE_MOVE, function()
            center.x = center.x + RANGE_MOVE
            next:Move(center, 0.1, function()
                touch:Enable()
            end)
        end)
        self.currentPageView = next
        self:UpdateView()
    end)
end

function WelcomeBackLoginLayout:BackPage()
    local touch = TouchUtils.Spawn("EasterEgg.BackPage")
    self.currentPage = self.currentPage - 1
    self.uiSelectPage:Select(self.currentPage)
    self:UpdateButtons()
    local current, next = self:GetCurrentAndNext()
    Coroutine.start(function()
        next:SetPosition(self.backPosition)
        next:FillData(self.pageDict:Get(self.currentPage), self.currentPage)
        next:SetEnable(true)
        current:SetEnable(true)
        current:Move(self.nextPosition, TIME_PAGE_MOVE, function()
            current:SetEnable(false)
        end)
        local center = self.centerPosition
        center.x = center.x + RANGE_MOVE
        next:Move(center, TIME_PAGE_MOVE, function()
            center.x = center.x - RANGE_MOVE
            next:Move(center, 0.1, function()
                touch:Enable()
            end)
        end)
        self.currentPageView = next
        self:UpdateView()
    end)
end

function WelcomeBackLoginLayout:InitTileDay()
    local onClickClaim = function(day, require, isFree)
        self:OnClickClaim(day, require, isFree)
    end
    ---@type DailyRewardWelcomeBackPageView
    self.page1 = DailyRewardWelcomeBackPageView(self.layoutConfig.content1, onClickClaim, self.isNewLogin)
    -----@type DailyRewardWelcomeBackPageView
    --self.page2 = DailyRewardWelcomeBackPageView(self.layoutConfig.content2, onClickClaim, self.isNewLogin)
end

function WelcomeBackLoginLayout:InitButtons()
    self.layoutConfig.buttonClaim.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickClaim()
    end)
    --self.layoutConfig.next.onClick:AddListener(function()
    --    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    --    self:NextPage()
    --end)
    --self.layoutConfig.back.onClick:AddListener(function()
    --    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    --    self:BackPage()
    --end)
end

function WelcomeBackLoginLayout:InitLocalization()
    self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
    self.layoutConfig.eventTittle.text = LanguageUtils.LocalizeCommon("welcome_back_login_title")
    self.layoutConfig.nextFreeText.text = LanguageUtils.LocalizeCommon("next_free")
end

---@param require RewardInBound
function WelcomeBackLoginLayout:OnClickClaim(day, require, isFree)
    if self.welcomeBackInBound:IsFreeClaim() and not self.isNewLogin then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reward_claimed"))
        return
    end
    local rewardInBoundList = nil
    local onReceived = function(result)
        local onBuffering = function(buffer)
            rewardInBoundList = NetworkUtils.GetRewardInBoundList(buffer)
        end
        local onSuccess = function()
            local day = self.welcomeBackInBound.lastClaimDay + 1
            --- @type RewardInBound
            self.welcomeBackInBound.lastClaimLoginTime = zg.timeMgr:GetServerTime()
            self.welcomeBackInBound.lastClaimDay = day
            self:UpdateView()
            self:ShowAndAddReward(rewardInBoundList)
            if isFree ~= nil and not isFree then
                InventoryUtils.Sub(require.type, require.id, require.number)
            end
            self.view:UpdateNotificationByTab(self.easterEggTab)
        end
        local onFail = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, onBuffering, onSuccess, onFail)
    end
    NetworkUtils.Request(OpCode.COMEBACK_DAILY_LOGIN, nil, onReceived)
end

--- @param rewardList List
function WelcomeBackLoginLayout:ShowAndAddReward(rewardList)
    local touchObject = TouchUtils.Spawn("EasterEgg.Login")
    local callbackDelay = function()
        touchObject:Enable()
    end
    local iconList = List()
    for i = 1, rewardList:Count() do
        rewardList:Get(i):GetIconData():AddToInventory()
        iconList:Add(rewardList:Get(i):GetIconData())
    end
    PopupMgr.ShowPopupDelay(0, UIPopupName.UIPopupReward, { ["resourceList"] = iconList, ["activeEffectBlackSmith"] = true }, nil, callbackDelay)
end

function WelcomeBackLoginLayout:UpdateViewOldLogin()
    if self.isFreeClaim then
        if self.welcomeBackInBound.lastClaimDay < 7 then
            self:StartUpdateTime()
            local current = self:GetCurrentPage()
            local index = self.lastClaimDay + 1
            local nextReward = current:GetDayView(index).config.transform
            self.timeCountDownContainer.gameObject:SetActive(true)
            self.timeCountDownContainer:SetParent(nextReward)
            self.timeCountDownContainer.transform.localPosition = U_Vector3(0, 0, 0)
        else
            self.timeCountDownContainer.gameObject:SetActive(false)
            self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("all_received")
        end
    else
        self.timeCountDownContainer.gameObject:SetActive(false)
        self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
    end
end

function WelcomeBackLoginLayout:UpdateViewNewLogin()
    local current = self:GetCurrentPage()
    local page = math.floor((self.currentEventDay) / DAY_PER_PAGE) + 1
    local currentPage = current:GetPageCount()
    self.layoutConfig.nextFreeText.gameObject:SetActive(true)
    if currentPage ~= nil and currentPage == page then
        local index = self.currentEventDay + 1
        local nextReward = current:GetDayView(index).config.transform
        self:EnableTimeCountDown(true, index, nextReward)
    else
        self:EnableTimeCountDown(false)
    end
end

function WelcomeBackLoginLayout:UpdateView()
    self.lastClaimDay = self.welcomeBackInBound.lastClaimDay
    self.currentEventDay = self.lastClaimDay
    self.isClaim = self.welcomeBackInBound:IsClaimed()
    self.isFreeClaim = self.welcomeBackInBound:IsFreeClaim()
    local progress = string.format("<color=#%s>%s</color>/7", "554939", self.lastClaimDay)
    self.layoutConfig.notify.gameObject:SetActive(not self.isFreeClaim)
    self.layoutConfig.txtProgress.text = string.format("%s",
            string.format(LanguageUtils.LocalizeCommon("login_event_progress"), progress))
    self.layoutConfig.buttonDisable:SetActive(self.isFreeClaim == true)
    self.page1:UpdateView(self.currentEventDay, self.lastClaimDay, self.isClaim, self.isFreeClaim)
    --self.page2:UpdateView(self.currentEventDay, self.lastClaimDay, self.isClaim, self.isFreeClaim)
    if self.isNewLogin then
        if self.welcomeBackInBound.lastClaimDay < DAY_PER_PAGE * self.maxPage then
            self:StartUpdateTime()
            self:UpdateViewNewLogin()
        else
            self:EnableTimeCountDown(false)
        end
    else
        self:UpdateViewOldLogin()
    end
    self.view:UpdateNotificationByTab(self.welcomeBackTab)
end

function WelcomeBackLoginLayout:EnableTimeCountDown(isEnable, index, nextReward)
    if nextReward ~= nil then
        self.layoutConfig.timeCountDownContainer:SetParent(nextReward)
        if index % DAY_PER_PAGE == 0 then
            self.layoutConfig.timeCountDownContainer.transform.localScale = U_Vector3(1.4, 1.4, 0)
            self.layoutConfig.timeCountDownContainer.transform.localPosition = U_Vector3(15, -200, 0)
        else
            self.layoutConfig.timeCountDownContainer.transform.localScale = U_Vector3(1, 1, 0)
            self.layoutConfig.timeCountDownContainer.transform.localPosition = U_Vector3(15, -130, 0)
        end
    end
    self.layoutConfig.timeCountDownContainer.gameObject:SetActive(isEnable)
end

function WelcomeBackLoginLayout:StartUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        local time = TimeUtils.GetDeltaTime(self.timeRefresh)
        local timeText = UIUtils.SetColorString(UIUtils.color11, time)
        self.layoutConfig.localizeClaim.text = string.format("%s\n%s",
                LanguageUtils.LocalizeCommon("all_received"),
                timeText)
        self.layoutConfig.textTimeCountDown.text = timeText
        self.layoutConfig.textTimeCountDown_2.text = timeText
        if self.textTimeCountDown ~= nil then
            self.textTimeCountDown.text = time
        end
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
        end
    end
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function WelcomeBackLoginLayout:SetTimeRefresh()
    local svTime = zg.timeMgr:GetServerTime()
    self.timeRefresh = TimeUtils.GetTimeStartDayFromSec(svTime) + TimeUtils.SecondADay - svTime
end

function WelcomeBackLoginLayout:RemoveUpdateTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
        self.updateTime = nil
    end
end