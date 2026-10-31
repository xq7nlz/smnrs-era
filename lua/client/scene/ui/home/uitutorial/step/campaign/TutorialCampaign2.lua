--- @class TutorialCampaign2 : TutorialCampaign
TutorialCampaign2 = Class(TutorialCampaign2, TutorialCampaign)

--- @return void
function TutorialCampaign2:Ctor()
    TutorialCampaign.Ctor(self)

    ---@type TutorialSingle
    self.needMorePowerInfo = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_need_more_power")
            :ShowNpc(true)
            :HideFocus(true)
            :Step(TutorialStep.BATTLE_DEFEATED)
            :TrackingName("need_more_power")
            :Focus(TutorialFocus.FOCUS)
            :Delay(0.1)
            :Pivot(TutorialPivot.BOTTOM_RIGHT)
            :TrackingID(4))

    ---@type TutorialSingle
    self.forgeEquipmentInfo = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_forge_equipment_info")
            :ShowNpc(true)
            :HideFocus(true)
            :Step(TutorialStep.DEFEATED_FORGE_EQUIPMENT)
            :TrackingName("upgrade_equipment")
            :Focus(TutorialFocus.FOCUS)
            :Delay(0.1)
            :Pivot(TutorialPivot.BOTTOM_RIGHT)
            :TrackingID(5))

    ---@type TutorialSingle
    self.upgradeHeroInfo = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_upgrade_hero_info")
            :ShowNpc(true)
            :HideFocus(true)
            :Step(TutorialStep.DEFEATED_UPGRADE_HERO)
            :TrackingName("upgrade_hero")
            :Focus(TutorialFocus.FOCUS)
            :Delay(0.1)
            :Pivot(TutorialPivot.BOTTOM_RIGHT)
            :TrackingID(6))

    ---@type TutorialSingle
    self.summonHeroInfo = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_summon_hero_info")
            :ShowNpc(true)
            :HideFocus(true)
            :Step(TutorialStep.DEFEATED_SUMMON_HERO)
            :TrackingName("summon_hero")
            :Focus(TutorialFocus.FOCUS)
            :Delay(0.1)
            :Pivot(TutorialPivot.BOTTOM_RIGHT)
            :TrackingID(7))

    ---@type TutorialSingle
    self.clickUpgradeHero = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_need_upgrade_hero")
            :ShowNpc(true)
            :HideFocus(true)
            :Step(TutorialStep.DEFEATED_UPGRADE_HERO)
            :TrackingName("click_upgrade_equipment")
            :Focus(TutorialFocus.TAP_TO_CLICK)
            :Delay(0.1)
            :Pivot(TutorialPivot.BOTTOM_RIGHT)
            :TrackingID(8))

    ---@type TutorialSingle
    self.closeBattle = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_need_power")
            :ShowNpc(true)
            :Step(TutorialStep.BATTLE_CLOSE)
            :Focus(TutorialFocus.FOCUS_CLICK)
            :Delay(0.1)
            :Pivot(TutorialPivot.TOP_LEFT)
            :HideFocus(true)
            :TrackingName("battle_close"))

    self.clickCampaign.tutorialStepData:TrackingID(1)
    self.clickBattle.tutorialStepData:TrackingID(2)
    self.formationBattleClick.tutorialStepData:TrackingID(9)
end

TutorialCampaign2.stepId = 5000

--- @return number
function TutorialCampaign2:GetStepId()
    return TutorialCampaign2.stepId
end

--- @return number
function TutorialCampaign2:CanRunTutorial()
    local canRun = zg.playerData:GetCampaignData().stageIdle == 101001
    if canRun then
        canRun = false
        ---@type FormationInBound
        local formationInBound = zg.playerData:GetFormationInBound()
        if formationInBound ~= nil then
            ---@type TeamFormationInBound
            local teamFormation = formationInBound.teamDict:Get(GameMode.CAMPAIGN)
            if teamFormation ~= nil then
                canRun = true
            end
        end
    end
    return canRun
end

--- @return TutorialNode
function TutorialCampaign2:Continue()
    return TutorialLine.Create(self.clickBattle,
            self.formationBattleClick,
            self.needMorePowerInfo,
            self.forgeEquipmentInfo,
            self.upgradeHeroInfo,
            self.summonHeroInfo,
            self.clickUpgradeHero)
end

--- @return TutorialNode
function TutorialCampaign2:Start()
    return TutorialLine.Create(self.clickCampaign,
            self:Continue()
    )
end