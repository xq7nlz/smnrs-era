--- @class TutorialHeroPower : TutorialBase
TutorialHeroPower = Class(TutorialHeroPower, TutorialBase)

--- @return void
function TutorialHeroPower:Ctor(isAttacker)
    TutorialBase.Ctor(self)

    ---@type TutorialStepData
    local heroPowerStep = TutorialStepData()
            :KeyLocalize("npc_summoner_power")
            :Pivot(TutorialPivot.CENTER)
            :Step(TutorialStep.SUMMONER_POWER)
            :TrackingName("skill_hero")
            :Focus(TutorialFocus.FOCUS)
            :Delay(0.3)
            :StepId(self:GetStepId())

    ---@type TutorialSingle
    self.heroPower = TutorialSingle.Create(heroPowerStep)

    self.heroPower.tutorialStepData:TrackingID(801)
    self.resumeBattle.tutorialStepData:TrackingID(802)
            :SetOnFinishStep(
            function()
                UIUtils.SetInteractableButton(UIBaseView.tutorial.config.buttonBg,true)
            end
    )
end

TutorialHeroPower.stepId = TutorialStepID.TUTORIAL_POWER_UP

--- @return number
function TutorialHeroPower:GetStepId()
    return TutorialHeroPower.stepId
end

--- @return number
function TutorialHeroPower:CanRunTutorial()
    return zg.playerData:GetCampaignData().stageIdle <= 101002
end

--- @return TutorialNode
function TutorialHeroPower:Continue()
    return TutorialLine.Create(self.heroPower, self.resumeBattle)
end

--- @return TutorialNode
function TutorialHeroPower:Start()
    return self:Continue()
end