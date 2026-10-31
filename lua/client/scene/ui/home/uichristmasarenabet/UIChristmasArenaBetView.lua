
--- @class UIChristmasArenaBetView : UIBaseView
UIChristmasArenaBetView = Class(UIChristmasArenaBetView, UIBaseView)

--- @param model UIChristmasArenaBetModel
function UIChristmasArenaBetView:Ctor(model)
	--- @type UIChristmasArenaBetConfig
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
	--- @type UIChristmasArenaBetModel
	self.model = model
end

function UIChristmasArenaBetView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self.moneyBar = MoneyBarLocalView(self.config.moneyBarInfo)
	self:InitButtons()
end

function UIChristmasArenaBetView:InitButtons()
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

function UIChristmasArenaBetView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("area_bet_title")
	self.config.textDonate.text = LanguageUtils.LocalizeCommon("area_bet")
	self.config.textExchange.text = LanguageUtils.LocalizeCommon("area_bet")
end

--- @param data {callbackClose : function}
function UIChristmasArenaBetView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self:SetButtonExchangePrice(false)
	self:Init(data)
end

--- @param data {callbackClose : function}
function UIChristmasArenaBetView:Init(data)
	self.teamId = data.teamId
	self.callbackBet = data.callbackBet
	self.moneyBar:SetIconData(MoneyType.EVENT_CHRISTMAS_CANDLE)
	self.moneyBar.needHighLight = true
	local number = InventoryUtils.GetMoney(MoneyType.EVENT_CHRISTMAS_CANDLE)
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
function UIChristmasArenaBetView:OnClickBet()
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
	NetworkUtils.RequestAndCallback(OpCode.EVENT_CHRISTMAS_BET_ARENA, outBound, onSuccess, onFailed)
end

--- @return void
function UIChristmasArenaBetView:SetButtonExchangePrice(isEnable)
	self.config.donateButton.gameObject:SetActive(not isEnable)
	self.config.buttonExchangePrice.gameObject:SetActive(isEnable)
end

--- @return void
function UIChristmasArenaBetView:Hide()
	self:SetButtonExchangePrice(false)
	if self.input ~= nil then
		self.input:ReturnPool()
		self.input.onChangeInput = nil
		self.input = nil
	end
	UIBaseView.Hide(self)
end