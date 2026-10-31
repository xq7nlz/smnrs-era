--- @class TutorialBlackMarket : TutorialCampaign
TutorialBlackMarket = Class(TutorialBlackMarket, TutorialCampaign)

--- @return void
function TutorialBlackMarket:Ctor()
    TutorialCampaign.Ctor(self)

    ---@type TutorialSingle
    self.clickBlackMarket = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_black_market")
            :ShowNpc(true)
            :Step(TutorialStep.BLACK_MARKET_CLICK)
            :TrackingName("click_black_market")
            :Focus(TutorialFocus.FOCUS_CLICK)
            :Delay(0.5)
            :Pivot(TutorialPivot.TOP_RIGHT))

    ---@type TutorialSingle
    self.buyHeroicScroll = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_buy_heroic_scroll")
            :ShowNpc(true)
            :Step(TutorialStep.BUY_HEROIC_SCROLL)
            :Focus(TutorialFocus.FOCUS_CLICK)
            :Delay(0.5)
            :TrackingName("click_buy_scroll")
            :Pivot(TutorialPivot.BOTTOM_LEFT))

    ---@type TutorialSingle
    self.clickNotificationOption2 = TutorialSingle.Create(TutorialStepData()
            :Step(TutorialStep.CLICK_NOTIFICATION_OPTION_2)
            :Focus(TutorialFocus.FOCUS_CLICK)
            :StepId(self:GetStepId())
            :Delay(0.5)
            :WaitOpCode(OpCode.TUTORIAL_MARKET_BUY)
            :TrackingName("click_ok"))

    ---@type TutorialSingle
    self.refundBuy = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_buy_scroll_success")
            :TrackingName("refund_buy_scroll")
            :Step(TutorialStep.REFUND_BUY_SCROLL)
            :Pivot(TutorialPivot.BOTTOM_RIGHT)
            :Focus(TutorialFocus.TAP_TO_CLICK)
            :ShowNpc(true)
            :Delay(1))

    ---@type TutorialSingle
    self.back = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_claim_black_market")
            :TrackingName("back_black_market")
            :Step(TutorialStep.BACK_BLACK_MARKET)
            :Pivot(TutorialPivot.TOP_LEFT)
            :Focus(TutorialFocus.TAP_TO_CLICK)
            :Delay(0.5)
            :ShowNpc(true))

    self.clickBlackMarket.tutorialStepData:TrackingID(1)
    self.buyHeroicScroll.tutorialStepData:TrackingID(2)
    self.clickNotificationOption2.tutorialStepData:TrackingID(3)
    self.refundBuy.tutorialStepData:TrackingID(4)
    self.back.tutorialStepData:TrackingID(5)
end

TutorialBlackMarket.stepId = 7000

--- @return number
function TutorialBlackMarket:GetStepId()
    return TutorialBlackMarket.stepId
end

--- @return number
function TutorialBlackMarket:CanRunTutorial()
    return InventoryUtils.GetMoney(MoneyType.SUMMON_HEROIC_SCROLL) == 0
            and InventoryUtils.Get(ResourceType.Hero):Count() == 2
end

--- @return TutorialNode
function TutorialBlackMarket:Continue()
    return TutorialLine.Create(
            self.clickBlackMarket,
            self.buyHeroicScroll,
            self.clickNotificationOption2,
            self.refundBuy,
            self.back)
end

--- @return TutorialNode
function TutorialBlackMarket:Start()
    return self:Continue()
end