--- @class TutorialCampaign4 : TutorialCampaign
TutorialCampaign4 = Class(TutorialCampaign4, TutorialCampaign)

--- @return void
function TutorialCampaign4:Ctor()
    TutorialCampaign.Ctor(self)

    self.clickCampaignNpc.tutorialStepData:TrackingID(1)
    self.clickBattle.tutorialStepData:TrackingID(2)
    self.formationBattleClickSave.tutorialStepData:TrackingID(3)
    self.closeBattle.tutorialStepData:TrackingID(4)
end

TutorialCampaign4.stepId = 13000

--- @return number
function TutorialCampaign4:GetStepId()
    return TutorialCampaign4.stepId
end

--- @return number
function TutorialCampaign4:CanRunTutorial()
    return zg.playerData:GetCampaignData().stageIdle == 101002
end

--- @return TutorialNode
function TutorialCampaign4:Continue()
    return TutorialLine.Create(self.clickCampaignNpc,
            self.clickBattle,
            self.formationBattleClickSave,
            self.closeBattle
    )
end

--- @return TutorialNode
function TutorialCampaign4:Start()
    return self:Continue()
end