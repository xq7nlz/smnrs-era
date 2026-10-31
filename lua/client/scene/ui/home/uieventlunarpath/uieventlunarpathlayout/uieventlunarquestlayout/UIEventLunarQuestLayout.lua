--- @class UIEventLunarQuestLayout : UIEventLunarPathLayout
UIEventLunarQuestLayout = Class(UIEventLunarQuestLayout, UIEventLunarPathLayout)

--- @param view UIEventLunarPathView
--- @param lunarPathTab LunarPathTab
--- @param anchor UnityEngine_RectTransform
function UIEventLunarQuestLayout:Ctor(view, lunarPathTab, anchor)
    --- @type LunarQuestLayoutConfig
    self.layoutConfig = nil
    --- @type Dictionary
    self.questConfig = nil
    --- @type UILoopScroll
    self.scrollLoopContent = nil
    UIEventLunarPathLayout.Ctor(self, view, lunarPathTab, anchor)
end

function UIEventLunarQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("lunar_path_quest_layout", self.anchor)
    UIEventLunarPathLayout.InitLayoutConfig(self, inst)
    self:InitLocalization()
    self:InitButtonListener()
    self:InitScroll()
end

function UIEventLunarQuestLayout:InitScroll()
    --- @param questId number
    local onClickClaim = function(questId)
        --- @param rewardList List
        local onClaimSuccess = function(rewardList)
            PopupUtils.ClaimAndShowRewardList(rewardList)
            self:OnClaimQuestSuccess(questId)
        end
        QuestDataInBound.RequestClaimQuest(OpCode.EVENT_LUNAR_NEW_YEAR_QUEST_CLAIM, questId, onClaimSuccess)
    end

    --- @param questId number
    --- @param questElementConfig QuestElementConfig
    local onClickGo = function(questId, questElementConfig)
        self:OnClickGo(questId, questElementConfig)
    end

    --- @param obj UIEventQuestItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        QuestDataInBound.OnCreateQuestItem(obj, dataIndex, self.eventModel.listQuest, self.questConfig,
                onClickClaim, onClickGo)
    end
    self.scrollLoopContent = UILoopScroll(self.layoutConfig.scrollQuest, UIPoolType.EventQuestItem, onCreateItem)
    self.scrollLoopContent:SetUpMotion(MotionConfig())
end

function UIEventLunarQuestLayout:InitLocalization()
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("lunar_path_quest_title")
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("lunar_path_quest_desc")
end

function UIEventLunarQuestLayout:InitButtonListener()

end

function UIEventLunarQuestLayout:GetModelConfig()
    UIEventLunarPathLayout.GetModelConfig(self)
    self.questConfig = self.eventConfig:GetQuestConfig()
end

function UIEventLunarQuestLayout:OnShow()
    UIEventLunarPathLayout.OnShow(self)
    self:UpdateView()
end

function UIEventLunarQuestLayout:OnHide()
    UIEventLunarPathLayout.OnHide(self)
    self.scrollLoopContent:Hide()
end

function UIEventLunarQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(UIPopupName.UIEventLunarPath)
    end)
end

function UIEventLunarQuestLayout:OnClaimQuestSuccess(questId)
    self.eventModel:OnClaimQuestSuccess(questId)
    self:UpdateView()
end

function UIEventLunarQuestLayout:UpdateView()
    self.scrollLoopContent:Resize(self.eventModel.listQuest:Count())
    self.view:UpdateNotificationByTab(self.lunarPathTab)
end