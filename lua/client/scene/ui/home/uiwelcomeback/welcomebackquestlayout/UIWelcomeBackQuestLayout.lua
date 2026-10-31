--- @class UIWelcomeBackQuestLayout : UIWelcomeBackLayout
UIWelcomeBackQuestLayout = Class(UIWelcomeBackQuestLayout, UIWelcomeBackLayout)

--- @param view UIWelcomeBackView
--- @param welcomeBackTab WelcomeBackTab
--- @param anchor UnityEngine_RectTransform
function UIWelcomeBackQuestLayout:Ctor(view, welcomeBackTab, anchor)
    --- @type WelcomeBackQuestLayoutConfig
    self.layoutConfig = nil
    --- @type Dictionary
    self.questConfig = nil
    --- @type UILoopScroll
    self.scrollLoopContent = nil
    --- @type WelcomeBackInBound
    self.welcomeBackInBound = nil
    UIWelcomeBackLayout.Ctor(self, view, welcomeBackTab, anchor)
end

function UIWelcomeBackQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("welcome_back_quest_layout", self.anchor)
    UIWelcomeBackLayout.InitLayoutConfig(self, inst)

    self:InitLocalization()

    self:InitButtonListener()

    self:InitScroll()
end

function UIWelcomeBackQuestLayout:InitScroll()
    --- @param questId number
    local onClickClaim = function(questId)
        --- @param rewardList List
        local onClaimSuccess = function(rewardList)
            PopupUtils.ClaimAndShowRewardList(rewardList)
            self:OnClaimQuestSuccess(questId)
        end
        QuestDataInBound.RequestClaimQuest(OpCode.COMEBACK_DAILY_QUEST, questId, onClaimSuccess)
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
        QuestDataInBound.OnCreateQuestItem(obj, dataIndex, self.welcomeBackInBound.listDailyQuest, self.questConfig,
                onClickClaim, onClickGo)
    end
    self.scrollLoopContent = UILoopScroll(self.layoutConfig.scrollQuest, UIPoolType.EventQuestItem, onCreateItem)
    self.scrollLoopContent:SetUpMotion(MotionConfig())
end

function UIWelcomeBackQuestLayout:InitLocalization()
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("welcome_back_quest_title")
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("welcome_back_quest_desc")
end

function UIWelcomeBackQuestLayout:InitButtonListener()

end

function UIWelcomeBackQuestLayout:OnShow()
    self.welcomeBackInBound = self.view.welcomeBackInBound
    self.questConfig = self.welcomeBackInBound.questConfig

    UIWelcomeBackLayout.OnShow(self)
    self:UpdateView()
end

function UIWelcomeBackQuestLayout:OnHide()
    UIWelcomeBackLayout.OnHide(self)
    self.scrollLoopContent:Hide()
end

function UIWelcomeBackQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(UIPopupName.UIWelcomeBack)
    end)
end

function UIWelcomeBackQuestLayout:OnClaimQuestSuccess(questId)
    self.welcomeBackInBound:OnClaimQuestSuccess(questId)
    self:UpdateView()
end

function UIWelcomeBackQuestLayout:UpdateView()
    self.scrollLoopContent:Resize(self.welcomeBackInBound.listDailyQuest:Count())
    self.view:UpdateNotificationByTab(self.welcomeBackTab)
end