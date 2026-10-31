require "lua.client.scene.ui.home.uiUnlockBattlePass.UnlockBattlePassPanelLayout"
POSX_PREMIUM_DATA_1 = -638.6
POSX_PREMIUM_DATA_2 = -414.07
POSX_VIP_PREMIUM_DATA_1 = 600
POSX_VIP_PREMIUM_DATA_2 = 359
--- @class UIUnlockBattlePassView : UIBaseView
UIUnlockBattlePassView = Class(UIUnlockBattlePassView, UIBaseView)

--- @param model UIUnlockBattlePassModel
function UIUnlockBattlePassView:Ctor(model)
    --- @type UIUnlockBattlePassConfig
    self.config = nil
    --- @type Dictionary
    self.bundleLayoutDict = Dictionary()

    UIBaseView.Ctor(self, model)
    --- @type UIUnlockBattlePassModel
    self.model = model
end

function UIUnlockBattlePassView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:InitButtons()

    self:InitBundleLayout()
end

function UIUnlockBattlePassView:InitBundleLayout()
    for i = 1, self.config.layoutAnchor.childCount do
        local layout = UnlockBattlePassPanelLayout(self.config.layoutAnchor:GetChild(i - 1), function()
            self:OnClickBuyPremium(i)
        end)
        layout:InitLocalization(i)
        self.bundleLayoutDict:Add(i, layout)
    end
end

function UIUnlockBattlePassView:InitButtons()
    self.config.bgClose.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBackOrClose()
    end)
end

function UIUnlockBattlePassView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    self:OnReadyHide()
end

--- @return void
function UIUnlockBattlePassView:OnReadyHide()
    if self.callbackClose ~= nil then
        self.callbackClose()
    end
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView.config.gameObject:SetActive(false)
    end
    PopupMgr.HidePopup(self.model.uiName)
end
function UIUnlockBattlePassView:InitLocalization()
    --- @param v UnlockBattlePassPanelLayout
    for k, v in pairs(self.bundleLayoutDict:GetItems()) do
        v:InitLocalization(k)
    end
end

--- @param data {callbackClose : function}
function UIUnlockBattlePassView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)
    self.onUnlockSuccess = data.onUnlockSuccess
    self.onPremiumUnlockSuccess = data.onPremiumUnlockSuccess
    self.callBackBuyPremium = data.callBackBuyPremium
    self.haveSkin = data.haveSkin
    self.config.tapToClose.text = LanguageUtils.LocalizeCommon("tap_to_close")
    self.config.instantTenLevel.text = LanguageUtils.LocalizeCommon("instant_unlock_ten_level")
    --- @type EventBattlePassModel
    self.eventBattlePassModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BATTLE_PASS)
    self.listProduct = ResourceMgr.GetPurchaseConfig():GetBattlePassBundlePremiumTicketStore():GetCurrentPack():GetAllPackBase()
    self.dataId = self.eventBattlePassModel.timeData.dataId
    self:ShowReward()
    --self:ShowDemoSkin()
    self:ShowDemoSkin2(data.skinId)
    if self.haveSkin then
        self.config.hehta.gameObject:SetActive(true)
        self.config.premiumPass.localPosition = U_Vector3(POSX_PREMIUM_DATA_1,
                self.config.premiumPass.localPosition.y, 0)
        self.config.vipProPass.localPosition = U_Vector3(POSX_VIP_PREMIUM_DATA_1,
                self.config.vipProPass.localPosition.y, 0)
    else
        self.config.hehta.gameObject:SetActive(false)
        self.config.premiumPass.localPosition = U_Vector3(POSX_PREMIUM_DATA_2,
                self.config.premiumPass.localPosition.y, 0)
        self.config.vipProPass.localPosition = U_Vector3(POSX_VIP_PREMIUM_DATA_2,
                self.config.vipProPass.localPosition.y, 0)
    end

    self:SetSprite("background", self.config.bg)
    self:SetSprite("bg_character_holder_dark_theme_pack", self.config.holder, true)
    --self:SetSprite("front_bg", self.config.frontground)
    self.config.frontground.gameObject:SetActive(false)
    self:SetSprite("icon_premium_pass_banner", self.config.premiumPassImage, true)
    self:SetSprite("icon_premium_pass_plus_banner", self.config.premiumPlusPassImage, true)
    if self.config.premiumPlusPassTopImage then
        self:SetSprite("bg_top", self.config.premiumPlusPassTopImage, true)
    end
end

--- @return void
function UIUnlockBattlePassView:SetSprite(spriteName, image, isSetNative)
    if self.atlas == nil or self.lastDataId ~= self.dataId then
        self.lastDataId = self.dataId
    end
    local sprite = ResourceLoadUtils.LoadAssetBattlePass(self.dataId, spriteName)
    if sprite ~= nil then
        image.sprite = sprite
        image.gameObject:SetActive(true)
    else
        image.gameObject:SetActive(false)
    end
    if isSetNative then
        image:SetNativeSize()
    end
