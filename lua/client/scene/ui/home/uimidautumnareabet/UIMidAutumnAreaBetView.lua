
--- @class UIMidAutumnAreaBetView : UIBaseView
UIMidAutumnAreaBetView = Class(UIMidAutumnAreaBetView, UIBaseView)

--- @param model UIMidAutumnAreaBetModel
function UIMidAutumnAreaBetView:Ctor(model)
	--- @type UIMidAutumnAreaBetConfig
	self.config = nil
	---@type number
	self.teamId = nil
	---@type function
	self.callbackBet = nil
	---@type MoneyBarLocalView
	self.moneyBar = nil
	---@type InputSliderView
	self.input = nil
	UIBaseView.Ctor(self, model)
	--- @type UIMidAutumnAreaBetModel
	self.model = model
end

function UIMidAutumnAreaBetView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self.moneyBar = MoneyBarLocalView(self.config.moneyBarInfo)
	self:InitButtons()
end

function UIMidAutumnAreaBetView:InitButtons()
	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonBg.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.donateButton.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickBet()
	end)
end

function UIMidAutumnAreaBetView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("area_bet_title")
	self.config.textDonate.text = LanguageUtils.LocalizeCommon("area_bet")
	self.config.textExchange.text = LanguageUtils.LocalizeCommon("area_bet")
end

--- @param data {callbackClose : function}
function UIMidAutumnAreaBetView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self:SetButtonExchangePrice(false)
	self:Init(data)
end

--- @param data {callbackClose : function}
function UIMidAutumnAreaBetView:Init(data)
	self.teamId = data.teamId
	self.callbackBet = data.callbackBet
	self.moneyBar:SetIconData(MoneyType.EVENT_MID_AUTUMN_LANTERN)
	self.moneyBar.needHighLight = true
	local number = InventoryUtils.GetMoney(MoneyType.EVENT_MID_AUTUMN_LANTERN)
	if self.input == nil then
		self.input = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.InputNumberView, self.config.inputSliderView)
	end
	self.input:SetData(1, 1, number)

	self.input.onChangeInput = function(value)
		self.moneyBar:SetBuyText(value)
	end
	self.input.onChangeInput(1)
end

--- @return void
function UIMidAutumnAreaBetView:OnClickBet()
	local value = self.input.value
	local teamId = self.teamId

	local onSuccess = function()
		if self.callbackBet ~= nil then
			self.callbackBet(value, teamId)
		end
	end
	local outBound = UnknownOutBound.CreateInstance(PutMethod.Int, self.teamId, PutMethod.Int, self.input.value)

	local onFailed = function(logicCode)
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("failed"))
		SmartPoolUtils.ShowShortNotification(logicCode)
	end
	self:OnClickBackOrClose()
	NetworkUtils.RequestAndCallback(OpCode.EVENT_MID_AUTUMN_BET_ARENA, outBound, onSuccess, onFailed)
end

--- @return void
function UIMidAutumnAreaBetView:SetButtonExchangePrice(isEnable)
	self.config.donateButton.gameObject:SetActive(not isEnable)
	self.config.buttonExchangePrice.gameObject:SetActive(isEnable)
end

--- @return void
function UIMidAutumnAreaBetView:Hide()
	self:SetButtonExchangePrice(false)
	if self.input ~= nil then
		self.input:ReturnPool()
		self.input.onChangeInput = nil
		self.input = nil
	end
	UIBaseView.Hide(self)
end
