--- @class UIEventSeasonalCheckinLayout : UIEventSeasonalLayout
UIEventSeasonalCheckinLayout = Class(UIEventSeasonalCheckinLayout, UIEventSeasonalLayout)

--- @param view UIEventSeasonalView
--- @param anchor UnityEngine_RectTransform
function UIEventSeasonalCheckinLayout:Ctor(view, tab, anchor)
    self.tab = tab
    --- @type UIEventSeasonalView
    self.view = view
    ---@type UIEventSeasonalCheckinLayoutConfig
    self.layoutConfig = nil
    ---@type Dictionary
    self.loginRewardDict = Dictionary()
    --- @type EventSeasonalConfig
    self.eventConfig = nil
    ---@type UILoopScroll
    self.uiScroll = nil
    UIEventSeasonalLayout.Ctor(self, view, tab, anchor)
end

function UIEventSeasonalCheckinLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_seasonal_checkin_layout", self.anchor)
    UIEventSeasonalLayout.InitLayoutConfig(self, inst)
    self:InitUpdateTime()
    self:InitIScroll()
end

function UIEventSeasonalCheckinLayout:InitLocalization()
    UIEventSeasonalLayout.InitLocalization(self)
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("seasonal_check_in")
    self.layoutConfig.textReCheckin.text = LanguageUtils.LocalizeCommon("recheckin")
end

function UIEventSeasonalCheckinLayout:InitButtonListener()
    self.layoutConfig.backButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        self:CloseLayout()
    end)
    self.layoutConfig.buttonInfor.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_seasonal_info"))
    end)
end

function UIEventSeasonalCheckinLayout:ButtonCheckInAddListener(func)
    self.layoutConfig.buttonCheckin.onClick:RemoveAllListeners()
    self.layoutConfig.buttonCheckin.onClick:AddListener(function()
        if func then
            func()
        end
    end)
end

function UIEventSeasonalCheckinLayout:ValidateCheckinDay()
    self.eventCurrentDay = self.eventModel:GetEventCurrentDay()
    self.lastClaimDay = self.eventModel:GetLoginLastClaimDay()
    self.isChecked = self.eventModel:IsClaimed()
    self.isFreeClaim = self.eventModel:IsFreeClaim()
    self.loginRewardDict = self.eventModel.config:GetLoginRewardConfig()
end

function UIEventSeasonalCheckinLayout:InitMoneyBar()
    --- @type List
    self.listMoneyBar = List()
    ---@type MoneyBarView
    local moneyBarView1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
    moneyBarView1:SetIconData(MoneyType.EVENT_SEASONAL_MONEY)
    moneyBarView1.config.buttonInfo.interactable = true
    moneyBarView1.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView1:SetSize(0, 0)
    moneyBarView1.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView1:ShowInfo()
    end)
    moneyBarView1:AddListener(function()
        self.view:SelectTab(EventSeasonalTab.FIREWORK_SHOP)
    end)
    ---@type MoneyBarView
    local moneyBarView2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
    moneyBarView2:SetIconData(MoneyType.EVENT_SEASONAL_GUN_POWER)
    moneyBarView2.config.buttonInfo.interactable = true
    moneyBarView2.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView2:SetSize(0, 0)
    moneyBarView2.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView2:ShowInfo()
    end)
    moneyBarView2:AddListener(function()
        self.view:SelectTab(EventSeasonalTab.FIREWORK_SHOP)
    end)
    self.listMoneyBar:Add(moneyBarView1)
    self.listMoneyBar:Add(moneyBarView2)
end

function UIEventSeasonalCheckinLayout:ReturnPoolMoneyBar()
    ---@param v MoneyBarView
    for _, v in pairs(self.listMoneyBar:GetItems()) do
        v:ReturnPool()
    end
    self.listMoneyBar:Clear()
end

