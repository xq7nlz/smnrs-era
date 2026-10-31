--- @class ButtonBuyView : IconView
ButtonBuyView = Class(ButtonBuyView, IconView)

--- @return void
--- @param transform UnityEngine_RectTransform
function ButtonBuyView:Ctor(transform)
    --- @type {moneyType, moneyPrice, buttonSprite}
    self.saveIconData = nil
    IconView.Ctor(self, transform)
end

--- @return void
function ButtonBuyView:SetPrefabName()
    self.prefabName = 'button_buy_info'
    self.uiPoolType = UIPoolType.ButtonBuyView
end

--- @return void
--- @param transform UnityEngine_Transform
function ButtonBuyView:SetConfig(transform)
    assert(transform)
    --- @type ButtonBuyConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
--- @param iconData  {moneyType, value, buttonSprite}
function ButtonBuyView:SetIconData(iconData)
    assert(iconData)
    self.saveIconData = self.iconData
    self.iconData = iconData
    self:UpdateView()
end

--- @param isShowStock boolean
--- @param currentStock number
--- @param maxStock number
function ButtonBuyView:ShowStock(isShowStock, currentStock, maxStock)
    if isShowStock == false then
        self.config.textStock.gameObject:SetActive(false)
        return
    end
    self.config.textStock.text = string.format(
            "%s <color=#%s>%d/%d</color>",
            LanguageUtils.LocalizeCommon("stock"), currentStock == 0 and UIUtils.red_light or UIUtils.green_light,
            currentStock,
            maxStock
    )
    self.config.textStock.gameObject:SetActive(true)
end

--- @return void
function ButtonBuyView:UpdateView()
    if self.saveIconData == nil then
        self:SetMoneyIcon()
        self:SetPrice()
        self:SetButtonImage()
    else
        if self.saveIconData.value ~= self.iconData.value then
            self:SetPrice()
        end

        if self.saveIconData.moneyType ~= self.iconData.moneyType then
            self:SetMoneyIcon()
        end

        if self.saveIconData.buttonSprite ~= self.iconData.buttonSprite then
            self:SetButtonImage()
        end
    end
end

--- @return void
---@param func function
function ButtonBuyView:AddListener(func)
    self:RemoveAllListeners()
    self.config.buttonBuy.onClick:AddListener(func)
end

--- @return void
function ButtonBuyView:RemoveAllListeners()
    self.config.buttonBuy.onClick:RemoveAllListeners()
end

--- @return void
--- @param enabled boolean
function ButtonBuyView:EnableButton(enabled)
    UIUtils.SetInteractableButton(self.config.buttonBuy, enabled)
    self.config.bgFog:SetActive(not enabled)
end

--- @return void
function ButtonBuyView:SetPrice()
    self.config.textPrice.text = ClientConfigUtils.FormatNumber(self.iconData.value)
end

--- @return void
function ButtonBuyView:SetButtonImage()
    --- do in the future
end

--- @return void
function ButtonBuyView:SetMoneyIcon()
    self.config.iconMoney.sprite = ResourceLoadUtils.LoadMoneyIcon(self.iconData.moneyType)
    self.config.iconMoney:SetNativeSize()
    --ClientConfigUtils.SetFillSizeImage(self.config.iconMoney, 60, 50)
end

return ButtonBuyView
