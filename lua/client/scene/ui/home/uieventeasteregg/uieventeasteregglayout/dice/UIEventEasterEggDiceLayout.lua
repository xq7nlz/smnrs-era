require "lua.client.data.Event.EventHalloweenConfig"
require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDice.DiceSlotView"
require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDice.LapSlotView"
require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDice.DiceRewardResult"

local TIME_TO_ROLL = 0.733
--- @class UIEventEasterEggDiceLayout : UIEventEasterEggLayout
UIEventEasterEggDiceLayout = Class(UIEventEasterEggDiceLayout, UIEventEasterEggLayout)

--- @param view UIEventEasterEggView
--- @param easterEggTab EasterEggTab
--- @param anchor UnityEngine_RectTransform
function UIEventEasterEggDiceLayout:Ctor(view, easterEggTab, anchor)
	--- @type EasterEggDiceLayoutConfig
	self.layoutConfig = nil
	---@type List<DiceSlotView>
	self.diceList = nil
	---@type List<LapSlotView>
	self.lapList = nil
	---@type number
	self.rollNum = 1
	---@type number
	self.position = 1
	---@type number
	self.prevPosition = 1
	---@type number
	self.lapCompleted = 1
	---@type boolean
	self.isLimit = false
	---@type EventDiceGameData
	self.eventDiceData = nil

	self.arrowTransform_1 = nil

	self.arrowTransform_2 = nil

	UIEventEasterEggLayout.Ctor(self, view, easterEggTab, anchor)
end

function UIEventEasterEggDiceLayout:InitLayoutConfig()
	local inst = PrefabLoadUtils.Instantiate("easter_egg_dice_layout", self.anchor)
	UIEventEasterEggLayout.InitLayoutConfig(self, inst)
	self.arrowTransform_1 = self.layoutConfig.select1:GetChild(0)
	self.arrowTransform_2 = self.layoutConfig.select2:GetChild(0)
	self.rollAnim = self.layoutConfig.rollAnim
	self.bg = self.layoutConfig.rollBg
	--self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
	self:InitLocalization()
	self:GetModelConfig()
	self:InitDiceViews()
	self:InitLapViews()
	self:InitButtons()
	self:InitToggle()
end

function UIEventEasterEggDiceLayout:InitButtons()
	self.layoutConfig.buttonNormalDice.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickRoll()
	end)
	self.layoutConfig.buttonSuperDice.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:ShowSelectDicePopup()
	end)
	self.layoutConfig.exchangeRewardButton.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:ShowExchangeReward()
	end)
end

function UIEventEasterEggDiceLayout:InitToggle()
	if self.layoutConfig.toggle then
		self.toggleView = ToggleView(self.layoutConfig.toggle, function()
			self:OnClickToggleSkipDiceAnim()
		end, function()
			return LanguageUtils.LocalizeCommon("skip_dice_anim")
		end)
		self.toggleView:SetState(PlayerSettingData.isSkipDiceAnim or false)
	end
end

function UIEventEasterEggDiceLayout:OnClickToggleSkipDiceAnim()
	PlayerSetting.ToggleDiceAnim()
	self.toggleView:SetState(PlayerSettingData.isSkipDiceAnim)
end

function UIEventEasterEggDiceLayout:InitDiceViews()
	if self.diceList == nil then
		self.diceList = List()
	end
	local dicList = self.eventConfig:GetDiceConfig()
	for i = 1, self.layoutConfig.diceRollContainer.childCount do
		if dicList:IsContainKey(i) then
			local reward = dicList:Get(i)
			local diceView = DiceSlotView(self.layoutConfig.diceRollContainer:GetChild(i - 1), i)
			diceView:SetReward(reward)
			self.diceList:Add(diceView)
		end
	end
end

