require "lua.client.hero.ClientHero40009.ClientHero40009BaseAttack"
require "lua.client.battleShow.ClientEffectConfig.FXSlash05pConfig"
local ANIM_CONFIG = "csv/client/anim_frame_config/60005.csv"

--- @class ClientHero60005BaseAttack : ClientHero40009BaseAttack
ClientHero60005BaseAttack = Class(ClientHero60005BaseAttack, ClientHero40009BaseAttack)

--- @param clientHero ClientHero
function ClientHero60005BaseAttack:Ctor(clientHero)
	--- @type Dictionary
	self.dictionaryTriggerFrame = Dictionary()
	self.listAnimationLength = List()
	self.listAnimationLength:Add(42)
	self.listAnimationLength:Add(66)
	self.listAnimationLength:Add(55)
	self.listAnimationLength:Add(84)
	self.listAnimationLength:Add(95)
	self.lastAnimIndex = 1
	--- @type List
	self.oldTriggerFrame = List()
	self:GetConfigAnimLength()
	ClientHero40009BaseAttack.Ctor(self, clientHero, true)
end

function ClientHero60005BaseAttack:SetFx(fx)
	--- @type ClientEffect
	self.weaponFx = ClientEffect()
	self.weaponFx.gameObject = fx
	local luaConfigFile = ResourceMgr.GetEffectLuaConfig("FX_Slash_05p")
	self.weaponFx:InitRef(AssetType.GeneralBattleEffect, "FX_Slash_05p",
			GeneralEffectPoolType.ClientEffect, luaConfigFile)
	self.weaponFx.isInited = true
	self:SetEffectConfig()
	self.weaponFx.gameObject:SetActive(true)
	self.weaponFx:OnTargetLayerChanged()
end

function ClientHero60005BaseAttack:DeliverCtor()
	BaseRangeAttack.DeliverCtor(self)
	self.skillTargetBone = self.clientHero.components:FindChildByPath("Model/SkeletonUtility-Root/root/skill_target")
end

function ClientHero60005BaseAttack:SetEffectConfig()
	if self.weaponFx.config.isSyncLayerToTarget == true
			and self.weaponFx.config.listEffectVisual ~= nil then
		self.weaponFx.currentHeroAnchor = self.clientHero
		self.weaponFx:SyncLayerToTarget(self.weaponFx.currentHeroAnchor)
		self.weaponFx.currentHeroAnchor.animation:AddLayerChangedListener(self.weaponFx.targetLayerChangedListener)
	end
	self.weaponFx:Play()
end

--- @param actionResults List<BaseActionResult>
function ClientHero60005BaseAttack:CastOnTarget(actionResults)
	ClientHero40009BaseAttack.CastOnTarget(self, actionResults)
	if self.clientHero.heroModelType == HeroModelType.Full then
		local target = self.listTargetHero:Get(1)
		local clientTarget = self.clientBattleShowController:GetClientHeroByBaseHero(target)
		self.skillTargetBone.position = clientTarget.components:GetAnchorPosition(ClientConfigUtils.BODY_ANCHOR)
	end
end

function ClientHero60005BaseAttack:UpdateTriggerDamage(animName)
	--- @type List
	local listAnim = self.dictionaryTriggerFrame:Get(animName)
	local count = listAnim:Count()
	for i = 1, count do
		local frame = listAnim:Get(i)
		self:UpdateFrameAction(frame, function()
			self:TriggerDamage()
		end)
	end
end

--- @param frame number
--- @param action function
function ClientHero60005BaseAttack:UpdateFrameAction(frame, action)
	if frame < 0 then
		return
	end
	self.listFrameAction = self:UpdateSerializeListActionByFrame(frame, action, self.listFrameAction)
end

--- @param frame number
--- @param action function
--- @param currentList List
function ClientHero60005BaseAttack:UpdateSerializeListActionByFrame(frame, action, currentList)
	self.oldTriggerFrame:Add(frame)
	--print("Add" ,frame )
	return self:CreateSerializeListActionByFrame(frame, action, currentList)
end

--- @return  List
function ClientHero60005BaseAttack:ClearOldAction(currentList)
	--print("ClearOldAction")
	for i = currentList:Count(), 1, -1 do
		local frameAction = currentList:Get(i)
		if frameAction ~= nil then
			if self.oldTriggerFrame:IsContainValue(frameAction.frame) then
				--print(UIUtils.SetColorString(UIUtils.red_light, "remove : "..frameAction.frame))
				currentList:RemoveByIndex(i)
			end
		end
	end
	self.oldTriggerFrame:Clear()
	return currentList
end




