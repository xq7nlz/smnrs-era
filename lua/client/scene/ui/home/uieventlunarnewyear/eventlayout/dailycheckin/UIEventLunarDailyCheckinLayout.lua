require "lua.client.scene.ui.home.uiEventLunarNewYear.eventLayout.dailyCheckin.DailyRewardLunarNewYearPageView"
--- @class UIEventLunarDailyCheckinLayout : UIEventLunarNewYearLayout
UIEventLunarDailyCheckinLayout = Class(UIEventLunarDailyCheckinLayout, UIEventLunarNewYearLayout)

local TIME_PAGE_MOVE = 0.3
local RANGE_MOVE = 100
--- @param view UIEventView
function UIEventLunarDailyCheckinLayout:Ctor(view, lunarNewYearTab, anchor)
    --- @type EventLunarNewYearModel
    self.eventModel = nil
    --- @type EventHalloweenConfig
    self.eventConfig = nil
    --- @type DailyRewardHalloweenConfig
    self.layoutConfig = nil
    --- @type number
    self.currentPage = 1
    --- @type DailyRewardPageView
    self.currentPageView = nil
    --- @type UISelect
    self.uiSelectPage = nil

    UIEventLunarNewYearLayout.Ctor(self, view, lunarNewYearTab, anchor)
    self:SetUpButtonPage()
end

function UIEventLunarDailyCheckinLayout:SetUpButtonPage()
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

function UIEventLunarDailyCheckinLayout:OnShow()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_NEW_YEAR_2022)
    self.eventConfig = self.eventModel:GetConfig()
    self.pageDict = self.eventConfig:GetLoginConfig()
    self.maxPage = self.pageDict:Count()
    UIEventLunarNewYearLayout.OnShow(self)
    self:FillReward()
    self:UpdateView()
    self:UpdateButtons()
    self.uiSelectPage:SetPagesCount(self.maxPage)
    self.uiSelectPage:Select(self.currentPage)
end

function UIEventLunarDailyCheckinLayout:OnHide()
    UIEventLunarNewYearLayout.OnHide(self)
    self.currentPage = 1
    self.page1:ReturnPools()
    self.page2:ReturnPools()
    self:RemoveUpdateTime()
end

function UIEventLunarDailyCheckinLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("lunar_new_year_checkin", self.anchor)
    UIEventLunarNewYearLayout.InitLayoutConfig(self, inst)
    self.centerPosition = U_Vector3.zero
    self.nextPosition = U_Vector3(1350, 0, 0)
    self.backPosition = U_Vector3(-1350, 0, 0)
    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitTileDay()
    self:InitButtons()
    self:InitLocalization()
    self:InitTimeView()
end
function UIEventLunarDailyCheckinLayout:GetCurrentPage()
    if self.page1 == self.currentPageView then
        return self.page1
    end
    return self.page2
end
function UIEventLunarDailyCheckinLayout:GetCurrentAndNext()
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

function UIEventLunarDailyCheckinLayout:InitTimeView()
    self.timeCountDownContainer = SmartPool.Instance:SpawnTransform(AssetType.UIPool, UIPoolType.TimeCountDown)
    self.textTimeCountDown = self.timeCountDownContainer:GetComponentInChildren(ComponentName.UnityEngine_UI_Text)
    self.textTimeCountDown:GetComponent(ComponentName.UnityEngine_RectTransform).sizeDelta = U_Vector2(120, 50)
    self.timeCountDownContainer:SetParent(self.layoutConfig.transform)
    self.timeCountDownContainer.transform.localPosition = U_Vector3(0, 0, 0)
    self.timeCountDownContainer.transform.localScale = U_Vector3(1.2, 1.2, 1.2)
end

function UIEventLunarDailyCheckinLayout:FillReward()
    self.currentPage = math.floor(self.eventModel:GetLoginData().lastClaimDay / 7 + 1)
    if self.currentPage > self.maxPage then
        self.currentPage = self.maxPage
    end
    if self.currentPage < 2 then
        self.page1:FillData(self.pageDict:Get(self.currentPage), self.currentPage)
        self.currentPageView = self.page1
    else
        self.page2:FillData(self.pageDict:Get(self.currentPage), self.currentPage)
        self.currentPageView = self.page2
    end
    self:SetDefaultPosition()
end

function UIEventLunarDailyCheckinLayout:SetDefaultPosition()
    self.page2.config.gameObject:SetActive(false)
    self.page1.config.gameObject:SetActive(false)
    self.currentPageView.config.gameObject:SetActive(true)
    --self.page2.config.transform.localPosition = self.nextPosition
    --self.page1.config.transform.localPosition = self.centerPosition
    self.currentPageView.config.transform.localPosition = self.centerPosition
end

function UIEventLunarDailyCheckinLayout:UpdateButtons()
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
end

function UIEventLunarDailyCheckinLayout:NextPage()
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
end

function UIEventLunarDailyCheckinLayout:BackPage()
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
end

