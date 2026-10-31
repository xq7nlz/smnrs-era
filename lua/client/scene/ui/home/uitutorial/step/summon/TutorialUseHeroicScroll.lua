--- @class TutorialUseHeroicScroll : TutorialSummon
TutorialUseHeroicScroll = Class(TutorialUseHeroicScroll, TutorialSummon)

--- @return void
function TutorialUseHeroicScroll:Ctor()
    TutorialSummon.Ctor(self)

    ---@type TutorialNode
    self.continueSummon = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_continue_summon")
            :Delay(0.3):Step(TutorialStep.CONTINUE_SUMMON)
            :TrackingName("click_summon")
            :Focus(TutorialFocus.FOCUS_CLICK)
            :Pivot(TutorialPivot.BOTTOM_RIGHT)
            :ShowNpc(true))

    ---@type TutorialNode
    self.heroicSummonScroll = TutorialSingle.Create(TutorialStepData()
            :Step(TutorialStep.FREE_HEROIC_SUMMON_CLICK)
            :Focus(TutorialFocus.FOCUS_CLICK)
            :StepId(self:GetStepId())
            :Delay(1)
            :HideFocus(true)
            :TrackingName("click_summon_heroic")
            :WaitOpCode(OpCode.TUTORIAL_SUMMON_HERO))

    self.continueSummon.tutorialStepData:TrackingID(1)
    self.heroicSummonScroll.tutorialStepData:TrackingID(2)
    self.backResult.tutorialStepData:TrackingID(3)
    self.backSummonAuto.tutorialStepData:TrackingID(4)
end

TutorialUseHeroicScroll.stepId = 8000

--- @return number
function TutorialUseHeroicScroll:GetStepId()
    return TutorialUseHeroicScroll.stepId
end

--- @return number
function TutorialUseHeroicScroll:CanRunTutorial()
    ---@type List
    local listHero = InventoryUtils.Get(ResourceType.Hero)
    return listHero:Count() == 2
end

--- @return TutorialNode
function TutorialUseHeroicScroll:Continue()
    return TutorialLine.Create(self.continueSummon,
            self.heroicSummonScroll,
            self.backResult,
            self.backSummonAuto
    )
end

--- @return TutorialNode
function TutorialUseHeroicScroll:Start()
    return self:Continue()
end