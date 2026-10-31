--- @class TutorialLevelUpHero : TutorialHeroMenu
TutorialLevelUpHero = Class(TutorialLevelUpHero, TutorialHeroMenu)

--- @return void
function TutorialLevelUpHero:Ctor()
    TutorialHeroMenu.Ctor(self)

    --- @type TutorialSingle
    self.clickLevelUpStart = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_click_level_up")
            :Step(TutorialStep.CLICK_LEVEL_UP_HERO)
            :Focus(TutorialFocus.FOCUS_CLICK)
            :Pivot(TutorialPivot.TOP_RIGHT)
            :ShowNpc(true)
            :Delay(0.5)
            :HideFocus(true)
            :TrackingName("click_level_up"))

    --- @type TutorialSingle
    self.clickLevelUpBack = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_upgrade_hero_success")
            :TrackingName("back_hero_info")
            :Step(TutorialStep.CLICK_LEVEL_UP_HERO_BACK)
            :Pivot(TutorialPivot.BOTTOM_RIGHT)
            :ShowNpc(true)
            :Focus(TutorialFocus.TAP_TO_CLICK)
            :StepId(self:GetStepId())
            :Delay(1))

    ---@type TutorialSingle
    self.introduceHeroUpgradeFeature = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_introduce_hero_upgrade_feature")
            :ShowNpc(true)
            :TrackingName("introduce_hero_upgrade_feature")
            :Delay(0.1)
            :HideFocus(true)
            :Pivot(TutorialPivot.BOTTOM_RIGHT))

    ---@type TutorialSingle
    --self.introduceWeaponSlot = TutorialSingle.Create(TutorialStepData()
    --        :KeyLocalize("npc_weapon")
    --        :ShowNpc(true)
    --        :Step(TutorialStep.UPGRADE_HERO_WEAPON_SLOT)
    --        :TrackingName("upgrade_hero_weapon_slot")
    --        :Focus(TutorialFocus.FOCUS)
    --        :Delay(0.1)
    --        :Pivot(TutorialPivot.BOTTOM_RIGHT))

    ---@type TutorialSingle
    --self.introduceArmorSlot = TutorialSingle.Create(TutorialStepData()
    --        :KeyLocalize("npc_armor")
    --        :ShowNpc(true)
    --        :Step(TutorialStep.UPGRADE_HERO_ARMOR_SLOT)
    --        :TrackingName("upgrade_hero_armor_slot")
    --        :Focus(TutorialFocus.FOCUS)
    --        :Delay(0.1)
    --        :Pivot(TutorialPivot.BOTTOM_RIGHT))

    ---@type TutorialSingle
    --self.introduceHelmetSlot = TutorialSingle.Create(TutorialStepData()
    --        :KeyLocalize("npc_helmet")
    --        :ShowNpc(true)
    --        :Step(TutorialStep.UPGRADE_HERO_HELMET_SLOT)
    --        :TrackingName("upgrade_hero_helmet_slot")
    --        :Focus(TutorialFocus.FOCUS)
    --        :Delay(0.1)
    --        :Pivot(TutorialPivot.BOTTOM_LEFT))

    ---@type TutorialSingle
    --self.introduceRingSlot = TutorialSingle.Create(TutorialStepData()
    --        :KeyLocalize("npc_ring")
    --        :ShowNpc(true)
    --        :Step(TutorialStep.UPGRADE_HERO_RING_SLOT)
    --        :TrackingName("upgrade_hero_ring_slot")
    --        :Focus(TutorialFocus.FOCUS)
    --        :Delay(0.1)
    --        :Pivot(TutorialPivot.BOTTOM_LEFT))

    ---@type number
    self.numberLevel = nil

    self.clickLevelUpStart.tutorialStepData:TrackingID(10)
    self.clickLevelUpBack.tutorialStepData:TrackingID(31)
    self.backHeroCollectionAuto.tutorialStepData:TrackingID(32)


end

--- @return TutorialNode
--- @param trackingId number
--- Tutorial click on level up hero button
function TutorialLevelUpHero:CreateTutorialNodeLevelUp(trackingId)
    return TutorialSingle.Create(TutorialStepData()
            :Step(TutorialStep.CLICK_LEVEL_UP_HERO)
            :Focus(TutorialFocus.FOCUS_CLICK)
            :Delay(0.1)
            :HideFocus(true)
            :TrackingID(trackingId))
end

TutorialLevelUpHero.stepId = TutorialStepID.TUTORIAL_LEVEL_UP

--- @return number
function TutorialLevelUpHero:GetStepId()
    return TutorialLevelUpHero.stepId
end

--- @return number
function TutorialLevelUpHero:CanRunTutorial()
    self.numberLevel = nil
    ---@param heroResource HeroResource
    --- Only run this tutorial if hero level < 10
    for _, heroResource in pairs(InventoryUtils.Get(ResourceType.Hero):GetItems()) do
        if heroResource.heroLevel >= 10 then
            return false
        end
        if self.numberLevel == nil or self.numberLevel < heroResource.heroLevel then
            self.numberLevel = heroResource.heroLevel
        end
    end
    return true
end

--- @return TutorialNode
function TutorialLevelUpHero:Continue()
    ---@type TutorialLine
    local tutorial = TutorialLine.Create(self:TutorialGoToHeroUpgrade(),
            self.introduceHeroUpgradeFeature,
            --self.introduceWeaponSlot,
            --self.introduceArmorSlot,
            --self.introduceHelmetSlot,
            --self.introduceRingSlot,
            self.clickLevelUpStart)
    --- Do tutorial click on level up til hero up to level 10
    if self.numberLevel < 9 then
        for i = self.numberLevel + 1, 9 do
            tutorial:AddNode(self:CreateTutorialNodeLevelUp(11 + i))
        end
    end
    tutorial:AddNode(self.clickLevelUpBack, self.backHeroCollectionAuto)
    return tutorial
end

--- @return TutorialNode
function TutorialLevelUpHero:Start()
    return self:Continue()
end