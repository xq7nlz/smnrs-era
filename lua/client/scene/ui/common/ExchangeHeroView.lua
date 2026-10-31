---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.ExchangeItemConfig"
require "lua.client.scene.ui.home.WorldSpaceHeroView.WorldSpaceHeroView"
require "lua.client.core.network.event.ExchangeOutBound"

--- @class ExchangeHeroView : IconView
ExchangeHeroView = Class(ExchangeHeroView, IconView)

--- @return void
function ExchangeHeroView:Ctor()
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
function ExchangeHeroView:InitLocalization()
    self.config.textExchange.text = LanguageUtils.LocalizeCommon("exchange")
    self.localizeLimitX = LanguageUtils.LocalizeCommon("limit_x")
end

--- @return void
function ExchangeHeroView:SetPrefabName()
    self.prefabName = 'hero_exchange'
    self.uiPoolType = UIPoolType.ExchangeHeroView
end

--- @return void
--- @param transform UnityEngine_Transform
function ExchangeHeroView:SetConfig(transform)
    assert(transform)
    ---@type ExchangeHeroConfig
    self.config = UIBaseConfig(transform)
    self.config.exchangeButton.onClick:AddListener(function ()
        self:OnClickExchange()
    end)
end

--- @return void
--- @param exchangeData ExchangeData
function ExchangeHeroView:SetIconData(exchangeData, eventPopupModel)
    assert(exchangeData)
    self.exchangeData = exchangeData
    self.eventPopupModel = eventPopupModel
    self.numberExchange = self.eventPopupModel.numberExchangeDict:Get(self.exchangeData.id) or 0
    self:UpdateView()
end

--- @return void
function ExchangeHeroView:UpdateLimit()
    local color = UIUtils.green_light
    if self.numberExchange >= self.exchangeData.limit then
        color = UIUtils.color7
    end
    self.config.textLimit.text = string.format(self.localizeLimitX, string.format("<color=#%s>%s/%s</color>", color, self.exchangeData.limit - self.numberExchange, self.exchangeData.limit))
end

--- @return void
function ExchangeHeroView:UpdateButtonExchange()
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
function ExchangeHeroView:SetBase()
    local itemRarity = 1
    if self.exchangeData.rarity ~= nil and self.exchangeData.rarity <= 3 then
        itemRarity = self.exchangeData.rarity
    end

    self.config.baseImage.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconExchangeBase, itemRarity)

    self.baseEffectType = EffectPoolType[string.format("ItemExchangeBase%d", itemRarity)]
    self.baseEffect = SmartPool.Instance:SpawnUIEffectPool(self.baseEffectType, self.config.baseRarity)
end

--- @return void
function ExchangeHeroView:UpdateView()
    self:UpdateLimit()
    self:UpdateButtonExchange()

    self:SetBase()

    if self.exchangeData.listReward:Count() == 1 then
        ---@type RewardInBound
        local reward = self.exchangeData.listReward:Get(1)
        if reward.type == ResourceType.HeroFragment then
            local heroId = ClientConfigUtils.GetHeroIdByFragmentHeroId(reward.id)
            if heroId ~= nil then
                local star = ClientConfigUtils.GetHeroFragmentStar(reward.id)
                self:HeroView(heroId, star)
            end
        end
    end
end

--- @return void
function ExchangeHeroView:InitHeroView()
    if self.worldSpaceHeroView == nil then
        ---@type UnityEngine_Transform
        local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
        self.worldSpaceHeroView = WorldSpaceHeroView(trans)
        local renderTexture = U_RenderTexture(1000, 1000, 24, U_RenderTextureFormat.ARGB32)
        self.config.hero.texture = renderTexture
        self.worldSpaceHeroView:Init(renderTexture)
    end
end

--- @return void
function ExchangeHeroView:HeroView(heroId, star)
    self:InitHeroView()
    local heroResource = HeroResource()
    heroResource:SetData(-1, heroId, star, 1)
    self.config.buttonHero.onClick:RemoveAllListeners()
    self.config.buttonHero.onClick:AddListener(function ()
        PopupMgr.ShowPopup(UIPopupName.UIHeroSummonInfo, { ["heroResource"] = heroResource })
    end)
    self.worldSpaceHeroView:ShowHero(heroResource)
    self.worldSpaceHeroView.config.transform.position = U_Vector3(10000 * self.exchangeData.id, 10000, 0)
    self.worldSpaceHeroView.config.bg:SetActive(false)
    self.config.textHeroName.text = LanguageUtils.LocalizeNameHero(heroId)
end

--- @return void
---@param listResource List
function ExchangeHeroView:CallbackExchange(listResource)
    PopupUtils.ClaimAndShowRewardList(self.exchangeData.listReward, function ()
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
function ExchangeHeroView:OnClickExchange()
    if self.numberExchange < self.exchangeData.limit then
        if self.exchangeMoney ~= nil then
            if InventoryUtils.GetMoney(self.exchangeMoney) >= self.exchangeQuantity then
                PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("are_you_sure"),nil, function ()
                    NetworkUtils.RequestAndCallback(OpCode.EVENT_EXCHANGE, ExchangeOutBound(self.exchangeData.id), function ()
                        self:CallbackExchange()
                    end, SmartPoolUtils.LogicCodeNotification)
                end)
            else
                SmartPoolUtils.NotiLackResource(self.exchangeMoney)
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
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("out_of_turn"))
    end
end

--- @return void
function ExchangeHeroView:ReturnPool()
    IconView.ReturnPool(self)
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end

    if self.baseEffect then
        SmartPool.Instance:DespawnUIEffectPool(self.baseEffectType, self.baseEffect)
        self.baseEffect = nil
    end
end

return ExchangeHeroView

