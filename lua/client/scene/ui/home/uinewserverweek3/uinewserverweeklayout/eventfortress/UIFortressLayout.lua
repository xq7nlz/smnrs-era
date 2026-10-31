require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.EventVipTreasure.UIVipTreasureLayout"
require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.UINewServerWeekLayout"
--- @class UIFortressLayout : UIVipTreasureLayout
UIFortressLayout = Class(UIFortressLayout, UIVipTreasureLayout)

--- @param view UINewServerWeekView
--- @param newServerWeekTab NewServerWeekTab3
--- @param anchor UnityEngine_RectTransform
function UIFortressLayout:Ctor(view, newServerWeekTab, anchor)
    UIVipTreasureLayout.Ctor(self, view, newServerWeekTab,anchor)
    self.tabId = NewServerWeekTab3.FORTRESS
end

function UIFortressLayout:RequestClaimAll(questIds)
    QuestDataInBound.RequestClaimMultiQuest(OpCode.EVENT_NEW_SERVER_OPEN_3_QUEST_CLAIM, questIds,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questIds)
            end)
end


--- @param objectView UnityEngine_GameObject
function UIFortressLayout:InitLayoutConfig(objectView)
    local inst = PrefabLoadUtils.Instantiate("new_server_fortress_layout", self.anchor)
    UINewServerWeekLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
end

function UIFortressLayout:InitLocalization()
    self.layoutConfig.packageTitle.text = LanguageUtils.LocalizeCommon("new_server_fortress")
    self.layoutConfig.desc.text = LanguageUtils.LocalizeCommon("new_server_fortress_desc")
    self.layoutConfig.claimAllText.text = LanguageUtils.LocalizeCommon("claim_all")
    self.layoutConfig.claimAllDesc.text = LanguageUtils.LocalizeCommon("claim_all_desc")
end