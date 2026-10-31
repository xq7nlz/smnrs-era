require "lua.client.scene.ui.home.uiEventNewHero.eventHeroNewLayout.login.DailyRewardNewHeroPageView"
--- @class UIEventNewHeroLoginLayout : UIEventNewHeroLayout
UIEventNewHeroLoginLayout = Class(UIEventNewHeroLoginLayout, UIEventNewHeroLayout)

local TIME_PAGE_MOVE = 0.3
local RANGE_MOVE = 100
local DAY_PER_PAGE = 7

function UIEventNewHeroLoginLayout:Ctor(view, xmasTab, anchor)
    --- @type EventNewHeroLoginModel
    self.eventModel = nil
    --- @type EventNewHeroLoginConfig
    self.eventConfig = nil
    --- @type XmasDailyCheckin
    self.layoutConfig = nil
    --- @type number
    self.currentPage = 1
    --- @type DailyRewardNewHeroPageView
    self.currentPageView = nil
    --- @type UISelect
    self.uiSelectPage = nil

    ---@type boolean
    self.isNewLogin = false
    UIEventNewHeroLayout.Ctor(self, view, xmasTab, anchor)
end

function UIEventNewHeroLoginLayout:SetUpButtonPage()
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

function UIEventNewHeroLoginLayout:OnShow()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_LOGIN)
    self.eventConfig = self.eventModel:GetConfig()
    self.pageDict = self.eventConfig:GetLoginConfig()
    self.maxPage = self.pageDict:Count()
    self.isNewLogin = self.eventConfig:IsNewLogin()
    if self.dataId ~= self.eventModel.timeData.dataId then
        self.dataId = self.eventModel.timeData.dataId
        self:InitLayoutConfig()
        self:InitTileDay()
    end

    UIEventNewHeroLayout.OnShow(self)
    self:FillReward()
    self:UpdateView()
    self:UpdateButtons()
    self.uiSelectPage:SetPagesCount(self.maxPage)
    self.uiSelectPage:Select(self.currentPage)
end

function UIEventNewHeroLoginLayout:OnHide()
    UIEventNewHeroLayout.OnHide(self)
    self.currentPage = 1
    self.page1:ReturnPools()
    self.page2:ReturnPools()
    self:RemoveUpdateTime()
end

function UIEventNewHeroLoginLayout:InitLayoutConfig()
    if self.layoutConfig ~= nil then
        U_Object.Destroy(self.layoutConfig.transform.gameObject)
    end
    local prefab = "new_hero_checkin_1"
    if self.dataId ~= nil then
        prefab = "new_hero_checkin_" .. self.dataId
    end
    local inst = PrefabLoadUtils.Instantiate(prefab, self.anchor)
    UIEventNewHeroLayout.InitLayoutConfig(self, inst)
    self.centerPosition = U_Vector3.zero
    self.nextPosition = U_Vector3(1350, 0, 0)
    self.backPosition = U_Vector3(-1350, 0, 0)
    self:InitButtons()
    self:InitLocalization()
    self:InitTimeView()
    self.uiSelectPage = nil
    self:SetUpButtonPage()
end

function UIEventNewHeroLoginLayout:GetCurrentPage()
    if self.page1 == self.currentPageView then
        return self.page1
    end
    return self.page2
end
function UIEventNewHeroLoginLayout:GetCurrentAndNext()
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

function UIEventNewHeroLoginLayout:InitTimeView()
    self.timeCountDownContainer = SmartPool.Instance:SpawnTransform(AssetType.UIPool, UIPoolType.TimeCountDown)
    self.textTimeCountDown = self.timeCountDownContainer:GetComponentInChildren(ComponentName.UnityEngine_UI_Text)
    self.textTimeCountDown:GetComponent(ComponentName.UnityEngine_RectTransform).sizeDelta = U_Vector2(120, 50)
    self.timeCountDownContainer:SetParent(self.layoutConfig.transform)
    self.timeCountDownContainer.transform.localPosition = U_Vector3(0, 0, 0)
    self.timeCountDownContainer.transform.localScale = U_Vector3(1.2, 1.2, 1.2)
    self.timeCountDownContainer.gameObject:SetActive(false)
