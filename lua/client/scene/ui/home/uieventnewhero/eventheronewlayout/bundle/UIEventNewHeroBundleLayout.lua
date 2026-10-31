require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"

--- @class UIEventNewHeroBundleLayout : UIEventNewHeroLayout
UIEventNewHeroBundleLayout = Class(UIEventNewHeroBundleLayout, UIEventNewHeroLayout)

--- @param view UIEventNewHeroView
--- @param eventTimeType EventTimeType
--- @param anchor UnityEngine_RectTransform
function UIEventNewHeroBundleLayout:Ctor(view, eventTimeType, anchor)
    --- @type UIEventNewHeroBundleLayoutConfig
    self.layoutConfig = nil
    --- @type PackOfProducts
    self.eventConfig = nil
    --- @type UILoopScroll
    self.uiLoopScroll = nil
    --- @type EventNewHeroBundleModel
    self.eventModel = nil

    UIEventNewHeroLayout.Ctor(self, view, eventTimeType, anchor)
end

function UIEventNewHeroBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_new_hero_bundle", self.anchor)
    UIEventNewHeroLayout.InitLayoutConfig(self, inst)

    self:InitLocalization()

    self:InitScroll()
end

function UIEventNewHeroBundleLayout:InitScroll()
    --- @param obj IapTilePackItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type EventNewHeroBundleProduct
        local eventNewHeroBundleProduct = self.eventConfig:GetAllPackBase():Get(dataIndex)
        local data = self.eventModel:GetPurchasePackInBound(eventNewHeroBundleProduct.id)
        obj:SetViewIconData(PackViewType.NEW_HERO_BUNDLE, data, function ()
            self:OnPurchaseSuccess(eventNewHeroBundleProduct.id)
        end)
    end
    self.uiLoopScroll = UILoopScroll(self.layoutConfig.scrollBundle, UIPoolType.IapTilePackItem, onCreateItem)
    self.uiLoopScroll:SetUpMotion(MotionConfig())
end

function UIEventNewHeroBundleLayout:InitLocalization()
    UIEventNewHeroLayout.InitLocalization(self)

    self.layoutConfig.textTittle.text = LanguageUtils.LocalizeCommon("new_hero_bundle_title")
end

function UIEventNewHeroBundleLayout:GetModelConfig()
    UIEventNewHeroLayout.GetModelConfig(self)
end

function UIEventNewHeroBundleLayout:OnShow()
    UIEventNewHeroLayout.OnShow(self)
    local bg = ResourceLoadUtils.LoadTexture("BannerNewHeroBundle", tostring(self.eventModel.timeData.dataId), ComponentName.UnityEngine_Sprite)
    self.layoutConfig.bgTittle.sprite = bg
    self.uiLoopScroll:Resize(self.eventConfig:GetAllPackBase():Count())
end

function UIEventNewHeroBundleLayout:OnHide()
    UIEventNewHeroLayout.OnHide(self)
    self.uiLoopScroll:Hide()
end

function UIEventNewHeroBundleLayout:OnPurchaseSuccess(packId)
end