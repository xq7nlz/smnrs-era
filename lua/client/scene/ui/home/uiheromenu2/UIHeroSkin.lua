SKIN_CARD_SIZE = U_Vector2(305, 445)

--- @class UIHeroSkin
UIHeroSkin = Class(UIHeroSkin)

--- @return void
--- @param transform UnityEngine_Transform
function UIHeroSkin:Ctor(transform, model, heroMenu2View)
    --- @type UIHeroMenu2Model
    self.model = model
    --- @type UIHeroMenu2View
    self.heroMenuView = heroMenu2View
    ---@type UIHeroSkinConfig
    self.config = UIBaseConfig(transform)

    --- @type HeroResource
    self.heroResource = nil
    --- @type List
    self.listItem = List()
    --- @type SkinCardView
    self.currentSkinCardView = nil
    --- @type SkinCardView
    self.lastItemEquip = nil
    --- @type number
    self.index = 1
    --- @type boolean
    self.enablePreview = true
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type number
    self.currentSkinCardCell = nil
    --- @type List -- SkinCardView
    self.listSkinCard = List()

    self.rawSkinExchangeConfig = ResourceMgr.GetRawSkinExchangeConfig()
    self:InitButtonListener()
end

--- @return void
function UIHeroSkin:InitLocalization()
    self.config.textEquip.text = LanguageUtils.LocalizeCommon("equip")
    self.config.textHideSkin.text = LanguageUtils.LocalizeCommon("show_skin")
    self.config.textPreview.text = LanguageUtils.LocalizeCommon("preview")
    self.config.textUnequip.text = LanguageUtils.LocalizeCommon("unequip")
    self.config.textBuy.text = LanguageUtils.LocalizeCommon("buy")
    self.config.textGoShop.text = LanguageUtils.LocalizeCommon("go_to_shop")
end

function UIHeroSkin:InitButtonListener()
    self.config.buttonHideSkin.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickToggleShowSkin()
    end)
    self.config.buttonEquip.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickEquip()
    end)
    self.config.buttonUnequip.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickUnEquip()
    end)
    self.config.buttonGoShop.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickGoToShop()
    end)
end

function UIHeroSkin:SetIndex(index)
    self.index = index

    local listHeroSkin = ClientConfigUtils.GetListSkinByHeroId(self.heroResource.heroId)
    self.skinId = listHeroSkin:Get(index)
end

function UIHeroSkin:SetCurrentSkinCard(skinCardView)
    self.currentSkinCardView = skinCardView
end

--- @return void
function UIHeroSkin:InitUI()
    self.heroResource = self.model.heroResource:Clone()

    self:ReturnPoolSkinItem()

    local listHeroSkin = ClientConfigUtils.GetListSkinByHeroId(self.heroResource.heroId)

    local currentEquippedSkin = self.heroResource.heroItem:Get(HeroItemSlot.SKIN)

    local index = 0
    ---@param skinId number
    for _, skinId in ipairs(listHeroSkin:GetItems()) do
        ---@type SkinCardView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.SkinCardView, self.config.content)
        iconView:SetIconData(ItemIconData.CreateInstance(ResourceType.Skin, skinId))
        iconView:RemoveAllListeners()
        iconView:AddListener(function()
            if iconView == self.currentSkinCardView then
                iconView:ShowInfo()
            end
        end)
        iconView:UnEquip()
        self.listItem:Add(iconView)

        index = index + 1
        if currentEquippedSkin == skinId then
            iconView:Equip()
            self.currentSkinCardView = iconView
            self.lastItemEquip = iconView

            self:SetIndex(index)
        end
    end
    if currentEquippedSkin == nil then
        self:SetIndex(1)
        local countSkin = InventoryUtils.Get(ResourceType.Skin, self.skinId)
        self:UpdatePreviewHero()
        if countSkin ~= nil and countSkin > 0 then
            self.config.buttonEquip.gameObject:SetActive(true)
        else
            self.config.buttonGoShop.gameObject:SetActive(true)
            self:ShowButtonGoToShop()
        end
        self.config.nameSkin.text = LanguageUtils.LocalizeSkinName(self.skinId)
    end
end