function UIEventSeasonalCheckinLayout:InitIScroll()
    ---@param obj EventSeasonalCheckinItem
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        local loginRewardDict = self.loginRewardDict:Get(dataIndex)
        obj:SetItemData(dataIndex, loginRewardDict)
        if self.eventCurrentDay <= 0 then
            obj:IsLock(true)
            obj:IsClaimed(false)
        elseif self.lastClaimDay == self.eventCurrentDay then
            if dataIndex <= self.lastClaimDay then
                obj:IsClaimed(true)
            else
                obj:IsLock(true)
                obj:IsClaimed(false)
            end
        else
            if dataIndex <= self.lastClaimDay then
                obj:IsClaimed(true)
            elseif dataIndex == self.lastClaimDay + 1 then
                if not self.isChecked and self.isFreeClaim then
                    obj:IsLock(false)
                    obj:IsClaimed(false)
                    obj:HasNoti(true)
                    obj:AddListener(function()
                        self:OpCode(obj)
                    end)
                elseif not self.isChecked and not self.isFreeClaim then
                    obj:IsLock(false)
                    obj:IsClaimed(false)
                    obj:AddListener(function()
                        local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, loginRewardDict.moneyData.moneyType, loginRewardDict.moneyData.moneyValue))
                        if canExchange then
                            local yesCallback = function()
                                self:OpCode(obj, loginRewardDict.moneyData)
                            end
                            PopupUtils.ShowPopupNotificationYesNo(string.format("%s: %d %s",
                                    LanguageUtils.LocalizeCommon("confirm_use_resource"), loginRewardDict.moneyData.moneyValue,
                                    UIUtils.SetColorString(UIUtils.green_dark,
                                            LanguageUtils.GetStringResourceName(ResourceType.Money, loginRewardDict.moneyData.moneyType)))
                            , nil, yesCallback)
                        end
                    end)
                end
            else
                obj:IsLock(true)
                obj:IsClaimed(false)
            end
        end
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.EventSeasonalCheckinItem, onCreateItem)
end

---@param obj EventSeasonalCheckinItem
function UIEventSeasonalCheckinLayout:OpCode(obj, moneyData)
    local rewardList = List()
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        rewardList = NetworkUtils.GetRewardInBoundList(buffer)
    end

    local onSuccess = function()
        if moneyData then
            InventoryUtils.Sub(ResourceType.Money, moneyData.moneyType, moneyData.moneyValue)
        end
        if self.isFreeClaim then
            self.isFreeClaim = false
        end
        self.eventModel:AddLoginLastClaimDay()
        self:ValidateCheckinDay()
        if obj then
            obj:IsClaimed(true)
        end
        self.uiScroll:Resize(self.loginRewardDict:Count())
        self.view:UpdateNotificationByTab(self.tab)
        if rewardList ~= nil or rewardList:Count() > 0 then
            PopupUtils.ClaimAndShowRewardList(rewardList)
        end
        self:InitButtonCheckin()
    end

    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
    end
    NetworkUtils.RequestAndCallback(OpCode.EVENT_SEASONAL_LOGIN, nil, onSuccess, onFailed, onBufferReading)
end

function UIEventSeasonalCheckinLayout:ReturnPoolScroll()
    self.uiScroll:Hide()
end

function UIEventSeasonalCheckinLayout:OnPurchaseSuccess()
    self.view:CheckAllNotificationTab()
end

function UIEventSeasonalCheckinLayout:EnableTextCheckin(isEnable)
    self.layoutConfig.textCheckin.gameObject:SetActive(isEnable)
    self.layoutConfig.textReCheckin.gameObject:SetActive(not isEnable)
end

function UIEventSeasonalCheckinLayout:EnableNotiCheckin(isEnable)
    self.layoutConfig.notiCheckin.gameObject:SetActive(isEnable)
end

function UIEventSeasonalCheckinLayout:SetCheckinText(text)
    self.layoutConfig.textCheckin.text = text
end

---@param moneyData {moneyType, moneyValue}
function UIEventSeasonalCheckinLayout:SetReCheckinMoneyData(moneyData)
    self.layoutConfig.recheckinMoneyIcon.sprite = ResourceLoadUtils.LoadMoneyIcon(moneyData.moneyType)
    self.layoutConfig.recheckinPrice.text = moneyData.moneyValue
