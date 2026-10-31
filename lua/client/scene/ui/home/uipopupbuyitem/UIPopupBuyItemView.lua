require "lua.client.scene.ui.common.MoneyBarLocalView"

--- @class UIPopupBuyItemView : UIBaseView
UIPopupBuyItemView = Class(UIPopupBuyItemView, UIBaseView)

--- @return void
--- @param model UIPopupBuyItemModel
function UIPopupBuyItemView:Ctor(model, ctrl)
	---@type UIPopupBuyItemConfig
	self.config = nil
	---@type ItemIconView
	self.itemView = nil
	---@type InputNumberView
	self.inputView = nil
	---@type MoneyBarLocalView
	self.moneyBarView = nil

	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIPopupBuyItemModel
	self.model = model
end

--- @return void
function UIPopupBuyItemView:OnReadyCreate()
	---@type UIPopupBuyItemConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.moneyBarView = MoneyBarLocalView(self.config.moneyBar)
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
function UIPopupBuyItemView:InitLocalization()
	self.config.textPurchase.text = LanguageUtils.LocalizeCommon("buy")
end

--- @return void
function UIPopupBuyItemView:OnReadyShow(result)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	self.model.data = result

	self.config.textItem.text = self.model.data.title
	self.config.textPurchase.text = self.model.data.textButton

	self.moneyBarView:SetIconData(self.model.data.moneyType, true, true, false)

	if self.itemView == nil then
		self.itemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.item)
		self.itemView:SetIconData(ItemIconData.CreateInstance(self.model.data.type, self.model.data.id, nil))
	end

	if self.inputView == nil then
		self.inputView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.InputNumberView, self.config.inputNumber)
		local changeInput = function(value)
			self:OnChangeInput(value)
		end
		self.inputView.onChangeInput = changeInput
	end

	self.inputView:SetData(self.model.data.number, self.model.data.minInput, self.model.data.maxInput)
	self:UpdateData()

	self:UpdateNumberPurchase()
end

--- @return void
function UIPopupBuyItemView:Hide()
	UIBaseView.Hide(self)
	if self.itemView ~= nil then
		self.itemView:ReturnPool()
		self.itemView = nil
	end
	if self.inputView ~= nil then
		self.inputView:ReturnPool()
		self.inputView = nil
	end
	if self.moneyBarView ~= nil then
		self.moneyBarView:RemoveListener()
	end
end

--- @return void
function UIPopupBuyItemView:UpdateNumberPurchase()
	if self.model.data.isSell then
		self.moneyBarView:SetMoneyText(self.model.priceTotal)
	else
		self.moneyBarView:SetBuyText(self.model.priceTotal)
	end
end

--- @return void
function UIPopupBuyItemView:OnChangeInput(value)
	self.model.data.number = value
	self:UpdateData()
	self:UpdateNumberPurchase()
end

--- @return void
function UIPopupBuyItemView:OnClickPurchase()
	if self.model.data.callbackPurchase ~= nil then
		if self.model.data.isSell then
			PopupMgr.HidePopup(UIPopupName.UIPopupBuyItem)
			self.model.data.callbackPurchase(self.model.data.number, self.model.priceTotal)
		else
			local canPurchase = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, self.model.data.moneyType, self.model.priceTotal))
			if canPurchase then
				PopupMgr.HidePopup(UIPopupName.UIPopupBuyItem)
				self.model.data.callbackPurchase(self.model.data.number, self.model.priceTotal)
				zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
			end
		end
	end
end

--- @return void
function UIPopupBuyItemView:UpdateData()
	self.model.priceTotal = math.floor(self.model.data.number * self.model.data.price)
end