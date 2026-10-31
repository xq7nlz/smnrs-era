require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDailyCheckin.DailyRewardPageView"
--- @class UIEventHalloweenDailyCheckinLayout : UIEventHalloweenLayout
UIEventHalloweenDailyCheckInLayout = Class(UIEventHalloweenDailyCheckInLayout, UIEventHalloweenLayout)

local TIME_PAGE_MOVE = 0.3
local RANGE_MOVE = 100
--- @param view UIEventView
function UIEventHalloweenDailyCheckInLayout:Ctor(view, halloweenTab, anchor)
    --- @type EventHalloweenModel
    self.eventHalloweenModel = nil
    --- @type EventHalloweenConfig
    self.eventConfig = nil
    --- @type HalloweenDailyCheckin
    self.layoutConfig = nil
    --- @type number
    self.currentPage = 1
    --- @type DailyRewardPageView
    self.currentPageView = nil
    --- @type UISelect
    self.uiSelectPage = nil

    UIEventHalloweenLayout.Ctor(self, view, halloweenTab, anchor)
    self:SetUpButtonPage()
end

function UIEventHalloweenDailyCheckInLayout:SetUpButtonPage()
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

function UIEventHalloweenDailyCheckInLayout:OnShow()
    self.eventHalloweenModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HALLOWEEN)
    self.eventConfig = self.eventHalloweenModel:GetConfig()
    self.pageDict = self.eventConfig:GetLoginConfig()
    self.maxPage = self.pageDict:Count()
    UIEventHalloweenLayout.OnShow(self)
    self:FillReward()
    self:UpdateView()
    self:UpdateButtons()
    self.uiSelectPage:SetPagesCount(self.maxPage)
    self.uiSelectPage:Select(self.currentPage)
end

function UIEventHalloweenDailyCheckInLayout:OnHide()
    UIEventHalloweenLayout.OnHide(self)
    self.currentPage = 1
    self.page1:ReturnPools()
    self.page2:ReturnPools()
    self:RemoveUpdateTime()
end

function UIEventHalloweenDailyCheckInLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("halloween_daily_checkin", self.anchor)
    UIEventHalloweenLayout.InitLayoutConfig(self, inst)
    self.centerPosition = U_Vector3.zero
    self.nextPosition = U_Vector3(1350, 0, 0)
    self.backPosition = U_Vector3(-1350, 0, 0)
    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitTileDay()
    self:InitButtons()
    self:InitLocalization()
    --self:InitTimeView()
end
function UIEventHalloweenDailyCheckInLayout:GetCurrentPage()
    if self.page1 == self.currentPageView then
        return self.page1
    end
    return self.page2
end
function UIEventHalloweenDailyCheckInLayout:GetCurrentAndNext()
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

function UIEventHalloweenDailyCheckInLayout:InitTimeView()
    self.timeCountDownContainer = SmartPool.Instance:SpawnTransform(AssetType.UIPool, UIPoolType.TimeCountDown)
    self.textTimeCountDown = self.timeCountDownContainer:GetComponentInChildren(ComponentName.UnityEngine_UI_Text)
    self.textTimeCountDown:GetComponent(ComponentName.UnityEngine_RectTransform).sizeDelta = U_Vector2(120, 50)
    self.timeCountDownContainer:SetParent(self.layoutConfig.transform)
    self.timeCountDownContainer.transform.localPosition = U_Vector3(0, 0, 0)
    self.timeCountDownContainer.transform.localScale = U_Vector3(1.2, 1.2, 1.2)
end

function UIEventHalloweenDailyCheckInLayout:FillReward()
    self.currentPage = math.floor(self.eventHalloweenModel:GetLoginData().lastClaimDay / 7 + 1)
    if self.currentPage > self.maxPage then
        self.currentPage = self.maxPage
    end
    self.page1:FillData(self.pageDict:Get(self.currentPage), self.currentPage)
    self.currentPageView = self.page1
    self:SetDefaultPosition()
end

function UIEventHalloweenDailyCheckInLayout:SetDefaultPosition()
    self.page2.config.gameObject:SetActive(false)
    self.page1.config.gameObject:SetActive(true)
    self.page2.config.transform.localPosition = self.nextPosition
    self.page1.config.transform.localPosition = self.centerPosition
end

function UIEventHalloweenDailyCheckInLayout:UpdateButtons()
    self.layoutConfig.back.gameObject:SetActive(false)
    self.layoutConfig.next.gameObject:SetActive(false)
--[[    if self.currentPage <= 1 then
        self.layoutConfig.back.gameObject:SetActive(false)
        self.layoutConfig.next.gameObject:SetActive(true)
    elseif self.currentPage >= self.maxPage then
        self.layoutConfig.back.gameObject:SetActive(true)
        self.layoutConfig.next.gameObject:SetActive(false)
    else
        self.layoutConfig.back.gameObject:SetActive(true)
        self.layoutConfig.next.gameObject:SetActive(true)
    end]]
end

function UIEventHalloweenDailyCheckInLayout:NextPage()
    local touch = TouchUtils.Spawn("Halloween.NextPage")
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
end

function UIEventHalloweenDailyCheckInLayout:BackPage()
    local touch = TouchUtils.Spawn("Halloween.BackPage")
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

function UIEventHalloweenDailyCheckInLayout:InitTileDay()
    ---@type DailyRewardPageView
    local onClickClaim = function(day, require, isFree)
        self:OnClickClaim(day, require, isFree)
    end
    self.page1 = DailyRewardPageView(self.layoutConfig.content1, onClickClaim)
    ---@type DailyRewardPageView
    self.page2 = DailyRewardPageView(self.layoutConfig.content2, onClickClaim)
end

