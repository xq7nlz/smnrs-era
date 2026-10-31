--- @class UIEventMergeServerDailyQuestLayout : UIEventMergeServerLayout
UIEventMergeServerDailyQuestLayout = Class(UIEventMergeServerDailyQuestLayout, UIEventMergeServerLayout)

--- @param view UIEventMergeServerView
--- @param eventTimeType EventTimeType
--- @param anchor UnityEngine_RectTransform
function UIEventMergeServerDailyQuestLayout:Ctor(view, eventTimeType, anchor)
    --- @type UIEventMergeServerDailyQuestLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.scrollQuest = nil
    --- @type EventMergeServerModel
    self.eventModel = nil

    UIEventMergeServerLayout.Ctor(self, view, eventTimeType, anchor)
end

function UIEventMergeServerDailyQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_merge_server_quest", self.anchor)
    UIEventMergeServerLayout.InitLayoutConfig(self, inst)

    self:InitLocalization()

    self:InitScrollQuest()
end

function UIEventMergeServerDailyQuestLayout:InitScrollQuest()
    --- @param obj UIEventQuestItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type QuestUnitInBound
        local questData = self.eventModel.listQuestData:Get(dataIndex)
        obj:SetData(questData.config, questData)
        if questData.config:IsFeatureMappingAvailable() then
            obj:AddGoListener(function()
                self:OnClickGo(questData.questId, questData.config)
            end)
        end
        obj:AddClaimListener(function()
            self:OnClickClaim(questData.questId)
        end)
    end
    self.scrollQuest = UILoopScroll(self.layoutConfig.scrollQuest, UIPoolType.EventQuestItem, onCreateItem)
    self.scrollQuest:SetUpMotion(MotionConfig())
end

function UIEventMergeServerDailyQuestLayout:InitLocalization()
    UIEventMergeServerLayout.InitLocalization(self)

    self.layoutConfig.textTittle.text = LanguageUtils.LocalizeCommon("event_merge_server_quest_tittle")
    self.layoutConfig.textDesc.text = LanguageUtils.LocalizeCommon("event_merge_server_quest_desc")
end

function UIEventMergeServerDailyQuestLayout:GetModelConfig()
    UIEventMergeServerLayout.GetModelConfig(self)

    self.questConfig = self.eventConfig:GetQuestConfig()
end

function UIEventMergeServerDailyQuestLayout:OnShow()
    UIEventMergeServerLayout.OnShow(self)

    self.scrollQuest:Resize(self.eventModel.listQuestData:Count())
end

function UIEventMergeServerDailyQuestLayout:OnHide()
    UIEventMergeServerLayout.OnHide(self)
    self.scrollQuest:Hide()
end

function UIEventMergeServerDailyQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.model.uiName)
    end)
end

function UIEventMergeServerDailyQuestLayout:OnClickClaim(questId)
    self.eventModel:RequestClaimQuest(questId, function()
        self.scrollQuest:Resize(self.eventModel.listQuestData:Count())

        self.view:UpdateNotificationByTab(MergeServerTab.QUEST)
    end)
end