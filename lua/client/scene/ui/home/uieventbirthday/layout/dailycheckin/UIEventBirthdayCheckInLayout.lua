require "lua.client.scene.ui.home.uiEventBirthday.layout.dailyCheckin.DailyRewardEventBirthdayPageView"

--- @class UIEventBirthdayCheckInLayout : UIEventBirthdayLayout
UIEventBirthdayCheckInLayout = Class(UIEventBirthdayCheckInLayout, UIEventBirthdayLayout)

local TIME_PAGE_MOVE = 0.3
local RANGE_MOVE = 100
local DAY_PER_PAGE = 7

--- @param view UIEventBirthdayView
--- @param eventBirthdayTab EventBirthdayTab
--- @param anchor UnityEngine_RectTransform
function UIEventBirthdayCheckInLayout:Ctor(view, eventBirthdayTab, anchor)
    --- @type EventBirthdayModel
    self.eventModel = nil
    --- @type EventBirthdayConfig
    self.eventConfig = nil
    --- @type XmasDailyCheckin
    self.layoutConfig = nil
    --- @type number
    self.currentPage = 1
    --- @type DailyRewardEventBirthdayPageView
    self.currentPageView = nil
    --- @type UISelect
    self.uiSelectPage = nil

    ---@type boolean
    self.isNewLogin = false
    UIEventBirthdayLayout.Ctor(self, view, eventBirthdayTab, anchor)
    self:SetUpButtonPage()
end

function UIEventBirthdayCheckInLayout:SetUpButtonPage()
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

function UIEventBirthdayCheckInLayout:OnShow()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.view.eventTimeType)
    self.eventConfig = self.eventModel:GetConfig()
    self.pageDict = self.eventConfig:GetLoginConfig()
    self.maxPage = self.pageDict:Count()
    self.isNewLogin = self.eventConfig:IsNewLogin()
    if self.cache == nil then
        self:InitTileDay()
        self.cache = true
    end
    UIEventBirthdayLayout.OnShow(self)
    self:FillReward()
    self:UpdateView()
    self:UpdateButtons()
    self.uiSelectPage:SetPagesCount(self.maxPage)
    self.uiSelectPage:Select(self.currentPage)
end

function UIEventBirthdayCheckInLayout:OnHide()
    UIEventBirthdayLayout.OnHide(self)
    self.currentPage = 1
    self.page1:ReturnPools()
    self.page2:ReturnPools()
    self:RemoveUpdateTime()
end

function UIEventBirthdayCheckInLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("birthday_check_in", self.anchor)
    UIEventBirthdayLayout.InitLayoutConfig(self, inst)
    self.centerPosition = U_Vector3.zero
    self.nextPosition = U_Vector3(1350, 0, 0)
    self.backPosition = U_Vector3(-1350, 0, 0)
    self:InitButtons()
    self:InitLocalization()
    self:InitTimeView()
end

function UIEventBirthdayCheckInLayout:GetCurrentPage()
    if self.page1 == self.currentPageView then
        return self.page1
    end
    return self.page2
end
function UIEventBirthdayCheckInLayout:GetCurrentAndNext()
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

function UIEventBirthdayCheckInLayout:InitTimeView()
    self.timeCountDownContainer = SmartPool.Instance:SpawnTransform(AssetType.UIPool, UIPoolType.TimeCountDown)
    self.textTimeCountDown = self.timeCountDownContainer:GetComponentInChildren(ComponentName.UnityEngine_UI_Text)
    self.textTimeCountDown:GetComponent(ComponentName.UnityEngine_RectTransform).sizeDelta = U_Vector2(120, 50)
    self.timeCountDownContainer:SetParent(self.layoutConfig.transform)
    self.timeCountDownContainer.transform.localPosition = U_Vector3(0, 0, 0)
    self.timeCountDownContainer.transform.localScale = U_Vector3(1.2, 1.2, 1.2)
    self.timeCountDownContainer.gameObject:SetActive(false)
