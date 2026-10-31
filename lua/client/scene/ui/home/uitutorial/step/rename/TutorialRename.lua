--- @class TutorialRename : TutorialBase
TutorialRename = Class(TutorialRename, TutorialBase)

--- @return void
function TutorialRename:Ctor()
    TutorialBase.Ctor(self)

    ---@type TutorialNode
    self.start = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_hello")
            :Delay(1)
            :ShowNpc(true)
            :TrackingID(1)
            :Pivot(TutorialPivot.CENTER)
            :TrackingName("start")
            :HideFocus(true))

    ---@type TutorialNode
    self.clickRename = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_rename")
            :ShowNpc(true)
            :TrackingID(2)
            :Step(TutorialStep.CLICK_RENAME)
            :TrackingName("click_rename")
            :Focus(TutorialFocus.FOCUS_CLICK)
            :Pivot(TutorialPivot.BOTTOM_RIGHT)
            :Delay(0.1)
            :WaitOpCode(OpCode.PLAYER_NAME_CHANGE)
            :StepId(self:GetStepId()))
end

TutorialRename.stepId = 1000

--- @return number
function TutorialRename:GetStepId()
    return TutorialRename.stepId
end

--- @return number
function TutorialRename:CanRunTutorial()
    return not (zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).numberChangeName ~= nil and
            zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).numberChangeName > 0)
end

--- @return TutorialNode
function TutorialRename:Continue()
    return TutorialLine.Create(self.start, self.clickRename)
end

--- @return TutorialNode
function TutorialRename:Start()
    return self:Continue()
end