end

function UIEventNewHeroLoginLayout:FillReward()
    self.currentPage = math.floor(self.eventModel:GetLoginData().lastClaimDay / DAY_PER_PAGE + 1)
    if self.currentPage > self.maxPage then
        self.currentPage = self.maxPage
    end
    self.page1:FillData(self.pageDict:Get(self.currentPage), self.currentPage)
    self.currentPageView = self.page1
    self:SetDefaultPosition()
end

function UIEventNewHeroLoginLayout:SetDefaultPosition()
    self.page2.config.gameObject:SetActive(false)
    self.page1.config.gameObject:SetActive(true)
    self.page2.config.transform.localPosition = self.nextPosition
    self.page1.config.transform.localPosition = self.centerPosition
end

function UIEventNewHeroLoginLayout:UpdateButtons()
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

function UIEventNewHeroLoginLayout:NextPage()
    local touch = TouchUtils.Spawn("NewHero.NextPage")
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

function UIEventNewHeroLoginLayout:BackPage()
    local touch = TouchUtils.Spawn("NewHero.BackPage")
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

function UIEventNewHeroLoginLayout:InitTileDay()
    ---@type DailyRewardPageView
    local onClickClaim = function(day, require, isFree)
        self:OnClickClaim(day, require, isFree)
    end
    local prefab = "daily_reward_new_hero_" .. self.eventModel.timeData.dataId
    self.page1 = DailyRewardNewHeroPageView(self.layoutConfig.content1, onClickClaim, self.isNewLogin, prefab)
    ---@type DailyRewardNewHeroPageView
    self.page2 = DailyRewardNewHeroPageView(self.layoutConfig.content2, onClickClaim, self.isNewLogin, prefab)
end

function UIEventNewHeroLoginLayout:InitButtons()
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

function UIEventNewHeroLoginLayout:InitLocalization()
    self.layoutConfig.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
    self.layoutConfig.eventTittle.text = LanguageUtils.LocalizeCommon("new_hero_checkin_title")
    self.layoutConfig.nextFreeText.text = LanguageUtils.LocalizeCommon("next_free")
end

---@param require RewardInBound
function UIEventNewHeroLoginLayout:OnClickClaim(day, require, isFree)
    if self.eventModel:IsFreeClaim() and not self.isNewLogin then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
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
            self.view:UpdateNotificationByTab(self.eventTimeType)
        end
        local onFail = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.ExecuteResult(result, onBuffering, onSuccess, onFail)
    end
    NetworkUtils.Request(OpCode.EVENT_NEW_HERO_LOGIN_CLAIM, nil, onReceived)
end

--- @param rewardList List
function UIEventNewHeroLoginLayout:ShowAndAddReward(rewardList)
    local touchObject = TouchUtils.Spawn("NewHero.Login")
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

function UIEventNewHeroLoginLayout:UpdateViewOldLogin()
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

function UIEventNewHeroLoginLayout:UpdateViewNewLogin()
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

function UIEventNewHeroLoginLayout:UpdateView()
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
    self.view:UpdateNotificationByTab(self.eventTimeType)
end

function UIEventNewHeroLoginLayout:EnableTimeCountDown(isEnable, index, nextReward)
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

function UIEventNewHeroLoginLayout:StartUpdateTime()
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

function UIEventNewHeroLoginLayout:SetTimeRefresh()
    local svTime = zg.timeMgr:GetServerTime()
    self.timeRefresh = TimeUtils.GetTimeStartDayFromSec(svTime) + TimeUtils.SecondADay - svTime
end

function UIEventNewHeroLoginLayout:RemoveUpdateTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
        self.updateTime = nil
    end
end