end

--- @return void
--- @param image UnityEngine_UI_Image
function UIUnlockBattlePassView:SetBackground(spriteName, image)
    local sprite = ResourceLoadUtils.LoadAssetBattlePass(self.dataId, spriteName)
    if sprite ~= nil then
        image.sprite = sprite
        image.gameObject:SetActive(true)
    else
        image.gameObject:SetActive(false)
    end
end

function UIUnlockBattlePassView:ShowReward()
    --- @param v UnlockBattlePassPanelLayout
    for k, v in pairs(self.bundleLayoutDict:GetItems()) do
        local productConfig = self.listProduct:Get(k)
        v:SetReward(productConfig, self.eventBattlePassModel:GetNumberBuyOpCode(productConfig.opCode, productConfig.id))
    end
end

function UIUnlockBattlePassView:Hide()
    UIBaseView.Hide(self)
    --- @param v UnlockBattlePassPanelLayout
    for k, v in pairs(self.bundleLayoutDict:GetItems()) do
        v:OnHide()
    end
    if self.worldSpaceHeroView ~= nil then
        self.worldSpaceHeroView:OnHide()
        self.worldSpaceHeroView = nil
    end
end
function UIUnlockBattlePassView:ShowDemoSkin()
    ---@type RewardInBound
    local firstRewardInBound = self.eventBattlePassModel:GetConfig():GetFirstReward()
    ---@type RewardInBound
    local lastRewardInBound = self.eventBattlePassModel:GetConfig():GetFinalReward()
    ---@type RewardInBound
    local rewardInBound = firstRewardInBound
    if lastRewardInBound.type == ResourceType.Skin then
        rewardInBound = lastRewardInBound
    end

    if (rewardInBound.type == ResourceType.Skin) then
        local skinId = rewardInBound.id
        local heroId = ClientConfigUtils.GetHeroIdBySkinId(skinId)
        if self.worldSpaceHeroView == nil then
            ---@type UnityEngine_Transform
            local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
            self.worldSpaceHeroView = WorldSpaceHeroView(trans)
            local renderTexture = U_RenderTexture(800, 800, 24, U_RenderTextureFormat.ARGB32)
            self.config.imageHertaChar.texture = renderTexture
            self.worldSpaceHeroView:Init(renderTexture)
        end
        local heroResource = HeroResource()
        heroResource:SetData(-1, heroId, 1, 1)
        heroResource.heroItem:Add(HeroItemSlot.SKIN, skinId)
        self.worldSpaceHeroView.config.gameObject:SetActive(true)
        self.worldSpaceHeroView:ShowHero(heroResource)
        self.worldSpaceHeroView.config.transform.position = U_Vector3(99000, 99000, 0)
        self.worldSpaceHeroView.config.bg:SetActive(false)
    end
end

function UIUnlockBattlePassView:ShowDemoSkin2(skinId)
    local heroId = ClientConfigUtils.GetHeroIdBySkinId(skinId)
    if self.worldSpaceHeroView == nil then
        ---@type UnityEngine_Transform
        local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
        self.worldSpaceHeroView = WorldSpaceHeroView(trans)
        local renderTexture = U_RenderTexture(800, 800, 24, U_RenderTextureFormat.ARGB32)
        self.config.imageHertaChar.texture = renderTexture
        self.worldSpaceHeroView:Init(renderTexture)
    end
    local heroResource = HeroResource()
    heroResource:SetData(-1, heroId, 1, 1)
    heroResource.heroItem:Add(HeroItemSlot.SKIN, skinId)
    self.worldSpaceHeroView.config.gameObject:SetActive(true)
    self.worldSpaceHeroView:ShowHero(heroResource)
    self.worldSpaceHeroView.config.transform.position = U_Vector3(99000, 99000, 0)
    self.worldSpaceHeroView.config.bg:SetActive(false)
end

function UIUnlockBattlePassView:OnClickBuyPremium(packId)
    --- @type ProductConfig
    local productConfig = self.listProduct:Get(packId)
    local numberOfBuy = self.eventBattlePassModel:GetNumberBuyOpCode(productConfig.opCode, productConfig.id)
    if numberOfBuy >= productConfig.stock then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("sold_out"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        return
    end

    BuyUtils.InitListener(function()
        --- @type UnlockBattlePassPanelLayout
        local layout = self.bundleLayoutDict:Get(packId)
        layout:SetReward(productConfig, numberOfBuy + 1)

        self:OnReadyHide()
        if self.onUnlockSuccess then
            self.onUnlockSuccess()
        end

        if self.onPremiumUnlockSuccess then
            self.onPremiumUnlockSuccess()
        end

        if (self.callBackBuyPremium) then
            self.callBackBuyPremium()
        end

    end)
    RxMgr.purchaseProduct:Next(productConfig.productID)
end