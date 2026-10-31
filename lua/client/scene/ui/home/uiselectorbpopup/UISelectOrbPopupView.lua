
--- @class UISelectOrbPopupView : UIBaseView
UISelectOrbPopupView = Class(UISelectOrbPopupView, UIBaseView)

--- @param model UISelectOrbPopupModel
function UISelectOrbPopupView:Ctor(model)
	--- @type UISelectOrbPopupConfig
	self.config = nil
	---@type function
	self.callbackSelect = nil
	---@type MoneyBarLocalView
	self.moneyBar = nil
	---@type InputSliderView
	self.input = nil
	---@type number
	self.number = nil
	UIBaseView.Ctor(self, model)
	--- @type UISelectOrbPopupModel
	self.model = model
end

function UISelectOrbPopupView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self.moneyBar = MoneyBarLocalView(self.config.moneyBarInfo)
	self:InitButtons()
end

function UISelectOrbPopupView:InitButtons()
	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonBg.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.selectButton.onClick:AddListener(function()
		self:OnClickSelect()
	end)
end

function UISelectOrbPopupView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("select_orb_title")
	self.config.textCancel.text = LanguageUtils.LocalizeCommon("cancel")
	self.config.textConfirm.text = LanguageUtils.LocalizeCommon("confirm")
end

--- @param data {callbackClose : function}
function UISelectOrbPopupView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self:Init(data)
end

--- @param data {callbackClose : function}
function UISelectOrbPopupView:Init(data)
	self.moneyType = data.moneyType
	self.callbackSelect = data.callbackSelect
	self.number = data.number
	self.moneyBar:SetIconData(self.moneyType)
	self.moneyBar:SetMoneyText(self.number)
	self.moneyBar.needHighLight = true
	if self.input == nil then
		self.input = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.InputNumberView, self.config.inputSliderView)
	end
	self.input:SetData(1, 1, self.number, 10)

	self.input.onChangeInput = function(value)
		self.moneyBar:SetBuyText(value)
	end
	self.input.onChangeInput(1)
end

--- @return void
function UISelectOrbPopupView:OnClickSelect()
	local value = self.input.value

	if self.callbackSelect ~= nil then
		self.callbackSelect(value, teamId)
	end

	self:OnClickBackOrClose()
end

--- @return void
function UISelectOrbPopupView:Hide()
	if self.input ~= nil then
		self.input:ReturnPool()
		self.input.onChangeInput = nil
		self.input = nil
	end
	UIBaseView.Hide(self)
end