end

function UIEventBirthdayCheckInLayout:FillReward()
    self.currentPage = math.floor(self.eventModel:GetLoginData().lastClaimDay / DAY_PER_PAGE + 1)
    if self.currentPage > self.maxPage then
        self.currentPage = self.maxPage
    end
    self.page1:FillData(self.pageDict:Get(self.currentPage), self.currentPage)
    self.currentPageView = self.page1
    self:SetDefaultPosition()
end

function UIEventBirthdayCheckInLayout:SetDefaultPosition()
    self.page2.config.gameObject:SetActive(false)
    self.page1.config.gameObject:SetActive(true)
    self.page2.config.transform.localPosition = self.nextPosition
    self.page1.config.transform.localPosition = self.centerPosition
end

function UIEventBirthdayCheckInLayout:UpdateButtons()
    self.layoutConfig.buttonClaim.gameObject:SetActive(not self.isNewLogin)
    if self.currentPage <= 1 then
        self.layoutConfig.backButton.gameObject:SetActive(false)
        self.layoutConfig.nextButton.gameObject:SetActive(true)
    elseif self.currentPage >= self.maxPage then
        self.layoutConfig.backButton.gameObject:SetActive(true)
        self.layoutConfig.nextButton.gameObject:SetActive(false)
    else
        self.layoutConfig.backButton.gameObject:SetActive(true)
        self.layoutConfig.nextButton.gameObject:SetActive(true)
    end
end

function UIEventBirthdayCheckInLayout:InitTileDay()
    ---@type DailyRewardPageView
    local onClickClaim = function(day, require, isFree)
        self:OnClickClaim(day, require, isFree)
    end
    self.page1 = DailyRewardEventBirthdayPageView(self.layoutConfig.content1, onClickClaim, self.isNewLogin)
    ---@type DailyRewardEventBirthdayPageView
    self.page2 = DailyRewardEventBirthdayPageView(self.layoutConfig.content2, onClickClaim, self.isNewLogin)
end

function UIEventBirthdayCheckInLayout:InitButtons()
    self.layoutConfig.buttonClaim.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickClaim()
    end)
    self.layoutConfig.nextButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:NextPage()
    end)
    self.layoutConfig.backButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:BackPage()
    end)
end

function UIEventBirthdayCheckInLayout:InitLocalization()
    self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
    self.layoutConfig.eventTittle.text = LanguageUtils.LocalizeCommon("birthday_check_in_title")
end

---@param require RewardInBound
function UIEventBirthdayCheckInLayout:OnClickClaim(day, require, isFree)
    if self.eventModel:IsFreeClaim() and not self.isNewLogin then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("all_received"))
        return
    end
    local rewardInBoundList = nil
    local onReceived = function(result)
        local onBuffering = function(buffer)
            rewardInBoundList = NetworkUtils.GetRewardInBoundList(buffer)
        end
        local onSuccess = function()
            local day = self.eventModel:GetLoginData().lastClaimDay + 1
            --- @type RewardInBound
            self.eventModel:GetLoginData().lastClaimLoginTime = zg.timeMgr:GetServerTime()
            self.eventModel:GetLoginData().lastClaimDay = day
            self:UpdateView()
            self:ShowAndAddReward(rewardInBoundList)
            if isFree ~= nil and not isFree then
                InventoryUtils.Sub(require.type, require.id, require.number)
            end
            self.view:UpdateNotificationByTab(self.eventBirthdayTab)
        end
        local onFail = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, onBuffering, onSuccess, onFail)
    end
    NetworkUtils.Request(OpCode.EVENT_BIRTHDAY_LOGIN_CLAIM, nil, onReceived)
end

--- @param rewardList List
function UIEventBirthdayCheckInLayout:ShowAndAddReward(rewardList)
    local touchObject = TouchUtils.Spawn("MergeServer.Login")
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