--- @return void
function UIHeroSkin:Show()

    self.config.heroName.text = LanguageUtils.LocalizeNameHero(self.model.heroResource.heroId)

    self.heroMenuView:SetButtonNextHero(self.config.buttonEquip.transform.position)

    self:InitUI()

    self.listHeroSkin = ClientConfigUtils.GetListSkinByHeroId(self.heroResource.heroId)
    self.listSkinCard = List()
    --- @param obj SkinCardView
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        local skinId = self.listHeroSkin:Get(dataIndex)
        self.listSkinCard:Add(obj)
        obj:SetIconData(ItemIconData.CreateInstance(ResourceType.Skin, skinId))
        obj:SetSize(SKIN_CARD_SIZE.x, SKIN_CARD_SIZE.y)
        obj:RemoveAllListeners()
        obj:AddListener(function()
            if obj == self.currentSkinCardView then
                obj:ShowInfo()
            end
        end)
        obj:UnEquip()
    end
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.SkinCardView, onCreateItem)
    self.uiScroll:Resize(self.listHeroSkin:Count())
    self.coroutine = Coroutine.start(function()
        while (true) do
            coroutine.waitforendofframe()
            self:ScrollSkin()
        end
    end)
end
--- @return void
function UIHeroSkin:OnChangeHero()
    self:Hide()

    self:Show()
end

--- @return void
function UIHeroSkin:StopCoroutine()
    if self.coroutine ~= nil then
        Coroutine.stop(self.coroutine)
        self.coroutine = nil
    end
end

--- @return void
function UIHeroSkin:ReturnPoolSkinItem()
    ---@param v SkinCardView
    for _, v in ipairs(self.listItem:GetItems()) do
        v:ReturnPool()
    end
    self.listItem:Clear()
end

--- @return void
function UIHeroSkin:Hide()
    self:StopCoroutine()

    self:ReturnPoolSkinItem()

    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end

    if self.listSkinCard:Count() < 1 then
        self.listSkinCard = nil
    end

    if self.heroMenuView ~= nil and self.heroMenuView.previewHeroMenu ~= nil then
        self.heroMenuView.previewHeroMenu:PreviewHero(self.model.heroResource, HeroModelType.Basic)
    end
end

--- @return void
function UIHeroSkin:UpdateUI()
    ---@param v SkinCardView
    for i, v in ipairs(self.listItem:GetItems()) do
        v.config.transform:GetChild(0).localScale = U_Vector3.one * math.max(0.7, 1 - math.abs(v.config.transform.position.x - self.config.content.parent.position.x) / 10)
    end
    self.config.layout.enabled = false
    self.config.layout.enabled = true
end

--- @return void
function UIHeroSkin:ScrollSkin()
    --- @param v SkinCardView
    for i, v in ipairs(self.listSkinCard:GetItems()) do
        local posX = math.floor(v.config.rectTransform.anchoredPosition.x + self.config.scrollContent.anchoredPosition.x)
        local selectPosX = self.config.selectSkinAnchor.anchoredPosition.x
        if selectPosX + 200 > posX and posX > selectPosX - 200 then
            if self.currentSkinCardView ~= v then
                self:SetIndex(i)
                self:SetCurrentSkinCard(v)
                self:CheckButton()
                self.uiScroll:ScrollToCellSnap(i - 1, 1500)
            end
            return
        end
    end
end

--- @return void
function UIHeroSkin:CheckButton()
    self.heroResource = self.model.heroResource:Clone()
    self.config.buttonArrowBack.gameObject:SetActive(false)
    self.config.buttonArrowNext.gameObject:SetActive(false)
    self.config.buttonBuy.gameObject:SetActive(false)
    self.config.buttonGoShop.gameObject:SetActive(false)
    self.config.buttonEquip.gameObject:SetActive(false)
    self.config.buttonUnequip.gameObject:SetActive(false)
    self.config.buttonHideSkin.gameObject:SetActive(false)

    local currentEquippedSkin = self.model.heroResource.heroItem:Get(HeroItemSlot.SKIN)
    if self.currentSkinCardView.iconData.itemId == currentEquippedSkin then
        self.config.buttonUnequip.gameObject:SetActive(true)
        self.config.buttonHideSkin.gameObject:SetActive(true)

        self:UpdateStateHideSkin()
    else
        local countSkin = InventoryUtils.Get(ResourceType.Skin, self.currentSkinCardView.iconData.itemId)
        if countSkin ~= nil and countSkin > 0 then
            self.config.buttonEquip.gameObject:SetActive(true)

            self.heroResource.heroItem:RemoveByKey(HeroItemSlot.SKIN, currentEquippedSkin)

            self:UpdatePreviewHero()
        else
            --self.config.buttonBuy.gameObject:SetActive(true)
            self.config.buttonGoShop.gameObject:SetActive(true)

            self:UpdatePreviewHero()

            --self:ShowButtonBuy()
            self:ShowButtonGoToShop()
        end
    end
    self.config.nameSkin.text = LanguageUtils.LocalizeSkinName(self.currentSkinCardView.iconData.itemId)
