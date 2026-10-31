--- @class LunarNewYearExclusiveOfferItem : MotionIconView
LunarNewYearExclusiveOfferItem = Class(LunarNewYearExclusiveOfferItem, MotionIconView)

--- @return void
function LunarNewYearExclusiveOfferItem:Ctor(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type LunarNewYearExclusiveOfferConfig
    self.config = UIBaseConfig(transform)
    ---@type List
    self.rewardItem = List()
    self:InitLocalization()
end

function LunarNewYearExclusiveOfferItem:SetPrefabName()
    self.prefabName = 'lunar_new_year_exclusive_item'
    self.uiPoolType = UIPoolType.LunarNewYearExclusiveOfferItem
end

---@param func function
function LunarNewYearExclusiveOfferItem:AddListener(func)
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func then
            func()
        end
    end)
end

function LunarNewYearExclusiveOfferItem:InitLocalization()
    self.config.extraText.text = LanguageUtils.LocalizeCommon("extra")
end

---@param productConfig ProductConfig
function LunarNewYearExclusiveOfferItem:ShowData(dataId, productConfig, eventActionType)
    self:ShowBuyState(dataId, productConfig, eventActionType)
    self:ShowTagHot(productConfig)
    local rewardList = productConfig:GetRewardList()
    ---@param v RewardInBound
    for _, v in pairs(rewardList:GetItems()) do
        if v.type == ResourceType.Skin then
            self:ShowDemoSkin(v)
        end
        if v.id == MoneyType.VIP_POINT then
            self.config.textVip.text = "+ " .. v.number
        else
            --- @type RootIconView
            local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardAnchor)
            v.itemId = v.id
            v.quantity = v.number
            local iconData = ItemIconData.Clone(v)
            item:SetIconData(iconData)
            item:RegisterShowInfo()
            self.rewardItem:Add(item)
        end
    end
end

function LunarNewYearExclusiveOfferItem:ShowDemoSkin(rewardInBound)
    self.config.rawImage.gameObject:SetActive(true)
    local skinId = rewardInBound.id
    local heroId = ClientConfigUtils.GetHeroIdBySkinId(skinId)
    local faction = ClientConfigUtils.GetFactionIdByHeroId(heroId)
    if self.worldSpaceHeroView == nil then
        ---@type UnityEngine_Transform
        local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
        self.worldSpaceHeroView = WorldSpaceHeroView(trans)
        local renderTexture = U_RenderTexture(800, 800, 24, U_RenderTextureFormat.ARGB32)
        self.config.rawImage.texture = renderTexture
        self.worldSpaceHeroView:Init(renderTexture)
    end
    local heroResource = HeroResource()
    heroResource:SetData(-1, heroId, 1, 1)
    heroResource.heroItem:Add(HeroItemSlot.SKIN, skinId)
    self.worldSpaceHeroView:ShowHero(heroResource)
    self.worldSpaceHeroView.config.transform.position = U_Vector3(heroId, 99000, 0)
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView.config.bg:SetActive(false)
    end
end

---@param productConfig ProductConfig
function LunarNewYearExclusiveOfferItem:ShowBuyState(dataId, productConfig, eventActionType)
    local eventModel = zg.playerData:GetEvents():GetEvent(productConfig.eventTimeType)
    local numberBuyData = eventModel:GetNumberBuy(eventActionType, productConfig.id)
    local purchaseKey = ClientConfigUtils.GetPurchaseKey(productConfig.opCode, productConfig.id, dataId)
    local isLock = numberBuyData > 0
    local stockLeft = productConfig.stock - numberBuyData
    local stringStockLeft = tostring(stockLeft) .. "/" .. productConfig.stock
    if stockLeft > 0 then
        stringStockLeft = UIUtils.SetColorString(UIUtils.green_light, stringStockLeft)
    else
        stringStockLeft = UIUtils.SetColorString(UIUtils.red_light, stringStockLeft)
    end
    self.config.limitText.text = LanguageUtils.LocalizeCommon("limit") .. " " .. stringStockLeft
    if isLock then
        self.config.textPrice.text = LanguageUtils.LocalizeCommon("sold_out")
        self.config.buttonBuy.onClick:RemoveAllListeners()
        self:AddListener(function()
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
        end)
    else
        self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(purchaseKey)
    end
end

---@param productConfig ProductConfig
function LunarNewYearExclusiveOfferItem:SetBuyState(productConfig)
    local stringStockLeft = tostring(0) .. "/" .. productConfig.stock
    stringStockLeft = UIUtils.SetColorString(UIUtils.red_light, stringStockLeft)
    self.config.limitText.text = LanguageUtils.LocalizeCommon("limit") .. " " .. stringStockLeft
    self.config.textPrice.text = LanguageUtils.LocalizeCommon("sold_out")
    self.config.buttonBuy.onClick:RemoveAllListeners()
    self:AddListener(function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end)
end

---@param productConfig ProductConfig
function LunarNewYearExclusiveOfferItem:ShowTagHot(productConfig)
    if not productConfig.profit then
        self.config.tagHot.gameObject:SetActive(false)
        return
    end
    self.config.profitText.text = tostring(productConfig.profit) .. "%"
end

function LunarNewYearExclusiveOfferItem:ReturnPool()
    self.config.buttonBuy.onClick:RemoveAllListeners()
    self:ReturnPoolDemoSkin()
    self:ReturnPoolRewardItem()
end

function LunarNewYearExclusiveOfferItem:ReturnPoolDemoSkin()
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end
end

function LunarNewYearExclusiveOfferItem:ReturnPoolRewardItem()
    if self.rewardItem:Count() > 0 then
        ---@param v RootIconView
        for _, v in pairs(self.rewardItem:GetItems()) do
            v:ReturnPool()
        end
        self.rewardItem:Clear()
    end
end

return LunarNewYearExclusiveOfferItem