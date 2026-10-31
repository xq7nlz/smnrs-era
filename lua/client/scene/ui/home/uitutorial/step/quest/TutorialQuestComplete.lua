--- @class TutorialQuestComplete : TutorialQuest
TutorialQuestComplete = Class(TutorialQuestComplete, TutorialQuest)

--- @return void
function TutorialQuestComplete:Ctor()
    TutorialQuest.Ctor(self)

    ---@type TutorialNode
    self.clickComplete = TutorialSingle.Create(TutorialStepData():Delay(0.2):HideFocus(true):
    Step(TutorialStep.CLICK_QUEST_COMPLETE):Focus(TutorialFocus.FOCUS_CLICK):Pivot(TutorialPivot.BOTTOM_RIGHT):
    StepId(self:GetStepId()))

    ---@type TutorialNode
    self.endTutorial = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_end_tut"):ShowNpc(true):
    Delay(0.1)                                                 :Pivot(TutorialPivot.CENTER))
end

TutorialQuestComplete.stepId = 17000

--- @return number
function TutorialQuestComplete:GetStepId()
    return TutorialQuestComplete.stepId
end

--- @return number
function TutorialQuestComplete:CanRunTutorial()
    return true
end

--- @return TutorialNode
function TutorialQuestComplete:Continue()
    return TutorialLine.Create(self:TutorialGoToQuest1(), self.clickQuest1, self.clickComplete, self.endTutorial
    )
end

--- @return TutorialNode
function TutorialQuestComplete:Start()
    return self:Continue()
end