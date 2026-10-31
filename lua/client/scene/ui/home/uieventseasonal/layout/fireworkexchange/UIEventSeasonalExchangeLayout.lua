require "lua.client.data.Event.ExchangeEventConfig"
--- @class UIEventSeasonalExchangeLayout : UIEventSeasonalLayout
UIEventSeasonalExchangeLayout = Class(UIEventSeasonalExchangeLayout, UIEventSeasonalLayout)

local EXCHANGE_NUMBER = 1
local SINGLE_LIMIT = 1

--- @param view UIEventSeasonalView
--- @param anchor UnityEngine_RectTransform
function UIEventSeasonalExchangeLayout:Ctor(view, tab, anchor)
    self.tab = tab
    --- @type UIEventSeasonalView
    self.view = view
    ---@type UIEventSeasonalExchangeLayoutConfig
    self.layoutConfig = nil
    ---@type Dictionary
    self.exchangeGroupRewardDict = Dictionary()
    --- @type EventSeasonalConfig
    self.eventConfig = nil
    ---@type number
    self.currentIndex = nil
    ---@type UILoopScroll
    self.uiScroll = nil
    ---@type List
    self.listDotSelect = nil
    UIEventSeasonalLayout.Ctor(self, view, tab, anchor)
end

function UIEventSeasonalExchangeLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_seasonal_exchange_layout", self.anchor)
    UIEventSeasonalLayout.InitLayoutConfig(self, inst)
    self:InitUpdateTime()
    self:InitIScroll()
end

function UIEventSeasonalExchangeLayout:InitLocalization()
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("seasonal_exchange")
end

function UIEventSeasonalExchangeLayout:InitMoneyBar()
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

function UIEventSeasonalExchangeLayout:ReturnPoolMoneyBar()
    ---@param v MoneyBarView
    for _, v in pairs(self.listMoneyBar:GetItems()) do
        v:ReturnPool()
    end
    self.listMoneyBar:Clear()
end

function UIEventSeasonalExchangeLayout:GetDictExchangeReward()
    self.exchangeGroupRewardDict = self.eventConfig:GetExchangeGroupRewardConfig()
end

function UIEventSeasonalExchangeLayout:InitIScroll()
    ---@param obj EventSeasonalExchangeItem
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        ---@type EventSeasonalExchangeItemData
        local itemData = self.exchangeGroupRewardDict:Get(self.currentIndex):Get(dataIndex)
        obj:AddListener(function()
            local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, itemData.priceType, itemData.price))
            if canExchange then
                if itemData.limit > SINGLE_LIMIT then
                    local listReward = List()
                    listReward:Add(itemData.rewardInBound:GetIconData())
                    --- @type ExchangeEventConfig
                    local exchangeData = ExchangeEventConfig()
                    exchangeData.id = itemData.id
                    exchangeData.itemIconData = ItemIconData.CreateInstance(ResourceType.Money, itemData.priceType, itemData.price)
                    exchangeData.limit = itemData.limit
                    exchangeData.listRewardItem = listReward
                    local data = {}
                    data.opCode = OpCode.EVENT_SEASONAL_EXCHANGE
                    data.exchangeData = exchangeData
                    data.currentExchange = self.eventModel:GetExchangeNumberById(itemData.id)
                    data.callbackExchange = function(number)
                        self:CallbackExchange(exchangeData, number)
                    end
                    PopupMgr.ShowPopup(UIPopupName.UIPopupExchangeMidAutumn, data)
                else
                    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("confirm_exchange"), nil, function()
                        self:ExchangeItem(itemData, EXCHANGE_NUMBER)
                    end)
                end
            end
        end)
        local numberBuy = self.eventModel:GetExchangeNumberById(itemData.id)
        obj:SetData(itemData, numberBuy)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.EventSeasonalExchangeItem, onCreateItem)
end

function UIEventSeasonalExchangeLayout:InitDotSelect()
    ---@type List
    self.listDotSelect = List()
    for i = 1, self.exchangeGroupRewardDict:Count() do
        ---@type DotSelect
        local dotSelect = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.DotSelect, self.layoutConfig.dotAnchor)
        dotSelect:AddListener(function()
            if i ~= self.currentIndex then
                self:SetCurrentIndex(i)
                self:RefreshScroll()
            end
        end)
        self.listDotSelect:Add(dotSelect)
    end
end

function UIEventSeasonalExchangeLayout:SetStateDotSelect()
    ---@param v DotSelect
    for k, v in pairs(self.listDotSelect:GetItems()) do
        if k == self.currentIndex then
            v:SetActiveState(true)
        else
            v:SetActiveState(false)
        end
    end
end

function UIEventSeasonalExchangeLayout:ResetStateDotSelect()
    ---@param v DotSelect
    for _, v in pairs(self.listDotSelect:GetItems()) do
        v:SetActiveState(false)
    end
end

function UIEventSeasonalExchangeLayout:ReturnPoolDotSelect()
    ---@param v DotSelect
    for _, v in pairs(self.listDotSelect:GetItems()) do
        v:ReturnPool()
    end
    self.listDotSelect:Clear()
end

