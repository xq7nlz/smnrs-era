require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.EventCampaignBoot.UICampaignBootLayout"
--- @class UICampaignBootLayout3 : UINewServerWeekLayout
UICampaignBootLayout3 = Class(UICampaignBootLayout3, UICampaignBootLayout)
--- @param view UINewServerWeekView
--- @param newServerWeekTab NewServerWeekTab
--- @param anchor UnityEngine_RectTransform
function UICampaignBootLayout3:Ctor(view, newServerWeekTab, anchor)
    UICampaignBootLayout.Ctor(self, view, newServerWeekTab,anchor)
    self.tabId = NewServerWeekTab3.CAMPAIGN_BOOT
end

function UICampaignBootLayout3:RequestClaimAll(questIds)
    QuestDataInBound.RequestClaimMultiQuest(OpCode.EVENT_NEW_SERVER_OPEN_3_QUEST_CLAIM, questIds,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questIds)
            end)
end

--- @param objectView UnityEngine_GameObject
function UICampaignBootLayout3:InitLayoutConfig(objectView)
    local inst = PrefabLoadUtils.Instantiate("new_server_campaign_boot_2_layout", self.anchor)
    UINewServerWeekLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
end

