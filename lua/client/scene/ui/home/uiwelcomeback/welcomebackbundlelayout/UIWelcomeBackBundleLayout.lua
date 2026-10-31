--- @class UIWelcomeBackBundleLayout : UIWelcomeBackLayout
UIWelcomeBackBundleLayout = Class(UIWelcomeBackBundleLayout, UIWelcomeBackLayout)

--- @param view UIWelcomeBackView
--- @param welcomeBackTab WelcomeBackTab
--- @param anchor UnityEngine_RectTransform
function UIWelcomeBackBundleLayout:Ctor(view, welcomeBackTab, anchor)
    --- @type UIWelcomeBackBundleLayoutConfig
    self.layoutConfig = nil
    --- @type List
    self.listPoolItemShow = List()
    --- @type PackOfProducts
    self.eventConfig = nil
    --- @type UILoopScroll
    self.uiLoopScroll = nil
    --- @type EventNewHeroBundleModel
    self.eventModel = nil
    --- @type UILoopScroll
    self.scrollRoundReward = nil
    --- @type WelcomeBackInBound
    self.welcomeBackInBound = nil
    --- @type ComebackProducts
    self.comebackProducts = nil
    --- @type PackOfProducts
    self.packsOfProducts = nil

    UIWelcomeBackLayout.Ctor(self, view, welcomeBackTab, anchor)
end

function UIWelcomeBackBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("welcome_back_bundle", self.anchor)
    UIWelcomeBackLayout.InitLayoutConfig(self, inst)

    self:InitButtonListener()

    self:InitLocalization()

    self:InitScroll()
end

function UIWelcomeBackBundleLayout:InitScroll()
    --- @param obj IapTilePackItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type LimitedProduct
        local limitedProduct = self.packsOfProducts:GetAllPackBase():Get(dataIndex)
        obj:SetViewIconData(PackViewType.WELCOME_BACK_BUNDLE, limitedProduct, function ()
            self:OnPurchaseSuccess(limitedProduct.id)
        end)
    end
    self.uiLoopScroll = UILoopScroll(self.layoutConfig.scrollBundle, UIPoolType.IapTilePackItem, onCreateItem)
    self.uiLoopScroll:SetUpMotion(MotionConfig())
end

function UIWelcomeBackBundleLayout:InitLocalization()
    UIWelcomeBackLayout.InitLocalization(self)

    self.layoutConfig.textTittle.text = LanguageUtils.LocalizeCommon("welcome_back_bundle_title")
end

function UIWelcomeBackBundleLayout:InitButtonListener()

end

function UIWelcomeBackBundleLayout:GetModelConfig()
    UIWelcomeBackLayout.GetModelConfig(self)
end

function UIWelcomeBackBundleLayout:OnShow()
    self.welcomeBackInBound = self.view.welcomeBackInBound
    self.questConfig = self.welcomeBackInBound.questConfig
    self.welcomeBackDataId = self.welcomeBackInBound.dataId

    self.packsOfProducts = ResourceMgr.GetPurchaseConfig():GetCashShop():GetComebackProducts():GetPackDictByDataId(self.welcomeBackDataId)

    UIWelcomeBackLayout.OnShow(self)

    self.uiLoopScroll:Resize(self.packsOfProducts:GetAllPackBase():Count())
end

function UIWelcomeBackBundleLayout:OnHide()
    UIWelcomeBackLayout.OnHide(self)
    self.uiLoopScroll:Hide()
end

function UIWelcomeBackBundleLayout:OnPurchaseSuccess(packId)

end