require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.UINewServerWeekLayout"
require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDailyCheckin.DailyRewardPageView"
--- @class UINewServerWeekLoginLayout : UINewServerWeekLayout
UINewServerWeekLoginLayout = Class(UINewServerWeekLoginLayout, UINewServerWeekLayout)

local TIME_PAGE_MOVE = 0.3
local RANGE_MOVE = 100
--- @param view UIEventView
function UINewServerWeekLoginLayout:Ctor(view, halloweenTab, anchor)
    --- @type EventNewServerWeekModel
    self.eventNewServerWeekModel = nil
    --- @type EventNewServerWeekConfig
    self.eventConfig = nil
    --- @type HalloweenDailyCheckin
    self.layoutConfig = nil
    --- @type number
    self.currentPage = 1
    --- @type DailyRewardPageView
    self.currentPageView = nil
    --- @type UISelect
    self.uiSelectPage = nil

    UINewServerWeekLayout.Ctor(self, view, halloweenTab, anchor)
    self:InitLayoutConfig()
end

function UINewServerWeekLoginLayout:OnShow()
    self.eventNewServerWeekModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK)
    self.eventConfig = self.eventNewServerWeekModel:GetConfig()
    self.pageDict = self.eventConfig:GetLoginConfig()
    self.maxPage = self.pageDict:Count()
    UINewServerWeekLayout.OnShow(self)
    self:FillReward()
    self:UpdateView()
    self:UpdateButtons()
    self:SetPopupSeen()
end

function UINewServerWeekLoginLayout:SetPopupSeen()
    local remoteConfigData = zg.playerData.remoteConfig
    remoteConfigData.newServerCheckinSeen = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime() + TimeUtils.SecondADay)
    zg.playerData:SaveRemoteConfig()
end

function UINewServerWeekLoginLayout:OnHide()
    UINewServerWeekLayout.OnHide(self)
    self.currentPage = 1
    self.page1:ReturnPools()
    self:RemoveUpdateTime()
end

function UINewServerWeekLoginLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("new_server_week_daily_checkin", self.anchor)
    UINewServerWeekLayout.InitLayoutConfig(self, inst)
    self.centerPosition = U_Vector3.zero
    self.nextPosition = U_Vector3(1350, 0, 0)
    self.backPosition = U_Vector3(-1350, 0, 0)
    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitTileDay()
    self:InitButtons()
    self:InitLocalization()
    --self:InitTimeView()
end

function UINewServerWeekLoginLayout:InitTimeView()
    self.timeCountDownContainer = SmartPool.Instance:SpawnTransform(AssetType.UIPool, UIPoolType.TimeCountDown)
    self.textTimeCountDown = self.timeCountDownContainer:GetComponentInChildren(ComponentName.UnityEngine_UI_Text)
    self.textTimeCountDown:GetComponent(ComponentName.UnityEngine_RectTransform).sizeDelta = U_Vector2(120, 50)
    self.timeCountDownContainer:SetParent(self.layoutConfig.transform)
    self.timeCountDownContainer.transform.localPosition = U_Vector3(0, 0, 0)
    self.timeCountDownContainer.transform.localScale = U_Vector3(1.2, 1.2, 1.2)
end

function UINewServerWeekLoginLayout:FillReward()
    self.currentPage = 1
    self.page1:FillData(self.pageDict, self.currentPage)
    self.currentPageView = self.page1
    self:SetDefaultPosition()
end

function UINewServerWeekLoginLayout:SetDefaultPosition()
    self.page1.config.gameObject:SetActive(true)
    self.page1.config.transform.localPosition = self.centerPosition
end

function UINewServerWeekLoginLayout:UpdateButtons()
    self.layoutConfig.back.gameObject:SetActive(false)
    self.layoutConfig.next.gameObject:SetActive(false)
end

function UINewServerWeekLoginLayout:InitTileDay()
    ---@type DailyRewardPageView
    local onClickClaim = function(day, require, isFree)
        self:OnClickClaim(day, require, isFree)
    end
    require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.EventDailyLogin.NewServerWeekDailyRewardPageView"
    self.page1 = NewServerWeekDailyRewardPageView(self.layoutConfig.content1, onClickClaim)
end

function UINewServerWeekLoginLayout:InitButtons()
    self.layoutConfig.bgClose.onClick:AddListener(function()
        self.view:OnClickBackOrClose()
    end)
end

