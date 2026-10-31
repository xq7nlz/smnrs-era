--- @class UIBossChallengeQuestLayout : UIEventBossChallengeLayout
UIBossChallengeQuestLayout = Class(UIBossChallengeQuestLayout, UIEventBossChallengeLayout)

--- @param view UIEventBossChallenge
--- @param eventBossChallengeTab EventBossChallengeTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIBossChallengeQuestLayout:Ctor(view, eventBossChallengeTab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    --- @type UIBossChallengeQuestLayoutConfig
    self.layoutConfig = nil
    UIEventBossChallengeLayout.Ctor(self, view, eventBossChallengeTab, anchor)
end

function UIBossChallengeQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_boss_challenge_quest_layout", self.anchor)
    UIEventBossChallengeLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:CreateQuestList()
    self:InitUpdateTime()

end

function UIBossChallengeQuestLayout:InitLocalization()
    self.layoutConfig.packageTitle.text = LanguageUtils.LocalizeCommon("event_boss_challenge_quest_title")
    self.layoutConfig.desc.text = LanguageUtils.LocalizeCommon("event_boss_challenge_desc")
end

function UIBossChallengeQuestLayout:SetUpLayout()
    UIEventBossChallengeLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIBossChallengeQuestLayout:InitButtons()

end

function UIBossChallengeQuestLayout:OnShow()
    UIEventBossChallengeLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
    self:StartUpdateTime()
end

function UIBossChallengeQuestLayout:ReturnPoolScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIBossChallengeQuestLayout:OnHide()
    self:ReturnPoolScroll()
    self:RemoveUpdateTime()
    UIEventBossChallengeLayout.OnHide(self)
end

function UIBossChallengeQuestLayout:CreateQuestList()
    --- @param obj UIEventBossChallengeQuestItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type QuestUnitInBound
        local questUnitInBound = self.listQuestData:Get(dataIndex)
        obj:SetData(questUnitInBound.config, questUnitInBound)
        if questUnitInBound.config:IsFeatureMappingAvailable() then
            obj:SetButtonGotoData(function()
                self:OnClickGo(questUnitInBound.questId, questUnitInBound.config)
            end)
        end
        obj:AddClaimListener(function()
            self:OnClickClaim(questUnitInBound.questId, questUnitInBound)
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.UIEventBossChallengeQuestItem, onCreateItem)
end

function UIBossChallengeQuestLayout:OnClickClaim(questId, questUnitInBound)
    local opcode = OpCode.EVENT_BOSS_CHALLENGE_QUEST_CLAIM
    QuestDataInBound.RequestClaimQuest(opcode, questId,
            function(rewardList)
                TrackingUtils.AddFirebaseEventWithArgs(FBEvents.EARN_RESOURCE,
                        FBEvents.ITEM_BRAND, questUnitInBound.config:GetMainRewardData().type,
                        FBEvents.ITEM_ID, questUnitInBound.config:GetMainRewardData().id,
                        FBEvents.VALUE, questUnitInBound.config:GetMainRewardData().number,
                        FBEvents.SOURCE, "event_boss_challenge_quest_claim",
                        FBEvents.SOURCE_ID, questUnitInBound.config.orderInGroup)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

function UIBossChallengeQuestLayout:OnClaimQuestSuccess(questId)
    self.eventModel:OnClaimQuestDailySuccess(questId)
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(EventBossChallengeTab.BOSS_QUEST)
end

function UIBossChallengeQuestLayout:OnUpdateListQuest()
    self.listQuestData = self.eventModel:GetListSortedDailyQuestData()
    local count = self.listQuestData:Count()
    self.uiScroll:Resize(count)
end

function UIBossChallengeQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.view.model.uiName)
    end)
end

function UIBossChallengeQuestLayout:InitUpdateTime()
    self.layoutConfig.time.gameObject:SetActive(true)
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.layoutConfig.time.text = string.format(LanguageUtils.LocalizeCommon("refresh_in"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end