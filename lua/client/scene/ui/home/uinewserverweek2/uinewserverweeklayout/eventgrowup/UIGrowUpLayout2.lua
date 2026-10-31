require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.UINewServerWeekLayout"
require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.EventGrowUp.UIGrowUpLayout"
--- @class UIGrowUpLayout2 : UIGrowUpLayout
UIGrowUpLayout2 = Class(UIGrowUpLayout2, UIGrowUpLayout)

--- @param view UINewServerWeekView
--- @param newServerWeekTab NewServerWeekTab
--- @param anchor UnityEngine_RectTransform
function UIGrowUpLayout2:Ctor(view, newServerWeekTab, anchor)
    UIGrowUpLayout.Ctor(self, view, newServerWeekTab,anchor)
    --- @type number
    self.tabId = NewServerWeekTab2.GROW_UP
end

function UIGrowUpLayout2:RequestClaimAll(questIds)
    QuestDataInBound.RequestClaimMultiQuest(OpCode.EVENT_NEW_SERVER_OPEN_2_QUEST_CLAIM, questIds,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questIds)
            end)
end

--- @param objectView UnityEngine_GameObject
function UIGrowUpLayout2:InitLayoutConfig(objectView)
    local inst = PrefabLoadUtils.Instantiate("new_server_grow_up_2_layout", self.anchor)
    UINewServerWeekLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
end
function UIGrowUpLayout2:InitLocalization()
    self.layoutConfig.textGuide.text = LanguageUtils.LocalizeCommon("new_server_grow_up_guide")
    self.layoutConfig.packageTitle.text = LanguageUtils.LocalizeCommon("new_server_grow_up_2")
    self.layoutConfig.desc.text = LanguageUtils.LocalizeCommon("new_server_grow_up_2_desc")
    self.layoutConfig.claimAllText.text = LanguageUtils.LocalizeCommon("claim_all")
end
function UIGrowUpLayout2:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("help_grow_up_2"))
end

