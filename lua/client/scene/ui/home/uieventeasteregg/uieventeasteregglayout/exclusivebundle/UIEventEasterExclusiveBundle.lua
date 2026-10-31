--- @class UIEventEasterExclusiveBundleLayout : UIEventEasterEggLayout
UIEventEasterExclusiveBundleLayout = Class(UIEventEasterExclusiveBundleLayout, UIEventEasterEggLayout)

--- @param view UIEventNewYearView
--- @param newYearTab LunarNewYearTab
--- @param anchor UnityEngine_RectTransform
function UIEventEasterExclusiveBundleLayout:Ctor(view, tab, anchor, packId)
    --- thay type bằng type config của từng layout
    --- @type EasterExclusiveBundleLayoutConfig
    self.layoutConfig = nil
    UIEventEasterEggLayout.Ctor(self ,view, tab, anchor)
    --- thay op code neu co
    self.opCode = OpCode.EVENT_EASTER_EXCLUSIVE_PURCHASE
    --- @type List
    self.rewardList = List()
    --- @type List
    self.rewardItem = List()
    self.packId = packId

    --- @type EventActionType
    self.eventActionType = EventActionType.EASTER_EXCLUSIVE_BUNDLE_PURCHASE
end

function UIEventEasterExclusiveBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("easter_exclusive_bundle", self.anchor)
    UIEventEasterEggLayout.InitLayoutConfig(self, inst)
    self:InitLocalization()
    self:SetUpLayout()
    self:SetEventTitle()
end

function UIEventEasterExclusiveBundleLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
    self.layoutConfig.buttonBuy.onClick:RemoveAllListeners()
    self.layoutConfig.buttonBuy.onClick:AddListener(
            function()
                zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
                self:OnClickBuy()
            end
    )
end

function UIEventEasterExclusiveBundleLayout:OnClickBuy()
    if self.isLock then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    else
        BuyUtils.InitListener(
                function()
                    self:ShowBuyState()
                    self.view:CheckAllNotificationTab()
                    RxMgr.notificationPurchasePacks:Next()
                end,
                function(logicCode)
                    print("Error logic code ", logicCode)
                end)
        RxMgr.purchaseProduct:Next(self.purchaseKey)
    end
end

function UIEventEasterExclusiveBundleLayout:SetEventBanner()
end

function UIEventEasterExclusiveBundleLayout:SetEventTitle()
    self.layoutConfig.title.text = LanguageUtils.LocalizeCommon("event_easter_exclusive_bundle")
end

function UIEventEasterExclusiveBundleLayout:SetEventDesc()
end

function UIEventEasterExclusiveBundleLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
    --- @type EventLunarNewYearModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_EGG)
    --- @type LunarExclusiveStore
    local bundleConfig = ResourceMgr.GetPurchaseConfig():GetEasterLimitedOfferStore()
    --- @type ProductConfig
    self.productConfig = bundleConfig:GetPack(self.eventModel.timeData.dataId).packList:Get(self.packId)
    self.purchaseKey = ClientConfigUtils.GetPurchaseKey(self.productConfig.opCode,
            self.packId,
            self.eventModel.timeData.dataId)
    if self.productConfig.profit ~= nil then
        self.layoutConfig.hot:SetActive(true)
        self.layoutConfig.profitText.text = tostring(self.productConfig.profit) .. "%"
        self.layoutConfig.extraText.text = LanguageUtils.LocalizeCommon("extra")
    end
    if (self.productConfig ~= nil) then
        self.rewardList = self.productConfig:GetRewardList()
        --- @type UnityEngine_RectTransform
        local rewardAnchor = self.layoutConfig.rewardFirstLine
        for i = 1, self.rewardList:Count() do
            if i > 3 then
                rewardAnchor = self.layoutConfig.rewardSecondLine;
            end
            --- @type RewardInBound
            local data = self.rewardList:Get(i)
            if(data.type == ResourceType.Skin) then
                self:ShowHero(data)
            end
            if data.id == MoneyType.VIP_POINT then
                self.layoutConfig.textVip.text = "+" .. data.number
            else
                --- @type RootIconView
                local item =  SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, rewardAnchor)
                data.itemId= data.id
                data.quantity = data.number
                local iconData = ItemIconData.Clone(data)
                item:SetIconData(iconData)
                item:RegisterShowInfo()
                self.rewardItem:Add(item)
            end

        end
        self:ShowBuyState()
        if self.isLock then
            self.layoutConfig.textPrice.text = LanguageUtils.LocalizeCommon("sold_out")
        else
            local price = zg.iapMgr:GetLocalPrizeString(self.purchaseKey)
            self.layoutConfig.textPrice.text =  price
        end
    end

end

function UIEventEasterExclusiveBundleLayout:ShowHero(rewardInBound)
    local skinId =  rewardInBound.id
    local heroId = ClientConfigUtils.GetHeroIdBySkinId(skinId)
    local faction = ClientConfigUtils.GetFactionIdByHeroId(heroId)
    if self.worldSpaceHeroView == nil then
        ---@type UnityEngine_Transform
        local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
        self.worldSpaceHeroView = WorldSpaceHeroView(trans)
        local renderTexture = U_RenderTexture(800, 800, 24, U_RenderTextureFormat.ARGB32)
        self.layoutConfig.rawImage.texture = renderTexture
        self.worldSpaceHeroView:Init(renderTexture)
    end
    local heroResource = HeroResource()
    heroResource:SetData(-1, heroId, 1, 1)
    heroResource.heroItem:Add(HeroItemSlot.SKIN, skinId)
    self.worldSpaceHeroView:ShowHero(heroResource)
    self.worldSpaceHeroView.config.transform.position = U_Vector3(99000, 99000, 0)
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView.config.bg:SetActive(false)
    end
end

function UIEventEasterExclusiveBundleLayout:ShowBuyState()
    local numberBuyData = self.eventModel:GetNumberBuy(self.eventActionType, self.packId)
    self.isLock = numberBuyData > 0
    local stockLeft = self.productConfig.stock - numberBuyData
    local stringStockLeft = tostring(stockLeft).."/" .. self.productConfig.stock
    if stockLeft > 0 then
        stringStockLeft =  UIUtils.SetColorString(UIUtils.green_light,stringStockLeft)
    else
        stringStockLeft =  UIUtils.SetColorString(UIUtils.red_light,stringStockLeft)
    end
    self.layoutConfig.limitText.text = LanguageUtils.LocalizeCommon("limit") .. " " .. stringStockLeft
    if self.isLock then
        self.layoutConfig.textPrice.text = LanguageUtils.LocalizeCommon("sold_out")
    end
end

function UIEventEasterExclusiveBundleLayout:OnHide()
    UIEventLayout.OnHide(self)
    self.anchor.gameObject:SetActive(false)
    for i = 1,  self.rewardItem:Count() do
        self.rewardItem:Get(i):ReturnPool()
    end
    self.rewardItem:Clear()
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end
end

function UIEventEasterExclusiveBundleLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end