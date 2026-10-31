--- @class TutorialHeroFragment : TutorialCampaign
TutorialHeroFragment = Class(TutorialHeroFragment, TutorialCampaign)

--- @return void
function TutorialHeroFragment:Ctor()
    TutorialCampaign.Ctor(self)
    ---@type TutorialSingle
    self.npcClaimHeroFragment = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_claim_hero_5star"):
    Step(TutorialStep.BACK_CAMPAIGN):TrackingName("npc_claim_hero_5star"):Focus(TutorialFocus.TAP_TO_CLICK):ShowNpc(true):
    Delay(0.2)                                                          :Pivot(TutorialPivot.TOP_LEFT))

    ---@type TutorialSingle
    self.clickInventory = TutorialSingle.Create(TutorialStepData():Delay(0.5):
    Step(TutorialStep.CLICK_INVENTORY):TrackingName("click_inventory"):Focus(TutorialFocus.FOCUS_CLICK))

    ---@type TutorialSingle
    self.clickTabFragment = TutorialSingle.Create(TutorialStepData():Delay(0.5):
    Step(TutorialStep.CLICK_TAB_FRAGMENT):TrackingName("click_tab_fragment"):Focus(TutorialFocus.FOCUS_CLICK))

    ---@type TutorialSingle
    self.clickHeroFragment = TutorialSingle.Create(TutorialStepData():Delay(0.3):
    Step(TutorialStep.CLICK_HERO_FRAGMENT):TrackingName("select_hero_fragment"):Focus(TutorialFocus.FOCUS_CLICK))

    ---@type TutorialSingle
    self.clickSummonItem = TutorialSingle.Create(TutorialStepData():Delay(0.5):HideFocus(true):
    Step(TutorialStep.CLICK_SUMMON_ITEM):TrackingName("click_summon_item"):Focus(TutorialFocus.FOCUS_CLICK))

    ---@type TutorialSingle
    self.clickSummonHeroFragment = TutorialSingle.Create(TutorialStepData():StepId(self:GetStepId()):Delay(0.5):
    Step(TutorialStep.CLICK_SUMMON_HERO_FRAGMENT):TrackingName("click_summon_hero_fragment"):Focus(TutorialFocus.FOCUS_CLICK):HideFocus(true))

    ---@type TutorialSingle
    self.npcContinue = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_continue_3"):ShowNpc(true):
    Pivot(TutorialPivot.BOTTOM_LEFT):TrackingName("npc_continue_3"):Delay(0.5))

    self.clickInventory.tutorialStepData:TrackingID(1)
    self.clickTabFragment.tutorialStepData:TrackingID(2)
    self.clickHeroFragment.tutorialStepData:TrackingID(3)
    self.clickSummonItem.tutorialStepData:TrackingID(4)
    self.clickSummonHeroFragment.tutorialStepData:TrackingID(5)
    self.npcContinue.tutorialStepData:TrackingID(6)
end

TutorialHeroFragment.stepId = 18000

--- @return number
function TutorialHeroFragment:GetStepId()
    return TutorialHeroFragment.stepId
end

--- @return TutorialNode
function TutorialHeroFragment:Continue()
    return TutorialLine.Create(self.npcClaimHeroFragment, self:Start())
end

--- @return number
function TutorialHeroFragment:CanRunTutorial()
    return zg.playerData:GetCampaignData().stageIdle == 101010
end

--- @return TutorialNode
function TutorialHeroFragment:Start()
    return TutorialLine.Create(self.clickInventory,
            self.clickTabFragment, self.clickHeroFragment, self.clickSummonHeroFragment, self.npcContinue)
end