function UIEventEasterEggDiceLayout:InitLapViews()
	--if self.lapList == nil then
	--	self.lapList = List()
	--end
	--local dicList = self.eventConfig:GetLapConfig()
	--for i = 1, self.layoutConfig.lapAnchor.childCount do
	--	if dicList:IsContainKey(i) then
	--		---@type EventHalloweenLapDataConfig
	--		local reward = dicList:Get(i)
	--		local lapView = LapSlotView(self.layoutConfig.lapAnchor:GetChild(i - 1), i, reward:GetLapRequire())
	--		lapView:SetReward(reward:GetRewardList())
	--		self.lapList:Add(lapView)
	--	end
	--end
end

function UIEventEasterEggDiceLayout:UpdateLapViews()
	--local questId = self.eventConfig:GetQuestId(self.lapCompleted)
	--self.layoutConfig.lapCompletedValue.text = self.lapCompleted
	----XDebug.Log(string.format("lap: %s, quest id: %s",self.lapCompleted, questId))
	--for i = 1, self.lapList:Count() do
	--	local view = self.lapList:Get(i)
	--	view:SetView(questId)
	--end
end

function UIEventEasterEggDiceLayout:UpdateDiceViews()
	for i = 1, self.diceList:Count() do
		--- @type DiceSlotView
		local view = self.diceList:Get(i)
		--print(LogUtils.ToDetail(self.posList:GetItems()))
		for j = 1, self.posList:Count() do
			local temp = self.posList:Get(j) + 1
			if i == temp then
				view:SetView(true)
				break
			end
		end
	end
end

function UIEventEasterEggDiceLayout:ResetLapViews()
	--for i = 1, self.lapList:Count() do
	--	local view = self.lapList:Get(i)
	--	view:SetView(0)
	--end
end

function UIEventEasterEggDiceLayout:ResetDiceViews(showEffect)
	for i = 1, self.diceList:Count() do
		local view = self.diceList:Get(i)
		view:SetView(false)
		if showEffect ~= nil then
			view:ShowEffect()
		end
	end
	self.first = nil
	--if self.posList ~= nil then
	--    self.posList:Clear()
	--end
end

function UIEventEasterEggDiceLayout:InitLocalization()
	self.layoutConfig.startTitle.text = LanguageUtils.LocalizeCommon("start")
	local diceGuide = StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("easter_dice_guide"), nil, nil, LanguageUtils.LocalizeCommon("daily_packs"))
	self.layoutConfig.diceGuideTitle.text = diceGuide
	self.layoutConfig.diceTitle.text = LanguageUtils.LocalizeCommon("easter_egg_dice")
	self.layoutConfig.lapTitle.text = LanguageUtils.LocalizeCommon("lap_reward")
	self.layoutConfig.textNormalDiceName.text = LanguageUtils.LocalizeCommon("normal_dice")
	self.layoutConfig.textSuperDiceName.text = LanguageUtils.LocalizeCommon("super_dice")
	self.layoutConfig.textSkipDiceAnim.text = LanguageUtils.LocalizeCommon("skip_dice_anim")
	self.layoutConfig.textTapToRoll.text = LanguageUtils.LocalizeCommon("tap_dice_to_roll")
	self.layoutConfig.localizeLapCompleted.text = LanguageUtils.LocalizeCommon("completed")
end

function UIEventEasterEggDiceLayout:OnShow()
	UIEventEasterEggLayout.OnShow(self)
	self:CheckNotificationExchangeReward()
	self:FillData()
	---self:UpdateRequireView()
	self:InitLapViews()
end




function UIEventEasterEggDiceLayout:CheckNotificationExchangeReward()
	local isAvailableExchangeReward = self.eventModel:isNotificationExchangeReward()
	self.layoutConfig.noti:SetActive(isAvailableExchangeReward)
end

function UIEventEasterEggDiceLayout:FillData()
	self.normalDiceBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.normalDiceBarAnchor)
	self.normalDiceBarView:SetIconData(MoneyType.EVENT_EASTER_DICE)
	self.superDiceBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.superDiceBarAnchor)
	self.superDiceBarView:SetIconData(MoneyType.EVENT_EASTER_SUPER_DICE)
	self.eventDiceData = self.eventModel:GetDiceData()
	self.position = self.eventDiceData.position + 1
	self.prevPosition = self.position
	self.lapCompleted = self.eventDiceData.lapCompleted
	self.rollNum = self.eventDiceData.rollNumber
	--- @type List
	self.posList = self.eventModel:GetPositionDiceList()
	if self.position ~= 1 then
		self.posList:Add(self.position - 1)
	end
	self:UpdateCurrentDiceView()
	self:UpdateLapViews()
	self:UpdateDiceViews()
