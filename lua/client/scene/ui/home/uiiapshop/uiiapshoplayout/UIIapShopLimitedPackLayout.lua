require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.UIIapShopLayout"

--- @class UIIapShopLimitedPackLayout : UIIapShopLayout
UIIapShopLimitedPackLayout = Class(UIIapShopLimitedPackLayout, UIIapShopLayout)

--- @param view UIIapShopView
--- @param packViewType PackViewType
function UIIapShopLimitedPackLayout:Ctor(view, packViewType)
    UIIapShopLayout.Ctor(self, view)

    --- @type UIIapShopRegularPackLayoutConfig
    self.regularLayoutConfig = view.regularLayoutConfig

    self.regularLayout = view

    self.opCode = OpCode.PURCHASE_LIMITED_PACK
    self.packViewType = packViewType
    self:InitPack()
    self:InitUpdateTime()
end

function UIIapShopLimitedPackLayout:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeReset()
        else
            self.timeReset = self.timeReset - 1
        end
        self:SetTextTimeReset()
        if self.timeReset < 0 then
            self:OnEndResetTime()
        end
    end
end

function UIIapShopLimitedPackLayout:InitPack()
    self.packOfProducts = ResourceMgr.GetPurchaseConfig():GetCashShop():GetPack(self.opCode)
    self.listPack = List()
    --- @param id number
    --- @param v LimitedProduct
    for id, v in pairs(self.packOfProducts.packDict:GetItems()) do
        if v.viewType == self.packViewType then
            self.listPack:Add(v)
        end
    end
end

function UIIapShopLimitedPackLayout:OnShow()
    UIIapShopLayout.OnShow(self)


    self.uiScroll:Resize(self.listPack:Count())
    self:SetTimeReset()
    self:AddTimer()
end

function UIIapShopLimitedPackLayout:SetUpLayout()
    UIIapShopLayout.SetUpLayout(self)
    self.config.scrollVertical.gameObject:SetActive(true)
    self.config.textTimer.gameObject:SetActive(true)
    self.config.bannerView.gameObject:SetActive(true)
    self:InitScroll()
end

function UIIapShopLimitedPackLayout:InitScroll()
    --- @param obj IapTilePackItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type LimitedProduct
        local limitedProduct = self.listPack:Get(dataIndex)
        obj:SetViewIconData(self.packViewType, limitedProduct, function ()
            self:OnPurchaseSuccess()
        end)
    end
    self.uiScroll = UILoopScroll(self.regularLayoutConfig.scrollVertical, UIPoolType.IapTilePackItem, onCreateItem)
end

function UIIapShopLimitedPackLayout:OnHide()
    self.uiScroll:Hide()
    self:RemoveTimer()
end

function UIIapShopLimitedPackLayout:AddTimer()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIIapShopLimitedPackLayout:RemoveTimer()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIIapShopLimitedPackLayout:SetTimeReset()

end

function UIIapShopLimitedPackLayout:OnEndResetTime()

end

function UIIapShopLimitedPackLayout:SetTextTimeReset()
    self.config.textTimer.text = string.format(LanguageUtils.LocalizeCommon("refresh_in"),
            UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeReset)))
end

function UIIapShopLimitedPackLayout:OnPurchaseSuccess()

end