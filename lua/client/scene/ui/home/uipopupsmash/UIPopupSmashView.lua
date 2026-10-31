---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiPopupSmash.UIPopupSmashConfig"
require "lua.client.scene.ui.common.MoneyBarLocalView"

--- @class UIPopupSmashView : UIBaseView
UIPopupSmashView = Class(UIPopupSmashView, UIBaseView)

--- @return void
--- @param model UIPopupSmashModel
function UIPopupSmashView:Ctor(model)
	---@type UIPopupSmashConfig
	self.config = nil
	---@type InputNumberView
	self.inputView = nil
	---@type MoneyBarLocalView
	self.moneyBarView = nil

	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIPopupSmashModel
	self.model = model
end

--- @return void
function UIPopupSmashView:OnReadyCreate()
	---@type UIPopupSmashConfig
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
function UIPopupSmashView:InitLocalization()
	local localizeSmash = LanguageUtils.LocalizeCommon("smash")
	self.config.localizeSmash.text = localizeSmash
	self.config.tittle.text = localizeSmash
	self.config.textContent.text = LanguageUtils.LocalizeCommon("smash_many")
end

--- @return void
---@param result PopupBuyItemData
function UIPopupSmashView:Init(result)
	self.model.moneyType = result.moneyType
	self.model.number = result.number
	self.model.minInput = result.minInput
	self.model.maxInput = result.maxInput
	self.callbackSmash = result.callbackSmash
	if self.moneyBarView == nil then
		self.moneyBarView = MoneyBarLocalView(self.config.moneyBarInfo)
	end
	self.moneyBarView:SetIconData(self.model.moneyType)

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
function UIPopupSmashView:OnReadyShow(result)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	self:Init(result)
end

--- @return void
function UIPopupSmashView:Hide()
	UIBaseView.Hide(self)
	self.inputView:ReturnPool()
	self.inputView = nil
	if self.moneyBarView ~= nil then
		self.moneyBarView:RemoveListener()
	end
end

--- @return void
function UIPopupSmashView:OnChangeInput(value)
	self.model.number = value
end

--- @return void
function UIPopupSmashView:OnClickSmash()
	PopupMgr.HidePopup(UIPopupName.UIPopupSmash)
	if self.callbackSmash ~= nil then
		self.callbackSmash(self.model.number)
	end
end