end

--- @return DiceSlotView
function UIEventEasterEggDiceLayout:UpdateCurrentDiceView()
	if self.position <= self.diceList:Count() then
		local view = self.diceList:Get(self.position)
		local check = self:IsBigDice(self.position)
		self:SetEnableArrow(check, true)
		self:DoWisecedaAnim(self.position,view.config.transform.position)
		self:SetEnableFrame(view.config.transform.position, check, true)
		return view
	end
	return nil
end

function UIEventEasterEggDiceLayout:UpdateRequireView()
	if self.requireList == nil then
		self.requireList = self.eventConfig:GetRollRequireConfig()
	end
--[[	self.layoutConfig.normalRequireText.text = self.requireList:Get(1).number
	self.layoutConfig.superRequireText.text = 1]]
end

function UIEventEasterEggDiceLayout:StartAnimRollDice()
	self.bg.gameObject:SetActive(true)

	self.bg.color = U_Color(0, 0, 0, 0)
	self.bg:DOColor(U_Color(0, 0, 0, 0.75), 1)

	if PlayerSettingData.isSkipDiceAnim == false then
		zg.audioMgr:PlaySfxUi(SfxUiType.DICE_ROLL)
		self.rollAnim.gameObject:SetActive(true)
		self.rollAnim.AnimationState:SetAnimation(0, "roll", true)
	end
end

function UIEventEasterEggDiceLayout:OnClickRoll()
	local onReceived = function(result)
		--- @type DiceRewardResult
		local diceResult

		local onBufferReading = function(buffer)
			diceResult = DiceRewardResult(buffer)
		end

		local onSuccess = function()
			if diceResult ~= nil then
				self.touch = TouchUtils.Spawn("DiceRollAnimation")
				self.prevPosition = self.position
				self.position = diceResult.newPosition + 1
				self.diceValue = diceResult.diceValue
				self.eventDiceData.position = diceResult.newPosition
				Coroutine.start(function()
					if PlayerSettingData.isSkipDiceAnim ~= true then
						coroutine.waitforseconds(2)
					end
					---@type UnityEngine_UI_Image
					local rollImage = self.layoutConfig.rollImage
					rollImage.sprite = ResourceLoadUtils.LoadIconRollDice(self.diceValue)
					rollImage.color = U_Color(1, 1, 1, 1)
					self.rollAnim.gameObject:SetActive(false)
					rollImage.gameObject:SetActive(true)
					zg.audioMgr:PlaySfxUi(SfxUiType.DICE_END)
					coroutine.waitforseconds(0.5)
					self.bg:DOColor(U_Color(0, 0, 0, 0), 1)
					coroutine.waitforseconds(0.5)
					rollImage:DOColor(U_Color(1, 1, 1, 0), 0.5)
					coroutine.waitforseconds(0.5)
					rollImage.gameObject:SetActive(false)
					self.bg.gameObject:SetActive(false)

					self:DiceRollAnimation()
					InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_EASTER_DICE, 1)
				end)
			end
		end
		NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
	end
	local canRoll = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money,MoneyType.EVENT_EASTER_DICE,1))--self.requireList:Get(self.rollNum + 1).number))
	if canRoll then
		self:StartAnimRollDice()
		NetworkUtils.Request(OpCode.EVENT_EASTER_DICE, nil, onReceived)
	end
end

function UIEventEasterEggDiceLayout:ShowSelectDicePopup()
	local canRoll = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money,MoneyType.EVENT_EASTER_SUPER_DICE,1))
	if canRoll then
		PopupMgr.ShowPopup(UIPopupName.UIEventEasterEggSelectDice,function(index)
			self:OnClickSuperRoll(index)
		end )
	end
