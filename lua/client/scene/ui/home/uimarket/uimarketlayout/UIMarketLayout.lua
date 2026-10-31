--- @class UIMarketLayout
UIMarketLayout = Class(UIMarketLayout)

--- @param view UIMarketView
--- @param marketType MarketType
function UIMarketLayout:Ctor(view, marketType)
    --- @type MarketType
    self.marketType = marketType
    --- @type UIMarketView
    self.view = view
    --- @type UIMarketConfig
    self.config = view.config
    --- @type UIMarketModel
    self.model = view.model

    --- @type MoneyType
    self.upgradeMoneyType = nil
    --- @type OpCode
    self.opCodeRefresh = nil
    --- @type OpCode
    self.opCodeBuy = nil
    --- @type OpCode
    self.opCodeUpgrade = nil
    --- @type MarketConfig
    self.marketConfig = nil
    --- @type ModeShopDataInBound
    self.modeShopDataInBound = nil

    self.rewardList = List()
end

function UIMarketLayout:InitLocalization()
    --- @type string
    self.formatTimer = LanguageUtils.LocalizeCommon("refresh_in")
end

function UIMarketLayout:OnShow()
    self:FireTracking()
    self:SetUpLayout()
    if self:IsAvailableToRequest() then
        self.config.loading:SetActive(true)
        Coroutine.start(function()
            coroutine.waitforseconds(0.3)
            self:RequestShopData()
        end)
    else
        self:OnLoadedShopData()
    end
    self:UpdateTimeRefresh()
end

function UIMarketLayout:SetUpLayout()

end

function UIMarketLayout:RequestShopData()
    self.config.loading:SetActive(true)
end

function UIMarketLayout:OnLoadedShopData()
    self.config.loading:SetActive(false)
    self.model.currentPage = 1
    self.view:SetNumberPageByMarketItemsCount(self.modeShopDataInBound.marketItemList:Count())
    self:ShowShopData()
    self:ShowUpgradingBtn()
    --self:UpdateTimeRefresh()
    self:ShowButtonRefresh()
end

function UIMarketLayout:ShowShopData()
    self.view:HideItemsTableView()
    local itemCount = self.modeShopDataInBound.marketItemList:Count()
    local fromIndex, toIndex = self:GetRangeItem(itemCount)
    local dataItems = List()
    for i = fromIndex, toIndex do
        dataItems:Add(self.modeShopDataInBound.marketItemList:Get(i))
    end
    self.view:SetDataItems(dataItems)
    self:UpdateIconViewList()
end

function UIMarketLayout:ShowUpgradingBtn()
    if self.view:IsOpenNewShop() then
        self.config.ugradingProcess.gameObject:SetActive(self.opCodeUpgrade ~= nil)
    end
end

function UIMarketLayout:ShowUpgradingProcess(marketTitle)
    local level = self.modeShopDataInBound.level
    --- @type MarketUpgradeData
    local processConfig = self.marketConfig:GetUpgradeMoneyList(level).listData:Get(1)
    if self.marketConfig ~= nil and self.view:IsOpenNewShop() then
        if level < self.marketConfig.maxLevel then
            local coin = InventoryUtils.GetMoney(self.upgradeMoneyType)
            local fill = coin / processConfig.moneyValue
            local processText = "%s/%s"
            local titleTxt = "%s %s %s"
            processText = string.format(processText, coin, processConfig.moneyValue)
            titleTxt = string.format(titleTxt, marketTitle, LanguageUtils.LocalizeCommon("level"), level)
            self.config.fillAmountLevel.fillAmount = fill
            self.config.modeShopLevel.text = titleTxt
            self.config.processText.text = processText
            self.config.canUpgrade.gameObject:SetActive(true)
            self.config.cantUpgrade.gameObject:SetActive(false)
        else
            local titleTxt = "%s %s"
            titleTxt = string.format(titleTxt, marketTitle, LanguageUtils.LocalizeCommon("level_to_max"))
            self.config.canUpgrade.gameObject:SetActive(false)
            self.config.cantUpgrade.text = titleTxt
            self.config.cantUpgrade.gameObject:SetActive(true)
        end
    end
