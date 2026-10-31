--- @class TutorialSummonBasic : TutorialSummon
TutorialSummonBasic = Class(TutorialSummonBasic, TutorialSummon)

--- @return void
function TutorialSummonBasic:Ctor()
    TutorialSummon.Ctor(self)
    ---@type TutorialNode
    self.start = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_hello")
            :Delay(1)
            :ShowNpc(true)
            :TrackingID(1)
            :Pivot(TutorialPivot.CENTER)
            :TrackingName("start")
            :HideFocus(true))

    self.basicSummon = TutorialSingle.Create(TutorialStepData()
            :Step(TutorialStep.FREE_BASIC_SUMMON_CLICK)
            :HideFocus(true)
            :Focus(TutorialFocus.FOCUS_CLICK)
            :StepId(self:GetStepId())
            :Delay(0.1)
            :TrackingName("click_summon_basic")
            :TrackingID(7)
            :WaitOpCode(OpCode.TUTORIAL_SUMMON_HERO))

    self.backResult.tutorialStepData:TrackingID(8)
end

TutorialSummonBasic.stepId = 2000

--- @return number
function TutorialSummonBasic:GetStepId()
    return TutorialSummonBasic.stepId
end

--- @return number
function TutorialSummonBasic:CanRunTutorial()
    ---@type List
    local listHero = InventoryUtils.Get(ResourceType.Hero)
    local canShow = listHero:Count() == 0
    if   zg.sceneMgr.gameMode == GameMode.TUT_BATTLE then
        canShow = false
    end
    return canShow
end

--- @return TutorialNode
function TutorialSummonBasic:Continue()
    return TutorialLine.Create(
            self.clickBasicSummon,
            self.basicSummon,
            self.backResult,
            self.clickHeroicSummon
    )
end

--- @return TutorialNode
function TutorialSummonBasic:Start()
    return TutorialLine.Create(self:TutorialSummonInfo(), self:Continue())
end