--- @class UIPopupPurchaseItemsView : UIBaseView
UIPopupPurchaseItemsView = Class(UIPopupPurchaseItemsView, UIBaseView)

--- @return void
--- @param model UIPopupPurchaseItemsModel
function UIPopupPurchaseItemsView:Ctor(model)
	--- @type OpCode
	self.opCode = OpCode.PURCHASE_LIMITED_PACK
	--- @type number
	self.packId = nil
	--- @type LimitedProduct
	self.packData = nil
	--- @type List
	self.rewardList = nil
	--- @type function
	self.onClickBuy = nil
	--- @type UILoopScroll
	self.uiScroll = nil
	UIBaseView.Ctor(self, model)
	--- @type UIPopupPurchaseItemsModel
	self.model = model
end

function UIPopupPurchaseItemsView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("purchase_items")
end

--- @return void
function UIPopupPurchaseItemsView:OnReadyCreate()
	require("lua.client.scene.ui.home.uiPopupPurchaseItems.UIPopupPurchaseItemsConfig")
	---@type UIPopupPurchaseItemsConfig
	self.config = UIBaseConfig(self.uiTransform)

	self:InitScrollView()
	self:InitButtonListener()
end

function UIPopupPurchaseItemsView:InitButtonListener()
	self.config.buttonBuy.onClick:AddListener(function()
		self:OnClickBackOrClose()
		if self.onClickBuy then
			self.onClickBuy()
		end
	end)

	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)

	self.config.bgClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
end

function UIPopupPurchaseItemsView:InitScrollView()
	--- @param obj RewardInBound
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type RewardInBound
		local reward = self.rewardList:Get(dataIndex)
		obj:SetIconData(reward:GetIconData())
	end

	self.uiScroll = UILoopScroll(self.config.scrollView, UIPoolType.ItemInfoView, onCreateItem, onCreateItem)
end

--- @param result table
function UIPopupPurchaseItemsView:OnReadyShow(result)
	self:SetPackData(result.packId)
	self:SetOnClickBuy(result.onClickBuy)
	self:SetLocalization()
	self:SetIcon()
	self:SetScrollSize()
end

function UIPopupPurchaseItemsView:SetScrollSize()
	self.uiScroll:Resize(self.rewardList:Count())
end

--- @param packId number
function UIPopupPurchaseItemsView:SetPackData(packId)
	self.packId = packId
	self.statistics = zg.playerData:GetIAP():GetLimitedPackStatisticsInBound(packId)
	self.packData = ResourceMgr.GetPurchaseConfig():GetCashShop():GetPack(self.opCode):GetPackBase(packId)
	self.rewardList = self.packData:GetRewardList()
end

function UIPopupPurchaseItemsView:SetOnClickBuy(onClickBuy)
	self.onClickBuy = onClickBuy
end

function UIPopupPurchaseItemsView:SetLocalization()
	self.config.textIconTitle.text = LanguageUtils.LocalizeCommon(string.format("limited_pack_%d", self.packId))
	self.config.textIconDesc.text = LanguageUtils.LocalizeCommon(string.format("limited_pack_desc_%d", self.packId))
	self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(ClientConfigUtils.GetPurchaseKey(OpCode.PURCHASE_LIMITED_PACK, self.packId))
	self:SetTextBuy()
end

function UIPopupPurchaseItemsView:SetTextBuy()
	local remaining = self.packData.stock - self.statistics.numberOfBought
	local color = remaining > 0 and UIUtils.color4 or UIUtils.color7
	self.config.textBuyValue.text = string.format("%s %s",
			LanguageUtils.LocalizeCommon("buy"),
			UIUtils.SetColorString(color, string.format("(%d/%d)", remaining, self.packData.stock))
	)
end

function UIPopupPurchaseItemsView:SetIcon()
	self.config.icon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconLimitedPack, self.packData.id)
end

function UIPopupPurchaseItemsView:OnReadyHide()
	UIBaseView.OnReadyHide(self)

	self.uiScroll:Hide()
end

function UIPopupPurchaseItemsView:OnClickBackOrClose()
	UIBaseView.OnClickBackOrClose(self)
end

