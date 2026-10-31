--- @class TutorialCampaign3 : TutorialCampaign
TutorialCampaign3 = Class(TutorialCampaign3, TutorialCampaign)

--- @return void
function TutorialCampaign3:Ctor()
    TutorialCampaign.Ctor(self)
    ---@type TutorialSingle
    self.selectHero1 = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_select_hero_continue")
            :Pivot(TutorialPivot.TOP_RIGHT)
            :Step(TutorialStep.FORMATION_SELECT_HERO_1)
            :TrackingName("select_hero_1")
            :Focus(TutorialFocus.FOCUS_CLICK)
            :Delay(0.5):ShowNpc(true))

    ---@type TutorialSingle
    self.endTutorial = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_end_tut")
            :ShowNpc(true)
            :Delay(0.1)
            :TrackingName("npc_end_tut")
            :Pivot(TutorialPivot.CENTER))
    --:Step(TutorialStep.BACK_CAMPAIGN)
    --:Focus(TutorialFocus.TAP_TO_CLICK)

    ---@type TutorialSingle
    self.dragHero = TutorialSingle.Create(TutorialStepData()
            :Pivot(TutorialPivot.BOTTOM_RIGHT)
            :KeyLocalize("npc_drag_hero")
            :TrackingName("drag_hero")
    --Text(string.format(LanguageUtils.LocalizeTutorial("npc_drag_hero"), buffAttack .. "%")):
            :Step(TutorialStep.FORMATION_DRAG_HERO)
            :Focus(TutorialFocus.DRAG)
            :Delay(0.5)
            :ShowNpc(true))

    self.npcClickCampaign.tutorialStepData:TrackingID(1)
    self.clickBattle.tutorialStepData:TrackingID(2)
    self.selectHero1.tutorialStepData:TrackingID(3)
    --self.dragHero.tutorialStepData:TrackingID(4)
    self.formationBattleClickSave.tutorialStepData:TrackingID(5)
    self.closeBattle.tutorialStepData:TrackingID(6)

end

TutorialCampaign3.stepId = 10000

--- @return number
function TutorialCampaign3:GetStepId()
    return TutorialCampaign3.stepId
end

--- @return number
function TutorialCampaign3:CanRunTutorial()
    local canRun = zg.playerData:GetCampaignData().stageIdle == 101001
    if canRun then
        canRun = false
        ---@type FormationInBound
        local formationInBound = zg.playerData:GetFormationInBound()
        if formationInBound ~= nil then
            ---@type TeamFormationInBound
            local teamFormation = formationInBound.teamDict:Get(GameMode.CAMPAIGN)
            if teamFormation ~= nil and teamFormation.backLine:Count() == 1 then
                canRun = true
            end
        end
    end
    return canRun
end

--- @return TutorialNode
function TutorialCampaign3:Continue()
    return TutorialLine.Create(self:TutorialGoToFormationNpc(),
            self.selectHero1,
            --self.dragHero,
            self.formationBattleClickSave,
            self.closeBattle,
            self.endTutorial
    )
end

--- @return TutorialNode
function TutorialCampaign3:Start()
    return self:Continue()
end