--- @class TutorialCampaign7 : TutorialCampaign
TutorialCampaign7 = Class(TutorialCampaign7, TutorialCampaign)

--- @return void
function TutorialCampaign7:Ctor()
    TutorialCampaign.Ctor(self)
    self.formationBattleClick.tutorialStepData:StepId(self:GetStepId())
    self.closeBattle.tutorialStepData:KeyLocalize("congratulation_you_have_done")
            :ShowNpc(true)
end

TutorialCampaign7.stepId = TutorialStepID.TUTORIAL_END

--- @return number
function TutorialCampaign7:GetStepId()
    return TutorialCampaign7.stepId
end

--- @return number
function TutorialCampaign7:CanRunTutorial()
    local canRun = zg.playerData:GetCampaignData().stageIdle <= 101002
    if canRun then
        canRun = false
        ---@type FormationInBound
        local formationInBound = zg.playerData:GetFormationInBound()
        if formationInBound ~= nil then
            ---@type TeamFormationInBound
            local teamFormation = formationInBound.teamDict:Get(GameMode.CAMPAIGN)
            if teamFormation ~= nil then
                canRun = true
            end
        end
    end
    return canRun
end

--- @return TutorialNode
function TutorialCampaign7:Continue()
    return TutorialLine.Create(self.clickCampaign,
            self.clickBattle,
            self.formationBattleClick,
            self.closeBattle)
end

--- @return TutorialNode
function TutorialCampaign7:Start()
    return self:Continue()
end