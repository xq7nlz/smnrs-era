--- @class BattlePassExchangeItem : MotionIconView
BattlePassExchangeItem = Class(BattlePassExchangeItem, MotionIconView)

--- @return void
function BattlePassExchangeItem:Ctor()
    ---@type UIBattlePassExchangeItemConfig
    self.config = nil
    ---@type RootIconView
    self.iconView = nil
    ---@type number
    self.id = nil
    ---@type number
    self.moneyType = nil
    ---@type number
    self.moneyValue = nil
    ---@type number
    self.resourceType = nil
    ---@type number
    self.resourceId = nil
    ---@type number
    self.resourceNumber = nil
    ---@type number
    self.resourceData = nil
    ---@type number
    self.limit = nil
    ---@type function
    self.onClickBuy = nil
    ---@type function
    self.onCLickBuyAlready = nil
    MotionIconView.Ctor(self)
end

function BattlePassExchangeItem:SetPrefabName()
    self.prefabName = 'battle_pass_exchange_item'
    self.uiPoolType = UIPoolType.BattlePassExchangeItem
end

--- @param transform UnityEngine_Transform
function BattlePassExchangeItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIBattlePassExchangeItemConfig
    self.config = UIBaseConfig(transform)

    self:InitButton()
    self:InitLocalization()
end

function BattlePassExchangeItem:InitButton()
    self.config.buttonBuy.onClick:AddListener(function()
        self:OnCLickBuy()
    end)
    self.config.button.onClick:AddListener(function()
        self:OnCLickPreview()
    end)
end

function BattlePassExchangeItem:InitLocalization()
    self.config.textBuy.text = LanguageUtils.LocalizeCommon("buy")
    --self.config.textBuyAlready.text = LanguageUtils.LocalizeCommon("already_bought")
end

function BattlePassExchangeItem:OnCLickBuy()
    if self.onClickBuy then
        self.onClickBuy()
    end
end

function BattlePassExchangeItem:OnCLickBuyAlready()
    if self.onCLickBuyAlready then
        self.onCLickBuyAlready()
    end
end

function BattlePassExchangeItem:OnCLickPreview()
    local data = {}
    data.type = self.resourceType
    data.id = self.resourceId
    PopupMgr.ShowPopup(UIPopupName.UISkinPreview, data)
end

---@param boolean boolean
function BattlePassExchangeItem:AvailableToBuy(boolean)
    self.config.textPrice.gameObject:SetActive(boolean)
    self.config.border.gameObject:SetActive(boolean)
    self.config.buttonBuy.gameObject:SetActive(boolean)
end

--- @return void
function BattlePassExchangeItem:SetSprite(spriteName, image)
    if self.lastDataId ~= self.dataId then
        self.lastDataId = self.dataId
    end
    image.sprite = ResourceLoadUtils.LoadAssetBattlePass(self.dataId, spriteName)
end

function BattlePassExchangeItem:SetItemData(id, moneyType, moneyValue, resourceType, resourceId, resourceNumber, resourceData, limit)
    self.id = id
    self.moneyType = moneyType
    self.moneyValue = moneyValue
    self.resourceType = resourceType
    self.resourceId = resourceId
    self.resourceNumber = resourceNumber
    self.resourceData = resourceData
    self.limit = limit
    self.config.iconMoney.sprite = ResourceLoadUtils.LoadMoneyIcon(self.moneyType)
    self.config.textPrice.text = moneyValue
    self.config.itemName.text = LanguageUtils.LocalizeSkinName(self.resourceId)
    self.config.exchangeItem.sprite = ResourceLoadUtils.LoadSkinIcon(self.resourceId)
    local eventBattlePassModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BATTLE_PASS)
    self.dataId = eventBattlePassModel.timeData.dataId
    self:SetItemRarity()
    self:SetSprite("bg_exchange_item", self.config.border)
end

function BattlePassExchangeItem:EnableTagHot(isHot)
    if self.config.tagHot then
        self.config.tagHot.gameObject:SetActive(isHot)
    end
end

function BattlePassExchangeItem:SetItemRarity()
    local rarity = ClientConfigUtils.GetSkinRarity(self.resourceId)
    self.config.rarity.sprite = ResourceLoadUtils.LoadSkinRarity(rarity)
    self.config.rarity:SetNativeSize()
end

function BattlePassExchangeItem:ReturnPool()
    MotionIconView.ReturnPool(self)
end

return BattlePassExchangeItem