end

function UIMarketLayout:OnHide()

end

function UIMarketLayout:FireTracking()

end

function UIMarketLayout:GetRangeItem()
    local minIndex = (self.model.currentPage - 1) * self.model.SLOT_PER_PAGE + 1
    local maxIndex = math.min(self.modeShopDataInBound.marketItemList:Count(), minIndex + self.model.SLOT_PER_PAGE - 1)
    return minIndex, maxIndex
end

function UIMarketLayout:OnClickUpgrade()
    if self.upgradeMoneyType == nil then
        return
    end
    local resourceUpgrade = self:GetMoneyUpgrade()
    local canUpgrade = InventoryUtils.IsEnoughMultiResourceRequirement(self.marketConfig:GetUpgradeMoneyList(self.modeShopDataInBound.level):GetRewardInboundList())
    if canUpgrade then
        PopupMgr.ShowPopup(UIPopupName.UIUpgradeMarket,
                { ["resourceList"] = resourceUpgrade,
                  ['title'] = LanguageUtils.LocalizeCommon("notice"),
                  ["yesCallback"] = function()
                      PopupMgr.HidePopup(UIPopupName.UIUpgradeMarket)
                      self:RequestUpgradeShop(function(result)
                          self:OnUpgradeSuccess(result)
                      end)
                  end })
    end
end

function UIMarketLayout:RequestUpgradeShop(callback, onFailed)
    if self.opCodeUpgrade ~= nil then
        NetworkUtils.Request(self.opCodeUpgrade, self:GetOutboundRequestUpgrade(), callback)
    else
        if onFailed ~= nil then
            onFailed()
        end
    end
end

--- @return UnknownOutBound
function UIMarketLayout:GetOutboundRequestUpgrade()
    return UnknownOutBound.CreateInstance(PutMethod.Short, self.modeShopDataInBound.level + 1)
end

function UIMarketLayout:IsAvailableToUpgradeMarket()
    local level = self.modeShopDataInBound.level
    local dataConfig = self.marketConfig:GetUpgradeMoneyList(level).listData
    --- @type MarketUpgradeData
    local processConfig = dataConfig:Get(1)
    return InventoryUtils.GetMoney(self.upgradeMoneyType) >= processConfig.moneyType
end

--- @return List
function UIMarketLayout:GetMoneyUpgrade()
    local resourceList = List()
    local listData = self.marketConfig:GetUpgradeMoneyList(self.modeShopDataInBound.level).listData
    for i = 1, listData:Count() do
        resourceList:Add(ItemIconData.CreateInstance(ResourceType.Money, listData:Get(i).moneyType, listData:Get(i).moneyValue))
    end
    return resourceList
end

function UIMarketLayout:OnUpgradeSuccess(result)
    local dataConfig = self.marketConfig:GetUpgradeMoneyList(self.modeShopDataInBound.level)
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        self.modeShopDataInBound:ReadBuffer(buffer)
    end
    local onSuccess = function()
        self:ShowUpgradeVfx()
        for i = 1, dataConfig.listData:Count() do
            InventoryUtils.Sub(ResourceType.Money, self.upgradeMoneyType, dataConfig.listData:Get(i).moneyValue)
        end
        self:OnLoadedShopData()
        self.view:SetAllNotification()
    end
    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
    end
    NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
end

function UIMarketLayout:OnChangePage()
    self:ShowShopData()
end

function UIMarketLayout:UpdateIconViewList()
    --- @type List|ModeShopIconView
    local itemViewList = self.view.itemsTableView:GetItems()
    for i = 1, itemViewList:Count() do
        --- @type ModeShopIconView
        local modeShopIconView = itemViewList:Get(i)
        if self.marketConfig == nil then
            modeShopIconView:ActiveButtonHelp(false)
        else
            local slotInConfig = (self.model.currentPage - 1) * self.model.SLOT_PER_PAGE + i
            local groupMarketItemRateConfig = self.marketConfig:FindGroupMarketItemRateBySlot(slotInConfig)
            if groupMarketItemRateConfig == nil or groupMarketItemRateConfig.listMarketItemRate:Count() == 1 then
                modeShopIconView:ActiveButtonHelp(false)
            else
                modeShopIconView:ActiveButtonHelp(true, function()
                    self.view:OnSelectShowInfo(groupMarketItemRateConfig)
                end)
            end
        end
    end