function ClientHero60005BaseAttack:DoAnimation()
	if self.weaponFx == nil then
		self:DeliverCtor()
	end
	self.weaponFx.gameObject:SetActive(false)
	local totalTurn = self:GetBonusTurn()
	if totalTurn then
		local animName = self.animName .. "_" .. totalTurn
		local animLength = self.listAnimationLength:Get(totalTurn)
		self:ClearOldAction(self.listFrameAction)
		self:UpdateTriggerDamage(animName)
		self:UpdateFrameActionEvent(animLength, animLength + 20, -1, -1)
		self.clientHero:PlayAnimation(animName, false, self.clientHero.mainTrackIndex)
		self.clientHero:PlayAnimationEffectByFrame(animName)
		self:PlayFrameAction(self.listFrameAction)
	else
		self.clientHero:PlayAnimation(self.animName, false, self.clientHero.mainTrackIndex)
		self.clientHero:PlayAnimationEffectByFrame(self.animName)
		self:PlayFrameAction(self.listFrameAction)
	end
end

--- @param clientTurnDetail ClientTurnDetail
function ClientHero60005BaseAttack:SetClientTurnDetail(clientTurnDetail)
	self.currentTurnDetail = clientTurnDetail
	local clientActionType = clientTurnDetail.actionType
	self:GetListTargetFromActions(clientTurnDetail.actionList)
	local extraTurnInfo = self.currentTurnDetail.extraTurnInfo
	if clientActionType == ClientActionType.BASIC_ATTACK then
		self.allowTrigger = true
		self:CastOnTarget(clientTurnDetail.actionList)
	elseif clientActionType == ClientActionType.BONUS_ATTACK then
		self.allowTrigger = extraTurnInfo ~= nil
	end
	if extraTurnInfo ~= nil then
		self.bonusTurnNum = extraTurnInfo.numberBonusTurn
	end
end

function ClientHero60005BaseAttack:GetBonusTurn()
	local clientBattleShowController = self.clientBattleShowController
	if clientBattleShowController and self.clientBattleShowController.clientLogDetail then
		local turnDetailList = self.clientBattleShowController.clientLogDetail.turnDetailList
		local totalBosnusTurn = 1
		for i = self.clientBattleShowController.clientTurnNum + 1, turnDetailList:Count() do
			--- @type ClientTurnDetail
			local turn = turnDetailList:Get(i)
			if turn.actionType == ClientActionType.BONUS_ATTACK then
				totalBosnusTurn = totalBosnusTurn + 1
			else
				break
			end
		end
		return totalBosnusTurn
	else
		return nil
	end
end

--- @param frameAnimLength number
--- @param frameEndTurn number
--- @param frameActionResult number
--- @param frameEffect number
function ClientHero60005BaseAttack:SetFrameActionEvent(frameAnimLength, frameEndTurn, frameActionResult, frameEffect)
	self:UpdateFrameAction(frameAnimLength, function()
		self:OnEndAnimation()
	end)
	--self.oldTriggerFrame:Add(frameAnimLength)


	--if self.clientHero.heroModelType ~= HeroModelType.Full then
	self:UpdateFrameAction(70, function()
		self.weaponFx.gameObject:SetActive(true)
	end)
	--self.oldTriggerFrame:Add(70)

	--	return
	--end
	self:UpdateFrameAction(frameEndTurn, function()
		self:OnCompleteActionTurn()
	end)
	--self.oldTriggerFrame:Add(frameEndTurn)

	self:UpdateFrameAction(frameActionResult, function()
		if self.allowTrigger == true then
			self:OnTriggerActionResult()
		end
	end)
	--self.oldTriggerFrame:Add(frameActionResult)
	self:UpdateFrameAction(frameEffect, function()
		self:OnCastEffect()
	end)
	--self.oldTriggerFrame:Add(frameEffect)

	--self:DeliverSetFrameAction()
end

--- @param frameAnimLength number
--- @param frameEndTurn number
function ClientHero60005BaseAttack:UpdateFrameActionEvent(frameAnimLength, frameEndTurn, frameActionResult, frameEffect)
	self:UpdateFrameAction(frameAnimLength, function()
		self:OnEndAnimation()
		self.weaponFx.gameObject:SetActive(true)
	end)
	if self.clientHero.heroModelType ~= HeroModelType.Full then
		return
	end
	self:UpdateFrameAction(frameActionResult, function()
		if self.allowTrigger == true then
			self:OnTriggerActionResult()
		end
	end)
	self:UpdateFrameAction(frameEffect, function()
		self:OnCastEffect()
	end)
	self:UpdateFrameAction(frameEndTurn, function()
		self:OnCompleteActionTurn()
	end)
	--
	--self:UpdateFrameAction(frameEndTurn - 20, function()
	--	self.weaponFx.gameObject:SetActive(true)
	--end)

end




--- @return void
function ClientHero60005BaseAttack:GetConfigAnimLength()
	local parsedData = CsvReaderUtils.ReadAndParseLocalFile(ANIM_CONFIG)
	if parsedData == nil then
		XDebug.Error(string.format(" nil %s", ANIM_CONFIG))
		return
	end
	local listAnimationLength = List()
	for i = 1, #parsedData do
		if parsedData[i].anim_name ~= nil then
			listAnimationLength = List()
			self.dictionaryTriggerFrame:Add(parsedData[i].anim_name, listAnimationLength)
			listAnimationLength:Add(tonumber(parsedData[i].trigger_frame))
		else
			listAnimationLength:Add(tonumber(parsedData[i].trigger_frame))
		end
	end
end