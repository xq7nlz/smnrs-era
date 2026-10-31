require "lua.client.scene.ui.home.uiTutorial.step.TutorialStepData"
require "lua.client.scene.ui.home.uiTutorial.step.TutorialNode"
require "lua.client.scene.ui.home.uiTutorial.step.TutorialLine"
require "lua.client.scene.ui.home.uiTutorial.step.TutorialSingle"
require "lua.client.scene.ui.home.uiTutorial.step.TutorialOption"

--- @class TutorialBase
TutorialBase = Class(TutorialBase)

--- @return void
function TutorialBase:Ctor()
    ---@type TutorialSingle
    self.closePopupReward = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.CLOSE_POPUP_REWARD):
    Focus(TutorialFocus.FOCUS_CLICK):Delay(1))

    ---@type TutorialSingle
    self.clickNotificationOption1 = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.CLICK_NOTIFICATION_OPTION_1):
    Focus(TutorialFocus.FOCUS_CLICK):Delay(0.5))

    ---@type TutorialSingle
    self.clickNotificationOption2 = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.CLICK_NOTIFICATION_OPTION_2):
    Focus(TutorialFocus.FOCUS_CLICK):Delay(0.5))

    ---@type TutorialSingle
    self.clickBackMap = TutorialSingle.Create(TutorialStepData():Delay(0.5):
    Step(TutorialStep.CLICK_BACK_MAP):Focus(TutorialFocus.FOCUS_CLICK))

    ---@type TutorialSingle
    self.clickBackMapAuto = TutorialSingle.Create(TutorialStepData():Delay(0.5):
    Step(TutorialStep.CLICK_BACK_MAP):Focus(TutorialFocus.AUTO_NEXT))

    ---@type TutorialSingle
    self.resumeBattle = TutorialSingle.Create(TutorialStepData():
    Step(TutorialStep.RESUME_BATTLE):Focus(TutorialFocus.AUTO_NEXT))

end

--- @return TutorialNode
function TutorialBase:ResumeBattle()
    return TutorialSingle.Create(TutorialStepData():
    Step(TutorialStep.RESUME_BATTLE):Focus(TutorialFocus.AUTO_NEXT))
end

--- @return void
function TutorialBase:GetStepId()
    return 0
end

--- @return boolean
function TutorialBase:CanRunTutorial()
    return true
end

--- @return TutorialNode
--- Start is called if this is the first tutorial node running in tutorial
function TutorialBase:Start()

end

--- @return TutorialNode
--- Continue is called if this tutorial node run after other tutorial node in tutorial
function TutorialBase:Continue()

end