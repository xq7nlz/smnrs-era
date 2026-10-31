--- @class TutorialStartGame : TutorialCampaign
TutorialStartGame = Class(TutorialStartGame, TutorialCampaign)

--- @return void
function TutorialStartGame:Ctor()
	TutorialCampaign.Ctor(self)
	---@type TutorialSingle
	self.t1 = TutorialSingle.Create(TutorialStepData()
			:KeyLocalize("npc_hello")
			:Delay(0.5)
			:ShowNpc(true)
			:Pivot(TutorialPivot.CENTER))
	---@type TutorialSingle
	self.npcClickCampaign = TutorialSingle.Create(TutorialStepData()
			:Step(TutorialStep.CAMPAIGN_CLICK)
			:ShowNpc(true)
			:Focus(TutorialFocus.FOCUS_CLICK)
			:TrackingName("click_campaign_npc")
			:Delay(0.5)
			:KeyLocalize("npc_continue_campaign")
			:Pivot(TutorialPivot.BOTTOM_RIGHT)
			:StepId(self:GetStepId()))
			
	---@type TutorialSingle
	self.closeBattle.tutorialStepData
			:ShowNpc(true)
			:KeyLocalize("victory_battle_tut")
	--		:SetOnFinishStep(function()
	--	TrackingUtils.TrackingTutorial(FBProperties.STEP,self:GetStepId() + 1)
	--end)

end

TutorialStartGame.stepId = TutorialStepID.TUTORIAL_FAKE_BATTLE

--- @return number
function TutorialStartGame:GetStepId()
	return TutorialStartGame.stepId
end

--- @return TutorialNode
function TutorialStartGame:Start()
	return TutorialLine.Create(self.t1,
			self.npcClickCampaign,
			self.closeBattle)
end

--- @return boolean
function TutorialStartGame:CanRunTutorial()
	return true
end

--- @return TutorialNode
function TutorialStartGame:Continue()

end