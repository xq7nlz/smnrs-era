--- @class TutorialAutoBattle : TutorialBase
TutorialAutoBattle = Class(TutorialAutoBattle, TutorialBase)

--- @return void
function TutorialAutoBattle:Ctor()
    TutorialBase.Ctor(self)

    ---@type TutorialSingle
    self.autoBattle = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_auto_battle")
            :Pivot(TutorialPivot.CENTER)
            :TrackingName("npc_auto_battle")
            :StepId(self:GetStepId()))

    self.autoBattle.tutorialStepData:TrackingID(801)
    self.resumeBattle.tutorialStepData:TrackingID(802)
end

TutorialAutoBattle.stepId = 23000

--- @return number
function TutorialAutoBattle:GetStepId()
    return TutorialAutoBattle.stepId
end

--- @return number
function TutorialAutoBattle:CanRunTutorial()
    return zg.playerData:GetCampaignData().stageIdle <= 101002
end

--- @return TutorialNode
function TutorialAutoBattle:Continue()
    return TutorialLine.Create(self.autoBattle, self.resumeBattle)
end

--- @return TutorialNode
function TutorialAutoBattle:Start()
    return self:Continue()
end