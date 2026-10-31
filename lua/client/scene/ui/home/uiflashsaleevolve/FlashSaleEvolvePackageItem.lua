--- @class FlashSaleEvolvePackageItem
FlashSaleEvolvePackageItem = Class(FlashSaleEvolvePackageItem)

local FIRST_CHILD = 1
local NUMBER_PACK_TYPE = 2
local PACK_TYPE = {
    NORMAL_HERO = 0,
    DARK_LIGHT_HERO = 1,
}

--- @param transform UnityEngine_Transform
--- @param view UIFlashSaleEvolveView
function FlashSaleEvolvePackageItem:Ctor(transform, view, index)
    ---@type FirstTopUpPackageItemConfig
    self.config = UIBaseConfig(transform)
    --- @type UIFlashSaleEvolveView
    self.view = view
    ---@type number
    self.index = index
    --- @type UnityEngine_Transform
    self.transform = transform
    --- @type number
    self.heroId = nil
    --- @type WorldSpaceHeroView
    self.worldSpaceHeroView = nil
    ---@type HeroResource
    self.heroResourcePreview = nil
    ---@type List
    self.listRewardItem = nil
    ---@type RewardState
    self.cameraSize = 3.3
    ---@type RewardInBound
    self.addedRewardInBound = nil
    ---@type number
    self.packId = nil
end

function FlashSaleEvolvePackageItem:SetData(heroId)
    local cashShop = ResourceMgr.GetPurchaseConfig():GetCashShop()
    self.heroId = heroId
    local packIndex = PACK_TYPE.NORMAL_HERO
    local isDarkLightHero = ClientConfigUtils.IsDarkLightHero(heroId)
    if isDarkLightHero then
        packIndex = PACK_TYPE.DARK_LIGHT_HERO
    end
    self.packId = self.index + NUMBER_PACK_TYPE * packIndex
    ---@type ProductConfig
    local productConfig = cashShop:GetFlashSaleEvolveProductConfig(self.packId)
    local heroFragmentId = ClientConfigUtils.GetHeroFragmentIdByHeroId(heroId)
    self.addedRewardInBound = RewardInBound.CreateBySingleParam(ResourceType.HeroFragment, heroFragmentId, 50)
    cashShop:AddRewardToFlashSaleEvolvePack(self.packId, self.addedRewardInBound)
    if not productConfig then
        self.view:OnClickBackOrClose()
    end
    ---@type List
    local rewardList = productConfig.rewardList
    self:InitLocalizeHerDes()
    self:InitLocalizeButtonBuy(productConfig)
    self:InitButtonListener(productConfig)
    self:InitPreviewHero()
    self:InitBackgroundAndForeground()
    self:AddExtendReward(rewardList, self.addedRewardInBound)
    self:InitListItemReward(rewardList)
end

function FlashSaleEvolvePackageItem:AddButtonListener(func)
    self.config.button1.onClick:RemoveAllListeners()
    self.config.button1.onClick:AddListener(function()
        if func then
            func()
        end
    end)
end

---@param productConfig ProductConfig
function FlashSaleEvolvePackageItem:InitButtonListener(productConfig)
    self:AddButtonListener(function()
        BuyUtils.InitListener(function()
            RxMgr.notificationPurchasePacks:Next()
            self.view.buyTime = self.view.buyTime + 1
            UIUtils.SetActiveColorByMaterial(self.config.button1.gameObject, false, "ui_gray_mat")
            self:InitLocalizeButtonBuy(nil, LanguageUtils.LocalizeCommon("sold_out"))
            self:AddButtonListener(function()
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("sold_out"))
            end)
        end)
        RxMgr.purchaseProduct:Next(productConfig.productID)
    end)
end

function FlashSaleEvolvePackageItem:InitLocalizeHerDes()
    self.config.textHero.text = LanguageUtils.LocalizeNameHero(self.heroId)
    self.config.textHeroDes.text = LanguageUtils.Localize("hero_desc_" .. self.heroId, LanguageUtils.EnumType)
end

