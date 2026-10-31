--- @class ZodiacExchangeItemView : RootIconView
ZodiacExchangeItemView = Class(ZodiacExchangeItemView, RootIconView)
function ZodiacExchangeItemView:Ctor()
    RootIconView.Ctor(self)
end

--- @return void
function ZodiacExchangeItemView:SetPrefabName()
    self.prefabName = 'zodiac_exchange_reward_item'
    self.uiPoolType = UIPoolType.ZodiacExchangeItemView
end

--- @return void
--- @param transform UnityEngine_RectTransform
function ZodiacExchangeItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type {transform, gameObject, rectTransform, visual : UnityEngine_RectTransform}
    self.config = {}
    self.config.transform = transform
    self.config.gameObject = transform.gameObject
    self.config.rectTransform = transform:GetComponent(ComponentName.UnityEngine_RectTransform)
    self.config.visual = transform:Find("button_exchange/visual"):GetComponent(ComponentName.UnityEngine_RectTransform)
    --- @type UnityEngine_UI_Text
    self.config.content = transform:Find("button_exchange/content"):GetComponent(ComponentName.UnityEngine_UI_Text)
    --- @type UnityEngine_UI_Text
    self.config.stock = transform:Find("button_exchange/stock"):GetComponent(ComponentName.UnityEngine_UI_Text)
    --- @type UnityEngine_UI_Text
    self.config.priceText = transform:Find("button_exchange/price_anchor/price_text"):GetComponent(ComponentName.UnityEngine_UI_Text)
    --- @type UnityEngine_UI_Button
    self.config.buttonExchange = transform:Find("button_exchange"):GetComponent(ComponentName.UnityEngine_UI_Button)
end

--- @return void
--- @param itemIconData ZodiacExchangeItemData
function ZodiacExchangeItemView:SetIconData(itemIconData)
    RootIconView.SetIconData(self,itemIconData.itemData:GetIconData())
    local remain = (itemIconData.limit - itemIconData.buyTime)
    UIUtils.SetActiveColor(self.config.gameObject, remain > 0 )
    self.config.stock.text = LanguageUtils.LocalizeCommon("stock").. ": ".. UIUtils.SetColorString(UIUtils.green_light,tostring(remain))
    self.config.priceText.text = itemIconData.price
end

--- @return void
--- @param func function
function ZodiacExchangeItemView:AddListener(func)
    if self.config.buttonExchange ~= nil then
        self.config.buttonExchange.onClick:RemoveAllListeners()
        self.config.buttonExchange.onClick:AddListener(func)
    end
end

--- @return void
--- @param func function
function ZodiacExchangeItemView:RemoveAllListeners(func)
    if self.iconView ~= nil then
        self.iconView:RemoveAllListeners()
    end
end

--- @return void
function ZodiacExchangeItemView:Show()
    RootIconView.Show(self)
end

--- @return void
function ZodiacExchangeItemView:ReturnPool()
    UIUtils.SetActiveColor(self.config.gameObject,true)
    RootIconView.ReturnPool(self)
end


return ZodiacExchangeItemView
