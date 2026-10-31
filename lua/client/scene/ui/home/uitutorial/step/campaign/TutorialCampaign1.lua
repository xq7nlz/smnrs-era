--- @class TutorialCampaign1 : TutorialCampaign
TutorialCampaign1 = Class(TutorialCampaign1, TutorialCampaign)

--- @return void
function TutorialCampaign1:Ctor()
    TutorialCampaign.Ctor(self)

    ---@type TutorialSingle
    self.npcClickCampaign = TutorialSingle.Create(TutorialStepData()
            :Step(TutorialStep.CAMPAIGN_CLICK)
            :ShowNpc(true)
            :TrackingID(1)
            :Focus(TutorialFocus.FOCUS_CLICK)
            :TrackingName("click_campaign_npc")
            :Delay(0.5)
            :KeyLocalize("npc_continue_campaign")
            :Pivot(TutorialPivot.BOTTOM_RIGHT))

    ---@type TutorialNode
    --- Tutorial introduce auto battle
    self.introduceAutoBattle = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_introduce_auto_battle")
            :HideFocus(true)
            :Delay(0.5)
            :ShowNpc(true)
            :Pivot(TutorialPivot.BOTTOM_RIGHT)
            :TrackingName("introduce_auto_battle")
            :TrackingID(3)
    )

    ---@type TutorialNode
    --- Tutorial introduce summoner
    self.introduceSummoner = TutorialSingle.Create(TutorialStepData()
            :Step(TutorialStep.POSITION_SUMMONER)
            :KeyLocalize("npc_introduce_summoner")
            :Delay(0.5)
            :ShowNpc(true)
            :Focus(TutorialFocus.FOCUS)
            :Pivot(TutorialPivot.BOTTOM_RIGHT)
            :TrackingName("introduce_summoner")
            :TrackingID(4)
    )

    ---@type TutorialSingle
    --- Tutorial npc introduce about information buff
    self.formationBuffInfo = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_formation_buff")
            :Delay(0.2):Focus(TutorialFocus.FOCUS)
            :TrackingName("formation_buff")
            :Pivot(TutorialPivot.BOTTOM_RIGHT)
            :Step(TutorialStep.FORMATION_BUFF)
            :ShowNpc(true)
            :TrackingID(5))

    ---@type TutorialSingle
    --- Tutorial click on first hero to bring it to battle
    self.selectHeroFormation = TutorialSingle.Create(TutorialStepData()
            :Step(TutorialStep.FORMATION_SELECT_HERO_1)
            :HideFocus(true)
            :Focus(TutorialFocus.FOCUS_CLICK)
            :KeyLocalize("npc_select_hero_formation")
            :TrackingName("select_hero_formation")
            :Pivot(TutorialPivot.TOP_RIGHT)
            :ShowNpc(true)
            :Delay(0.5)
            :TrackingID(6))

    ---@type TutorialSingle
    --- Tutorial click on position 1 of formation
    self.selectPosition1 = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_formation_change_position")
            :Step(TutorialStep.POSITION_1)
            :TrackingName("select_position_1")
            :Focus(TutorialFocus.FOCUS_CLICK)
            :Delay(0.5)
            :Pivot(TutorialPivot.CENTER)
            :TrackingID(7))

    ---@type TutorialSingle
    --- Tutorial click on position 4 of formation
    self.selectPosition4 = TutorialSingle.Create(TutorialStepData()
            :Step(TutorialStep.POSITION_4)
            :Delay(0.2)
            :TrackingName("select_position_4")
            :Focus(TutorialFocus.FOCUS_CLICK)
            :TrackingID(8))

    ---@type TutorialSingle
    --- Tutorial click on battle in formation view
    self.formationBattleClick = TutorialSingle.Create(TutorialStepData()
            :Step(TutorialStep.FORMATION_BATTLE_CLICK)
            :KeyLocalize("npc_let_battle_commence")
            :Delay(0.2)
            :Pivot(TutorialPivot.TOP_LEFT)
            :HideFocus(true)
            :WaitOpCode(OpCode.CAMPAIGN_CHALLENGE)
            :TrackingName("click_battle_formation")
            :Focus(TutorialFocus.FOCUS_CLICK)
            :TrackingID(9))
    -----@type TutorialSingle
    self.turnMechanic = TutorialSingle.Create(TutorialStepData()
            :Step(TutorialStep.INTRODUCE_TURN_MECHANIC)
            :KeyLocalize("npc_introduce_turn_mechanic")
            :Delay(6)
            :Pivot(TutorialPivot.TOP_LEFT)
            :StepId(self:GetStepId())
            :ShowNpc(true))
    self.clickBattle.tutorialStepData:TrackingID(2)
    self.closeBattle.tutorialStepData:TrackingID(10)
            :KeyLocalize("first_victory")
            :Pivot(TutorialPivot.CENTER)

end

TutorialCampaign1.stepId = TutorialStepID.TUTORIAL_CAMPAIGN_1

--- @return number
function TutorialCampaign1:GetStepId()
    return TutorialCampaign1.stepId
end

--- @return number
function TutorialCampaign1:CanRunTutorial()
    return zg.playerData:GetCampaignData().stageNext == 101001
end

--- @return TutorialNode
function TutorialCampaign1:Continue()
    return TutorialLine.Create(self:TutorialGoToFormationNpc(),
            self.introduceAutoBattle,
            self.introduceSummoner,
            self.formationBuffInfo,
            self.selectHeroFormation,
            self.selectPosition1,
            self.selectPosition4,
            self.formationBattleClick,
            self.turnMechanic,
            self.resumeBattle,
            self.closeBattle)
end

--- @return TutorialNode
function TutorialCampaign1:Start()
    return self:Continue()
end