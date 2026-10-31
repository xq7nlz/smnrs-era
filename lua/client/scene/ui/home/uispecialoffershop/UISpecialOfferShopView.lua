require "lua.client.scene.ui.home.uiIapShop.iapShopItem.IapShopTabItem"
require "lua.client.scene.ui.home.uiSpecialOfferShop.uiSpecialOfferLayout.UISpecialOfferLayout"

--- @class UISpecialOfferShopView : UIBaseView
UISpecialOfferShopView = Class(UISpecialOfferShopView, UIBaseView)

--- @param model UISpecialOfferShopModel
function UISpecialOfferShopView:Ctor(model)
    --- @type UISpecialOfferShopConfig
    self.config = nil
    --- @type Dictionary
    self.tabDict = Dictionary()
	--- @type UISpecialOfferLayout
	self.layout = nil
	--- @type Dictionary
	self.layoutDict = Dictionary()
    UIBaseView.Ctor(self, model)
    --- @type UISpecialOfferShopModel
    self.model = model
end

function UISpecialOfferShopView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtonListener()
end

function UISpecialOfferShopView:InitButtonListener()
    self.config.backButton.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgNone.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UISpecialOfferShopView:InitLocalization()
    --- @param k PackViewType
    --- @param v IapShopTabItem
    for k, v in pairs(self.tabDict:GetItems()) do
        v:SetTabName(self:GetTabName(k))
    end
    for k, v in pairs(self.layoutDict:GetItems()) do
        v:InitLocalization()
    end
end

function UISpecialOfferShopView:OnReadyShow()
    local eventHasEnded = function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        self:OnReadyHide()
    end
    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    --- @type ProgressPackCollection
    local progressPackCollection = iapDataInBound.progressPackData
    local listGroupProductConfig = progressPackCollection:GetListActiveGroupByViewType(PackViewType.MASTER_BLACKSMITH)
    if listGroupProductConfig:Count() > 0 then
        local hasAvailableGroup = true
        for i = 1, listGroupProductConfig:Count() do
            --- @type GroupProductConfig
            local groupProductConfig = listGroupProductConfig:Get(i)
            local groupId = groupProductConfig.groupId
            local groupCreatedTime = progressPackCollection.activeProgressPackDict:Get(groupId)
            if (groupProductConfig.duration - (zg.timeMgr:GetServerTime() - groupCreatedTime)) > 0 then
                break
            else
                hasAvailableGroup = false
            end
        end
        if hasAvailableGroup == false then
            eventHasEnded()
            return
        end
    else
        eventHasEnded()
        return
    end
	self:CheckTabActive(PackViewType.MASTER_BLACKSMITH)
	self:GetLayout(PackViewType.MASTER_BLACKSMITH)
	self.layout:OnShow()
end

--- @param packViewType PackViewType
function UISpecialOfferShopView:CheckTabActive(packViewType)
    if self.tabDict:IsContainValue(packViewType) == false then
        local tabAnchor = self.config.contentShopTab:Find("tab_view_" .. packViewType)
        if tabAnchor ~= nil then
            --- @type IapShopTabItem
            local iapShopTabItem = IapShopTabItem(tabAnchor)
            iapShopTabItem:SetTabName(self:GetTabName(packViewType))
            iapShopTabItem:SetListener(function()
                self:OnSelectTab(packViewType)
            end)
            self.tabDict:Add(packViewType, iapShopTabItem)
        else
            XDebug.Error("Missing Anchor Tab View Type " .. packViewType)
        end
    end
end

--- @param packViewType PackViewType
function UISpecialOfferShopView:OnSelectTab(packViewType)
	self:DisableCommon()
	--- @param v IapShopTabItem
	for k, v in pairs(self.tabDict:GetItems()) do
		v:SetTabState(k == packViewType)
	end
	self:GetLayout(packViewType)
	self.layout:OnShow()
end

function UISpecialOfferShopView:DisableCommon()

end

--- @param packViewType PackViewType
function UISpecialOfferShopView:GetLayout(packViewType)
	if self.layout ~= nil then
		self.layout:OnHide()
	end
	self.layout = self.layoutDict:Get(packViewType)
	if self.layout == nil then
		if packViewType == PackViewType.MASTER_BLACKSMITH then
			require "lua.client.scene.ui.home.uiSpecialOfferShop.uiSpecialOfferLayout.UIMasterBlackSmithLayout"
			self.layout = UIMasterBlackSmithLayout(self, packViewType, self.config.masterBlacksmithView)
		else
			XDebug.Error("Missing layout of type " .. packViewType)
		end
		self.layout:InitLocalization()
		self.layoutDict:Add(packViewType, self.layout)
	end
end

--- @return string
--- @param packViewType PackViewType
function UISpecialOfferShopView:GetTabName(packViewType)
    if packViewType == PackViewType.MASTER_BLACKSMITH then
        return LanguageUtils.LocalizeCommon("master_blacksmith")
    end
    XDebug.Error("Missing Localize pack view type " .. packViewType)
    return "Localize " .. packViewType
end


function UISpecialOfferShopView:Hide()
    UIBaseView.Hide(self)
    self.layout:OnHide()
end

