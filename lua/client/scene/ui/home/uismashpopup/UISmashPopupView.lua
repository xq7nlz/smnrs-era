require "lua.client.scene.ui.common.MoneyBarLocalView"

--- @class UISmashPopupView : UIBaseView
UISmashPopupView = Class(UISmashPopupView, UIBaseView)

--- @return void
--- @param model UISmashPopupModel
function UISmashPopupView:Ctor(model)
	---@type UISmashPopupConfig
	self.config = nil
	---@type InputNumberView
	self.inputView = nil
	---@type MoneyBarLocalView
	self.moneyBarView = nil
	---@type RootIconView
	self.item = nil

	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UISmashPopupModel
	self.model = model
end

--- @return void
function UISmashPopupView:OnReadyCreate()
	---@type UISmashPopupConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.bgClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonSmash.onClick:AddListener(function ()
		self:OnClickSmash()
	end)
end

--- @return void
function UISmashPopupView:InitLocalization()
	local localizeSmash = LanguageUtils.LocalizeCommon("smash_egg")
	self.config.localizeSmash.text = localizeSmash
	self.config.tittle.text = localizeSmash
end

--- @return void
---@param result PopupBuyItemData
function UISmashPopupView:Init(result)
	self.model.moneyType = result.moneyType
	self.model.number = result.number
	self.model.minInput = result.minInput
	self.model.maxInput = result.maxInput
	self.model.step = result.step
	self.callbackSmash = result.callbackSmash
	if self.model.moneyType ~= nil then
		if self.moneyBarView == nil then
			self.moneyBarView = MoneyBarLocalView(self.config.moneyBarInfo)
		end
		self.moneyBarView:SetIconData(self.model.moneyType, false, true)
		self.config.moneyBarInfo.gameObject:SetActive(true)
	else
		self.config.moneyBarInfo.gameObject:SetActive(false)
	end
	if self.item == nil then
		self.item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.item)
	end
	self.item:SetIconData(result.item)

	if self.inputView == nil then
		self.inputView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.InputNumberView, self.config.inputNumberView)
		local changeInput = function(value)
			self:OnChangeInput(value)
		end
		self.inputView.onChangeInput = changeInput
	end

	self.inputView:SetData(self.model.number, self.model.minInput, self.model.maxInput)
end

--- @return void
function UISmashPopupView:OnReadyShow(result)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	self:Init(result)
end

--- @return void
function UISmashPopupView:Hide()
	UIBaseView.Hide(self)
	self.inputView:ReturnPool()
	self.inputView = nil
	if self.moneyBarView ~= nil then
		self.moneyBarView:RemoveListener()
	end
end

--- @return void
function UISmashPopupView:OnChangeInput(value)
	self.model.number = value
	if self.moneyBarView ~= nil and self.model.step ~= nil then
		self.moneyBarView:SetText1(value * self.model.step)
	end
end

--- @return void
function UISmashPopupView:OnClickSmash()
	PopupMgr.HidePopup(UIPopupName.UISmashPopup)
	if self.callbackSmash ~= nil then
		self.callbackSmash(self.model.number)
	end
end