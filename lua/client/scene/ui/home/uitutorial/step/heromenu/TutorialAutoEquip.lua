--- @class TutorialAutoEquip : TutorialHeroMenu
TutorialAutoEquip = Class(TutorialAutoEquip, TutorialHeroMenu)

--- @return void
function TutorialAutoEquip:Ctor()
    TutorialHeroMenu.Ctor(self)

    ---@type TutorialSingle
    self.selectTabEquip = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.SELECT_TAB_EQUIP):
    Focus(TutorialFocus.FOCUS_CLICK):Delay(0.5):HideFocus(true):TrackingName("click_tab_equip"))

    ---@type TutorialSingle
    self.autoEquip = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.CLICK_AUTO_EQUIP):TrackingName("click_auto_equip"):
    Focus(TutorialFocus.FOCUS_CLICK):Delay(0.5):HideFocus(true):WaitOpCode(OpCode.ITEM_EQUIP):StepId(self:GetStepId()))

    ---@type TutorialSingle
    self.backEquip = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.BACK_HERO_INFO):KeyLocalize("npc_continue_5"):
    Focus(TutorialFocus.TAP_TO_CLICK):Delay(0.5):Pivot(TutorialPivot.BOTTOM_RIGHT):TrackingName("back_hero_equip"):ShowNpc(true))

    self.selectHeroListNpc.tutorialStepData:TrackingID(1)
    self.selectHero.tutorialStepData:TrackingID(2)
    self.selectTabEquip.tutorialStepData:TrackingID(3)
    self.autoEquip.tutorialStepData:TrackingID(4)
    self.backEquip.tutorialStepData:TrackingID(5)
    self.backHeroCollectionAuto.tutorialStepData:TrackingID(6)
end

TutorialAutoEquip.stepId = 9000

--- @return number
function TutorialAutoEquip:GetStepId()
    return TutorialAutoEquip.stepId
end

--- @return number
function TutorialAutoEquip:CanRunTutorial()
    ---@param heroResource HeroResource
    for _, heroResource in pairs(InventoryUtils.Get(ResourceType.Hero):GetItems()) do
        if heroResource.heroItem ~= nil then
            for _, id in pairs(heroResource.heroItem:GetItems()) do
                if id > 0 then
                    return false
                end
            end
        end
    end
    return true
end

--- @return TutorialNode
function TutorialAutoEquip:Continue()
    return TutorialLine.Create(self.selectHeroListNpc,
            self.selectHero,
            self.selectTabEquip,
            self.autoEquip,
            self.backEquip,
            self.backHeroCollectionAuto
    )
end

--- @return TutorialNode
function TutorialAutoEquip:Start()
    return self:Continue()
end