--- @param productConfig ProductConfig
function FlashSaleEvolvePackageItem:InitLocalizeButtonBuy(productConfig, localize)
    local priceText = LanguageUtils.LocalizeCommon("buy")
    if productConfig then
        priceText = zg.iapMgr:ConvertLocalPrice(tonumber(productConfig.dollarPrice)).price
    end
    if localize then
        priceText = localize
    end
    self.config.text1.text = priceText
end

---@param rewardList List
---@param rewardInBound RewardInBound
function FlashSaleEvolvePackageItem:AddExtendReward(rewardList, rewardInBound)
    rewardList:Insert(rewardInBound, FIRST_CHILD)
end

---@param rewardList List
function FlashSaleEvolvePackageItem:InitListItemReward(rewardList)
    self.listRewardItem = List()
    ---@param v RewardInBound
    for _, v in pairs(rewardList:GetItems()) do
        --- @type RootIconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardContent)
        iconView:SetIconData(v:GetIconData())
        iconView:RegisterShowInfo()
        self.listRewardItem:Add(iconView)
    end
end

function FlashSaleEvolvePackageItem:InitPreviewHero()
    ---@type boolean
    local mustRenderHero = self.heroId ~= nil
    if (mustRenderHero) then
        if self.worldSpaceHeroView == nil then
            ---@type UnityEngine_Transform
            local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
            self.worldSpaceHeroView = WorldSpaceHeroView(trans)
            local renderTexture = U_RenderTexture(540, 800, 24, U_RenderTextureFormat.ARGB32)
            if (self.config.rawImageHero ~= nil) then
                self.config.rawImageHero.gameObject:SetActive(true)
                self.config.rawImageHero.texture = renderTexture
            end
            self.worldSpaceHeroView:Init(renderTexture)
        end
        self.heroResourcePreview = HeroResource.CreateInstance(nil, tonumber(self.heroId), 13, 1)
    end
    if (self.config.rawImageHero ~= nil) then
        self.config.rawImageHero.gameObject:SetActive(mustRenderHero)
    end
    self.worldSpaceHeroView:ShowHero(self.heroResourcePreview)
    self.worldSpaceHeroView:SetSizeCamera(self.cameraSize)
    self.worldSpaceHeroView.config.transform.position = U_Vector3(10000 * self.index, 99000, 0)
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView.config.bg:SetActive(false)
    end
end

function FlashSaleEvolvePackageItem:InitBackgroundAndForeground()
    local factionId = ClientConfigUtils.GetFactionIdByHeroId(self.heroId)
    self.config.bg.sprite = ResourceLoadUtils.LoadFirstTopUpBackground(factionId)
    self.config.fg.sprite = ResourceLoadUtils.LoadFirstTopUpForeground(factionId)
end

--- @return void
--- Add hero and background to view preview hero
function FlashSaleEvolvePackageItem:ReturnPoolPreviewHero()
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end
end

--- @return void
function FlashSaleEvolvePackageItem:RemoveAddedRewardFromProductConfig()
    ResourceMgr.GetPurchaseConfig():GetCashShop():RemoveRewardFromFlashSaleEvolvePack(self.packId, self.addedRewardInBound)
    self.addedRewardInBound = nil
end

--- @return void
function FlashSaleEvolvePackageItem:ReturnPoolListReward()
    if self.listRewardItem then
        ---@param v RootIconView
        for _, v in pairs(self.listRewardItem:GetItems()) do
            v:ReturnPool()
        end
        self.listRewardItem = nil
    end
end

--- @return void
function FlashSaleEvolvePackageItem:ResetButtonBuyState()
    UIUtils.SetActiveColorByMaterial(self.config.button1.gameObject, true, "ui_gray_mat")
end

--- @return void
function FlashSaleEvolvePackageItem:RemoveIapListener()
    if self.onIAPInitializedComplete ~= nil then
        self.onIAPInitializedComplete:Unsubscribe()
        self.onIAPInitializedComplete = nil
    end
end

--- @return void
function FlashSaleEvolvePackageItem:ReturnPool()
    self:RemoveAddedRewardFromProductConfig()
    self:ReturnPoolListReward()
    self:ReturnPoolPreviewHero()
    self:ResetButtonBuyState()
    self:RemoveIapListener()
end