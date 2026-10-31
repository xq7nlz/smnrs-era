--- @class TutorialSummon : TutorialBase
TutorialSummon = Class(TutorialSummon, TutorialBase)

--- @return void
function TutorialSummon:Ctor()
    TutorialBase.Ctor(self)

    ---@type TutorialSingle
    self.clickSummon = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_summon_click")
            :Delay(0.2)
            :ShowNpc(true)
            :TrackingID(1)
            :Step(TutorialStep.SUMMON_CLICK)
            :TrackingName("click_summon_main")
            :Focus(TutorialFocus.FOCUS_CLICK)
            :Pivot(TutorialPivot.BOTTOM_RIGHT))

    ---@type TutorialSingle
    self.summon = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_summon_start")
            :HideFocus(true)
            :TrackingID(2)
            :Text1("player_option1_1")
            :TrackingName("summon_info")
            :Text2("player_option2_1")
            :Delay(1))

    ---@type TutorialSingle
    --- Tutorial Npc introduce basic summon hero scroll
    --self.basicInfo = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_basic_summon_info"):ShowNpc(true):TrackingID(3):
    --Step(TutorialStep.BASIC_SUMMON_INFO)                     :TrackingName("summon_basic_info"):Focus(TutorialFocus.FOCUS):Pivot(TutorialPivot.BOTTOM_LEFT))

    ---@type TutorialSingle
    --- Tutorial Npc introduce premium summon hero scroll
    self.heroicInfo = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_heroic_summon_info"):ShowNpc(true):TrackingID(4):
    Step(TutorialStep.HEROIC_SUMMON_INFO)                     :TrackingName("summon_heroic_info"):Focus(TutorialFocus.FOCUS):Pivot(TutorialPivot.BOTTOM_LEFT))

    ---@type TutorialSingle
    --- Tutorial Npc introduce friendship summon hero scroll
    --self.friendInfo = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_friend_summon_info"):ShowNpc(true):TrackingID(5):
    --Step(TutorialStep.FRIEND_SUMMON_INFO)                     :TrackingName("summon_friend_info"):Focus(TutorialFocus.FOCUS):Pivot(TutorialPivot.BOTTOM_LEFT))

    ---@type TutorialSingle
    --- Tutorial Back button in result view after summoning hero
    self.backResult = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.BACK_SUMMON_RESULT_CLICK):HideFocus(true):
    Focus(TutorialFocus.FOCUS_CLICK)                          :TrackingName("back_summon_result"))

    ---@type TutorialSingle
    --- Tutorial Back button in summon view hero
    self.backSummonAuto = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.BACK_SUMMON_CLICK):
    Focus(TutorialFocus.AUTO_NEXT)                                :Delay(0.5):TrackingName("back_summon_auto"))

    ---@type TutorialSingle
    --- Tutorial Click on basic summon scroll tab
    --self.clickBasicSummon = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.CLICK_SUMMON_BASIC):HideFocus(true):
    --Focus(TutorialFocus.FOCUS_CLICK)                                :Delay(0.5):TrackingName("click_summon_basic_tab"))

    ---@type TutorialSingle
    --- Tutorial Click on premium summon scroll tab
    self.clickHeroicSummon = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.CLICK_SUMMON_HEROIC):HideFocus(true):
    Focus(TutorialFocus.FOCUS_CLICK)                                 :Delay(0.5):TrackingName("click_summon_heroic_tab"))

    -----@type TutorialSingle
    --self.backSummonNpc = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_continue_1"):Step(TutorialStep.BACK_SUMMON_CLICK):
    --Focus(TutorialFocus.FOCUS_CLICK)                             :Delay(0.5):Pivot(TutorialPivot.BOTTOM_RIGHT))

    ---@type TutorialSingle
    --- Tutorial Asking click on premium summon scroll tab
    self.pleaseHeroicSummon = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_please_summon_heroic"):Delay(0.2):ShowNpc(true)
                                                                      :Step(TutorialStep.PLEASE_CLICK_SUMMON_HEROIC):TrackingName("please_summon_heroic"):Focus(TutorialFocus.FOCUS_CLICK):Pivot(TutorialPivot.BOTTOM_LEFT))

end

--- @return TutorialNode
--- Tutorial Npc introduce about all summon hero scroll
function TutorialSummon:TutorialSummonInfo()
    return TutorialLine.Create(self.clickSummon, self.heroicInfo, self.friendInfo, self.basicInfo)
end