---@param itemData EventSeasonalExchangeItemData
function UIEventSeasonalExchangeLayout:ExchangeItem(itemData, quantity)
    local number = quantity or EXCHANGE_NUMBER
    local rewardList = List()
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        rewardList = NetworkUtils.GetRewardInBoundList(buffer)
    end

    local onSuccess = function()
        if itemData.priceType and itemData.price ~= nil then
            InventoryUtils.Sub(ResourceType.Money, itemData.priceType, itemData.price)
        end
        self.eventModel:AddExchangeNumberByIdAndNumber(itemData.id, number)
        self:RefreshScroll()
        if rewardList ~= nil or rewardList:Count() > 0 then
            PopupUtils.ClaimAndShowRewardList(rewardList)
        end
    end

    local onFailed = function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("failed"))
    end
    NetworkUtils.RequestAndCallback(OpCode.EVENT_SEASONAL_EXCHANGE,
            UnknownOutBound.CreateInstance(PutMethod.Int, itemData.id, PutMethod.Int, EXCHANGE_NUMBER),
            onSuccess, onFailed, onBufferReading)
end

---@param exchangeData ExchangeEventConfig
function UIEventSeasonalExchangeLayout:CallbackExchange(exchangeData, number)
    exchangeData:SubMoney(number)
    local iconList = List()
    --- @param reward ItemIconData
    for _, reward in ipairs(exchangeData.listRewardItem:GetItems()) do
        local newReward = ItemIconData.Clone(reward)
        newReward.quantity = newReward.quantity * number
        iconList:Add(newReward)
    end
    PopupUtils.ClaimAndShowItemList(iconList)
    self.eventModel:AddExchangeNumberByIdAndNumber(exchangeData.id, number)
    self:RefreshScroll()
end

function UIEventSeasonalExchangeLayout:ReturnPoolScroll()
    self.uiScroll:Hide()
end

function UIEventSeasonalExchangeLayout:OnPurchaseSuccess()
    self.view:CheckAllNotificationTab()
end

function UIEventSeasonalExchangeLayout:InitButtonListener()
    self.layoutConfig.backButton.onClick:AddListener(function()
        self:CloseLayout()
    end)
    self.layoutConfig.buttonInfor.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_seasonal_info"))
    end)

    self.layoutConfig.arrowLeft.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:CheckCurrentIndex(-1)
        self:RefreshScroll()
    end)

    self.layoutConfig.arrowRight.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:CheckCurrentIndex(1)
        self:RefreshScroll()
    end)
end

function UIEventSeasonalExchangeLayout:CheckCurrentIndex(number)
    self:SetCurrentIndex(self.currentIndex + number)
end

function UIEventSeasonalExchangeLayout:SetCurrentIndex(number)
    self.currentIndex = number
    self:CheckArrowState()
    self:ResetStateDotSelect()
    self:SetStateDotSelect()
end

function UIEventSeasonalExchangeLayout:CheckArrowState()
    if self.currentIndex <= 1 then
        self.layoutConfig.arrowRight.gameObject:SetActive(true)
        self.layoutConfig.arrowLeft.gameObject:SetActive(false)
    elseif self.currentIndex >= self.exchangeGroupRewardDict:Count() then
        self.layoutConfig.arrowRight.gameObject:SetActive(false)
        self.layoutConfig.arrowLeft.gameObject:SetActive(true)
    else
        self.layoutConfig.arrowRight.gameObject:SetActive(true)
        self.layoutConfig.arrowLeft.gameObject:SetActive(true)
    end
end

function UIEventSeasonalExchangeLayout:OnShow()
    UIEventSeasonalLayout.OnShow(self)
    self.anchor.gameObject:SetActive(true)
    self:InitMoneyBar()
    self:SetNextDayTime(function()
        self:OnEventTimeEnded()
    end)
    self:GetDictExchangeReward()
    self.currentIndex = 1
    self:CheckArrowState()
    self:RefreshScroll()
    self:InitDotSelect()
    self:SetStateDotSelect()
end

function UIEventSeasonalExchangeLayout:RefreshScroll()
    self.uiScroll:Resize(self.exchangeGroupRewardDict:Get(self.currentIndex):Count())
end

function UIEventSeasonalExchangeLayout:SetUpLayout()
    UIEventSeasonalLayout.SetUpLayout(self)
end

function UIEventSeasonalExchangeLayout:OnHide()
    self:ReturnPoolMoneyBar()
    self:ReturnPoolScroll()
    self:ReturnPoolDotSelect()
    self:RemoveUpdateTime()
    UIEventSeasonalLayout.OnHide(self)
end

function UIEventSeasonalExchangeLayout:GetEventEndTime()
    return self.eventModel.timeData.endTime
end

--- @param onEventTimeEnded function
function UIEventSeasonalExchangeLayout:SetNextDayTime(onEventTimeEnded)
    self.onEventTimeEnded = onEventTimeEnded
    self:StartUpdateTime()
end

--- @param eventTimeType EventTimeType
function UIEventSeasonalExchangeLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventSeasonalExchangeLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventSeasonalExchangeLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventSeasonalExchangeLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

function UIEventSeasonalExchangeLayout:InitUpdateTime()
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
