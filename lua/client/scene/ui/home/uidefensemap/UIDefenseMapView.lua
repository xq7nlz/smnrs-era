require "lua.client.scene.ui.home.uiDefenseMode.LandSelect.LandSelectArea"

--- @class UIDefenseMapView : UIBaseView
UIDefenseMapView = Class(UIDefenseMapView, UIBaseView)

--- @return void
--- @param model UIDefenseMapModel
function UIDefenseMapView:Ctor(model)
	self.listRewardView = List()
	self.listIdleView = List()
	self.listStage = List()
	---@type LandSelectArea
	self.landSelectArea = nil
	UIBaseView.Ctor(self, model)
	--- @type UIDefenseMapModel
	self.model = model
end

--- @return void
function UIDefenseMapView:OnReadyCreate()
	---@type UIDefenseMapConfig
	self.config = UIBaseConfig(self.uiTransform)
	local selectLand = function (landId)
		self:OnSelectLand(landId)
		self.config.backGround.gameObject:SetActive(true)
	end
	local selectBubble = function(landId, key)
		self:OnClickClaimItem(landId, key)
	end
	self.landSelectArea = LandSelectArea(self.config.landSelect, selectLand, selectBubble)
	self.config.backButton.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonHelp.onClick:AddListener(function ()
		self:OnClickHelp()
	end)
	self.config.buttonHelp2.onClick:AddListener(function ()
		self:OnClickHelp()
	end)
	self.config.buttonJoin.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickJoin()
	end)
	self.config.buttonRecord.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickRecord()
	end)
	self.config.buttonClaimAll.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickClaimAll()
	end)
	for i = 1, self.config.stage.childCount do
		self.listStage:Add(UIBaseConfig(self.config.stage:GetChild(i - 1)))
	end
end

function UIDefenseMapView:InitLocalization()
	self.config.textJoin.text = LanguageUtils.LocalizeCommon("battle")
	self.config.textRecord.text = LanguageUtils.LocalizeCommon("record")
	self.config.textClaimAll.text = LanguageUtils.LocalizeCommon("claim_all")
	self.config.textInstantReward.text = LanguageUtils.LocalizeCommon("instant_reward")
	self.config.textIdle.text = LanguageUtils.LocalizeCommon("idle_reward")

	if self.landSelectArea then
		self.landSelectArea:InitLocalization()
	end
end

--- @param data {land, stage, wave, road, recordId, isPlayerRecord, listWaveBasicRecord}
function UIDefenseMapView:OnReadyShow(data)
	---@type DefenseModeInbound
	self.defenseModeInbound = zg.playerData:GetMethod(PlayerDataMethod.DEFENSE_MODE)
	if data == nil then
		---@type DefenseModeInbound
		self.landSelectArea:Show()
		self:StartCoroutineIdle()
	else
		self.landSelectArea:SetActive(true)
		local land = self.landSelectArea:GetLandWithId(data.land)
		land:OnClickLand()
	end
	self.landSelectArea:SetAllDefenseModeData(self.defenseModeInbound:GetIdleDataDictionary())
	self.config.buttonClaimAll.gameObject:SetActive(false)
	self.config.landInfo:SetActive(false)
end

--- @return void
function UIDefenseMapView:StartCoroutineIdle()
	self:StopCoroutineIdle()
	local timeRefresh = zg.timeMgr:GetServerTime()
	self.config.buttonClaimAll.gameObject:SetActive(self.defenseModeInbound:CanClaimAll(timeRefresh))
	self.updateTime = function(isSetTime)
		if isSetTime == false then
			timeRefresh = timeRefresh + 1
		end
		self.config.buttonClaimAll.gameObject:SetActive(self.defenseModeInbound:CanClaimAll(timeRefresh))
		self.landSelectArea:UpdateAllBubbleTimeAndResource()
	end
	zg.timeMgr:AddUpdateFunction(self.updateTime)
end

--- @return void
function UIDefenseMapView:StopCoroutineIdle()
	if self.updateTime ~= nil then
		zg.timeMgr:RemoveUpdateFunction(self.updateTime)
		self.updateTime = nil
	end
end

--- @return void
function UIDefenseMapView:OnClickHelp()
	zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	local info = LanguageUtils.LocalizeHelpInfo("defense_mode_info")
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

