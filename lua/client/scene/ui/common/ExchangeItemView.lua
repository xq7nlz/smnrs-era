require "lua.client.scene.ui.home.WorldSpaceHeroView.WorldSpaceHeroView"
require "lua.client.core.network.event.ExchangeOutBound"

--- @class ExchangeItemView : IconView
ExchangeItemView = Class(ExchangeItemView, IconView)

--- @return void
function ExchangeItemView:Ctor()
    ---@type RootIconView
    self.iconView = nil
    --- @type ExchangeData
    self.exchangeData = nil
    --- @type number
    self.numberExchange = nil
    ---@type WorldSpaceHeroView
    self.worldSpaceHeroView = nil
    --- @type EventExchangeModel
    self.eventPopupModel = nil
    ---@type List
    self.listItem = List()
    --- @type List
    self.listTweener = List()
    ---@type MoneyType
    self.exchangeMoney = nil
    ---@type number
    self.exchangeQuantity = nil
    ---@type number
    self.localizeLimitX = nil
    --- @type EffectPoolType
    self.baseEffectType = nil
    IconView.Ctor(self)
end

--- @return void
function ExchangeItemView:InitLocalization()
    self.config.textExchange.text = LanguageUtils.LocalizeCommon("exchange")
    self.localizeLimitX = LanguageUtils.LocalizeCommon("limit_x")
end

--- @return void
function ExchangeItemView:SetPrefabName()
    self.prefabName = 'item_exchange'
    self.uiPoolType = UIPoolType.ExchangeItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function ExchangeItemView:SetConfig(transform)
    assert(transform)
    ---@type ExchangeItemConfig
    self.config = UIBaseConfig(transform)
    self.config.exchangeButton.onClick:AddListener(function()
        self:OnClickExchange()
    end)
end

--- @return void
--- @param exchangeData ExchangeData
function ExchangeItemView:SetIconData(exchangeData, eventPopupModel)
    assert(exchangeData)
    self.exchangeData = exchangeData
    self.eventPopupModel = eventPopupModel
    self.numberExchange = self.eventPopupModel.numberExchangeDict:Get(self.exchangeData.id) or 0
    self:UpdateView()
end

--- @return void
function ExchangeItemView:UpdateLimit()
    local color = UIUtils.green_dark
    if self.numberExchange >= self.exchangeData.limit then
        color = UIUtils.red_dark
    end
    self.config.textLimit.text = string.format(self.localizeLimitX, string.format("<color=#%s>%s/%s</color>", color, self.exchangeData.limit - self.numberExchange, self.exchangeData.limit))
end

--- @return void
function ExchangeItemView:UpdateButtonExchange()
    self.exchangeQuantity = nil
    self.exchangeMoney = nil
    if self.exchangeData.listRequirement:Count() == 0 and self.exchangeData.listMoney:Count() == 1 then
        ---@type ItemIconData
        local money = self.exchangeData.listMoney:Get(1)
        self.exchangeMoney = money.itemId
        self.exchangeQuantity = money.quantity
        self.config.textGem.text = money.quantity
        self.config.iconMoney.sprite = ResourceLoadUtils.LoadMoneyIcon(money.itemId)
        self.config.iconMoney:SetNativeSize()
    end
    if self.exchangeQuantity ~= nil then
        self.config.exchange:SetActive(false)
        self.config.gem:SetActive(true)
    else
        self.config.exchange:SetActive(true)
        self.config.gem:SetActive(false)
    end
end

--- @return void
function ExchangeItemView:UpdateView()
    self:UpdateLimit()
    self:UpdateButtonExchange()

    local isHero = false
    if self.exchangeData.listReward:Count() == 1 then
        ---@type RewardInBound
        local reward = self.exchangeData.listReward:Get(1)
        if reward.type == ResourceType.HeroFragment then
            local heroId = ClientConfigUtils.GetHeroIdByFragmentHeroId(reward.id)
            if heroId ~= nil then
                local star = ClientConfigUtils.GetHeroFragmentStar(reward.id)
                isHero = true
            end
        end
    end
    if isHero == false then

        for i = 1, self.exchangeData.listReward:Count() do
            ---@type ItemIconData
            local iconData = self.exchangeData.listReward:Get(i):GetIconData()
            ---@type ItemIconView
            local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.itemReward)

            iconView:SetIconData(iconData)
            iconView:RegisterShowInfo()
            iconView:SetActiveColor(true)
            self.listItem:Add(iconView)
        end
    end
end

--- @return void
---@param listResource List
function ExchangeItemView:CallbackExchange(listResource)
    PopupUtils.ClaimAndShowRewardList(self.exchangeData.listReward, function()
        if listResource ~= nil and listResource:Count() > 0 then
            InventoryUtils.AddListItemIconData(listResource)
            PopupUtils.ShowRewardList(listResource)
        end
    end)
    self.exchangeData:SubMoney()
    self.numberExchange = self.numberExchange + 1
    self.eventPopupModel.numberExchangeDict:Add(self.exchangeData.id, self.numberExchange)
    self:UpdateLimit()
end

--- @return void
function ExchangeItemView:OnClickExchange()
    if self.numberExchange < self.exchangeData.limit then
        if self.exchangeMoney ~= nil then
            local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, self.exchangeMoney, self.exchangeQuantity))
            if canExchange then
                PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("are_you_sure"), nil, function()
                    NetworkUtils.RequestAndCallback(OpCode.EVENT_EXCHANGE, ExchangeOutBound(self.exchangeData.id), function()
                        self:CallbackExchange()
                    end, SmartPoolUtils.LogicCodeNotification)
                end)
            end
        else
            local data = {}
            data.exchangeData = self.exchangeData
            data.callbackExchange = function(listResource)
                self:CallbackExchange(listResource)
            end
            PopupMgr.ShowPopup(UIPopupName.UIPopupExchange, data)
        end
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("out_of_turn"))
    end
end

--- @return void
function ExchangeItemView:ReturnPool()
    IconView.ReturnPool(self)
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end

    ---@param v ItemIconView
    for i, v in ipairs(self.listItem:GetItems()) do
        v:ReturnPool()
    end
    self.listItem:Clear()

    if self.baseEffect then
        SmartPool.Instance:DespawnUIEffectPool(self.baseEffectType, self.baseEffect)
        self.baseEffect = nil
    end
end

return ExchangeItemView

