--- @class TutorialIdleReward : TutorialCampaign
TutorialIdleReward = Class(TutorialIdleReward, TutorialCampaign)

--- @return void
function TutorialIdleReward:Ctor()
    TutorialCampaign.Ctor(self)


    -----@type TutorialSingle
    self.introduceIdleReward1 = TutorialSingle.Create(TutorialStepData()
            :GetTextMethod(function()
                return string.format(LanguageUtils.LocalizeTutorial("npc_idle_reward_1"),
                        math.floor(ResourceMgr.GetCampaignDataConfig():GetMaxTimeIdle() / 3600))
            end
            )
            :Delay(0.5)
            :Pivot(TutorialPivot.TOP_RIGHT)
            :ShowNpc(true))
    ---@type TutorialSingle
    self.idleReward = TutorialSingle.Create(TutorialStepData():GetTextMethod(function ()
        return LanguageUtils.LocalizeTutorial("npc_idle_reward_2")
    end):
    ShowNpc(true):
    TrackingName("idle_reward"):Step(TutorialStep.CAMPAIGN_IDLE_REWARD_CLICK):
    Focus(TutorialFocus.FOCUS_CLICK):
    Delay(1):Pivot(TutorialPivot.TOP_RIGHT):
    WaitOpCode(OpCode.CAMPAIGN_RESOURCE_CLAIM)
            :StepId(self:GetStepId()))


    ---@type TutorialSingle
    --- Tutorial click on battle in formation view
    self.formationBattleClick = TutorialSingle.Create(TutorialStepData()
            :Step(TutorialStep.CAMPAIGN_BATTLE_CLICK)
            :KeyLocalize("npc_let_battle_commence")
            :Delay(0.2)
            :Pivot(TutorialPivot.TOP_LEFT)
            :HideFocus(true)
            :Focus(TutorialFocus.FOCUS_CLICK))
    ---@type TutorialSingle
    self.continueLevelUp = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_level_up")
                                         :ShowNpc(true):
    Step(TutorialStep.CLOSE_POPUP_REWARD):TrackingName("npc_level_up"):Focus(TutorialFocus.TAP_TO_CLICK)
            :Delay(1):
    Pivot(TutorialPivot.TOP_LEFT))

    ---@type TutorialSingle
    self.backCampaignAuto = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.BACK_CAMPAIGN):
    Focus(TutorialFocus.AUTO_NEXT):TrackingName("back_campaign_auto"):Delay(1))

    self.clickCampaign.tutorialStepData:TrackingID(1)
    self.idleReward.tutorialStepData:TrackingID(2)
    self.continueLevelUp.tutorialStepData:TrackingID(3)
    self.backCampaignAuto.tutorialStepData:TrackingID(4)

end

TutorialIdleReward.stepId = TutorialStepID.TUTORIAL_IDLE_REWARD

--- @return number
function TutorialIdleReward:GetStepId()
    return TutorialIdleReward.stepId
end

--- @return number
function TutorialIdleReward:CanRunTutorial()
    return zg.playerData:GetCampaignData().stageIdle == 101001
end

--- @return TutorialNode
function TutorialIdleReward:Continue()
    return TutorialLine.Create(self.introduceIdleReward1,
            self.idleReward,
            self.continueLevelUp,
            self.backCampaignAuto
    )
end

--- @return TutorialNode
function TutorialIdleReward:Start()
    return TutorialLine.Create(self.clickCampaign,
            self:Continue()
    )
end