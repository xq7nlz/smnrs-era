--- @class ExchangeMultiItemView : MotionIconView
ExchangeMultiItemView = Class(ExchangeMultiItemView, MotionIconView)

function ExchangeMultiItemView:Ctor()
    --- @type ExchangeEventConfig
    self.exchangeData = nil
    --- @type ExchangeMultiItemConfig
    self.config = nil
    --- @type List
    self.listItem = List()
    MotionIconView.Ctor(self)
end

function ExchangeMultiItemView:SetPrefabName()
    self.prefabName = 'item_exchange_multi_item'
    self.uiPoolType = UIPoolType.ExchangeMultiItemView
end

--- @param transform UnityEngine_Transform
function ExchangeMultiItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    self.config = UIBaseConfig(transform)
    self.config.exchangeButton.onClick:AddListener(function()
        self:OnClickExchange()
    end)
end

function ExchangeMultiItemView:InitLocalization()
    self.config.textExchange.text = LanguageUtils.LocalizeCommon("exchange")
    self.localizeLimitX = LanguageUtils.LocalizeCommon("limit_x")
    self.localizeNoLimit = LanguageUtils.LocalizeCommon("no_limit")
end

function ExchangeMultiItemView:ReturnPool()
    IconView.ReturnPool(self)
    self:ActiveMaskNoti(false)
    ---@param v ItemIconView
    for i, v in ipairs(self.listItem:GetItems()) do
        v:ReturnPool()
    end
    self.listItem:Clear()
end

function ExchangeMultiItemView:ActiveMaskNoti(isActive, noti)
    self.config.textMask.transform.parent.gameObject:SetActive(isActive)
    if noti ~= nil then
        self.config.textMask.text = noti
    else
        self.config.textMask.text = ""
    end
end

--- @param exchangeData ExchangeEventConfig
function ExchangeMultiItemView:SetIconData(opCode, exchangeData, numberExchange, callbackExchange)
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

function ExchangeMultiItemView:UpdateLimit()
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
function ExchangeMultiItemView:CallbackExchange(number)
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
function ExchangeMultiItemView:OnClickExchange()
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    if self.exchangeData.limit < 0 or self.numberExchange < self.exchangeData.limit then
        local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, self.exchangeData.itemIconData.itemId, self.exchangeData.itemIconData.quantity))
        if canExchange then
            PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_buy"), nil, function()
                NetworkUtils.RequestAndCallback(self.opCode,
                        UnknownOutBound.CreateInstance(PutMethod.Int, self.exchangeData.id, PutMethod.Int, 1),
                        function()
                            self:CallbackExchange(1)
                        end, SmartPoolUtils.LogicCodeNotification, nil, true, true)
            end)
        end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("out_of_turn"))
    end
end

return ExchangeMultiItemView