function UINewServerWeekLoginLayout:InitLocalization()
    self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
    self.layoutConfig.eventTittle.text = LanguageUtils.LocalizeCommon("event_new_server_week_login")
    self.layoutConfig.nextFreeText.text = LanguageUtils.LocalizeCommon("next_free")
end
---@param require RewardInBound
function UINewServerWeekLoginLayout:OnClickClaim(day, require, isFree)
    local rewardInBoundList = nil
    local onReceived = function(result)
        local onBuffering = function(buffer)
            rewardInBoundList = NetworkUtils.GetRewardInBoundList(buffer)
        end
        local onSuccess = function()
            local day = self.eventNewServerWeekModel.eventLoginData.lastClaimDay + 1
            --- @type RewardInBound
            self.eventNewServerWeekModel.eventLoginData.lastClaimLoginTime = zg.timeMgr:GetServerTime()
            self.eventNewServerWeekModel.eventLoginData.lastClaimDay = day
            self:UpdateView()
            self:ShowAndAddReward(rewardInBoundList)
            if not isFree then
                InventoryUtils.Sub(require.type, require.id, require.number)
            end
            -- RxMgr.notificationEventPopup:Next(self.eventMidAutumnModel:GetType())
        end
        NetworkUtils.ExecuteResult(result, onBuffering, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.EVENT_NEW_SERVER_OPEN_DAILY_CLAIM, UnknownOutBound.CreateInstance(PutMethod.Byte, day), onReceived)
end

--- @param rewardList List
function UINewServerWeekLoginLayout:ShowAndAddReward(rewardList)
    local touchObject = TouchUtils.Spawn("NewServerWeek.Login")
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

function UINewServerWeekLoginLayout:UpdateView()
    local lastClaimDay = self.eventNewServerWeekModel.eventLoginData.lastClaimDay
    local currentEventDay = self.eventNewServerWeekModel.eventLoginData.eventCurrentDay
    local isClaim = self.eventNewServerWeekModel:IsClaim()
    local isFreeClaim = self.eventNewServerWeekModel:IsFreeClaim()
    local progress = string.format("<color=#%s>%s</color>/7", "554939", lastClaimDay)
    self.layoutConfig.txtProgress.text = string.format("%s",
            string.format(LanguageUtils.LocalizeCommon("login_event_progress"), progress))
    self.layoutConfig.buttonDisable:SetActive(isClaim == true)
    self.page1:UpdateView(currentEventDay, lastClaimDay, isClaim, isFreeClaim)
    if self.eventNewServerWeekModel.eventLoginData.eventCurrentDay < 7 then
        self:StartUpdateTime()
        ---@type DailyRewardPageView
        local current = self.page1
        local currentEventDay = self.eventNewServerWeekModel.eventLoginData.eventCurrentDay
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
function UINewServerWeekLoginLayout:EnableTimeCountDown(isEnable, index, nextReward)
    if nextReward ~= nil then
        self.layoutConfig.timeCountDownContainer:SetParent(nextReward)
        if index % 7 == 0 then
            self.layoutConfig.timeCountDownContainer.transform.localScale = U_Vector3(1.4, 1.4, 0)
            self.layoutConfig.timeCountDownContainer.transform.localPosition = U_Vector3(0, -235, 0)
        else
            self.layoutConfig.timeCountDownContainer.transform.localScale = U_Vector3(1.2, 1.2, 0)
            self.layoutConfig.timeCountDownContainer.transform.localPosition = U_Vector3(0, 0, 0)
        end
    end
    self.layoutConfig.timeCountDownContainer.gameObject:SetActive(isEnable)
end
function UINewServerWeekLoginLayout:StartUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        local timeText = UIUtils.SetColorString(UIUtils.white, TimeUtils.GetDeltaTime(self.timeRefresh))
        self.layoutConfig.localizeClaim.text = string.format("%s\n%s",
                LanguageUtils.LocalizeCommon("all_received"),
                timeText)
        self.layoutConfig.textTimeCountDown.text = timeText
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
        end
    end
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UINewServerWeekLoginLayout:SetTimeRefresh()
    local svTime = zg.timeMgr:GetServerTime()
    self.timeRefresh = TimeUtils.GetTimeStartDayFromSec(svTime) + TimeUtils.SecondADay - svTime
end

function UINewServerWeekLoginLayout:RemoveUpdateTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
        self.updateTime = nil
    end
end



