
--- @class UIBossChallengeQuickBattleView : UIBaseView
UIBossChallengeQuickBattleView = Class(UIBossChallengeQuickBattleView, UIBaseView)

--- @param model UIBossChallengeQuickBattleModel
function UIBossChallengeQuickBattleView:Ctor(model)
	--- @type UIBossChallengeQuickBattleConfig
	self.config = nil
	---@type function
	self.callbackQuickBattle = nil
	---@type MoneyBarLocalView
	self.moneyBar = nil
	---@type InputSliderView
	self.input = nil
	UIBaseView.Ctor(self, model)
	--- @type UIBossChallengeQuickBattleModel
	self.model = model
end

function UIBossChallengeQuickBattleView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self.moneyBar = MoneyBarLocalView(self.config.moneyBarInfo)

	self:InitButtons()
end

function UIBossChallengeQuickBattleView:InitButtons()
	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonBg.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.donateButton.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickQuickBattle()
	end)
end

function UIBossChallengeQuickBattleView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("quick_battle_title")
	self.config.textDonate.text = LanguageUtils.LocalizeCommon("quick_battle")
	self.config.textExchange.text = LanguageUtils.LocalizeCommon("quick_battle")
end

--- @param data {callbackClose : function}
function UIBossChallengeQuickBattleView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self:Init(data)
end

--- @param data {callbackClose : function}
function UIBossChallengeQuickBattleView:Init(data)
	self.callbackQuickBattle = data.callbackQuickBattle
	self.moneyBar:SetIconData(MoneyType.EVENT_BOSS_CHALLENGE_TICKET)
	self.moneyBar.needHighLight = true
	local number = InventoryUtils.GetMoney(MoneyType.EVENT_BOSS_CHALLENGE_TICKET)
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
function UIBossChallengeQuickBattleView:OnClickQuickBattle()
	if self.callbackQuickBattle ~= nil then
		self.callbackQuickBattle(self.input.value)
	end
	self:OnClickBackOrClose()
end

--- @return void
function UIBossChallengeQuickBattleView:Hide()
	if self.input ~= nil then
		self.input:ReturnPool()
		self.input.onChangeInput = nil
		self.input = nil
	end
	UIBaseView.Hide(self)
end
