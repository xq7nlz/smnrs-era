require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapShopLevelPassLayout.UIGrowthPackView"

--- @class UIIapShopLevelPassLayout : UIIapShopLayout
UIIapShopLevelPassLayout = Class(UIIapShopLevelPassLayout, UIIapShopLayout)

--- @param view UIIapShopView
--- @param parent UnityEngine_RectTransform
function UIIapShopLevelPassLayout:Ctor(view, parent)
    --- @type Dictionary
    self.uiGrowthPackDict = Dictionary()
    --- @type UIIapShopLevelPassLayoutConfig
    self.layoutConfig = nil
    --- @type UIGrowthPackView
    self.uiGrowthPackView = nil
    UIIapShopLayout.Ctor(self, view, parent)
end

--- @param parent UnityEngine_RectTransform
function UIIapShopLevelPassLayout:InitLayoutConfig(parent)
    local inst = PrefabLoadUtils.Instantiate("level_pass_view", parent)
    self.layoutConfig = UIBaseConfig(inst.transform)
    UIUtils.SetParent(inst.transform, parent)
    inst:SetActive(true)
end

--- @param iapShopTab IapShopTab
function UIIapShopLevelPassLayout:OnShow(iapShopTab)
    UIIapShopLayout.OnShow(self, iapShopTab)
    self:GetUiGrowthPack(iapShopTab)

    --- @type BasicInfoInBound
    local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    self.layoutConfig.textLevel.text = tostring(basicInfoInBound.level)

    self.config.levelPassView.gameObject:SetActive(true)
    self.uiGrowthPackView:Show()
end

function UIIapShopLevelPassLayout:SetUpLayout()
    UIIapShopLayout.SetUpLayout(self)
    self.config.levelPassView.gameObject:SetActive(true)
end

--- @param iapShopTab IapShopTab
function UIIapShopLevelPassLayout:GetUiGrowthPack(iapShopTab)
    self.uiGrowthPackView = self.uiGrowthPackDict:Get(iapShopTab)
    if self.uiGrowthPackView == nil then
        if iapShopTab == IapShopTab.LEVEL_PASS_1 then
            self.uiGrowthPackView = UIGrowthPackView(self.view, self, self.layoutConfig.line1, 1)
        elseif iapShopTab == IapShopTab.LEVEL_PASS_2 then
            self.uiGrowthPackView = UIGrowthPackView(self.view, self, self.layoutConfig.line2, 2)
        end
        self.uiGrowthPackDict:Add(iapShopTab, self.uiGrowthPackView)
    end
    self.layoutConfig.tittle.text = string.format("%s %d", LanguageUtils.LocalizeCommon("level_pass"), self.uiGrowthPackView.id)
end

function UIIapShopLevelPassLayout:InitLocalization()
    self.layoutConfig.textSummonerLevel.text = LanguageUtils.LocalizeCommon("summoner_level")
    self.layoutConfig.textActive.text = LanguageUtils.LocalizeCommon("activated")
    self.layoutConfig.textUnlock.text = LanguageUtils.LocalizeCommon("unlock_level_pass")
    self.layoutConfig.textFreeReward.text = LanguageUtils.LocalizeCommon("free_reward")
    self.layoutConfig.textPremiumReward.text = LanguageUtils.LocalizeCommon("premium_reward")

    self.layoutConfig.textClaimAllFree.text = LanguageUtils.LocalizeCommon("claim_all")
    self.layoutConfig.textClaimAllPremium.text = LanguageUtils.LocalizeCommon("claim_all")
end

function UIIapShopLevelPassLayout:OnHide()
    self.uiGrowthPackView:Hide()
end

function UIIapShopLevelPassLayout:OnDestroy()
    self.uiGrowthPackView:OnDestroy()
end

function UIIapShopLevelPassLayout:SetBuyState(isAllowToBuy, isUnlocked)
    self.layoutConfig.buttonUnlock.gameObject:SetActive(isAllowToBuy and not isUnlocked)
    self.layoutConfig.buttonActive.gameObject:SetActive(isUnlocked)
end

function UIIapShopLevelPassLayout:SetActiveButtonClaimAll(isBasic, isActive)
    if isBasic then
        self.layoutConfig.buttonClaimFree.gameObject:SetActive(isActive)
    else
        self.layoutConfig.buttonClaimPremium.gameObject:SetActive(isActive)
    end
end

function UIIapShopLevelPassLayout:SetPrice(price)
    self.layoutConfig.textPrice.text = price
end

function UIIapShopLevelPassLayout:AddOnClickBuyListener(listener)
    self.layoutConfig.buttonUnlock.onClick:RemoveAllListeners()
    self.layoutConfig.buttonUnlock.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if listener then
            listener()
        end
    end)
end

function UIIapShopLevelPassLayout:AddOnClickClaimAllFree(listener)
    self.layoutConfig.buttonClaimFree.onClick:RemoveAllListeners()
    self.layoutConfig.buttonClaimFree.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if listener then
            listener()
        end
    end)
end

function UIIapShopLevelPassLayout:AddOnClickClaimAllPremium(listener)
    self.layoutConfig.buttonClaimPremium.onClick:RemoveAllListeners()
    self.layoutConfig.buttonClaimPremium.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if listener then
            listener()
        end
    end)
end

--- @param isLock boolean
function UIIapShopLevelPassLayout:EnableLockPremium(isLock)
    self.layoutConfig.iconLockPremiumReward:SetActive(isLock)
end