end

function UIHeroSkin:OnClickGoToShop()
    if PopupUtils.IsPopupShowing(UIPopupName.UIHeroMenu2) then
        PopupMgr.HidePopup(UIPopupName.UIHeroMenu2)
    end
    PopupMgr.ShowAndHidePopup(UIPopupName.UIIapShop, IapShopTab.SKIN, UIPopupName.UISkinPreview)
end

function UIHeroSkin:ShowButtonGoToShop()
    --- @type SkinRawProducts
    local skinRawProducts = ResourceMgr.GetPurchaseConfig():GetCashShop().packConfigDict:Get(OpCode.ITEM_SKIN_BUNDLE_PURCHASE)
    --- @type ProductConfig
    local productConfig = skinRawProducts:FindSkinProductBySkinId(self.skinId)
    self.config.buttonGoShop.gameObject:SetActive(productConfig ~= nil)
end

function UIHeroSkin:ShowButtonBuy()
    --- @type {id, moneyType, moneyValue, listRewardInBound, limit}
    local skinItemExchangeConfig = self.rawSkinExchangeConfig:GetSkinItemConfigBySkinId(self.skinId)
    self.config.iconPrice.gameObject:SetActive(skinItemExchangeConfig ~= nil)

    if skinItemExchangeConfig ~= nil then
        self.config.iconPrice.sprite = ResourceLoadUtils.LoadMoneyIcon(skinItemExchangeConfig.moneyType)
        self.config.textPrice.text = skinItemExchangeConfig.moneyValue
    else
        --- @type SkinRawProducts
        local skinRawProducts = ResourceMgr.GetPurchaseConfig():GetCashShop().packConfigDict:Get(OpCode.ITEM_SKIN_BUNDLE_PURCHASE)
        --- @type ProductConfig
        local productConfig = skinRawProducts:FindSkinProductBySkinId(self.skinId)
        self.config.buttonBuy.gameObject:SetActive(productConfig ~= nil)
        if productConfig ~= nil then
            self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(productConfig.productID)
        end
    end

    self.config.buttonBuy.onClick:RemoveAllListeners()
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuySkin()
    end)
end

function UIHeroSkin:UpdateStateHideSkin()
    self.config.tickHideSkin:SetActive(not self.model.heroResource.isHideSkin)

    self.heroMenuView.previewHeroMenu:PreviewHeroNormal(self.heroResource, HeroModelType.Basic)
end

function UIHeroSkin:UpdatePreviewHero()
    if self.enablePreview then
        self.heroResource.heroItem:Add(HeroItemSlot.SKIN, self.skinId)
        self.heroResource.isHideSkin = false
    else
        self.heroResource.heroItem:RemoveByKey(HeroItemSlot.SKIN)
    end
    if self.heroMenuView.previewHeroMenu then
        self.heroMenuView.previewHeroMenu:PreviewHeroNormal(self.heroResource, HeroModelType.Basic)
    end
end

function UIHeroSkin:OnClickToggleShowSkin()
    local onToggleHideSkinSuccess = function()
        self.model.heroResource.isHideSkin = not self.model.heroResource.isHideSkin

        self:CheckButton()

        self.heroMenuView.previewHeroMenu:PreviewHeroNormal(self.model.heroResource, HeroModelType.Basic)
    end

    NetworkUtils.RequestAndCallback(OpCode.HERO_SKIN_HIDE,
            UnknownOutBound.CreateInstance(PutMethod.Long, self.model.heroResource.inventoryId, PutMethod.Bool, not self.model.heroResource.isHideSkin),
            onToggleHideSkinSuccess, SmartPoolUtils.LogicCodeNotification, nil, true)
