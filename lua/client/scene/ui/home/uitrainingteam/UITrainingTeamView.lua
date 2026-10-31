require "lua.client.scene.ui.home.uiTrainingTeam.UISlotTrainingTeamView"
---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiTrainingTeam.UITrainingTeamConfig"
require "lua.client.core.network.campaign.BindHeroTrainOutBound"

--- @class UITrainingTeamView : UIBaseView
UITrainingTeamView = Class(UITrainingTeamView, UIBaseView)

--- @return void
--- @param model UITrainingTeamModel
function UITrainingTeamView:Ctor(model)
	---@type UISlotTrainingTeamView
	self.slotTraining = nil
	---@type number
	self.maxTimeTrainingSlot = nil
	---@type number
	self.timeTrainingSlot = nil
	---@type HeroListView
	self.heroList = nil

	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UITrainingTeamModel
	self.model = model
end

--- @return void
function UITrainingTeamView:OnReadyCreate()
	---@type UITrainingTeamConfig
	---@type UITrainingTeamConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.bgClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonSave.onClick:AddListener(function ()
		self:OnClickSave()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
	self.config.buttonClaim.onClick:AddListener(function ()
		self:OnClickClaim()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
	---@type List --<UISlotTrainingTeamView>
	self.listSlotTraining = List()
	for i = 1, 8 do
		local slotTrain = UISlotTrainingTeamView(self.config.slot:GetChild(i - 1), i)
		self.listSlotTraining:Add(slotTrain)
		slotTrain.callbackClickSlot = function()
			self:OnClickSlot(slotTrain)
		end
	end
end

--- @return void
function UITrainingTeamView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("training_hero")
	self.config.localizeSelectHero.text = LanguageUtils.LocalizeCommon("select_heroes")
	self.config.localizeBattle.text = LanguageUtils.LocalizeCommon("training_hero")
	self.config.localizeClaim.text = LanguageUtils.LocalizeCommon("claim")
	self.config.localizeCompleteTraining.text = LanguageUtils.LocalizeCommon("to_complete_training")
	self.config.localizeBlockCondition.text = LanguageUtils.LocalizeCommon("unblock_training_condition")
	self.config.textTapToClose.gameObject:SetActive(false)
	self.config.localizeSort.text = LanguageUtils.LocalizeCommon("sort")
end

--- @return void
function UITrainingTeamView:CreateHeroList()
	if self.heroList == nil then
		self.heroList = HeroListView(self.config.prefabHeroList)

		--- @return void
		--- @param heroIndex number
		--- @param buttonHero HeroIconView
		--- @param heroResource HeroResource
		self.onUpdateIconHero = function(heroIndex, buttonHero, heroResource)
			if self.model.heroResourceSelect:IsContainValue(heroResource) then
				buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
			else
				buttonHero:ActiveMaskSelect(false)
			end
		end

		--- @return void
		--- @param heroIndex number
		--- @param buttonHero HeroIconView
		--- @param heroResource HeroResource
		self.buttonListener = function(heroIndex, buttonHero, heroResource)
			if self.campaignData.trainingSlotExp:Count() == 0 then
				if self:CheckTrainingHero(heroResource) then
					buttonHero:ActiveMaskSelect(false)
					self:RemoveHero(heroResource)
				else
					if self:AddHero(heroResource) then
						buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
					end
				end
			end
		end

		--- @return boolean
		--- @param heroIndex number
		---@param heroResource HeroResource
		local filterConditionAnd = function (heroIndex, heroResource)
			return heroResource.heroStar < 4 and not self.raiseHero:IsInRaisedSlot(heroResource.inventoryId)
		end

		self.heroList:Init(self.buttonListener, nil, filterConditionAnd, nil, nil, self.onUpdateIconHero, self.onUpdateIconHero)
	end
	---@type HeroList
	local heroList = InventoryUtils.Get(ResourceType.Hero)
	self.heroList:SetData(heroList)
end

--- @return boolean
--- @param heroResource HeroResource
function UITrainingTeamView:CheckTrainingHero(heroResource)
	---@param v UISlotTrainingTeamView
	for _, v in ipairs(self.listSlotTraining:GetItems()) do
		if v.heroResource == heroResource then
			return true
		end
	end
	return false
end

--- @return boolean
--- @param heroResource HeroResource
function UITrainingTeamView:AddHero(heroResource)
	local add = false
	---@param v UISlotTrainingTeamView
	for i, v in ipairs(self.listSlotTraining:GetItems()) do
		if i <= self.model.slotUnlock then
			if v.heroResource == nil then
				v:SetHeroResource(heroResource)
				self.model.heroResourceSelect:Add(heroResource)
				add = true
				break
			end
		else
			break
		end
	end
	if add == false then
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("noti_full_hero"))
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
		return false
	else
		self:UpdateTimeTrainingFullSlot()
		return true
	end
end

--- @return void
--- @param heroResource HeroResource
function UITrainingTeamView:RemoveHero(heroResource)
	---@param v UISlotTrainingTeamView
	for i, v in ipairs(self.listSlotTraining:GetItems()) do
		if v.heroResource == heroResource then
			v:ReturnPool()
			self.model.heroResourceSelect:RemoveByReference(heroResource)
			self:UpdateTimeTrainingFullSlot()
		end
	end
end

--- @return void
function UITrainingTeamView:FillHeroTrain()
	local trainCount = self.campaignData.trainingSlotExp:Count()
	---@param v UISlotTrainingTeamView
	for i, v in ipairs(self.listSlotTraining:GetItems()) do
		if i > self.model.slotUnlock then
			v:SetLock(true)
		else
			v:SetLock(false)
			if i <= trainCount then
				---@type HeroResource
				local heroResource = InventoryUtils.GetHeroResourceByInventoryId(self.campaignData.trainingSlotExp:Get(i))
				v:SetHeroResource(heroResource)
				--v.heroIconView:ActiveEffectHeroTraining(true)
				self.model.heroResourceSelect:Add(heroResource)
			end
		end
	end
end

--- @return void
function UITrainingTeamView:UpdateProgress()
	local expTrainCurrentStageConfig = ResourceMgr.GetIdleRewardConfig():GetExpTrain(self.campaignData.stageIdle)
	local totalExp = self.campaignData:GetExpTraining()

	local slotProgress
    for slotTrain, heroInventoryId in ipairs(self.campaignData.trainingSlotExp:GetItems()) do
		---@type HeroResource
		local heroResource = InventoryUtils.GetHeroResourceByInventoryId(heroInventoryId)
		---@type HeroLevelCapConfig
		local levelCap = ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(heroResource.heroStar)
		---@type UISlotTrainingTeamView
		local slotTraining = self.listSlotTraining:Get(slotTrain)

		if heroResource.heroLevel < levelCap.levelCap then
			for i = heroResource.heroLevel + 1, levelCap.levelCap do
				---@type HeroLevelDataConfig
				local levelData = ResourceMgr.GetHeroMenuConfig():GetHeroLevelDataDictionary(i)
				if levelData.exp <= totalExp then
					totalExp = totalExp - levelData.exp
				else
					slotProgress = slotTrain
					slotTraining:SetLevel(i - heroResource.heroLevel - 1)

					self.maxTimeTrainingSlot = math.ceil(levelData.exp / expTrainCurrentStageConfig) + 1
					self.timeTrainingSlot = math.ceil((levelData.exp - totalExp) / expTrainCurrentStageConfig) + 1

					slotTraining:SetProgress(self.maxTimeTrainingSlot, self.timeTrainingSlot)
					slotTraining:ActiveEffectTraining(true)
					self.slotTraining = slotTraining
					self:StartTimeIdle()
					break
				end
			end
		end

		if slotProgress == nil then
			slotTraining:SetLevel(levelCap.levelCap - heroResource.heroLevel)
			slotTraining:SetProgress(1, 0)
			slotTraining:ActiveEffectTraining(false)
			self.config.textTimer.text = TimeUtils.SecondsToClock(0)
		else
			break
		end
	end
end

--- @return void
function UITrainingTeamView:UpdateTimeTrainingFullSlot()
	local expTrainCurrentStageConfig = ResourceMgr.GetIdleRewardConfig():GetExpTrain(self.campaignData.stageIdle)
	local time = math.floor(self:GetExpFullSlot() / expTrainCurrentStageConfig)
	time = math.max(time, 0)
	self.config.textTimer.text = TimeUtils.SecondsToClock(time)
end

--- @return void
function UITrainingTeamView:GetExpFullSlot()
	local exp = 0
	---@param v UISlotTrainingTeamView
	for _, v in ipairs(self.listSlotTraining:GetItems()) do
		if v.heroResource ~= nil then
			exp = exp + CampaignData.GetExpTrainingByHeroResource(v.heroResource)
		end
	end
	return exp
end

function UITrainingTeamView:SetTimeFinish()
	---@type number
	self.timeFullExp = self.campaignData:GetTimeFinishTraining()
end

--- @return void
function UITrainingTeamView:StartTimeIdle()
	if self.updateTime == nil then
		--- @param isSetTime boolean
		self.updateTime = function(isSetTime)
			if isSetTime == true then
				self:SetTimeFinish()
				self:UpdateProgress()
			end
			if self.slotTraining ~= nil then
				if self.timeTrainingSlot > 0 then
					self.timeTrainingSlot = self.timeTrainingSlot - 1
					self.timeFullExp = math.max(self.timeFullExp - 1, 0)
					self.config.textTimer.text = TimeUtils.SecondsToClock(self.timeFullExp)
					self.slotTraining:SetProgress(self.maxTimeTrainingSlot, self.timeTrainingSlot)
				else
					self:UpdateProgress()
				end
			elseif isSetTime == false then
				self:StopTimeIdle()
				self:UpdateProgress()
			end
		end
		zg.timeMgr:AddUpdateFunction(self.updateTime)
	end
end

--- @return void
function UITrainingTeamView:StopTimeIdle()
	if self.updateTime ~= nil then
		zg.timeMgr:RemoveUpdateFunction(self.updateTime)
		self.updateTime = nil
	end
end

--- @return void
function UITrainingTeamView:UpdateUI()
	local isTraining = self.campaignData.trainingSlotExp:Count() > 0
	self.config.coverBlock:SetActive(isTraining)
	self.config.buttonSave.gameObject:SetActive(not isTraining)
	self.config.buttonClaim.gameObject:SetActive(isTraining)

	if self.campaignData.trainingSlotExp:Count() > 0 then
		self:UpdateProgress()
	else
		---@param v UISlotTrainingTeamView
		for _, v in ipairs(self.listSlotTraining:GetItems()) do
			v:SetActiveProgress(false)
		end
	end
end

--- @return void
function UITrainingTeamView:OnReadyShow()
	self.raiseHero = zg.playerData:GetRaiseLevelHero()
	self.campaignData = zg.playerData:GetCampaignData()
	self.config.textTimer.text = TimeUtils.SecondsToClock(0)
	self.model:InitData()
	self:FillHeroTrain()
	self:CreateHeroList()
	self:UpdateUI()
end

--- @return void
function UITrainingTeamView:OnFinishAnimation()
	UIBaseView.OnFinishAnimation(self)
	self:CheckAndInitTutorial()
end

--- @return void
function UITrainingTeamView:Hide()
	UIBaseView.Hide(self)
	if self.heroList ~= nil then
		self.heroList:ReturnPool()
	end
	---@param v UISlotTrainingTeamView
	for _, v in pairs(self.listSlotTraining:GetItems()) do
		v:ReturnPool()
	end
	self.model.heroResourceSelect:Clear()
	self:StopTimeIdle()

	self:RemoveListenerTutorial()
end

--- @return void
function UITrainingTeamView:OnClickSave()
	---@type BindHeroTrainOutBound
	local bindHeroTrainOutBound = BindHeroTrainOutBound()
	---@param v UISlotTrainingTeamView
	for i, v in ipairs(self.listSlotTraining:GetItems()) do
		if v.heroResource ~= nil then
			bindHeroTrainOutBound.listHero:Add(v.heroResource.inventoryId)
		end
	end

	local callback = function(result)
		local onSuccess = function()
			XDebug.Log("CAMPAIGN_TRAINING_HERO_BIND success")
			self.campaignData.trainingSlotExp:Clear()
			self.campaignData.trainingSlotExp = bindHeroTrainOutBound.listHero
			---@param v UISlotTrainingTeamView
			for i, v in ipairs(self.listSlotTraining:GetItems()) do
				if i > self.campaignData.trainingSlotExp:Count() then
					v:ReturnPool()
				else
					local heroResource = InventoryUtils.GetHeroResourceByInventoryId(self.campaignData.trainingSlotExp:Get(i))
					if v.heroResource ~= heroResource then
						v:SetHeroResource(heroResource)
					end
					--v.heroIconView:ActiveEffectHeroTraining(true)
				end
			end
			self.campaignData.idleTraining.lastTimeIdle = zg.timeMgr:GetServerTime()
			self.campaignData.idleTraining.totalTime:Clear()
			self:UpdateUI()
		end

		local onFailed = function(logicCode)
			SmartPoolUtils.LogicCodeNotification(logicCode)
		end
		NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
	end
	NetworkUtils.Request(OpCode.CAMPAIGN_TRAINING_HERO_BIND, bindHeroTrainOutBound, callback)
end

--- @return void
function UITrainingTeamView:OnClickClaim()
	local clientExp = self.campaignData:GetExpTraining()
	local callback = function(result)
		local exp = 0
		--- @param buffer UnifiedNetwork_ByteBuf
		local onBufferReading = function(buffer)
			exp = buffer:GetLong()
		end

		local onSuccess = function()
			if clientExp > exp then
				XDebug.Warning(string.format("CAMPAIGN_TRAINING_EXP_CLAIM success client %s, server %s", clientExp , exp))
			end
			self:ReceiveExp(exp)
			for slotTrain, heroInventoryId in ipairs(self.campaignData.trainingSlotExp:GetItems()) do
				---@type HeroResource
				local heroResource = InventoryUtils.GetHeroResourceByInventoryId(heroInventoryId)
				self:RemoveHero(heroResource)
			end
			self.heroList.uiScroll:RefreshCells()
			self.campaignData.trainingSlotExp:Clear()
			self:StopTimeIdle()
			self:UpdateUI()
		end

		local onFailed = function(logicCode)
			SmartPoolUtils.LogicCodeNotification(logicCode)
		end
		NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
		--TouchUtils.Enable()
	end
	NetworkUtils.Request(OpCode.CAMPAIGN_TRAINING_EXP_CLAIM, nil, callback)
	--TouchUtils.Disable()
end

--- @return void
---@param slotTrain UISlotTrainingTeamView
function UITrainingTeamView:OnClickSlot(slotTrain)
	if slotTrain.slot <= self.model.slotUnlock then
		if self.campaignData.trainingSlotExp:Count() == 0 then
			if slotTrain.heroResource ~= nil then
				self:RemoveHero(slotTrain.heroResource)
				self.heroList.uiScroll:RefreshCells()
			end
		else

		end
	else
		local level = nil
		---@type CampaignConfig
		local campaignConfig = ResourceMgr.GetCampaignDataConfig().campaignConfig
		local bonusVipSlot = ResourceMgr.GetVipConfig():GetCurrentBenefits().campaignBonusAutoTrainSlot or 0
		for i, v in pairs(campaignConfig.trainSlotIncrementLevel:GetItems()) do
			if slotTrain.slot == campaignConfig.autoTrainSlot + v + bonusVipSlot then
				level = i
			end
		end
		local vipUnlock = ResourceMgr.GetVipConfig():RequireLevelUnlockNextBonusAutoTrainSlot()
		SmartPoolUtils.NotificationRequireVipOrLevelAndStage(vipUnlock, level)
	end
end

--- @return void
---@param totalExp number
function UITrainingTeamView:ReceiveExp(totalExp)
	local canSortHero = false
	for slotTrain, heroInventoryId in ipairs(self.campaignData.trainingSlotExp:GetItems()) do
		---@type HeroResource
		local heroResource = InventoryUtils.GetHeroResourceByInventoryId(heroInventoryId)
		---@type HeroLevelCapConfig
		local levelCap = ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(heroResource.heroStar)
		---@type UISlotTrainingTeamView
		local slotTraining = self.listSlotTraining:Get(slotTrain)

		local addLevel = 0
		local stop = false
		if heroResource.heroLevel < levelCap.levelCap then
			for i = heroResource.heroLevel + 1, levelCap.levelCap do
				---@type HeroLevelDataConfig
				local levelData = ResourceMgr.GetHeroMenuConfig():GetHeroLevelDataDictionary(i)
				if levelData.exp <= totalExp then
					totalExp = totalExp - levelData.exp
					addLevel = addLevel + 1
				else
					stop = true
					break
				end
			end
		end
		if addLevel > 0 then
			heroResource.heroLevel = heroResource.heroLevel + addLevel
			slotTraining:SetHeroResource(heroResource)
			canSortHero = true
		end
		if stop == true then
			break
		end
	end
	---@type HeroList
	local heroList = InventoryUtils.Get(ResourceType.Hero)
	if canSortHero == true then
		heroList:SortHeroDataBase()
	end
	self.heroList:SetData(heroList)
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UITrainingTeamView:ShowTutorial(tutorial, step)
	if step == TutorialStep.SELECT_HERO_TRAINING_1 then
		tutorial:ViewFocusCurrentTutorial(self.heroList.uiScroll.scroll.content:GetChild(0):
		GetComponent(ComponentName.UnityEngine_UI_Button),0.5)
	elseif step == TutorialStep.SELECT_HERO_TRAINING_2 then
		tutorial:ViewFocusCurrentTutorial(self.heroList.uiScroll.scroll.content:GetChild(1):
		GetComponent(ComponentName.UnityEngine_UI_Button), 0.5)
	elseif step == TutorialStep.SAVE_TRAINING then
		tutorial:ViewFocusCurrentTutorial(self.config.buttonSave, U_Vector2(500, 150), nil, nil, TutorialHandType.CLICK)
	elseif step == TutorialStep.CLOSE_AUTO_TEAM then
		tutorial:ViewFocusCurrentTutorial(self.config.buttonClose, 0.4)
	elseif step == TutorialStep.TRAINING_INFO then
		tutorial:ViewFocusCurrentTutorial(nil, 1, self.config.slot:GetChild(0).position)
	end
end