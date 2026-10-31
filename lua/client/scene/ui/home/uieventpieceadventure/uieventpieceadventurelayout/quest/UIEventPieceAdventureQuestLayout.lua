--- @class UIEventPieceAdventureQuestLayout : UIEventPieceAdventureLayout
UIEventPieceAdventureQuestLayout = Class(UIEventPieceAdventureQuestLayout, UIEventPieceAdventureLayout)

--- @param view UIEventPieceAdventure
--- @param eventPieceAdventureTab EventPieceAdventureTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIEventPieceAdventureQuestLayout:Ctor(view, eventPieceAdventureTab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    --- @type UIEventPieceAdventureQuestLayoutConfig
    self.layoutConfig = nil
    UIEventPieceAdventureLayout.Ctor(self, view, eventPieceAdventureTab, anchor)
end

function UIEventPieceAdventureQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_piece_adventure_quest_layout", self.anchor)
    UIEventPieceAdventureLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:CreateQuestList()
    self:InitUpdateTime()
end

function UIEventPieceAdventureQuestLayout:InitLocalization()
    self.layoutConfig.packageTitle.text = LanguageUtils.LocalizeCommon("event_piece_adventure_quest_title")
    self.layoutConfig.desc.text = LanguageUtils.LocalizeCommon("event_piece_adventure_desc")
end

function UIEventPieceAdventureQuestLayout:SetUpLayout()
    UIEventPieceAdventureLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventPieceAdventureQuestLayout:InitButtons()

end

function UIEventPieceAdventureQuestLayout:OnShow()
    UIEventPieceAdventureLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
    self:StartUpdateTime()
end

function UIEventPieceAdventureQuestLayout:ReturnPoolScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIEventPieceAdventureQuestLayout:OnHide()
    self:ReturnPoolScroll()
    self:RemoveUpdateTime()
    UIEventPieceAdventureLayout.OnHide(self)
end

function UIEventPieceAdventureQuestLayout:CreateQuestList()
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
            self:OnClickClaim(questUnitInBound.questId)
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.UIEventBossChallengeQuestItem, onCreateItem)
end

function UIEventPieceAdventureQuestLayout:OnClickClaim(questId)
    local opcode = OpCode.EVENT_PIECE_ADVENTURE_QUEST_CLAIM
    QuestDataInBound.RequestClaimQuest(opcode, questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

function UIEventPieceAdventureQuestLayout:OnClaimQuestSuccess(questId)
    self.eventModel:OnClaimQuestDailySuccess(questId)
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(EventPieceAdventureTab.DAILY_QUEST)
end

function UIEventPieceAdventureQuestLayout:OnUpdateListQuest()
    self.listQuestData = self.eventModel:GetListSortedDailyQuestData()
    local count = self.listQuestData:Count()
    self.uiScroll:Resize(count)
end

function UIEventPieceAdventureQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.view.model.uiName)
    end)
end

function UIEventPieceAdventureQuestLayout:InitUpdateTime()
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