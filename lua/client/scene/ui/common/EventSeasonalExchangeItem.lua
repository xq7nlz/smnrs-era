--- @class EventSeasonalExchangeItem : MotionIconView
EventSeasonalExchangeItem = Class(EventSeasonalExchangeItem, MotionIconView)

--- @return void
function EventSeasonalExchangeItem:Ctor()
    ---@type UIEventSeasonalExchangeItemConfig
    self.config = nil
    --- @type RootIconView
    self.rootIconView = nil
    MotionIconView.Ctor(self)
end

function EventSeasonalExchangeItem:SetPrefabName()
    self.prefabName = 'event_seasonal_exchange_item'
    self.uiPoolType = UIPoolType.EventSeasonalExchangeItem
end

--- @param transform UnityEngine_Transform
function EventSeasonalExchangeItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIEventSeasonalExchangeItemConfig
    self.config = UIBaseConfig(transform)
end

function EventSeasonalExchangeItem:AddListener(func)
    self.config.exchangeButton.onClick:RemoveAllListeners()
    self.config.exchangeButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func then
            func()
        end
    end)
end

function EventSeasonalExchangeItem:InitLocalize()
    self.config.textSoldOut.text = LanguageUtils.LocalizeCommon("sold_out")
end

---@param data {id, priceType, price, rewardInBound, limit}
function EventSeasonalExchangeItem:SetData(data, numberBuy)
    self:InitLocalize()
    self:SetTextLimit(data.limit, numberBuy)
    self:SetItemReward(data.rewardInBound)
    self:SetPrice(data.priceType, data.price)
    self:IsSoldOut(numberBuy >= data.limit)
end

---@param rewardInBound RewardInBound
function EventSeasonalExchangeItem:SetItemReward(rewardInBound)
    self.rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardAnchor)
    self.rootIconView:SetIconData(rewardInBound:GetIconData())
    self.rootIconView:RegisterShowInfo()
end

function EventSeasonalExchangeItem:SetTextLimit(limit, numberBuy)
    local remain = limit - numberBuy
    local color = UIUtils.color6
    if remain > 0 then
        color = UIUtils.red1
    end
    self.config.textLimit.text = string.format("%s: %s",
            UIUtils.SetColorString(UIUtils.green_light, LanguageUtils.LocalizeCommon("limit")),
            UIUtils.SetColorString(color, string.format("%s/%s", remain, limit)))
end

function EventSeasonalExchangeItem:SetPrice(priceType, price)
    self.config.iconMoney.sprite = ResourceLoadUtils.LoadMoneyIcon(priceType)
    self.config.textPrice.text = price
end

function EventSeasonalExchangeItem:IsSoldOut(isSoldOut)
    self.config.tick:SetActive(isSoldOut)
    self.config.textSoldOut.gameObject:SetActive(isSoldOut)
    self.config.bgCurrencyValueSlot:SetActive(not isSoldOut)
    if isSoldOut then
        self:AddListener(function()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("sold_out"))
        end)
    end
end

function EventSeasonalExchangeItem:ListRewardIconReturnPool()
    self.rootIconView:ReturnPool()
end

function EventSeasonalExchangeItem:ReturnPool()
    MotionIconView.ReturnPool(self)
    self:ListRewardIconReturnPool()
end

return EventSeasonalExchangeItem