end

function UIMarketLayout:UpdateIconViewListRefresh()
    --- @type List|ModeShopIconView
    local itemViewList = self.view.itemsTableView:GetItems()
    for i = 1, itemViewList:Count() do
        --- @type ModeShopIconView
        local modeShopIconView = itemViewList:Get(i)
        modeShopIconView:ActiveEffectResetItem(false)
        modeShopIconView:ActiveEffectResetItem(true)
    end
end

function UIMarketLayout:ShowButtonRefresh()
    if self.view:IsOpenNewShop() then
        self.config.refreshButton.gameObject:SetActive(self.opCodeRefresh ~= nil and self.playerDataMethod ~= nil
                and self.playerDataMethod ~= PlayerDataMethod.ARENA_MARKET)
    else
        self.config.refreshButton.gameObject:SetActive(self.opCodeRefresh ~= nil and self.playerDataMethod ~= nil
                and self.playerDataMethod ~= PlayerDataMethod.MARKET)
    end
end

function UIMarketLayout:UpdateTimeRefresh(setTime, onTimeEnd)
    local ended = function()
        self.view:RemoveUpdateTime()
        self.view:HideItemsTableView()
        if onTimeEnd ~= nil then
            onTimeEnd()
        else
            self:RequestShopData()
        end
    end
    self.view.updateTime = function(isSetTime)
        if isSetTime == true then
            setTime()
            if self.timeRefresh < 0 then
                ended()
                return
            end
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        if self.timeRefresh >= 0 then
            local textTime = TimeUtils.GetDeltaTime(self.timeRefresh)
            self.config.textTimer.text = string.format(self.formatTimer, " " .. UIUtils.SetColorString(UIUtils.green_light, textTime))
        else
            ended()
        end
    end
    self.view:StartUpdateTime()
end

function UIMarketLayout:OnClickButtonRefresh()
    self:UpdateRewardNeed()
    if self:IsRefreshAvailable() then
        self:RequestRefreshMarket(function(result)
            self:OnSuccessRefreshMarket(result)
        end)
    end
end

--- @return boolean
function UIMarketLayout:UpdateRewardNeed()
    self.rewardList:Clear()
    self.rewardList:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, self.marketConfig.refreshMoneyType, self.marketConfig.refreshPrice))
end

--- @return boolean
function UIMarketLayout:IsRefreshAvailable()
    return InventoryUtils.IsEnoughMultiResourceRequirement(self.rewardList, true)
end

function UIMarketLayout:RequestRefreshMarket(callback, onFailed)
    if self.opCodeRefresh ~= nil then
        NetworkUtils.Request(self.opCodeRefresh, nil, callback)
    else
        if onFailed ~= nil then
            onFailed()
        end
    end
end

function UIMarketLayout:OnSuccessRefreshMarket(result)
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        self.modeShopDataInBound:ReadBuffer(buffer)
    end
    local onSuccess = function()
        self:OnLoadedShopData()
        InventoryUtils.Sub(ResourceType.Money, self.marketConfig.refreshMoneyType, self.marketConfig.refreshPrice)
        self.view:ShowRefreshPriceText(self.marketConfig)
    end
    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
    end
    NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
end

function UIMarketLayout:ShowUpgradeVfx()
    if self.view:IsOpenNewShop() then
        self.config.animUpgrade:SetActive(false)
        self.config.animUpgrade:SetActive(true)
    end
end

--- @param iconView ModeShopIconView
--- @param onBuySuccess function
function UIMarketLayout:RequestBuyItem(iconView, onBuySuccess)
    MarketRequest.BuyItem(self.opCodeBuy, iconView.iconData.id, onBuySuccess)
end

--- @return boolean
function UIMarketLayout:IsAvailableToRequest()
    return false
end