end

function UIEventSeasonalCheckinLayout:InitButtonCheckin()
    self.layoutConfig.buttonCheckin.interactable = true
    if self.eventCurrentDay <= 0 then
        self:EnableTextCheckin(true)
        self:EnableNotiCheckin(false)
        self:SetCheckinText(LanguageUtils.LocalizeCommon("wait_event_start"))
        self:ButtonCheckInAddListener(function()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("wait"))
        end)
    elseif self.lastClaimDay + 1 <= self.eventCurrentDay then
        if not self.isChecked and not self.isFreeClaim then
            self:EnableTextCheckin(false)
            self:EnableNotiCheckin(false)
            self:SetCheckinText(LanguageUtils.LocalizeCommon("recheckin"))
            ---@type {moneyType, moneyValue}
            local moneyData = self.loginRewardDict:Get(self.lastClaimDay + 1).moneyData
            self:SetReCheckinMoneyData(moneyData)
            self:ButtonCheckInAddListener(function()
                local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(
                        RewardInBound.CreateBySingleParam(
                                ResourceType.Money, moneyData.moneyType, moneyData.moneyValue))
                if canExchange then
                    local yesCallback = function()
                        self:OpCode(false, moneyData)
                    end
                    PopupUtils.ShowPopupNotificationYesNo(string.format("%s: %d %s",
                            LanguageUtils.LocalizeCommon("confirm_use_resource"), moneyData.moneyValue,
                            UIUtils.SetColorString(UIUtils.green_dark,
                                    LanguageUtils.GetStringResourceName(ResourceType.Money, moneyData.moneyType)))
                    , nil, yesCallback)
                end
            end)
        elseif not self.isChecked and self.isFreeClaim then
            self:EnableTextCheckin(true)
            self:EnableNotiCheckin(true)
            self:SetCheckinText(LanguageUtils.LocalizeCommon("checkin"))
            self:ButtonCheckInAddListener(function()
                self:OpCode(false)
            end)
        end
    elseif self.lastClaimDay == self.eventCurrentDay then
        self:EnableTextCheckin(true)
        self:EnableNotiCheckin(false)
        self:SetCheckinText(LanguageUtils.LocalizeCommon("claimed"))
        self.layoutConfig.buttonCheckin.interactable = false
    end
    UIUtils.SetActiveColorByMaterial(self.layoutConfig.buttonCheckin.gameObject, self.lastClaimDay ~= self.eventCurrentDay, "ui_gray_mat")
end

function UIEventSeasonalCheckinLayout:OnShow()
    UIEventSeasonalLayout.OnShow(self)
    self.anchor.gameObject:SetActive(true)
    self:InitMoneyBar()
    self:SetNextDayTime(function()
        self:OnEventTimeEnded()
    end)
    self:ValidateCheckinDay()
    self:InitButtonCheckin()
    self.uiScroll:Resize(self.loginRewardDict:Count())
end

function UIEventSeasonalCheckinLayout:SetUpLayout()
    UIEventSeasonalLayout.SetUpLayout(self)
end

function UIEventSeasonalCheckinLayout:OnHide()
    self:ReturnPoolScroll()
    self:RemoveUpdateTime()
    self:ReturnPoolMoneyBar()
    UIEventSeasonalLayout.OnHide(self)
end

function UIEventSeasonalCheckinLayout:GetEventEndTime()
    return self.eventModel.timeData.endTime
end

--- @param onEventTimeEnded function
function UIEventSeasonalCheckinLayout:SetNextDayTime(onEventTimeEnded)
    self.onEventTimeEnded = onEventTimeEnded
    self:StartUpdateTime()
end

--- @param eventTimeType EventTimeType
function UIEventSeasonalCheckinLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventSeasonalCheckinLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventSeasonalCheckinLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventSeasonalCheckinLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

function UIEventSeasonalCheckinLayout:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.layoutConfig.textEventTime.text = string.format("%s %s", LanguageUtils.LocalizeCommon("time_next_day"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end
