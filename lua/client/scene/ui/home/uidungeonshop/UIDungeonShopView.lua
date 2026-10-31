---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiDungeonShop.UIDungeonShopConfig"
require "lua.client.scene.ui.common.MoneyBarLocalView"

--- @class UIDungeonShopView : UIBaseView
UIDungeonShopView = Class(UIDungeonShopView, UIBaseView)

--- @return void
--- @param model UIDungeonShopModel
function UIDungeonShopView:Ctor(model, ctrl)
	--- @type UIDungeonShopConfig
    self.config = nil
	--- @type MarketItemInBound
	self.marketItemInBound = nil
	--- @type RootIconView
	self.iconView = nil

	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIDungeonShopModel
	self.model = model
end

--- @return void
function UIDungeonShopView:OnReadyCreate()
	---@type UIDungeonShopConfig
	self.config = UIBaseConfig(self.uiTransform)

	self.config.buttonBuy.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		local cost = self.marketItem.cost
		local yesCallback = function()
			DungeonRequest.BuyShop(true, function()
				InventoryUtils.Sub(ResourceType.Money, cost.moneyType, cost.value)
				self.marketItem.reward:AddToInventory()
				PopupMgr.HidePopup(self.model.uiName)
				SmartPoolUtils.ShowReward1Item(self.marketItem.reward:GetIconData(), self.skipCallback)
			end)
		end
		PopupUtils.ShowBuyItem(LanguageUtils.LocalizeCommon("want_to_buy"), cost, yesCallback)
	end)

	self.config.buttonSkip.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		DungeonRequest.BuyShop(false, function()
			self.skipCallback()
			self:OnReadyHide()
		end)
	end)
	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.bgFog.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
end

--- @return void
function UIDungeonShopView:InitLocalization()
	self.config.localizeTitle.text = LanguageUtils.LocalizeCommon("secret_shop")
	self.config.localizeBuy.text = LanguageUtils.LocalizeCommon("buy")
	self.config.localizeSkip.text = LanguageUtils.LocalizeCommon("skip")
end

--- @return void
--- @param result table
function UIDungeonShopView:OnReadyShow(result)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	--- @type MarketItemInBound
	self.marketItem = result.marketItem
	self.skipCallback = result.skipCallback
	self.iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.resAnchor)
	self.iconView:SetIconData(self.marketItem.reward:GetIconData())
	--- @type CostInBound
	local cost = self.marketItem.cost
	--- set money bar
	self.config.iconMoney.sprite = ResourceLoadUtils.LoadMoneyIcon(cost.moneyType)
	self.config.iconMoney:SetNativeSize()

	local currentMoney = InventoryUtils.GetMoney(cost.moneyType)
	self.config.textMoney.text = ClientConfigUtils.FormatTextAPB(cost.value, currentMoney)
end

--- @return void
function UIDungeonShopView:Hide()
	UIBaseView.Hide(self)
	if self.iconView ~= nil then
		self.iconView:ReturnPool()
		self.iconView = nil
	end
end

