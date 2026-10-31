--- @class UIEventHeroReleaseBundleLayout : UIEventHeroReleaseLayout
UIEventHeroReleaseBundleLayout = Class(UIEventHeroReleaseBundleLayout, UIEventHeroReleaseLayout)

--- @param view UIEventValentineView
--- @param tab number
--- @param anchor UnityEngine_RectTransform
function UIEventHeroReleaseBundleLayout:Ctor(view, tab, anchor)
    --- @type UIEventHeroReleaseBundleLayoutConfig
    self.layoutConfig = nil
    --- @type PackOfProducts
    self.listProductConfig = nil
    --- @type UILoopScroll
    self.uiLoopScroll = nil
    --- @type PackViewType
    self.packViewType = PackViewType.HERO_RELEASE_BUNDLE

    UIEventHeroReleaseLayout.Ctor(self, view, tab, anchor)
end

function UIEventHeroReleaseBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_hero_release_bundle", self.anchor)
    UIEventHeroReleaseLayout.InitLayoutConfig(self, inst)

    self:InitLocalization()

    self:InitScroll()
end

function UIEventHeroReleaseBundleLayout:InitScroll()
    --- @param obj IapTilePackItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type EventHeroReleaseProduct
        local eventHeroReleaseProduct = self.listProductConfig:Get(dataIndex)
        obj:SetViewIconData(self.packViewType, eventHeroReleaseProduct, function ()
            self:OnPurchaseSuccess(eventHeroReleaseProduct.id)
        end)
    end
    self.uiLoopScroll = UILoopScroll(self.layoutConfig.scrollBundle, UIPoolType.IapTilePackItem, onCreateItem)
    self.uiLoopScroll:SetUpMotion(MotionConfig())
end

function UIEventHeroReleaseBundleLayout:OnPurchaseSuccess()

end

function UIEventHeroReleaseBundleLayout:OnShow()
    UIEventHeroReleaseLayout.OnShow(self)
    local bundleStore  = ResourceMgr.GetPurchaseConfig():GetHeroReleaseBundleStore()
    if (bundleStore == nil) then
        XDebug.Log("ERROR BUNDLE STORE NIL")
    end
    local packGet =  bundleStore:GetPack(self.eventModel.timeData.dataId)
    if (packGet == nil) then
        XDebug.Log("ERROR packGet NIL")
    end
    self.listProductConfig = packGet.packList
    self.uiLoopScroll:Resize(self.listProductConfig:Count())
end

function UIEventHeroReleaseBundleLayout:SetUpLayout()
    UIEventHeroReleaseLayout.SetUpLayout(self)

    local dataId = self.eventModel.timeData.dataId
    self.layoutConfig.textTittle.text = LanguageUtils.LocalizeCommon("event_hero_release_bundle_tittle_" .. dataId)

    local bg = ResourceLoadUtils.LoadTexture("BannerEventHeroReleaseBundle", tostring(dataId), ComponentName.UnityEngine_Sprite)
    self.layoutConfig.bgTittle.sprite = bg
    self.layoutConfig.bgTittle:SetNativeSize()
    local faction = ClientConfigUtils.GetFactionIdByEventHeroRelease(self.eventModel:GetConfig())
    self.layoutConfig.imgTextBg.color = ClientConfigUtils.GetBGColorByFaction(faction)
end

function UIEventHeroReleaseBundleLayout:OnHide()
    UIEventHeroReleaseLayout.OnHide(self)
    self.uiLoopScroll:Hide()
end