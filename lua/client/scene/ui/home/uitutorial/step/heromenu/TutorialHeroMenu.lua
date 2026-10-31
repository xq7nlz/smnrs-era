--- @class TutorialHeroMenu : TutorialBase
TutorialHeroMenu = Class(TutorialHeroMenu, TutorialBase)

--- @return void
function TutorialHeroMenu:Ctor()
    TutorialBase.Ctor(self)

    ---@type TutorialSingle
    self.selectHeroList = TutorialSingle.Create(TutorialStepData():TrackingName("click_hero_list"):
    Step(TutorialStep.CLICK_HERO_COLLECTION):Focus(TutorialFocus.FOCUS_CLICK):Delay(0.5))

    ---@type TutorialSingle
    self.selectHeroListNpc = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_equipment"):ShowNpc(true):
    Step(TutorialStep.CLICK_HERO_COLLECTION):TrackingName("click_hero_list_npc"):Focus(TutorialFocus.FOCUS_CLICK):Delay(0.5)
                                                                     :Pivot(TutorialPivot.BOTTOM_LEFT))

    ---@type TutorialSingle
    self.selectHero = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.SELECT_HERO_IN_COLLECTION):
    Focus(TutorialFocus.FOCUS_CLICK):Delay(0.5):TrackingName("select_hero"))

    ---@type TutorialSingle
    self.selectHeroUpgrade = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.SELECT_HERO_IN_COLLECTION):ShowNpc(true):
    Focus(TutorialFocus.FOCUS_CLICK):TrackingName("select_hero"):Delay(0.5):KeyLocalize("npc_select_hero_upgrade"):Pivot(TutorialPivot.BOTTOM_RIGHT))

    ---@type TutorialSingle
    self.backHeroMenu = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_continue"):Pivot(TutorialPivot.TOP_LEFT):ShowNpc(true):
    Step(TutorialStep.BACK_HERO_INFO):TrackingName("back_hero_info"):Focus(TutorialFocus.TAP_TO_CLICK):Delay(0.5))

    ---@type TutorialSingle
    self.backHeroCollectionAuto = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.BACK_HERO_COLLECTION):
    Focus(TutorialFocus.AUTO_NEXT):Delay(0.5):TrackingName("back_hero_list"))

    self.selectHeroList.tutorialStepData:TrackingID(1)
    self.selectHero.tutorialStepData:TrackingID(2)
    self.selectHeroUpgrade.tutorialStepData:TrackingID(3)

end

--- @return TutorialNode
function TutorialHeroMenu:TutorialGoToHeroMenu()
    return TutorialLine.Create(self.selectHeroList,
            self.selectHero)
end

--- @return TutorialNode
function TutorialHeroMenu:TutorialGoToHeroUpgrade()
    return TutorialLine.Create(self.selectHeroList,
            self.selectHeroUpgrade)
end