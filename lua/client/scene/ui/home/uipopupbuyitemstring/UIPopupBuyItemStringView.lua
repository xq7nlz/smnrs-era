---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiPopupBuyItemString.UIPopupBuyItemStringConfig"
require "lua.client.scene.ui.common.MoneyBarLocalView"

--- @class UIPopupBuyItemStringView : UIBaseView
UIPopupBuyItemStringView = Class(UIPopupBuyItemStringView, UIBaseView)

--- @return void
--- @param model UIPopupBuyItemStringModel
--- @param ctrl UIPopupBuyItemStringCtrl
function UIPopupBuyItemStringView:Ctor(model, ctrl)
	---@type UIPopupBuyItemStringConfig
	self.config = nil
	---@type ItemIconView
	self.itemView = nil
	---@type InputNumberView
	self.inputView = nil
	---@type MoneyBarLocalView
	self.moneyBarView = nil

	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIPopupBuyItemStringModel
	self.model = model
	--- @type UIPopupBuyItemStringCtrl
	self.ctrl = ctrl
end

--- @return void
function UIPopupBuyItemStringView:OnReadyCreate()
	---@type UIPopupBuyItemStringConfig
	self.config = UIBaseConfig(self.uiTransform)

	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonCloseLayer.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonPurchase.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickPurchase()
	end)
end

--- @return void
function UIPopupBuyItemStringView:InitLocalization()
	self.config.textPurchase.text = LanguageUtils.LocalizeCommon("buy")
	self.config.textItem.text = LanguageUtils.LocalizeCommon("smash_many")
end

--- @return void
---@param result PopupBuyItemData
function UIPopupBuyItemStringView:Init(result)
	self.model.data = result
	self.config.textPurchase.text = self.model.data.textButton
	if self.moneyBarView == nil then
		self.moneyBarView = MoneyBarLocalView(self.config.moneyBar)
	end
	self.moneyBarView:SetIconData(self.model.data.moneyType, true, true, false)

	if self.inputView == nil then
		self.inputView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.InputNumberView, self.config.inputNumber)
		local changeInput = function(value)
			self:OnChangeInput(value)
		end
		self.inputView.onChangeInput = changeInput
	end

	self.inputView:SetData(self.model.data.number, self.model.data.minInput, self.model.data.maxInput)
	self.ctrl:UpdateData()
	self:UpdateNumberPurchase()
end

--- @return void
function UIPopupBuyItemStringView:OnReadyShow(result)
	self:Init(result)
end

--- @return void
function UIPopupBuyItemStringView:Hide()
	UIBaseView.Hide(self)
	self.inputView:ReturnPool()
	self.inputView = nil
	if self.moneyBarView ~= nil then
		self.moneyBarView:RemoveListener()
	end
end

--- @return void
function UIPopupBuyItemStringView:UpdateNumberPurchase()
	if self.model.data.isSell then
		self.moneyBarView:SetMoneyText(self.model.priceTotal)
	else
		self.moneyBarView:SetBuyText(self.model.priceTotal)
	end
end

--- @return void
function UIPopupBuyItemStringView:OnChangeInput(value)
	self.model.data.number = value
	self.ctrl:UpdateData()
	self:UpdateNumberPurchase()
end

--- @return void
function UIPopupBuyItemStringView:OnClickPurchase()
	if self.model.data.callbackPurchase ~= nil then
		if self.model.data.isSell then
			PopupMgr.HidePopup(UIPopupName.UIPopupBuyItemString)
			self.model.data.callbackPurchase(self.model.data.number, self.model.priceTotal)
			zg.audioMgr:PlaySfxUi(SfxUiType.SELL)
		else
			local canPurchase = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, self.model.data.moneyType, self.model.priceTotal))
			if canPurchase then
				PopupMgr.HidePopup(UIPopupName.UIPopupBuyItemString)
				self.model.data.callbackPurchase(self.model.data.number, self.model.priceTotal)
				zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
			end
		end
	end
end