--- @return void
function UIDefenseMapView:BackToMap()
	self.config.landInfo.gameObject:SetActive(false)
	self.landSelectArea:OpenAllLands()
	local isRestrictArea = self.landSelectArea:IsRestrictArea()
	if isRestrictArea then
		self.landSelectArea:SetClampRight(true)
	end
	self.landSelectArea:EnableUpdateScroll()
	if not isRestrictArea then
		self.landSelectArea:SetClampRight(true)
	end
	self.config.backGround.gameObject:SetActive(false)
	self:StartCoroutineIdle()
end

--- @return void
function UIDefenseMapView:OnClickClaimAll()
	self.defenseModeInbound:ClaimAll(function ()
		self:StartCoroutineIdle()
	end)
end

--- @return void
function UIDefenseMapView:OnClickClaimItem(land, key)
	self.defenseModeInbound:ClaimItem(land, key,function ()
		self:StartCoroutineIdle()
	end)
end

--- @return void
function UIDefenseMapView:OnClickClaimLand(landId)
	self.defenseModeInbound:ClaimIdle(landId,function ()
		self.config.buttonClaimAll.gameObject:SetActive(false)
		self:StartCoroutineIdle()
	end)
end

--- @return void
function UIDefenseMapView:OnClickJoin()
	local data = {}
	data.gameMode = GameMode.DEFENSE_MODE
	data.callbackClose = function()
		PopupMgr.ShowAndHidePopup(self.model.uiName, nil, UIPopupName.UIFormationDefense)
	end
	data.land = self.land
	data.stage = self.nextStage
	data.callbackPlayBattle = function(uiFormationTeamData, callback)
		--- @param defenseChallengeResultInBound DefenseChallengeResultInBound
		local onChallengeSuccess = function(defenseChallengeResultInBound)
			zg.playerData.rewardList = RewardInBound.GetItemIconDataList(defenseChallengeResultInBound.listReward )
			if defenseChallengeResultInBound.isWin == true then
				PlayerDataRequest.Request(PlayerDataMethod.DEFENSE_MODE)
			end
			if callback ~= nil then
				callback()
			end
			zg.playerData:AddListRewardToInventory()
			zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
		end
		DefenseModeInbound.ChallengeDefense(BattleFormationOutBound(uiFormationTeamData), data.land, data.stage, onChallengeSuccess)
	end
	PopupMgr.ShowAndHidePopup(UIPopupName.UIFormationDefense, data, self.model.uiName)
end

--- @return void
function UIDefenseMapView:OnClickRecord()
	local data = {}
	data.land = self.land
	data.stage = self.nextStage
	data.isPlayerRecord = false
	PopupMgr.ShowPopup(UIPopupName.UIDefenseStageRecordList, data)
end

