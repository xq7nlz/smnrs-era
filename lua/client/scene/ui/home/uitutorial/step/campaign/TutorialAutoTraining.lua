--- @class TutorialAutoTraining : TutorialCampaign
TutorialAutoTraining = Class(TutorialAutoTraining, TutorialCampaign)

--- @return void
function TutorialAutoTraining:Ctor()
    TutorialCampaign.Ctor(self)

    ---@type TutorialNode
    self.stage10 = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_stage_10"):
    Step(TutorialStep.STAGE10_INFO)                        :Focus(TutorialFocus.FOCUS):Delay(0.2):
    Pivot(TutorialPivot.TOP_RIGHT))

    ---@type TutorialNode
    self.clickTraining = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_training_team"):
    Step(TutorialStep.CLICK_TRAINING)                            :Focus(TutorialFocus.FOCUS_CLICK):Delay(0.2):
    Pivot(TutorialPivot.TOP_LEFT))

    ---@type TutorialNode
    self.selectHero1 = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_select_hero_training"):
    Step(TutorialStep.SELECT_HERO_TRAINING_1)                  :Focus(TutorialFocus.FOCUS_CLICK):Delay(0.5):
    Pivot(TutorialPivot.BOTTOM_LEFT))

    ---@type TutorialNode
    self.selectHero2 = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.SELECT_HERO_TRAINING_2):
    Focus(TutorialFocus.FOCUS_CLICK):Delay(0.5))

    ---@type TutorialNode
    self.npcTrainingInfo = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.TRAINING_INFO):
    Focus(TutorialFocus.FOCUS)                                     :Delay(0.5):KeyLocalize("npc_training_info"):Pivot(TutorialPivot.BOTTOM_LEFT):
    Text1("player_option1"))

    ---@type TutorialNode
    self.saveTraining = TutorialSingle.Create(TutorialStepData():
    Step(TutorialStep.SAVE_TRAINING):Focus(TutorialFocus.FOCUS_CLICK):StepId(self:GetStepId()):Delay(0.5))

    ---@type TutorialNode
    self.endTraining = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_nice"):
    Step(TutorialStep.CLOSE_AUTO_TEAM)                         :Pivot(TutorialPivot.BOTTOM_LEFT):Focus(TutorialFocus.FOCUS_CLICK):
    Delay(0.2))

end

TutorialAutoTraining.stepId = 15000

--- @return number
function TutorialAutoTraining:GetStepId()
    return TutorialAutoTraining.stepId
end

--- @return number
function TutorialAutoTraining:CanRunTutorial()
    ---@type List
    local heroResourceList = List()
    ---@param v HeroResource
    for _, v in pairs(InventoryUtils.Get(ResourceType.Hero):GetItems()) do
        if v.heroStar <= ResourceMgr.GetCampaignDataConfig().campaignConfig.trainStarMax then
            heroResourceList:Add(v)
        end
    end
    return heroResourceList:Count() >= 2 and zg.playerData:GetCampaignData().trainingSlotExp:Count() == 0
end

--- @return TutorialNode
function TutorialAutoTraining:Continue()
    return TutorialLine.Create(self.stage10,
            self.clickTraining,
            self.selectHero1,
            self.selectHero2,
            self.saveTraining,
            self.npcTrainingInfo,
            self.endTraining,
            self.backCampaign
    )
end

--- @return TutorialNode
function TutorialAutoTraining:Start()
    return TutorialLine.Create(self.clickCampaign,
            self:Continue()
    )
end