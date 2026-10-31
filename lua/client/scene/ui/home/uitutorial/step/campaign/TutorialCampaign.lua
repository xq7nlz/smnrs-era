--- @class TutorialCampaign : TutorialBase
TutorialCampaign = Class(TutorialCampaign, TutorialBase)

--- @return void
function TutorialCampaign:Ctor()
	TutorialBase.Ctor(self)

	---@type TutorialSingle
	self.clickCampaign = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.CAMPAIGN_CLICK):
	Focus(TutorialFocus.FOCUS_CLICK)                             :Delay(0.5):TrackingName("click_campaign"))

	---@type TutorialSingle
	self.npcClickCampaign = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.CAMPAIGN_CLICK):ShowNpc(true):
	Focus(TutorialFocus.FOCUS_CLICK)                                :TrackingName("click_campaign_npc1"):Delay(0.5):KeyLocalize("npc_continue"):Pivot(TutorialPivot.BOTTOM_RIGHT))

	---@type TutorialSingle
	self.clickCampaignNpc = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_continue_3"):Step(TutorialStep.CAMPAIGN_CLICK):
	Pivot(TutorialPivot.BOTTOM_LEFT)                                :TrackingName("click_campaign_npc2"):Focus(TutorialFocus.FOCUS_CLICK):Delay(0.5):ShowNpc(true))

	---@type TutorialSingle
	self.clickBattle = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.CAMPAIGN_BATTLE_CLICK):Delay(0.2):
	Focus(TutorialFocus.FOCUS_CLICK)                           :HideFocus(true):TrackingName("click_battle_map"))

	---@type TutorialSingle
	self.nextStage = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.NEXT_STAGE):
	Focus(TutorialFocus.FOCUS_CLICK)                         :Delay(1):TrackingName("click_next_stage"))

	-----@type TutorialSingle
	--self.npcNextStage = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.NEXT_STAGE):
	--Focus(TutorialFocus.FOCUS_CLICK)                            :Delay(1):KeyLocalize("npc_continue_4"):Pivot(TutorialPivot.TOP_LEFT))

	---@type TutorialSingle
	self.formationBattleClick = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.FORMATION_BATTLE_CLICK):
	Focus(TutorialFocus.FOCUS_CLICK)                                    :Delay(0.2):HideFocus(true):TrackingName("click_battle_formation"))

	---@type TutorialSingle
	self.formationBattleClickSave = TutorialSingle.Create(TutorialStepData()
			:Step(TutorialStep.FORMATION_BATTLE_CLICK)
			:Delay(0.2)
			:Focus(TutorialFocus.FOCUS_CLICK)
			:StepId(self:GetStepId())
			:HideFocus(true)
			:WaitOpCode(OpCode.CAMPAIGN_CHALLENGE)
			:TrackingName("click_battle_formation"))

	---@type TutorialSingle
	self.npcFormationBattleClick = TutorialSingle.Create(TutorialStepData()
			:Step(TutorialStep.FORMATION_BATTLE_CLICK)
			:KeyLocalize("npc_continue")
			:Pivot(TutorialPivot.BOTTOM_LEFT):Delay(0.2):HideFocus(true)
			:Focus(TutorialFocus.FOCUS_CLICK):TrackingName("click_battle_formation_npc"))

	---@type TutorialSingle
	self.npcFormationBattleClickSave = TutorialSingle.Create(TutorialStepData()
			:Step(TutorialStep.FORMATION_BATTLE_CLICK)
			:KeyLocalize("npc_continue")
			:Pivot(TutorialPivot.BOTTOM_LEFT)
			:Delay(0.5):HideFocus(true)
			:Focus(TutorialFocus.FOCUS_CLICK)
			:TrackingName("click_battle_formation_npc")
			:StepId(self
			:GetStepId()))

	---@type TutorialSingle
	self.closeBattle = TutorialSingle.Create(TutorialStepData()
			:Step(TutorialStep.BATTLE_CLOSE)
			:Focus(TutorialFocus.TAP_TO_CLICK)
			:Delay(0.2)
			:HideFocus(true)
			:TrackingName("battle_close"))

	---@type TutorialSingle
	self.backCampaign = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.BACK_CAMPAIGN):
	Focus(TutorialFocus.FOCUS_CLICK)                            :Delay(0.5):TrackingName("back_campaign"))

	---@type TutorialSingle
	self.backCampaignAuto = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.BACK_CAMPAIGN):
	Focus(TutorialFocus.AUTO_NEXT)                                  :Delay(0.2):TrackingName("back_campaign_auto"))

	self.npcClickCampaign.tutorialStepData:TrackingID(1)
	self.clickBattle.tutorialStepData:TrackingID(2)

end

--- @return TutorialNode
function TutorialCampaign:TutorialGoToFormation()
	return TutorialLine.Create(self.clickCampaign,
			self.clickBattle
	)
end

--- @return TutorialNode
function TutorialCampaign:TutorialGoToFormationNpc()
	return TutorialLine.Create(self.npcClickCampaign,
			self.clickBattle
	)
end

--- @return TutorialNode
function TutorialCampaign:TutorialGoToBattle()
	return TutorialLine.Create(self:TutorialGoToFormation(),
			self.formationBattleClick
	)
end

--- @return TutorialNode
function TutorialCampaign:TutorialGoToBattleSave()
	return TutorialLine.Create(self:TutorialGoToFormation(),
			self.formationBattleClickSave
	)
end

--- @return TutorialNode
function TutorialCampaign:TutorialGoToBattleNpc()
	return TutorialLine.Create(self:TutorialGoToFormationNpc(),
			self.formationBattleClick
	)
end

--- @return TutorialNode
function TutorialCampaign:TutorialGoToBattleNpcSave()
	return TutorialLine.Create(self:TutorialGoToFormationNpc(),
			self.formationBattleClickSave
	)
end