require("lua.client.scene.ui.home.uiEventBlackFridayNewVersion.eventLayout.UIEventBlackFridayNewVersionLayout")
require("lua.client.scene.ui.home.uiEventBlackFridayNewVersion.eventLayout.super_deal_layout.UIEventBlackFridayNewPackView")

--- @class UIEventBlackFridayNewSuperDealLayout : UIEventBlackFridayNewVersionLayout
UIEventBlackFridayNewSuperDealLayout = Class(UIEventBlackFridayNewSuperDealLayout, UIEventBlackFridayNewVersionLayout)

--- @param view UIIapShopView
function UIEventBlackFridayNewSuperDealLayout:Ctor(view, tab, anchor)
    --- @type List
    self.packList = List()
    --- @type UIBlackFridayNewSuperDealConfig
    self.layoutConfig = nil
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    UIEventBlackFridayNewVersionLayout.Ctor(self, view, tab, anchor)
end

--- @param parent UnityEngine_RectTransform
function UIEventBlackFridayNewSuperDealLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("black_friday_new_super_deal", self.anchor)
    UIEventBlackFridayNewVersionLayout.InitLayoutConfig(self, inst)
    self:InitLocalization()
    self:InitPack()
    self:InitUpdateTime()
end

function UIEventBlackFridayNewSuperDealLayout:InitPack()
    self.listData = ResourceMgr.GetPurchaseConfig():GetEventBlackFridayNewBundleStore():GetPack(self.eventModel.timeData.dataId).packDict
end

function UIEventBlackFridayNewSuperDealLayout:OnShow()
    UIEventBlackFridayNewVersionLayout.OnShow(self)
    self:InitLocalization()
    self.coroutine = Coroutine.start(function()
        coroutine.waitforseconds(0.45)
        --- @param obj UIEventBlackFridayNewPackView
        local onCreateItem = function(obj, index)
            index = index + 1
            --- @type CustomizeProduct
            local customizeProduct = self.listData:Get(index)
            obj:SetData(customizeProduct)
        end

        self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.UIEventBlackFridayNewPackView, onCreateItem)
        self.uiScroll:Resize(self.listData:Count())
    end)

    self:StartUpdateTime()
end

function UIEventBlackFridayNewSuperDealLayout:OnHide()
    self:RemoveUpdateTime()
    UIEventBlackFridayNewVersionLayout.OnHide(self)
    self.uiScroll:Hide()
end

function UIEventBlackFridayNewSuperDealLayout:InitUpdateTime()
    self.layoutConfig.textTimer.gameObject:SetActive(true)
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.layoutConfig.textTimer.text = string.format(LanguageUtils.LocalizeCommon("refresh_in"),
                UIUtils.SetColorString(UIUtils.white, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end

function UIEventBlackFridayNewSuperDealLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventBlackFridayNewSuperDealLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventBlackFridayNewSuperDealLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventBlackFridayNewSuperDealLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

function UIEventBlackFridayNewSuperDealLayout:InitLocalization()
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("title_black_friday_sale_super_deal")
end