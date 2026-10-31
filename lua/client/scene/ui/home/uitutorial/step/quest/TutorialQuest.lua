--- @class TutorialQuest : TutorialBase
TutorialQuest = Class(TutorialQuest, TutorialBase)

--- @return void
function TutorialQuest:Ctor()
    ---@type TutorialNode
    self.clickQuest = TutorialSingle.Create(TutorialStepData():Delay(0.5):
    Step(TutorialStep.CLICK_QUEST):Focus(TutorialFocus.FOCUS_CLICK):Pivot(TutorialPivot.BOTTOM_RIGHT))

    ---@type TutorialNode
    self.clickQuestTree = TutorialSingle.Create(TutorialStepData():HideFocus(true):
    Step(TutorialStep.CLICK_QUEST_TREE):Focus(TutorialFocus.FOCUS_CLICK):Pivot(TutorialPivot.BOTTOM_RIGHT))

    ---@type TutorialNode
    self.clickMainAction = TutorialSingle.Create(TutorialStepData():HideFocus(true):
    Step(TutorialStep.CLICK_MAIN_ACTION):Focus(TutorialFocus.FOCUS_CLICK):Pivot(TutorialPivot.BOTTOM_RIGHT))

    ---@type TutorialNode
    self.clickQuest1 = TutorialSingle.Create(TutorialStepData():Delay(0.2):HideFocus(true):
    Step(TutorialStep.CLICK_QUEST_1):Focus(TutorialFocus.FOCUS_CLICK):Pivot(TutorialPivot.BOTTOM_RIGHT))
end

--- @return TutorialNode
function TutorialQuest:TutorialGoToQuest1()
    return TutorialLine.Create(self.clickQuest, self.clickQuestTree,
            self.clickMainAction
    )
end