function UIEventBirthdayCheckInLayout:UpdateViewOldLogin()
    if self.isFreeClaim then
        if self.eventModel:GetLoginData().lastClaimDay < 7 then
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

function UIEventBirthdayCheckInLayout:UpdateViewNewLogin()
    local current = self:GetCurrentPage()
    local page = math.floor((self.currentEventDay) / DAY_PER_PAGE) + 1
    local currentPage = current:GetPageCount()
    if currentPage ~= nil and currentPage == page then
        local index = self.currentEventDay + 1
        local nextReward = current:GetDayView(index).config.transform
        self:EnableTimeCountDown(true, index, nextReward)
    else
        self:EnableTimeCountDown(false)
    end
end

function UIEventBirthdayCheckInLayout:UpdateView()
    self.lastClaimDay = self.eventModel:GetLoginData().lastClaimDay
    self.currentEventDay = self.eventModel:GetLoginData().eventCurrentDay
    self.isClaim = self.eventModel:IsClaim()
    self.isFreeClaim = self.eventModel:IsFreeClaim()
    local progress = string.format("<color=#%s>%s</color>/7", "554939", self.lastClaimDay)
    self.layoutConfig.notify.gameObject:SetActive(not self.isFreeClaim)
    self.layoutConfig.txtProgress.text = string.format("%s",
            string.format(LanguageUtils.LocalizeCommon("login_event_progress"), progress))
    self.layoutConfig.buttonDisable:SetActive(self.isFreeClaim == true)
    self.page1:UpdateView(self.currentEventDay, self.lastClaimDay, self.isClaim, self.isFreeClaim)
    self.page2:UpdateView(self.currentEventDay, self.lastClaimDay, self.isClaim, self.isFreeClaim)
    if self.isNewLogin then
        if self.eventModel:GetLoginData().eventCurrentDay < DAY_PER_PAGE * self.maxPage then
            self:StartUpdateTime()
            self:UpdateViewNewLogin()
        else
            self:EnableTimeCountDown(false)
        end
    else
        self:UpdateViewOldLogin()
    end
    ---@type DailyRewardPageView
    self.view:UpdateNotificationByTab(self.xmasTab)
end

function UIEventBirthdayCheckInLayout:NextPage()
    local touch = TouchUtils.Spawn("LunarNewYear.NextPage")
    self.currentPage = self.currentPage + 1
    self.uiSelectPage:Select(self.currentPage)
    self:UpdateButtons()
    ---@type DailyRewardPageView
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
    self:RemoveUpdateTime()
end

function UIEventBirthdayCheckInLayout:BackPage()
    local touch = TouchUtils.Spawn("LunarNewYear.BackPage")
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
    self:RemoveUpdateTime()
end


function UIEventBirthdayCheckInLayout:EnableTimeCountDown(isEnable, index, nextReward)
    if nextReward ~= nil then
        self.timeCountDownContainer:SetParent(nextReward)
        if index % DAY_PER_PAGE == 0 then
            self.timeCountDownContainer.transform.localScale = U_Vector3(1.4, 1.4, 0)
            self.timeCountDownContainer.transform.localPosition = U_Vector3(15, -200, 0)
        else
            self.timeCountDownContainer.transform.localScale = U_Vector3(1, 1, 0)
            self.timeCountDownContainer.transform.localPosition = U_Vector3(15, -130, 0)
        end
    end
    self.timeCountDownContainer.gameObject:SetActive(isEnable)
end

function UIEventBirthdayCheckInLayout:StartUpdateTime()
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
        if self.textTimeCountDown ~= nil then
            self.textTimeCountDown.text = time
        end
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
        end
    end
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventBirthdayCheckInLayout:SetTimeRefresh()
    local svTime = zg.timeMgr:GetServerTime()
    self.timeRefresh = TimeUtils.GetTimeStartDayFromSec(svTime) + TimeUtils.SecondADay - svTime
end

function UIEventBirthdayCheckInLayout:RemoveUpdateTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
        self.updateTime = nil
    end
end