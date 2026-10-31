--- @class UIEventMergeServerAccumulationLayout : UIEventMergeServerLayout
UIEventMergeServerAccumulationLayout = Class(UIEventMergeServerAccumulationLayout, UIEventMergeServerLayout)

--- @param view UIEventMergeServerView
--- @param eventTimeType EventTimeType
--- @param anchor UnityEngine_RectTransform
function UIEventMergeServerAccumulationLayout:Ctor(view, eventTimeType, anchor)
    --- @type UIEventMergeServerAccumulationLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.scrollQuest = nil
    --- @type EventMergeServerModel
    self.eventModel = nil

    UIEventMergeServerLayout.Ctor(self, view, eventTimeType, anchor)
end

function UIEventMergeServerAccumulationLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_merge_server_accumulation", self.anchor)
    UIEventMergeServerLayout.InitLayoutConfig(self, inst)

    self:InitLocalization()

    self:InitScrollQuest()
end

function UIEventMergeServerAccumulationLayout:InitScrollQuest()
    --- @param obj UIEventQuestItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local index = index + 1
        --- @type QuestUnitInBound
        local questData = self.eventModel.listAccumulateQuest:Get(index)
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

function UIEventMergeServerAccumulationLayout:InitLocalization()
    UIEventMergeServerLayout.InitLocalization(self)

    self.layoutConfig.textTittle.text = LanguageUtils.LocalizeCommon("event_merge_server_accumulation_tittle")
    self.layoutConfig.textDesc.text = LanguageUtils.LocalizeCommon("event_merge_server_accumulation_desc")
end

function UIEventMergeServerAccumulationLayout:GetModelConfig()
    UIEventMergeServerLayout.GetModelConfig(self)
    --- @type Dictionary
    self.questConfig = self.eventConfig:GetAccumulateQuestConfig()
end

function UIEventMergeServerAccumulationLayout:OnShow()
    UIEventMergeServerLayout.OnShow(self)

    self.eventModel:UpdateAccumulationProgress()
    self.scrollQuest:Resize(self.eventModel.listAccumulateQuest:Count())
end

function UIEventMergeServerAccumulationLayout:OnHide()
    UIEventMergeServerLayout.OnHide(self)
    self.scrollQuest:Hide()
end

function UIEventMergeServerAccumulationLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.model.uiName)
    end)
end

function UIEventMergeServerAccumulationLayout:OnClickClaim(questId)
    self.eventModel:RequestClaimAccumulateQuest(questId, function()
        self.eventModel:UpdateAccumulationProgress()
        self.scrollQuest:Resize(self.eventModel.listAccumulateQuest:Count())
        self.view:UpdateNotificationByTab(MergeServerTab.ACCUMULATION)
    end)
end