function UIEventLunarDailyCheckinLayout:InitTileDay()
    ---@type DailyRewardPageView
    local onClickClaim = function(day, require, isFree)
        self:OnClickClaim(day, require, isFree)
    end
    self.page1 = DailyRewardLunarNewYearPageView(self.layoutConfig.content1, onClickClaim)
    ---@type DailyRewardLunarNewYearPageView
    self.page2 = DailyRewardLunarNewYearPageView(self.layoutConfig.content2, onClickClaim)
end

function UIEventLunarDailyCheckinLayout:InitButtons()
    self.layoutConfig.buttonClaim.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickClaim()
    end)
    self.layoutConfig.next.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:NextPage()
    end)
    self.layoutConfig.back.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:BackPage()
    end)
end

function UIEventLunarDailyCheckinLayout:InitLocalization()
    self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
    self.layoutConfig.eventTittle.text = LanguageUtils.LocalizeCommon("event_lunar_new_year_login_title")
end
---@param require RewardInBound
function UIEventLunarDailyCheckinLayout:OnClickClaim(day, require, isFree)
    local rewardInBoundList = nil
    local onReceived = function(result)
        local onBuffering = function(buffer)
            rewardInBoundList = NetworkUtils.GetRewardInBoundList(buffer)
        end
        local onSuccess = function()
            local day = self.eventModel.eventLunarLoginData.lastClaimDay + 1
            --- @type RewardInBound
            self.eventModel.eventLunarLoginData.lastClaimLoginTime = zg.timeMgr:GetServerTime()
            self.eventModel.eventLunarLoginData.lastClaimDay = day
            self:UpdateView()
            self:ShowAndAddReward(rewardInBoundList)
            if not isFree then
                InventoryUtils.Sub(require.type, require.id, require.number)
            end
            -- RxMgr.notificationEventPopup:Next(self.eventMidAutumnModel:GetType())
        end
        NetworkUtils.ExecuteResult(result, onBuffering, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.EVENT_LUNAR_2022_DAILY_LOGIC_CLAIM, UnknownOutBound.CreateInstance(PutMethod.Byte, day), onReceived)
end

--- @param rewardList List
function UIEventLunarDailyCheckinLayout:ShowAndAddReward(rewardList)
    local touchObject = TouchUtils.Spawn("LunarNewYear.Login")
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

function UIEventLunarDailyCheckinLayout:UpdateView()
    local lastClaimDay = self.eventModel.eventLunarLoginData.lastClaimDay
    local currentEventDay = self.eventModel.eventLunarLoginData.eventCurrentDay
    local isClaim = self.eventModel:IsClaim()
    local isFreeClaim = self.eventModel:IsFreeClaim()
    local progress = string.format("<color=#%s>%s<.color>.7", "554939", lastClaimDay)
    self.layoutConfig.txtProgress.text = string.format("%s",
            string.format(LanguageUtils.LocalizeCommon("login_event_progress"), progress))
    self.layoutConfig.buttonDisable:SetActive(isClaim == true)
    self.page1:UpdateView(currentEventDay, lastClaimDay, isClaim, isFreeClaim)
    self.page2:UpdateView(currentEventDay, lastClaimDay, isClaim, isFreeClaim)
    self:RemoveUpdateTime()
    if isFreeClaim then
        local lastClaimDay = self.eventModel.eventLunarLoginData.lastClaimDay
        if lastClaimDay < 7 then
            self:StartUpdateTime()
            local nextReward = self.page1.tileDayDict:Get(lastClaimDay + 1 ).config.transform
            self.timeCountDownContainer.gameObject:SetActive(true)
            self.timeCountDownContainer:SetParent(nextReward)
            self.timeCountDownContainer.transform.localPosition = U_Vector3(0, 0, 0)
        elseif lastClaimDay >= 7 and lastClaimDay < 14 then
            self:StartUpdateTime()
            local nextReward = self.page2.tileDayDict:Get(lastClaimDay % 7 + 1).config.transform
            self.timeCountDownContainer.gameObject:SetActive(true)
            self.timeCountDownContainer:SetParent(nextReward)
            self.timeCountDownContainer.transform.localPosition = U_Vector3(0, 0, 0)
        else
            self.timeCountDownContainer.gameObject:SetActive(false)
            self:RemoveUpdateTime()
            self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("all_received")
        end
    else
        self.timeCountDownContainer.gameObject:SetActive(false)
        self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
    end

    local claimAble = self.view:_GetEventNotification(self.newYearTab)
    self.layoutConfig.notify:SetActive(claimAble)
    if claimAble then
        self.timeCountDownContainer.gameObject:SetActive(not claimAble)
        self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
    end
    self.view:CheckAllNotificationTab()
end

function UIEventLunarDailyCheckinLayout:StartUpdateTime()
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
        self.textTimeCountDown.text = timeText
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
        end
    end
    if not zg.timeMgr.updateList:IsContainValue(self.updateTime) then
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end

function UIEventLunarDailyCheckinLayout:SetTimeRefresh()
    local svTime = zg.timeMgr:GetServerTime()
    self.timeRefresh = TimeUtils.GetTimeStartDayFromSec(svTime) + TimeUtils.SecondADay - svTime
end

function UIEventLunarDailyCheckinLayout:RemoveUpdateTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
        self.updateTime = nil
    end
end



