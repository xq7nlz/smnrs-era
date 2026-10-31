require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.UINewServerWeekLayout"
require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.EventGrowUp.UIGrowUpLayout"
--- @class UIGrowUpLayout3 : UIGrowUpLayout
UIGrowUpLayout3 = Class(UIGrowUpLayout3, UIGrowUpLayout)

--- @param view UINewServerWeekView
--- @param newServerWeekTab NewServerWeekTab
--- @param anchor UnityEngine_RectTransform
function UIGrowUpLayout3:Ctor(view, newServerWeekTab, anchor)
    UIGrowUpLayout.Ctor(self, view, newServerWeekTab,anchor)
    --- @type number
    self.tabId = NewServerWeekTab3.GROW_UP
end

function UIGrowUpLayout3:RequestClaimAll(questIds)
    QuestDataInBound.RequestClaimMultiQuest(OpCode.EVENT_NEW_SERVER_OPEN_3_QUEST_CLAIM, questIds,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questIds)
            end)
end

--- @param objectView UnityEngine_GameObject
function UIGrowUpLayout3:InitLayoutConfig(objectView)
    local inst = PrefabLoadUtils.Instantiate("new_server_grow_up_3_layout", self.anchor)
    UINewServerWeekLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
end
function UIGrowUpLayout3:InitLocalization()
    self.layoutConfig.textGuide.text = LanguageUtils.LocalizeCommon("new_server_grow_up_guide")
    self.layoutConfig.packageTitle.text = LanguageUtils.LocalizeCommon("new_server_grow_up_3")
    self.layoutConfig.desc.text = LanguageUtils.LocalizeCommon("new_server_grow_up_3_desc")
    self.layoutConfig.claimAllText.text = LanguageUtils.LocalizeCommon("claim_all")
end
function UIGrowUpLayout3:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("help_grow_up_3"))
end

