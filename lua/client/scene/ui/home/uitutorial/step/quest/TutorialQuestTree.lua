--- @class TutorialQuestTree : TutorialQuest
TutorialQuestTree = Class(TutorialQuestTree, TutorialQuest)

--- @return void
function TutorialQuestTree:Ctor()
    TutorialQuest.Ctor(self)

    ---@type TutorialNode
    self.clickQuest = TutorialSingle.Create(TutorialStepData():Delay(0.5):KeyLocalize("npc_list_tut"):ShowNpc(true):
    Step(TutorialStep.CLICK_QUEST)                            :Focus(TutorialFocus.FOCUS_CLICK):Pivot(TutorialPivot.TOP_RIGHT))

    ---@type TutorialNode
    self.clickQuest1 = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_quest"):Delay(0.2):
    ShowNpc(true)                                              :HideFocus(true):
    Step(TutorialStep.CLICK_QUEST_1)                           :Focus(TutorialFocus.FOCUS_CLICK):Pivot(TutorialPivot.BOTTOM_RIGHT))

    ---@type TutorialNode
    self.clickGo = TutorialSingle.Create(TutorialStepData():Delay(0.2):HideFocus(true):
    Step(TutorialStep.CLICK_GO):Focus(TutorialFocus.FOCUS_CLICK):Pivot(TutorialPivot.BOTTOM_RIGHT))

    ---@type TutorialNode
    self.basicSummon = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.FREE_BASIC_SUMMON_CLICK):HideFocus(true):
    Focus(TutorialFocus.FOCUS_CLICK):StepId(self:GetStepId()):Delay(1))

    ---@type TutorialNode
    self.backResult = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.BACK_SUMMON_RESULT_CLICK):
    ShowNpc(true)                                             :HideFocus(true):
    Focus(TutorialFocus.TAP_TO_CLICK)                         :Delay(2):KeyLocalize("npc_quest_complete"):Pivot(TutorialPivot.TOP_RIGHT))

    ---@type TutorialNode
    self.backSummonAuto = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.BACK_SUMMON_CLICK):
    Focus(TutorialFocus.AUTO_NEXT):Delay(0.5))
end

TutorialQuestTree.stepId = 16000

--- @return number
function TutorialQuestTree:GetStepId()
    return TutorialQuestTree.stepId
end

--- @return number
function TutorialQuestTree:CanRunTutorial()
    return true
end

--- @return TutorialNode
function TutorialQuestTree:Continue()
    return TutorialLine.Create(self:TutorialGoToQuest1(), self.clickQuest1, self.clickGo,
            self.basicSummon, self.backResult, self.backSummonAuto
    )
end

--- @return TutorialNode
function TutorialQuestTree:Start()
    return self:Continue()
end