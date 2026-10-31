--- @class FirstTopUpPackageItemView
FirstTopUpPackageItemView = Class(FirstTopUpPackageItemView)

--- @param transform UnityEngine_Transform
function FirstTopUpPackageItemView:Ctor(transform, view, index)
    --- @type UIFirstTopUpView
    self.parentView = view
    ---@type FirstTopUpPackageItemConfig
    self.config = UIBaseConfig(transform)
    ---@type number
    self.index = index
    --- @type UnityEngine_Transform
    self.transform = transform
    --- @type number
    self.heroFragmentId = nil
    --- @type number
    self.skinId = nil
    --- @type WorldSpaceHeroView
    self.worldSpaceHeroView = nil
    ---@type HeroResource
    self.heroResourcePreview = nil
    ---@type List
    self.listSelectedBox = List()
    ---@type RewardState
    self.rewardState = RewardState.NOT_AVAILABLE_TO_CLAIM
    self:InitButton()
    self:InitLocalization()
    ---@type RewardState
    self.cameraSize = 3.3
end

function FirstTopUpPackageItemView:InitLocalization()
    --self:UpdateTextBtnChoose()
end

function FirstTopUpPackageItemView:InitButton()
    local onBufferReading = function(buffer)
        ---@type IapDataInBound
        local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
        iapDataInBound:OnClaimFirstPurchaseItemIndex(self.index)
        if PopupUtils.IsPopupShowing(UIPopupName.UIPopupNotificationReward) then
            PopupMgr.HidePopup(UIPopupName.UIPopupNotificationReward)
        end
        local listReward = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)
        PopupUtils.ClaimAndShowRewardList(listReward, function()
            self.parentView:OnReload()
        end)
    end
    self.config.button1.onClick:AddListener(function()
        if (self.rewardState == RewardState.CLAIMED) then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("first_purchase_reward_claimed"))
        else
            NetworkUtils.RequestAndCallback(OpCode.FIRST_PURCHASE_ITEM_CLAIM, UnknownOutBound.CreateInstance(PutMethod.Int, self.index), nil, SmartPoolUtils.LogicCodeNotification, onBufferReading)
        end
    end)
end

---@param rewardConfig RewardRequirePriceConfig
function FirstTopUpPackageItemView:SetHeroFragmentID(rewardConfig)
    self.heroFragmentId = rewardConfig:GetHeroFragmentID()
    self.cameraSize = rewardConfig.heroScale or 3.3
end

---@param rewardState RewardState
function FirstTopUpPackageItemView:SetData(rewardState, onlyLocalize)
    self.rewardState = rewardState
    self.config.button1.gameObject:SetActive(rewardState ~= RewardState.NOT_AVAILABLE_TO_CLAIM)
    local claimBtnKeyLocalize = "claim"
    if (rewardState == RewardState.CLAIMED) then
        claimBtnKeyLocalize = "claimed"
    end
    self.config.text1.text = LanguageUtils.LocalizeCommon(claimBtnKeyLocalize)
    local purchaseConfig = ResourceMgr.GetPurchaseConfig()
    --- @type RewardRequirePriceConfig
    local rewardConfig = purchaseConfig:GetListFirstTopUpRewardConfig(self.index)
    local showTextNac = rewardState == RewardState.NOT_AVAILABLE_TO_CLAIM
    if (showTextNac) then
        local price = rewardConfig.priceRequire
        local textNac
        local priceText
        local localizeKey = "first_purchase_nac_price"
        if (price > 0) then
            local updatePrice = function()
                priceText = zg.iapMgr:ConvertLocalPrice(tonumber(price)).price
                textNac = string.format(LanguageUtils.LocalizeCommon("first_purchase_nac_price"), priceText)
                self.config.textNotAvaialbleClaim.text = textNac
            end
            if zg.iapMgr.initialized then
                priceText = zg.iapMgr:ConvertLocalPrice(tonumber(price)).price
            else
                localizeKey = "first_purchase_nac_price_global"
                priceText = tostring(price)
            end
            self.onIAPInitializedComplete = RxMgr.onIAPInitializedComplete:Subscribe(updatePrice)
            textNac = string.format(LanguageUtils.LocalizeCommon(localizeKey), priceText)
        else
            textNac = LanguageUtils.LocalizeCommon("first_purchase_nac")
        end
        self.config.textNotAvaialbleClaim.text = textNac
    end
    self.config.textNotAvaialbleClaim.gameObject:SetActive(showTextNac == true)
    self.heroId = ClientConfigUtils.GetHeroIdByFragmentHeroId(rewardConfig:GetHeroFragmentID())
    self.config.textHero.text = LanguageUtils.LocalizeNameHero(self.heroId)
    self.config.textHeroDes.text = LanguageUtils.LocalizeCommon("first_purchase_hero_desc_" .. self.heroId)

    self:SetHeroFragmentID(rewardConfig)
    self:InitPreviewHero()
    self:InitBackgroundAndForeground()

    if (self.heroFragmentId ~= nil) then
        self:ShowPreviewHero()
    end
    if (onlyLocalize ~= true) then
        self.listSelectedBox = List()
        local iconDataList = purchaseConfig:GetListFirstTopUpIconReward(self.index)
        for i = 1, iconDataList:Count() do
            local iconData = iconDataList:Get(i)
            --- @type RootIconView
            local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardContent)
            iconView:SetIconData(iconData)
            iconView:RegisterShowInfo()
            self.listSelectedBox:Add(iconView)
        end
    end
end

function FirstTopUpPackageItemView:InitPreviewHero()
    ---@type boolean
    local mustRenderHero = self.heroFragmentId ~= nil
    if (mustRenderHero) then
        if self.worldSpaceHeroView == nil then
            ---@type UnityEngine_Transform
            local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
            self.worldSpaceHeroView = WorldSpaceHeroView(trans)
            local renderTexture = U_RenderTexture(800, 800, 24, U_RenderTextureFormat.ARGB32)
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
end

function FirstTopUpPackageItemView:InitBackgroundAndForeground()
    local heroId = ClientConfigUtils.GetHeroIdByFragmentHeroId(self.heroFragmentId)
    local factionId = ClientConfigUtils.GetFactionIdByHeroId(heroId)
    self.config.bg.sprite = ResourceLoadUtils.LoadFirstTopUpBackground(factionId)
    self.config.fg.sprite = ResourceLoadUtils.LoadFirstTopUpForeground(factionId)
end

--- @return void
--- Add hero and background to view preview hero
function FirstTopUpPackageItemView:ShowPreviewHero()
    self.worldSpaceHeroView:ShowHero(self.heroResourcePreview)
    self.worldSpaceHeroView:SetSizeCamera(self.cameraSize)
    self.worldSpaceHeroView.config.transform.position = U_Vector3(10000 * self.index, 99000, 0)
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView.config.bg:SetActive(false)
    end
end

--- @return void
function FirstTopUpPackageItemView:OnReadyHide()
    ---@param v RootIconView
    for _, v in pairs(self.listSelectedBox:GetItems()) do
        v:ReturnPool()
    end
    self.listSelectedBox = List()
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end
    if self.onIAPInitializedComplete ~= nil then
        self.onIAPInitializedComplete:Unsubscribe()
        self.onIAPInitializedComplete = nil
    end
end