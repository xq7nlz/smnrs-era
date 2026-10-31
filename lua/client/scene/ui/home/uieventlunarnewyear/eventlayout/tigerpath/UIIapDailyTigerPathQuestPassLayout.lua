--- @class UIIapDailyTigerPathQuestPassLayout : UIIapPassLayout
UIIapDailyTigerPathQuestPassLayout = Class(UIIapDailyTigerPathQuestPassLayout, UIIapPassLayout)

--- @param view UIIapShopView
--- @param parent UnityEngine_RectTransform
--- @param eventTimeType EventTimeType
function UIIapDailyTigerPathQuestPassLayout:Ctor(view, parent, eventTimeType)
    --- @type EventLunarNewYearModel
    self.eventModel = nil
    UIIapPassLayout.Ctor(self, view, parent, eventTimeType)
    self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR_2022
    self.opCodeClaim = OpCode.EVENT_LUNAR_2022_MILESTONE_CLAIM
end

--- @param parent UnityEngine_RectTransform
function UIIapDailyTigerPathQuestPassLayout:InitLayoutConfig(parent)
    self.prefabName = "lunar_new_year_tiger_path_quest_view"
    self.unlockContentKey = "daily_quest_pass_unlock_content"
    UIIapPassLayout.InitLayoutConfig(self, parent)
end

function UIIapDailyTigerPathQuestPassLayout:CheckResourceOnSeason()
end

function UIIapDailyTigerPathQuestPassLayout:InitLocalization()
    self.titleKey = "daily_quest_pass"
    self.layoutConfig.textFreeReward.text = LanguageUtils.LocalizeCommon("free_reward")
    self.layoutConfig.textPremiumReward.text = LanguageUtils.LocalizeCommon("premium_reward")
    self.layoutConfig.textActive.text = LanguageUtils.LocalizeCommon("activated")
    self.layoutConfig.textUnlock.text = LanguageUtils.LocalizeCommon("purchase_items")
    self.layoutConfig.textDesc.text = LanguageUtils.LocalizeCommon("daily_quest_pass_desc")
    self.layoutConfig.tittle.text = LanguageUtils.LocalizeCommon(self.titleKey)
end

function UIIapDailyTigerPathQuestPassLayout:GetGrowthPackLineConfig()
    self.growthPackLineConfig = self.eventModel:GetConfig():GetTigerPathConfig()
end

function UIIapDailyTigerPathQuestPassLayout:UpdateCheckNotification()
    self.view:CheckNotificationDailyQuestPass()
end