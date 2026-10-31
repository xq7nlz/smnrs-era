--- @class SkinChallengeExchangeItem : MotionIconView
SkinChallengeExchangeItem = Class(SkinChallengeExchangeItem, MotionIconView)

--- @return void
function SkinChallengeExchangeItem:Ctor()
    ---@type SkinChallengeSkinItemConfig
    self.config = nil
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
    self.onClickExchange = nil
    MotionIconView.Ctor(self)
end

function SkinChallengeExchangeItem:SetPrefabName()
    self.prefabName = 'event_skin_challenge_skin_item'
    self.uiPoolType = UIPoolType.SkinChallengeExchangeItem
end

--- @param transform UnityEngine_Transform
function SkinChallengeExchangeItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type SkinChallengeSkinItemConfig
    self.config = UIBaseConfig(transform)

    self:InitButton()
    self:InitLocalization()
end

function SkinChallengeExchangeItem:InitButton()
    self.config.buttonExchange.onClick:AddListener(function()
        self:OnCLickExchange()
    end)
    self.config.buttonPreview1.onClick:AddListener(function()
        self:OnCLickPreview()
    end)
    self.config.buttonPreview2.onClick:AddListener(function()
        self:OnCLickPreview()
    end)
end

function SkinChallengeExchangeItem:InitLocalization()
    self.config.textExchange.text = LanguageUtils.LocalizeCommon("exchange")
    self.config.textAlreadyExchange.text = LanguageUtils.LocalizeCommon("already_exchange")
end

function SkinChallengeExchangeItem:OnCLickExchange()
    if self.onClickExchange then
        self.onClickExchange()
    end
end

function SkinChallengeExchangeItem:OnCLickPreview()
    local data = {}
    data.type = self.resourceType
    data.id = self.resourceId
    PopupMgr.ShowPopup(UIPopupName.UISkinPreview, data)
end

---@param boolean boolean
function SkinChallengeExchangeItem:AvailableToBuy(isAvailable)
    --self.config.iconImage.gameObject:SetActive(isAvailable)
    self.config.iconImageDark.gameObject:SetActive(not isAvailable)
    self.config.textExchange.gameObject:SetActive(isAvailable)
    self.config.textAlreadyExchange.gameObject:SetActive(not isAvailable)
end

---@param boolean boolean
function SkinChallengeExchangeItem:SetTagHotOn(isOn)
    self.config.tagHot.gameObject:SetActive(isOn)
end

--- @return void
function SkinChallengeExchangeItem:SetSprite(spriteName, image1, image2)
    image1.sprite = ResourceLoadUtils.LoadSkinChallengeImage(spriteName, self.dataId)
    image2.sprite = ResourceLoadUtils.LoadSkinChallengeImage(spriteName, self.dataId)
    image1:SetNativeSize()
    image2:SetNativeSize()
end

function SkinChallengeExchangeItem:SetItemData(id, moneyType, moneyValue, resourceType, resourceId, resourceNumber, resourceData, limit)
    self:SetTagHotOn(false)
    self.id = id
    self.moneyType = moneyType
    self.moneyValue = moneyValue
    self.resourceType = resourceType
    self.resourceId = resourceId
    self.resourceNumber = resourceNumber
    self.resourceData = resourceData
    self.limit = limit
    self.config.iconMoney.sprite = ResourceLoadUtils.LoadMoneyIcon(self.moneyType)
    self.config.price.text = moneyValue
    self.config.textSkinName.text = LanguageUtils.LocalizeSkinName(self.resourceId)
    local eventSkinChallengeModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SKIN_CHALLENGE)
    if eventSkinChallengeModel then
        self.dataId = eventSkinChallengeModel.timeData.dataId
        self:SetSprite(self.resourceId, self.config.iconImage, self.config.iconImageDark)
    end
    --self:SetItemRarity()
end

function SkinChallengeExchangeItem:SetItemRarity()
    local rarity = ClientConfigUtils.GetSkinRarity(self.resourceId)
    self.config.rarity.sprite = ResourceLoadUtils.LoadSkinRarity(rarity)
    self.config.rarity:SetNativeSize()
end

function SkinChallengeExchangeItem:ReturnPool()
    MotionIconView.ReturnPool(self)
end

return SkinChallengeExchangeItem