end

function UIEventEasterEggDiceLayout:OnClickSuperRoll(value)
	local onReceived = function(result)
		--- @type DiceRewardResult
		local diceResult
		local onBufferReading = function(buffer)
			diceResult = DiceRewardResult(buffer)
		end

		local onSuccess = function()
			if diceResult ~= nil then
				self.touch = TouchUtils.Spawn("DiceRollAnimation")
				self.prevPosition = self.position
				self.position = diceResult.newPosition + 1
				self.diceValue = diceResult.diceValue
				self.eventDiceData.position = diceResult.newPosition
				self.posList:Add(self.eventDiceData.position)
				Coroutine.start(function()
					self:DiceRollAnimation()
					InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_EASTER_SUPER_DICE, 1)
				end)
			end
		end
		NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
	end
	local canRoll = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money,MoneyType.EVENT_EASTER_SUPER_DICE,1))--self.requireList:Get(self.rollNum + 1).number))
	if canRoll then
		NetworkUtils.Request(OpCode.EVENT_EASTER_SUPER_DICE, UnknownOutBound.CreateInstance(PutMethod.Int,value), onReceived)
	end
end

function UIEventEasterEggDiceLayout:DiceRollAnimation()
	Coroutine.start(function()
		---@type DiceSlotView
		local diceView = nil
		if self.position > self.diceList:Count() then
			self.position = self.diceList:Count()
		end

		local temp = self.prevPosition + self.diceValue
		if temp > self.diceList:Count() then
			self.lapCompleted = self.lapCompleted + 1
			self.eventDiceData.lapCompleted = self.eventDiceData.lapCompleted + 1
			for i = self.prevPosition + 1, self.diceList:Count() do
				diceView = self.diceList:Get(i)
				local check = self:IsBigDice(i)
				self:SetEnableArrow(check, false)
				zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
				self:DoWisecedaAnim(i,diceView.config.transform.position)
				--coroutine.waitforseconds((TIME_TO_ROLL - 0.6))
				self:SetEnableFrame(diceView.config.transform.position, check, true)
				coroutine.waitforseconds(TIME_TO_ROLL)
				self:SetEnableFrame(diceView.config.transform.position, check, false)
			end
			local check_2 = self:IsBigDice(1)
			diceView = self.diceList:Get(1)
			self:SetEnableArrow(check_2, false)
			zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
			self:DoWisecedaAnim(1,diceView.config.transform.position)
			--coroutine.waitforseconds((TIME_TO_ROLL - 0.6))
			self:SetEnableFrame(diceView.config.transform.position, check_2, true)
			coroutine.waitforseconds(TIME_TO_ROLL)
			if diceView ~= nil then
				self:SetEnableArrow(check_2, true)
				self.prevPosition = self.position
				if self.position ~= 1 then
					diceView:ShowRewardInbound()
				end
			end
			self:UpdateLapViews()
			coroutine.waitforseconds(TIME_TO_ROLL + 0.5)
			self:ResetSelect(false)
			--diceView:SetView(true)
			coroutine.waitforseconds(0.25)
			local count = 2
			local _diceView = nil
			for j = 1, count do
				for i = 1, self.diceList:Count() do
					--- @type DiceSlotView
					_diceView = self.diceList:Get(i)
					zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
					_diceView:SetEnableFrame(true)
					coroutine.waitforseconds(0.035)
					_diceView:SetEnableFrame(false)
				end
			end
			count = 3
			for j = 1, count do
				zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
				for i = 1, self.diceList:Count() do
					--- @type DiceSlotView
					_diceView = self.diceList:Get(i)
					_diceView:SetEnableFrame(true)
				end
				coroutine.waitforseconds(0.6)
			end

			coroutine.waitforseconds(0.2)
			zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
			self:ResetDiceViews(true)
			coroutine.waitforseconds(0.2)
			local view = self:UpdateCurrentDiceView()
			view:SetView(true)
			view:ShowRewardInbound()

			self.posList:Clear()
			self.posList:Add(self.eventDiceData.position)
		else
			print("Not overlap")
			---@type DiceSlotView
			local check = false
			for i = self.prevPosition + 1, self.position do
				check = self:IsBigDice(i)
				diceView = self.diceList:Get(i)
				self:SetEnableArrow(check, false)
				zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
				self:DoWisecedaAnim(i,diceView.config.transform.position)
				--coroutine.waitforseconds((TIME_TO_ROLL - 0.6))
				self:SetEnableFrame(diceView.config.transform.position, check, true)
				coroutine.waitforseconds(TIME_TO_ROLL)
				self:SetEnableFrame(diceView.config.transform.position, check, false)
			end
			if diceView ~= nil then
				zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
				self:SetEnableArrow(check, true)
				self:DoWisecedaAnim(diceView.index,diceView.config.transform.position)
				self:SetEnableFrame(diceView.config.transform.position, check, true)
				self.prevPosition = self.position
				diceView:ShowRewardInbound()
				diceView:SetView(true)
			end
		end
		self.touch:Enable()
	end)
