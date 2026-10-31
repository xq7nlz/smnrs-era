--- @class TutorialMiniQuestComplete : TutorialBase
TutorialMiniQuestComplete = Class(TutorialMiniQuestComplete, TutorialBase)

--- @return void
function TutorialMiniQuestComplete:Ctor()
    TutorialBase.Ctor(self)

    ---@type TutorialSingle
    self.clickComplete = TutorialSingle.Create(TutorialStepData():Delay(0.2):HideFocus(true):
    Step(TutorialStep.CLICK_QUEST_COMPLETE):Focus(TutorialFocus.FOCUS_CLICK):Pivot(TutorialPivot.BOTTOM_RIGHT):
    StepId(self:GetStepId()):TrackingName("click_quest_complete"))

    ---@type TutorialSingle
    self.endTutorial = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_end_tut"):ShowNpc(true):
    Delay(0.1):TrackingName("npc_end_tut"):Pivot(TutorialPivot.CENTER))

    self.clickComplete.tutorialStepData:TrackingID(1)
    self.endTutorial.tutorialStepData:TrackingID(2)
end

TutorialMiniQuestComplete.stepId = 17000

--- @return number
function TutorialMiniQuestComplete:GetStepId()
    return TutorialMiniQuestComplete.stepId
end

--- @return number
function TutorialMiniQuestComplete:CanRunTutorial()
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
function TutorialMiniQuestComplete:Continue()
    return TutorialLine.Create(self.clickComplete, self.endTutorial
    )
end

--- @return TutorialNode
function TutorialMiniQuestComplete:Start()
    return self:Continue()
end