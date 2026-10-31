--- @class GemBoxMidAutumnItemView : MotionIconView
GemBoxMidAutumnItemView = Class(GemBoxMidAutumnItemView, MotionIconView)

function GemBoxMidAutumnItemView:Ctor()
    --- @type ExchangeEventConfig
    self.exchangeData = nil
    --- @type GemBoxMidAutumnItemConfig
    self.config = nil
    --- @type List
    self.listItem = List()
    MotionIconView.Ctor(self)
end

function GemBoxMidAutumnItemView:SetPrefabName()
    self.prefabName = 'item_gem_box_mid_autumn'
    self.uiPoolType = UIPoolType.GemBoxMidAutumnItemView
end

--- @param transform UnityEngine_Transform
function GemBoxMidAutumnItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    self.config = UIBaseConfig(transform)
    self.config.exchangeButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickExchange()
    end)
end

function GemBoxMidAutumnItemView:InitLocalization()
    self.config.textBuy.text = LanguageUtils.LocalizeCommon("buy")
    self.localizeLimitX = LanguageUtils.LocalizeCommon("limit_x")
    self.localizeNoLimit = LanguageUtils.LocalizeCommon("no_limit")
end

function GemBoxMidAutumnItemView:ReturnPool()
    IconView.ReturnPool(self)
    ---@param v ItemIconView
    for i, v in ipairs(self.listItem:GetItems()) do
        v:ReturnPool()
    end
    self.listItem:Clear()
end

--- @param exchangeData ExchangeEventConfig
function GemBoxMidAutumnItemView:SetIconData(exchangeData, numberExchange, callbackExchange)
    self.exchangeData = exchangeData
    self.numberExchange = numberExchange or 0
    self.callbackExchange = callbackExchange
    self.config.textValue.text = exchangeData.itemIconData.quantity
    ---@type ItemIconView
    local money
    ---@param v ItemIconData
    for _, v in ipairs(exchangeData.listRewardItem:GetItems()) do
        money = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.reward)
        money:SetIconData(v)
        money:RegisterShowInfo()
        self.listItem:Add(money)
    end
    self:UpdateLimit()
end

function GemBoxMidAutumnItemView:UpdateLimit()
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
function GemBoxMidAutumnItemView:OnClickExchange()
    if self.exchangeData.limit < 0 or self.numberExchange < self.exchangeData.limit then
        local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, self.exchangeData.itemIconData.itemId, self.exchangeData.itemIconData.quantity))
        if canExchange then
            PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("are_you_sure"), nil, function()
                NetworkUtils.RequestAndCallback(OpCode.EVENT_MID_AUTUMN_GEM_BOX_BUY,
                        UnknownOutBound.CreateInstance(PutMethod.Int, self.exchangeData.id),
                        function()
                            self.exchangeData.itemIconData:SubToInventory()
                            PopupUtils.ClaimAndShowItemList(self.exchangeData.listRewardItem)
                            self.numberExchange = self.numberExchange + 1
                            self:UpdateLimit()
                            if self.callbackExchange ~= nil then
                                self.callbackExchange(1)
                            end
                        end, SmartPoolUtils.LogicCodeNotification, nil, true, true)
            end)
        end
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("out_of_turn"))
    end
end

return GemBoxMidAutumnItemView