end

function UIEventEasterEggDiceLayout:ShowExchangeReward()
	PopupMgr.ShowPopup(UIPopupName.UIEventEasterEggExchangeReward, { listExchangeReward = self.eventModel.listExchangeReward, callbackExchange = function()
		self:CheckNotificationExchangeReward()
		self.view:UpdateNotificationByTab(self.easterEggTab)
	end })
end


function UIEventEasterEggDiceLayout:IsBigDice(index)
	local indexList = { 1, 7, 11, 17 }
	for i, v in ipairs(indexList) do
		if v == index then
			return true
		end
	end
	return false
end
function UIEventEasterEggDiceLayout:SetEnableArrow(check, isEnable)
	if check then
		self.arrowTransform_1.gameObject:SetActive(isEnable)
		self.arrowTransform_2.gameObject:SetActive(not isEnable)
	else
		self.arrowTransform_1.gameObject:SetActive(not isEnable)
		self.arrowTransform_2.gameObject:SetActive(isEnable)
	end
end
function UIEventEasterEggDiceLayout:SetEnableFrame(position, check, isEnable)
	if check then
		self.layoutConfig.select1.gameObject:SetActive(isEnable)
		self.layoutConfig.select2.gameObject:SetActive(not isEnable)
		self.layoutConfig.select1.position = position
	else
		self.layoutConfig.select1.gameObject:SetActive(not isEnable)
		self.layoutConfig.select2.gameObject:SetActive(isEnable)
		self.layoutConfig.select2.position = position
	end
end

function UIEventEasterEggDiceLayout:DoWisecedaAnim(currentPos ,position)
	if currentPos > 7 and currentPos <= 17 then
		self.layoutConfig.groot.transform.localEulerAngles = U_Vector3(0, 180, 0)
	else
		self.layoutConfig.groot.transform.localEulerAngles = U_Vector3(0,0,0)
	end
	Coroutine.start(function()
		if position ~= self.grootLastPos then
			self.grootLastPos = position
			self.layoutConfig.groot.AnimationState:SetAnimation(0, "move", false)
		end
		coroutine.waitforseconds(0.2)
		DOTweenUtils.DOMove(self.layoutConfig.groot.transform, position, TIME_TO_ROLL - 0.6, U_Ease.Linear)
	end)

end

function UIEventEasterEggDiceLayout:ResetSelect(isEnable)
	self.layoutConfig.select1.gameObject:SetActive(isEnable)
	self.layoutConfig.select2.gameObject:SetActive(isEnable)
end
function UIEventEasterEggDiceLayout:OnHide()
	self:ResetDiceViews()
	self:ResetLapViews()
	self:UpdateCurrentDiceView()
	if self.normalDiceBarView ~= nil then
		self.normalDiceBarView:ReturnPool()
		self.normalDiceBarView = nil
	end
	if self.superDiceBarView ~= nil then
		self.superDiceBarView:ReturnPool()
		self.superDiceBarView = nil
	end
	UIEventEasterEggLayout.OnHide(self)
end

