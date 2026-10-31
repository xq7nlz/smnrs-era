--- @class UIPopupExchangeMidAutumnView : UIBaseView
UIPopupExchangeMidAutumnView = Class(UIPopupExchangeMidAutumnView, UIBaseView)

--- @return void
--- @param model UIPopupExchangeMidAutumnModel
function UIPopupExchangeMidAutumnView:Ctor(model)
    ---@type MoneyType
    self.moneyType = nil
    ---@type number
    self.currentExchange = nil
    ---@type function
    self.callbackExchange = nil
    ---@type InputSliderView
    self.input = nil
    ---@type MoneyBarLocalView
    self.moneyBar = nil
    ---@type MoneyIconView
    self.item1 = nil
    ---@type MoneyIconView
    self.item2 = nil
    ---@type number
    self.quantityExchange = nil
    ----@type  {moneyType, moneyValue}
    self.exchangePrice = nil
    ---@type function
    self.callbackExchangePrice = nil
    -- init variables here
    UIBaseView.Ctor(self, model)
    --- @type UIPopupExchangeMidAutumnModel
    self.model = model
end

--- @return void
function UIPopupExchangeMidAutumnView:OnReadyCreate()
    ---@type UIGuildQuestDonateConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.moneyBar = MoneyBarLocalView(self.config.moneyBarInfo)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonBg.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.donateButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickExchange()
    end)
end

--- @return void
function UIPopupExchangeMidAutumnView:ExchangePriceListener(func)
    self.config.buttonExchangePrice.onClick:RemoveAllListeners()
    self.config.buttonExchangePrice.onClick:AddListener(function()
        if func then
            func()
        end
    end)
end

--- @return void
function UIPopupExchangeMidAutumnView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("exchange")
    self.config.textCurrencyOwned.text = LanguageUtils.LocalizeCommon("owned")
    self.config.textCurrencyGuildOwned.text = LanguageUtils.LocalizeCommon("item_exchange")
    self.config.textDonate.text = LanguageUtils.LocalizeCommon("exchange")
    self.config.textExchange.text = LanguageUtils.LocalizeCommon("exchange")
end

function UIPopupExchangeMidAutumnView:OnReadyShow(result)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self:SetButtonExchangePrice(false)
    self:Init(result)
end

--- @return void
function UIPopupExchangeMidAutumnView:Init(result)
    self.opCode = result.opCode
    --- @type ExchangeEventConfig
    self.exchangeData = result.exchangeData
    self.currentExchange = result.currentExchange or 0
    self.callbackExchange = result.callbackExchange
    self.exchangePrice = result.exchangePrice
    self.callbackExchangePrice = result.callbackExchangePrice
    if self.exchangePrice then
        self:SetButtonExchangePrice(true)
        self:SetButtonExchangePriceState(self.exchangePrice)
    end
    self.moneyBar:SetIconData(self.exchangeData.itemIconData.itemId)
    self.moneyBar.needHighLight = true
    self.moneyBar:SetBuyText(self.exchangeData.itemIconData.quantity)
    local totalMoney = InventoryUtils.GetMoney(self.exchangeData.itemIconData.itemId)
    if self.item1 == nil then
        self.item1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyIconView, self.config.icon1)
    end
    self.item1:SetIconData(self.exchangeData.itemIconData)
    ---@type ItemIconData
    local reward = self.exchangeData.listRewardItem:Get(1)
    if self.item2 == nil then
        self.item2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.icon2)
    end
    local iconData = ItemIconData.Clone(reward)
    self.item2:SetIconData(iconData)
    self.config.textCurrencyName1.text = LanguageUtils.LocalizeMoneyType(self.exchangeData.itemIconData.itemId)
    self.config.textCurrencyName2.text = LanguageUtils.GetStringResourceName(reward.type, reward.itemId)
    if self.input == nil then
        self.input = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.InputNumberView, self.config.inputSliderView)
    end
    local max = math.min(100000000, math.floor(totalMoney / self.exchangeData.itemIconData.quantity))
    if self.exchangeData.limit > 0 then
        max = math.min(max, self.exchangeData.limit - self.currentExchange)
    end
    self.input:SetData(1, 1, max)

    self.input.onChangeInput = function(value)
        local quantity = self.exchangeData.itemIconData.quantity * value
        self.moneyBar:SetBuyText(quantity)
        self.item1:_SetQuantity(quantity)
        iconData.quantity = reward.quantity * value
        self.item2:SetIconData(iconData)
        if self.exchangePrice then
            self:SetTextExchangePrice(self.exchangePrice, quantity)
            self.quantityExchange = value
        end
    end
    self.input.onChangeInput(1)
end

--- @return void
function UIPopupExchangeMidAutumnView:Hide()
    self:SetButtonExchangePrice(false)
    if self.input ~= nil then
        self.input:ReturnPool()
        self.input.onChangeInput = nil
        self.input = nil
    end
    if self.item1 ~= nil then
        self.item1:ReturnPool()
        self.item1 = nil
    end
    if self.item2 ~= nil then
        self.item2:ReturnPool()
        self.item2 = nil
    end
    UIBaseView.Hide(self)
end

--- @return void
function UIPopupExchangeMidAutumnView:OnClickExchange()
    NetworkUtils.RequestAndCallback(self.opCode,
            UnknownOutBound.CreateInstance(PutMethod.Int, self.exchangeData.id, PutMethod.Int, self.input.value),
            function()
                if self.callbackExchange ~= nil then
                    self.callbackExchange(self.input.value)
                end
                self:OnClickBackOrClose()
            end, SmartPoolUtils.LogicCodeNotification, nil, true, true)
end

--- @return void
---@param exchangePrice {moneyType, moneyValue}
function UIPopupExchangeMidAutumnView:SetButtonExchangePriceState(exchangePrice)
    self.config.exchangePriceType.sprite = ResourceLoadUtils.LoadMoneyIcon(exchangePrice.moneyType)
    self.config.exchangePriceType:SetNativeSize()
end

--- @return void
---@param exchangePrice {moneyType, moneyValue}
function UIPopupExchangeMidAutumnView:SetTextExchangePrice(exchangePrice, quantity)
    local resourceNumber = InventoryUtils.GetMoney(exchangePrice.moneyType)
    local resourceNeeded = exchangePrice.moneyValue * quantity
    self.config.exchangePriceText.text = string.format("%s/%s", resourceNumber, resourceNeeded)
    UIUtils.SetActiveColorByMaterial(self.config.buttonExchangePrice.gameObject, resourceNumber >= resourceNeeded, "ui_gray_mat")
    if resourceNumber < resourceNeeded then
        self:ExchangePriceListener(function()
            self.config.buttonExchangePrice.onClick:AddListener(function()
                zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("not_enough_resource"))
            end)
        end)
    else
        self:ExchangePriceListener(function()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            if self.callbackExchangePrice then
                self.callbackExchangePrice(self.input.value)
                self:SubMoney()
                self:OnClickBackOrClose()
            end
        end)
    end
end

--- @return void
function UIPopupExchangeMidAutumnView:SetButtonExchangePrice(isEnable)
    self.config.donateButton.gameObject:SetActive(not isEnable)
    self.config.buttonExchangePrice.gameObject:SetActive(isEnable)
end

--- @return void
function UIPopupExchangeMidAutumnView:SubMoney()
    InventoryUtils.Sub(ResourceType.Money, self.exchangePrice.moneyType, self.exchangePrice.moneyValue * self.quantityExchange)
end

--TODO: logic AddListener button exchange price
--TODO: override logic call opCode