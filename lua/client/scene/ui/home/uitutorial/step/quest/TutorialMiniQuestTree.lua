--- @class TutorialMiniQuestTree : TutorialBase
TutorialMiniQuestTree = Class(TutorialMiniQuestTree, TutorialBase)

--- @return void
function TutorialMiniQuestTree:Ctor()
    TutorialBase.Ctor(self)

    ---@type TutorialSingle
    self.clickGo = TutorialSingle.Create(TutorialStepData():Delay(0.2):HideFocus(true):TrackingName("click_go"):
    Step(TutorialStep.CLICK_GO):Focus(TutorialFocus.FOCUS_CLICK):Pivot(TutorialPivot.BOTTOM_RIGHT))

    ---@type TutorialSingle
    self.basicSummon = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.FREE_BASIC_SUMMON_CLICK):HideFocus(true):
    Focus(TutorialFocus.FOCUS_CLICK):StepId(self:GetStepId()):Delay(1):TrackingName("click_summon_basic")
            :WaitOpCode(OpCode.TUTORIAL_SUMMON_HERO))

    ---@type TutorialSingle
    self.backResult = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.BACK_SUMMON_RESULT_CLICK):
    ShowNpc(true):TrackingName("back_summon_result"):HideFocus(true):
    Focus(TutorialFocus.TAP_TO_CLICK)                         :Delay(2):KeyLocalize("npc_quest_complete"):Pivot(TutorialPivot.TOP_RIGHT))

    ---@type TutorialSingle
    self.backSummonAuto = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.BACK_SUMMON_CLICK):
    Focus(TutorialFocus.AUTO_NEXT):Delay(0.5):TrackingName("back_summon_auto"))

    self.clickGo.tutorialStepData:TrackingID(1)
    self.basicSummon.tutorialStepData:TrackingID(2)
    self.backResult.tutorialStepData:TrackingID(3)
    self.backSummonAuto.tutorialStepData:TrackingID(4)
end

TutorialMiniQuestTree.stepId = 16000

--- @return number
function TutorialMiniQuestTree:GetStepId()
    return TutorialMiniQuestTree.stepId
end

--- @return number
function TutorialMiniQuestTree:CanRunTutorial()
    local canRun = false
    --- @type QuestDataInBound
    local questDataInBound = zg.playerData:GetQuest()
    if questDataInBound ~= nil then
        --- @type number
        local selectedQuestId = questDataInBound.questTreeDataInBound:SelectQuestTreeToShowOnMiniPanel()
        if selectedQuestId ~= nil and ResourceMgr.GetQuestConfig():GetQuestTreeTypeById(selectedQuestId) == QuestType.SUMMON_HERO_BY_BASIC_SCROLL then
            canRun = true
        end
    end

    return canRun
end

--- @return TutorialNode
function TutorialMiniQuestTree:Continue()
    return TutorialLine.Create(self.clickGo,
            self.basicSummon, self.backResult, self.backSummonAuto
    )
end

--- @return TutorialNode
function TutorialMiniQuestTree:Start()
    return self:Continue()
end