--- @return void
function UIDefenseMapView:OnSelectLand(landId)
	self.config.textLandName.text = LanguageUtils.LocalizeLand(landId)
	self.land = landId
	self:StopCoroutineIdle()
	self.config.landInfo:SetActive(true)
	self.config.buttonClaimAll.gameObject:SetActive(false)
	---@type LandConfig
	local landConfig = ResourceMgr.GetDefenseModeConfig():GetLandConfig(landId)
	---@type LandUnlockConfig
	local landUnlock = ResourceMgr.GetDefenseModeConfig():GetLandUnlockConfig(landId)
	self.config.textRegisterRule.text = LanguageUtils.LocalizeLandRule(landUnlock.restrictType)
	---@type LandCollectionData
	local landCollectionData = self.defenseModeInbound.landCollectionDataMap:Get(landId)
	local stage = nil
	if landCollectionData ~= nil and landCollectionData.stage > 0 then
		stage = landCollectionData.stage
	end
	local nextStage = 1
	local startIndex = 1
	self:ReturnPoolListIdle()
	self:ReturnPoolListReward()
	if stage ~= nil then
		nextStage = stage + 1
		local idleRewardConfig = landConfig:GetLandIdleRewardConfig(stage)
		local nextIdleRewardConfig = landConfig:GetLandIdleRewardConfig(nextStage)
		if nextIdleRewardConfig ~= nil then
			---@param next LandIdleRewardItemConfig
			for i, next in ipairs(nextIdleRewardConfig.listReward:GetItems()) do
				local reward = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.StageIdleRewardItemView, self.config.idleReward)
				local idle = nil
				---@param v LandIdleRewardItemConfig
				for i, v in ipairs(idleRewardConfig.listReward:GetItems()) do
					if v.rewardInBound.type == next.rewardInBound.type and v.rewardInBound.id == next.rewardInBound.id then
						idle = v
						break
					end
				end
				reward:SetData(idle, next)
				self.listIdleView:Add(reward)
			end
		else
			---@param idle LandIdleRewardItemConfig
			for i, idle in ipairs(idleRewardConfig.listReward:GetItems()) do
				local reward = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.StageIdleRewardItemView, self.config.idleReward)
				reward:SetData(idle, nil)
				self.listIdleView:Add(reward)
			end
		end

	else
		local nextIdleRewardConfig = landConfig:GetLandIdleRewardConfig(nextStage)
		---@param next LandIdleRewardItemConfig
		for i, next in ipairs(nextIdleRewardConfig.listReward:GetItems()) do
			local reward = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.StageIdleRewardItemView, self.config.idleReward)
			reward:SetData(nil, next)
			self.listIdleView:Add(reward)
		end
	end

	local instantRewardConfig = landConfig:GetLandStageConfig(nextStage)
	if instantRewardConfig ~= nil then
		---@param v RewardInBound
		for i, v in ipairs(instantRewardConfig.listReward:GetItems()) do
			---@type RootIconView
			local reward = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.iconInstantReward)
			reward:SetIconData(v:GetIconData())
			reward:RegisterShowInfo()
			self.listRewardView:Add(reward)
		end
	end
	self.config.textProgressValue.text = string.format("%s <color=#466e08>%s/%s</color>", LanguageUtils.LocalizeCommon("in_progress"), nextStage - 1, landConfig.dictLandStageConfig:Count())
	startIndex = MathUtils.Clamp(nextStage - 3, 1, landConfig.dictLandStageConfig:Count() - self.config.stage.childCount + 1)
	---@param v LandStageItemConfig
	for i, v in ipairs(self.listStage:GetItems()) do
		local current = i + startIndex - 1
		v.textStage.text = string.format("%s %s", LanguageUtils.LocalizeCommon("stage"), current)
		v.iconIdleSwordInCampaign:SetActive(current == nextStage)
		v.iconTick:SetActive(current < nextStage)
		v.iconLandStageCurrent:SetActive(current <= nextStage)
		if current < nextStage then
			v.button.gameObject:SetActive(false)
			v.button.onClick:RemoveAllListeners()
			v.button.onClick:AddListener(function ()
				self:OnClickPlayRecord(current)
			end)
		else
			v.button.gameObject:SetActive(false)
		end
	end
	self.config.bgLandStage.sizeDelta = U_Vector2(60 + 156 * math.min(nextStage - startIndex, self.config.stage.childCount - 1), self.config.bgLandStage.sizeDelta.y)
	self.nextStage = math.min(nextStage, landConfig.dictLandIdleRewardConfig:Count())
	self.config.buttonJoin.gameObject:SetActive(nextStage <= landConfig.dictLandStageConfig:Count())
end

--- @return void
function UIDefenseMapView:ReturnPoolListIdle()
	---@param v IconView
	for i, v in ipairs(self.listIdleView:GetItems()) do
		v:ReturnPool()
	end
	self.listIdleView:Clear()
end

--- @return void
function UIDefenseMapView:OnClickPlayRecord(stage)
	local data = {}
	data.land = self.land
	data.stage = stage
	data.isPlayerRecord = true
	PopupMgr.ShowPopup(UIPopupName.UIDefenseStageRecordList, data)
end

--- @return void
function UIDefenseMapView:ReturnPoolListReward()
	---@param v IconView
	for i, v in ipairs(self.listRewardView:GetItems()) do
		v:ReturnPool()
	end
	self.listRewardView:Clear()
end

--- @return void
function UIDefenseMapView:Hide()
	UIBaseView.Hide(self)
	self:ReturnPoolListIdle()
	self:ReturnPoolListReward()
	self:StopCoroutineIdle()
	self.landSelectArea:Hide()
	self.config.backGround.gameObject:SetActive(false)
end

--- @return void
function UIDefenseMapView:OnClickBackOrClose()
	if self.config.landInfo.activeSelf then
		zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
		self:BackToMap()
	else
		UIBaseView.OnClickBackOrClose(self)
		PopupMgr.ShowPopup(UIPopupName.UIMainArea)
	end
end