end

function UIHeroSkin:OnClickEquip()
    NetworkUtils.RequestAndCallback(OpCode.HERO_SKIN_EQUIP,
            UnknownOutBound.CreateInstance(PutMethod.Long, self.model.heroResource.inventoryId, PutMethod.Int, self.currentSkinCardView.iconData.itemId),
            function()
                local lastEquip = self.model.heroResource.heroItem:Get(HeroItemSlot.SKIN)
                if lastEquip ~= nil then
                    InventoryUtils.Add(ResourceType.Skin, lastEquip, 1)
                end
                self.model.heroResource.heroItem:Add(HeroItemSlot.SKIN, self.currentSkinCardView.iconData.itemId)
                InventoryUtils.Sub(ResourceType.Skin, self.currentSkinCardView.iconData.itemId, 1)

                if self.lastItemEquip ~= nil then
                    self.lastItemEquip:UnEquip()
                end
                self.lastItemEquip = self.currentSkinCardView
                self.currentSkinCardView:Equip()

                self:CheckButton()

                self.heroMenuView.previewHeroMenu:PreviewHero(self.heroResource, HeroModelType.Basic)
                self.heroMenuView:ChangeStatHero()
            end, SmartPoolUtils.LogicCodeNotification, nil, true)
end

function UIHeroSkin:OnClickUnEquip()
    NetworkUtils.RequestAndCallback(OpCode.HERO_SKIN_EQUIP,
            UnknownOutBound.CreateInstance(PutMethod.Long, self.model.heroResource.inventoryId, PutMethod.Int, -1),
            function()
                local lastEquip = self.model.heroResource.heroItem:Get(HeroItemSlot.SKIN)
                if lastEquip ~= nil then
                    self.model.heroResource.heroItem:RemoveByKey(HeroItemSlot.SKIN)
                    InventoryUtils.Add(ResourceType.Skin, lastEquip, 1)
                end
                self.currentSkinCardView:UnEquip()

                self:CheckButton()

                self.heroMenuView.previewHeroMenu:PreviewHero(self.heroResource, HeroModelType.Basic)
                self.heroMenuView:ChangeStatHero()
            end, SmartPoolUtils.LogicCodeNotification, nil, true)
end

--- @type {id, moneyType, moneyValue, listRewardInBound, limit}
function UIHeroSkin:RequestSkinExchange(skinItemExchangeConfig)
    local price = RewardInBound.CreateBySingleParam(ResourceType.Money, skinItemExchangeConfig.moneyType, skinItemExchangeConfig.moneyValue)
    if InventoryUtils.IsEnoughSingleResourceRequirement(price) == false then
        return
    end
    --- @type List
    local listReward
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        listReward = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)
    end
    local onSuccess = function()
        if listReward ~= nil then
            PopupUtils.ClaimAndShowRewardList(listReward)
            InventoryUtils.Sub(price.type, price.id, price.number)
        end
        self:OnClickEquip()
    end
    NetworkUtils.RequestAndCallback(OpCode.ITEM_SKIN_EXCHANGE,
            UnknownOutBound.CreateInstance(PutMethod.Int, skinItemExchangeConfig.id),
            onSuccess, nil, onBufferReading)
end

function UIHeroSkin:RequestSkinPurchase()
    --- @type SkinRawProducts
    local skinRawProducts = ResourceMgr.GetPurchaseConfig():GetCashShop().packConfigDict:Get(OpCode.ITEM_SKIN_BUNDLE_PURCHASE)
    --- @type ProductConfig
    local productConfig = skinRawProducts:FindSkinProductBySkinId(self.skinId)

    RxMgr.purchaseProduct:Next(productConfig.productID)
end

function UIHeroSkin:OnClickBuySkin()
    --- @type {id, moneyType, moneyValue, listRewardInBound, limit}
    local skinItemExchangeConfig = self.rawSkinExchangeConfig:GetSkinItemConfigBySkinId(self.skinId)
    if skinItemExchangeConfig ~= nil then
        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_buy"), nil,
                function()
                    self:RequestSkinExchange(skinItemExchangeConfig)
                end)
    else
        self:RequestSkinPurchase(self.skinId)
    end
end