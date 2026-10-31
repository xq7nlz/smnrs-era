--- @class TutorialEvolveSummoner : TutorialCampaign
TutorialEvolveSummoner = Class(TutorialEvolveSummoner, TutorialCampaign)

--- @return void
function TutorialEvolveSummoner:Ctor()
    TutorialCampaign.Ctor(self)
    ---@type TutorialSingle
    self.npcUnlockSummoner = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_go_evolve_summoner"):ShowNpc(true):
    Step(TutorialStep.BACK_CAMPAIGN):TrackingName("npc_go_evolve_summoner"):Focus(TutorialFocus.TAP_TO_CLICK):
    Delay(0.2)                                                       :Pivot(TutorialPivot.TOP_LEFT))

    ---@type TutorialSingle
    self.clickSummoner = TutorialSingle.Create(TutorialStepData():Delay(0.2):
    Step(TutorialStep.CLICK_SUMMONER):Focus(TutorialFocus.FOCUS_CLICK):TrackingName("click_summoner"))

    ---@type TutorialSingle
    self.clickTabEvolve = TutorialSingle.Create(TutorialStepData():Delay(0.2):HideFocus(true):
    Step(TutorialStep.CLICK_TAB_EVOLVE):Focus(TutorialFocus.FOCUS_CLICK):TrackingName("click_tab_evolve"))

    ---@type TutorialSingle
    self.clickEvolve = TutorialSingle.Create(TutorialStepData():StepId(self:GetStepId()):Delay(0.2):HideFocus(true):
    Step(TutorialStep.CLICK_EVOLVE):Focus(TutorialFocus.FOCUS_CLICK):WaitOpCode(OpCode.SUMMONER_EVOLVE):TrackingName("click_evolve"))

    self.npcUnlockSummoner.tutorialStepData:TrackingID(1)
    self.clickSummoner.tutorialStepData:TrackingID(2)
    self.clickTabEvolve.tutorialStepData:TrackingID(3)
    self.clickEvolve.tutorialStepData:TrackingID(4)
end

TutorialEvolveSummoner.stepId = 19000

--- @return number
function TutorialEvolveSummoner:GetStepId()
    return TutorialEvolveSummoner.stepId
end

--- @return TutorialNode
function TutorialEvolveSummoner:Continue()
    return TutorialLine.Create(self.npcUnlockSummoner, self:Start())
end

--- @return number
function TutorialEvolveSummoner:CanRunTutorial()
    return zg.playerData:GetMethod(PlayerDataMethod.SUMMONER).star == 3 and ResourceMgr.GetMainCharacterConfig():IsCanEvolve(3)
end

--- @return TutorialNode
function TutorialEvolveSummoner:Start()
    return TutorialLine.Create(self.clickSummoner,
            self.clickTabEvolve, self.clickEvolve
    )
end