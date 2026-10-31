--- @class TutorialCampaign5 : TutorialCampaign
TutorialCampaign5 = Class(TutorialCampaign5, TutorialCampaign)

--- @return void
function TutorialCampaign5:Ctor()
    TutorialCampaign.Ctor(self)
end

TutorialCampaign5.stepId = 14000

--- @return number
function TutorialCampaign5:GetStepId()
    return TutorialCampaign5.stepId
end

--- @return TutorialNode
function TutorialCampaign5:Continue()
    return TutorialLine.Create(self.formationBattleClickSave,
            self.closeBattle
    )
end

--- @return number
function TutorialCampaign5:CanRunTutorial()
    return zg.playerData:GetCampaignData().stageNext == 101005
end

--- @return TutorialNode
function TutorialCampaign5:Start()
    return TutorialLine.Create(self:TutorialGoToBattle(),
            self.closeBattle
    )
end