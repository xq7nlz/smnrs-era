--- @class TutorialSkillSummoner : TutorialBase
TutorialSkillSummoner = Class(TutorialSkillSummoner, TutorialBase)

--- @return void
function TutorialSkillSummoner:Ctor(isAttacker)
    TutorialBase.Ctor(self)

    ---@type TutorialStepData
    local summonerInfoStep = TutorialStepData():KeyLocalize("npc_summoner_battle_info"):ShowNpc(true):
    ShowTargetFocus(true):TrackingName("npc_summoner_battle_info"):Step(TutorialStep.SUMMONER_BATTLE_INFO):Focus(TutorialFocus.FOCUS)

    ---@type TutorialStepData
    local summonerAddPowerStep = TutorialStepData():KeyLocalize("npc_add_power_summoner"):
    Step(TutorialStep.SUMMONER_ADD_POWER):TrackingName("npc_add_power_summoner"):Focus(TutorialFocus.FOCUS):Pivot(TutorialPivot.CENTER)

    ---@type TutorialStepData
    local summonerSkillStep = TutorialStepData():KeyLocalize("npc_summoner_skill"):Pivot(TutorialPivot.CENTER):
    Step(TutorialStep.SUMMONER_SKILL):TrackingName("npc_summoner_skill"):Focus(TutorialFocus.FOCUS):StepId(self:GetStepId())

    if isAttacker == true then
        summonerInfoStep:Pivot(TutorialPivot.BOTTOM_RIGHT)
    else
        summonerInfoStep:Pivot(TutorialPivot.BOTTOM_LEFT)
    end

    ---@type TutorialSingle
    self.summonerInfo = TutorialSingle.Create(summonerInfoStep)

    ---@type TutorialSingle
    self.summonerAddPower = TutorialSingle.Create(summonerAddPowerStep)

    ---@type TutorialSingle
    self.summonerSkill = TutorialSingle.Create(summonerSkillStep)

    self.summonerInfo.tutorialStepData:TrackingID(801)
    self.summonerAddPower.tutorialStepData:TrackingID(802)
    self.summonerSkill.tutorialStepData:TrackingID(803)
    self.resumeBattle.tutorialStepData:TrackingID(804)

end

TutorialSkillSummoner.stepId = 22000

--- @return number
function TutorialSkillSummoner:GetStepId()
    return TutorialSkillSummoner.stepId
end

--- @return number
function TutorialSkillSummoner:CanRunTutorial()
    return zg.playerData:GetCampaignData().stageIdle <= 101002
end

--- @return TutorialNode
function TutorialSkillSummoner:Continue()
    return TutorialLine.Create(self.summonerInfo, self.summonerAddPower, self.summonerSkill, self.resumeBattle)
end

--- @return TutorialNode
function TutorialSkillSummoner:Start()
    return self:Continue()
end