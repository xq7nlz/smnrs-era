--- @class ExchangeMidAutumnItemView : MotionIconView
ExchangeMidAutumnItemView = Class(ExchangeMidAutumnItemView, MotionIconView)

function ExchangeMidAutumnItemView:Ctor()
    --- @type ExchangeEventConfig
    self.exchangeData = nil
    --- @type ExchangeMidAutumnItemConfig
    self.config = nil
    --- @type List
    self.listItem = List()
    MotionIconView.Ctor(self)
end

function ExchangeMidAutumnItemView:SetPrefabName()
    self.prefabName = 'item_exchange_mid_autumn'
    self.uiPoolType = UIPoolType.ExchangeMidAutumnItemView
end

--- @param transform UnityEngine_Transform
function ExchangeMidAutumnItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    self.config = UIBaseConfig(transform)
    self.config.exchangeButton.onClick:AddListener(function ()
        self:OnClickExchange()
    end)
end

function ExchangeMidAutumnItemView:InitLocalization()
    self.config.textExchange.text = LanguageUtils.LocalizeCommon("exchange")
    self.localizeLimitX = LanguageUtils.LocalizeCommon("limit_x")
    self.localizeNoLimit = LanguageUtils.LocalizeCommon("no_limit")
end

function ExchangeMidAutumnItemView:ReturnPool()
    IconView.ReturnPool(self)
    self:ActiveMaskNoti(false)
    ---@param v ItemIconView
    for i, v in ipairs(self.listItem:GetItems()) do
        v:ReturnPool()
    end
    self.listItem:Clear()
end

function ExchangeMidAutumnItemView:ActiveMaskNoti(isActive, noti)
    self.config.textMask.transform.parent.gameObject:SetActive(isActive)
    if noti ~= nil then
        self.config.textMask.text = noti
    else
        self.config.textMask.text = ""
    end
end

--- @param exchangeData ExchangeEventConfig
function ExchangeMidAutumnItemView:SetIconData(opCode, exchangeData, numberExchange, callbackExchange)
    self.opCode = opCode
    self.exchangeData = exchangeData
    self.numberExchange = numberExchange or 0
    self.callbackExchange = callbackExchange
    ---@type RootIconView
    local money = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyIconView, self.config.iconItemExchangeRequirement)
    money:SetIconData(exchangeData.itemIconData)
    money:RegisterShowInfo()
    self.listItem:Add(money)
    ---@param v ItemIconData
    for _, v in ipairs(exchangeData.listRewardItem:GetItems()) do
        money = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.reward)
        money:SetIconData(v)
        money:RegisterShowInfo()
        self.listItem:Add(money)
    end
    self:UpdateLimit()
end

function ExchangeMidAutumnItemView:UpdateLimit()
    if self.exchangeData.limit > 0 then
        local color = UIUtils.green_dark
        if self.numberExchange >= self.exchangeData.limit then
            color = UIUtils.red_dark
        end
        self.config.textLimit.text = string.format(self.localizeLimitX, string.format("<color=#%s>%s/%s</color>", color, self.exchangeData.limit - self.numberExchange, self.exchangeData.limit))
    else
        self.config.textLimit.text = self.localizeNoLimit
    end
end

--- @return void
---@param number number
function ExchangeMidAutumnItemView:CallbackExchange(number)
    self.exchangeData:SubMoney(number)
    local iconList = List()
    --- @param reward ItemIconData
    for _, reward in ipairs(self.exchangeData.listRewardItem:GetItems()) do
        local newReward = ItemIconData.Clone(reward)
        newReward.quantity = newReward.quantity * number
        iconList:Add(newReward)
    end
    PopupUtils.ClaimAndShowItemList(iconList)
    self.numberExchange = self.numberExchange + number
    self:UpdateLimit()
    if self.callbackExchange ~= nil then
        self.callbackExchange(number)
    end
end

--- @return void
function ExchangeMidAutumnItemView:OnClickExchange()
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    if self.exchangeData.limit < 0 or self.numberExchange < self.exchangeData.limit then
        local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, self.exchangeData.itemIconData.itemId, self.exchangeData.itemIconData.quantity))
        if canExchange then
            local data = {}
            data.opCode = self.opCode
            data.exchangeData = self.exchangeData
            data.currentExchange = self.numberExchange
            data.callbackExchange = function(number)
                self:CallbackExchange(number)
            end
            PopupMgr.ShowPopup(UIPopupName.UIPopupExchangeMidAutumn, data)
        end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("out_of_turn"))
    end
end

return ExchangeMidAutumnItemView