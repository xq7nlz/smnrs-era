--require "lua.client.scene.ui.home.uiIapShop.eventBundleLarge.UIEventBundleLarge"
require "lua.client.scene.ui.home.uiEventLunarNewYear.eventLayout.springBundle.UIEventLunarNewYearBundleItemView"

--- @class UIEventLunarNewYearSpringBundleLayout : UIEventLunarNewYearLayout
UIEventLunarNewYearSpringBundleLayout = Class(UIEventLunarNewYearSpringBundleLayout, UIEventLunarNewYearLayout)

--- @param view UIEventNewYearView
--- @param newYearTab LunarNewYearTab
--- @param anchor UnityEngine_RectTransform
function UIEventLunarNewYearSpringBundleLayout:Ctor(view, newYearTab, anchor)
    --- thay type bằng type config của từng layout
    --- @type EventLunarNewYearConfig
    --self.eventConfig = nil
    --- @type List
    self.listBundleLarge = List()
    --- @type UIEventLunarNewYearBundleItemView
    self.packList = nil
   -- --- @type PackOfProducts
    --self.packOfProducts = nil
    self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR_2022
    UIEventLunarNewYearLayout.Ctor(self ,view, newYearTab, anchor)
end

--- @param objectView UnityEngine_GameObject
function UIEventLunarNewYearSpringBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_lunar_2022_spring_bundle_layout", self.anchor)
    UIEventLunarNewYearLayout.InitLayoutConfig(self, inst)
    --  ---@type UIEventBirthdayBundleLayoutConfig
    --self.listBundleLarge = List()
    --
    --self.listBundleLarge:Add(UIEventBundleLarge(self.layoutConfig.bundle1,nil,self.view.CheckAllNotificationTab))
    --self.listBundleLarge:Add(UIEventBundleLarge(self.layoutConfig.bundle2,nil,self.view.CheckAllNotificationTab))
    --self:InitLocalization()

    self:InitPacks()
end

function UIEventLunarNewYearSpringBundleLayout:InitLocalization()
    --for i = 1, self.listBundleLarge:Count() do
    --    --- @type UIEventBundleLarge
    --    local eventBundleLarge = self.listBundleLarge:Get(i)
    --    eventBundleLarge:SetTittle(LanguageUtils.LocalizeCommon("event_lunar_2022_spring_bundle_" .. i))
    --end
end

function UIEventLunarNewYearSpringBundleLayout:GetModelConfig()
    ---@type EventLunarNewYearModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end


function UIEventLunarNewYearSpringBundleLayout:OnShow()
   self:GetModelConfig()
    UIEventLunarNewYearLayout.OnShow(self)
    ---@type PackOfProducts
    --self.packOfProducts = ResourceMgr.GetPurchaseConfig():GetLunarSpringBundleStore():GetCurrentPack()
    --for i = 1, self.listBundleLarge:Count() do
    --    local productConfig = self.packOfProducts:GetPackBase(i)
    --    --- @type UIEventBundleLarge
    --    local eventBundleLarge = self.listBundleLarge:Get(i)
    --    eventBundleLarge:SetProduct(productConfig, self.eventModel)
    --    eventBundleLarge:OnShow()
    --end
    for i = 1, self.packList:Count() do
        --- @type UIEventNewYearBundleItemView
        local packItem = self.packList:Get(i)
        packItem:OnShow(i, self.eventModel.timeData.dataId)
    end
end

function UIEventLunarNewYearSpringBundleLayout:OnHide()
    UIEventLayout.OnHide(self)
    self.anchor.gameObject:SetActive(false)
    --for i = 1, self.listBundleLarge:Count() do
    --    --- @type UIEventBundleLarge
    --    local eventBundleLarge = self.listBundleLarge:Get(i)
    --    eventBundleLarge:OnHide()
    --end
end

function UIEventLunarNewYearSpringBundleLayout:InitPacks()
    self.packList = List()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    for i = 1, self.layoutConfig.rectTrans.childCount do
        local packView = UIEventLunarNewYearBundleItemView(self.layoutConfig.rectTrans:GetChild(i - 1))
        self.packList:Add(packView)
    end
end