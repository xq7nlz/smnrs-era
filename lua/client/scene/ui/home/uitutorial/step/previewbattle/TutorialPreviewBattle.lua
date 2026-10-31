--- @class TutorialPreviewBattle : TutorialCampaign
TutorialPreviewBattle = Class(TutorialPreviewBattle, TutorialCampaign)

--- @return void
function TutorialPreviewBattle:Ctor()
    TutorialCampaign.Ctor(self)

    ---@type TutorialSingle
    self.npcClickCampaign = TutorialSingle.Create(TutorialStepData()
            :Step(TutorialStep.CAMPAIGN_CLICK)
            :ShowNpc(true)
            :TrackingID(1)
            :Focus(TutorialFocus.FOCUS_CLICK)
            :TrackingName("click_campaign_npc")
            :Delay(0.5)
            :KeyLocalize("npc_continue_campaign")
            :Pivot(TutorialPivot.BOTTOM_RIGHT))

    --self.clickBattle.tutorialStepData:TrackingID(2)
    --self.closeBattle.tutorialStepData:TrackingID(7)

end

TutorialPreviewBattle.stepId = 4000

--- @return number
function TutorialPreviewBattle:GetStepId()
    return TutorialPreviewBattle.stepId
end

--- @return number
function TutorialPreviewBattle:CanRunTutorial()
    return true
end

--- @return TutorialNode
function TutorialPreviewBattle:Continue()
    return TutorialLine.Create(self.selectHero1)
end

--- @return TutorialNode
function TutorialPreviewBattle:Start()
    return self:Continue()
end