function UIEventHalloweenDailyCheckInLayout:InitButtons()
    --self.layoutConfig.buttonClaim.onClick:AddListener(function()
    --    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    --    self:OnClickClaim()
    --end)
    self.layoutConfig.next.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:NextPage()
    end)
    self.layoutConfig.back.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:BackPage()
    end)
end

function UIEventHalloweenDailyCheckInLayout:InitLocalization()
    self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
    self.layoutConfig.eventTittle.text = LanguageUtils.LocalizeCommon("halloween_daily_checkin")
    self.layoutConfig.nextFreeText.text = LanguageUtils.LocalizeCommon("next_free")
end
---@param require RewardInBound
function UIEventHalloweenDailyCheckInLayout:OnClickClaim(day, require, isFree)
    --if self.eventHalloweenModel:IsClaim() then
    --    zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    --    SmartPoolUtils.LogicCodeNotification(LogicCode.EVENT_HALLOWEEN_DAILY_CLAIM)
    --    return
    --end
    local rewardInBoundList = nil
    local onReceived = function(result)
        local onBuffering = function(buffer)
            rewardInBoundList = NetworkUtils.GetRewardInBoundList(buffer)
        end
        local onSuccess = function()
            local day = self.eventHalloweenModel.eventHalloweenLoginData.lastClaimDay + 1
            --- @type RewardInBound
            self.eventHalloweenModel.eventHalloweenLoginData.lastClaimLoginTime = zg.timeMgr:GetServerTime()
            self.eventHalloweenModel.eventHalloweenLoginData.lastClaimDay = day
            self:UpdateView()
            self:ShowAndAddReward(rewardInBoundList)
            if not isFree then
                InventoryUtils.Sub(require.type, require.id, require.number)
            end
            -- RxMgr.notificationEventPopup:Next(self.eventMidAutumnModel:GetType())
        end
        NetworkUtils.ExecuteResult(result, onBuffering, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.EVENT_HALLOWEEN_DAILY_CLAIM, UnknownOutBound.CreateInstance(PutMethod.Byte, day), onReceived)
end

--- @param rewardList List
function UIEventHalloweenDailyCheckInLayout:ShowAndAddReward(rewardList)
    local touchObject = TouchUtils.Spawn("Halloween.Login")
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

function UIEventHalloweenDailyCheckInLayout:UpdateView()
    local lastClaimDay = self.eventHalloweenModel.eventHalloweenLoginData.lastClaimDay
    local currentEventDay = self.eventHalloweenModel.eventHalloweenLoginData.eventCurrentDay
    local isClaim = self.eventHalloweenModel:IsClaim()
    local isFreeClaim = self.eventHalloweenModel:IsFreeClaim()
    local progress = string.format("<color=#%s>%s</color>/7", "554939", lastClaimDay)
    self.layoutConfig.txtProgress.text = string.format("%s",
            string.format(LanguageUtils.LocalizeCommon("login_event_progress"), progress))
    self.layoutConfig.buttonDisable:SetActive(isClaim == true)
    self.page1:UpdateView(currentEventDay, lastClaimDay, isClaim, isFreeClaim)
    self.page2:UpdateView(currentEventDay, lastClaimDay, isClaim, isFreeClaim)
    if self.eventHalloweenModel.eventHalloweenLoginData.eventCurrentDay < 14 then
        self:StartUpdateTime()
        ---@type DailyRewardPageView
        local current = self:GetCurrentPage()
        local currentEventDay = self.eventHalloweenModel.eventHalloweenLoginData.eventCurrentDay
        local page = math.floor((currentEventDay) / 7) + 1
        local currentPage = current:GetPageCount()
        self.layoutConfig.nextFreeText.gameObject:SetActive(true)
        if currentPage ~= nil and currentPage == page then
            local index = currentEventDay + 1
            local nextReward = current:GetDayView(index).config.transform
            self:EnableTimeCountDown(true, index, nextReward)
        else
            self:EnableTimeCountDown(false)
        end
    else
        self.layoutConfig.nextFreeText.gameObject:SetActive(isFreeClaim and not isClaim)
        self:EnableTimeCountDown(false)
        self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("all_received")
    end
    self.view:UpdateNotificationByTab(self.halloweenTab)
end
function UIEventHalloweenDailyCheckInLayout:EnableTimeCountDown(isEnable, index, nextReward)
    if nextReward ~= nil then
        self.layoutConfig.timeCountDownContainer:SetParent(nextReward)
        if index % 7 == 0 then
            self.layoutConfig.timeCountDownContainer.transform.localScale = U_Vector3(1.4, 1.4, 0)
            self.layoutConfig.timeCountDownContainer.transform.localPosition = U_Vector3(0, -235, 0)
        else
            self.layoutConfig.timeCountDownContainer.transform.localScale = U_Vector3(1.2, 1.2, 0)
            self.layoutConfig.timeCountDownContainer.transform.localPosition = U_Vector3(0, -135, 0)
        end
    end
    self.layoutConfig.timeCountDownContainer.gameObject:SetActive(isEnable)
end
function UIEventHalloweenDailyCheckInLayout:StartUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        local timeText = UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh))
        self.layoutConfig.localizeClaim.text = string.format("%s\n%s",
                LanguageUtils.LocalizeCommon("all_received"),
                timeText)
        self.layoutConfig.textTimeCountDown.text = timeText
        self.layoutConfig.textTimeCountDown_2.text = timeText
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
        end
    end
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventHalloweenDailyCheckInLayout:SetTimeRefresh()
    local svTime = zg.timeMgr:GetServerTime()
    self.timeRefresh = TimeUtils.GetTimeStartDayFromSec(svTime) + TimeUtils.SecondADay - svTime
end

function UIEventHalloweenDailyCheckInLayout:RemoveUpdateTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
        self.updateTime = nil
    end
end



