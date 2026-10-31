--- @class TutorialStage10 : TutorialCampaign
TutorialStage10 = Class(TutorialStage10, TutorialCampaign)

--- @return void
function TutorialStage10:Ctor()
    TutorialCampaign.Ctor(self)
    ---@type TutorialSingle
    self.stage10 = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_stage_10"):
    Step(TutorialStep.STAGE10_INFO):TrackingName("stage_10_info"):Focus(TutorialFocus.FOCUS):Delay(0.2):StepId(self:GetStepId()):
    Pivot(TutorialPivot.CENTER_TOP))

    self.clickCampaign.tutorialStepData:TrackingID(1)
    self.stage10.tutorialStepData:TrackingID(2)
    self.backCampaignAuto.tutorialStepData:TrackingID(3)
end

TutorialStage10.stepId = 15000

--- @return number
function TutorialStage10:GetStepId()
    return TutorialStage10.stepId
end

--- @return TutorialNode
function TutorialStage10:Continue()
    return TutorialLine.Create(self.stage10,
            self.backCampaignAuto
    )
end

--- @return number
function TutorialStage10:CanRunTutorial()
    return zg.playerData:GetCampaignData().stageIdle == 101003
end

--- @return TutorialNode
function TutorialStage10:Start()
    return TutorialLine.Create(self.clickCampaign,
            self:Continue()
    )
end