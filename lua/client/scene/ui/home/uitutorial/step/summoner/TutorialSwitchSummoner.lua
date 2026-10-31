--- @class TutorialSwitchSummoner : TutorialCampaign
TutorialSwitchSummoner = Class(TutorialSwitchSummoner, TutorialCampaign)

--- @return void
function TutorialSwitchSummoner:Ctor()
    ---@type TutorialSingle
    self.clickSummoner = TutorialSingle.Create(TutorialStepData():Delay(0.2):
    Step(TutorialStep.CLICK_SUMMONER):TrackingName("click_summoner"):Focus(TutorialFocus.FOCUS_CLICK):Pivot(TutorialPivot.BOTTOM_RIGHT))

    ---@type TutorialSingle
    self.npc5Summoner = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_5summoner"):Focus(TutorialFocus.FOCUS):
    Step(TutorialStep.ALL_SUMMONER):TrackingName("summoner_info"):Pivot(TutorialPivot.BOTTOM_RIGHT):Delay(0.8):ShowNpc(true))

    ---@type TutorialSingle
    self.npcSummoner1 = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_summoner_class_1"):ShowNpc(true):
    Step(TutorialStep.SUMMONER_CLASS_1):TrackingName("summoner_info1"):Pivot(TutorialPivot.BOTTOM_RIGHT):Focus(TutorialFocus.FOCUS):Delay(0.2))

    ---@type TutorialSingle
    self.npcSummoner2 = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_summoner_class_2"):ShowNpc(true):
    Step(TutorialStep.SUMMONER_CLASS_2):TrackingName("summoner_info2"):Pivot(TutorialPivot.BOTTOM_RIGHT):Focus(TutorialFocus.FOCUS):Delay(0.2))

    ---@type TutorialSingle
    self.npcSummoner3 = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_summoner_class_3"):ShowNpc(true):
    Step(TutorialStep.SUMMONER_CLASS_3):TrackingName("summoner_info3"):Pivot(TutorialPivot.BOTTOM_RIGHT):Focus(TutorialFocus.FOCUS):Delay(0.2))

    ---@type TutorialSingle
    self.npcSummoner4 = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_summoner_class_4"):ShowNpc(true):
    Step(TutorialStep.SUMMONER_CLASS_4):TrackingName("summoner_info4"):Pivot(TutorialPivot.TOP_RIGHT):Focus(TutorialFocus.FOCUS):Delay(0.2))

    ---@type TutorialSingle
    self.npcSummoner5 = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_summoner_class_5"):ShowNpc(true):
    Step(TutorialStep.SUMMONER_CLASS_5):TrackingName("summoner_info5"):Pivot(TutorialPivot.TOP_RIGHT):Focus(TutorialFocus.FOCUS):Delay(0.2))

    ---@type TutorialSingle
    self.npcSwitchSummoner = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_switch_summoner"):
    ShowNpc(true):TrackingName("click_switch"):
    Step(TutorialStep.SWITCH_SUMMONER):Pivot(TutorialPivot.TOP_RIGHT):Focus(TutorialFocus.FOCUS_CLICK):Delay(0.5))

    ---@type TutorialSingle
    self.confirmSwitch = TutorialSingle.Create(TutorialStepData()
            :Step(TutorialStep.CLICK_NOTIFICATION_OPTION_2)
            :Focus(TutorialFocus.FOCUS_CLICK)
            :StepId(self:GetStepId())
            :Delay(0.5)
            :WaitOpCode(OpCode.SUMMONER_CLASS_SELECT)
            :TrackingName("confirm_switch")
    )

    ---@type TutorialSingle
    self.npcEnd = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_end_summoner"):ShowNpc(true):
    Pivot(TutorialPivot.BOTTOM_LEFT):TrackingName("npc_end_summoner"):Delay(0.5))

    self.clickSummoner.tutorialStepData:TrackingID(1)
    self.npc5Summoner.tutorialStepData:TrackingID(2)
    self.npcSummoner1.tutorialStepData:TrackingID(3)
    self.npcSummoner2.tutorialStepData:TrackingID(4)
    self.npcSummoner3.tutorialStepData:TrackingID(5)
    self.npcSummoner4.tutorialStepData:TrackingID(6)
    self.npcSummoner5.tutorialStepData:TrackingID(7)
    self.npcSwitchSummoner.tutorialStepData:TrackingID(8)
    self.confirmSwitch.tutorialStepData:TrackingID(9)
    self.npcEnd.tutorialStepData:TrackingID(10)

end

TutorialSwitchSummoner.stepId = 20000

--- @return number
function TutorialSwitchSummoner:GetStepId()
    return TutorialSwitchSummoner.stepId
end

--- @return TutorialNode
function TutorialSwitchSummoner:Continue()
    return TutorialLine.Create(self.npc5Summoner,
            self.npcSummoner1, self.npcSummoner2, self.npcSummoner3,
            self.npcSummoner4, self.npcSummoner5, self.npcSwitchSummoner, self.confirmSwitch, self.npcEnd
    )
end

--- @return number
function TutorialSwitchSummoner:CanRunTutorial()
    ---@type PlayerSummonerInBound
    local summonerData = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
    return summonerData.star == 4
            and summonerData.summonerId ~= HeroClassType.RANGER
end

--- @return TutorialNode
function TutorialSwitchSummoner:Start()
    return TutorialLine.Create(self.clickSummoner, self:Continue()
    )
end