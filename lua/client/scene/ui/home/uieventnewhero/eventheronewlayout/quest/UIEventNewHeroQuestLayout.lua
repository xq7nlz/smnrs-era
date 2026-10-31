require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"

--- @class UIEventNewHeroQuestLayout : UIEventNewHeroLayout
UIEventNewHeroQuestLayout = Class(UIEventNewHeroQuestLayout, UIEventNewHeroLayout)

--- @param view UIEventLunarNewYearView
--- @param eventTimeType EventTimeType
--- @param anchor UnityEngine_RectTransform
function UIEventNewHeroQuestLayout:Ctor(view, eventTimeType, anchor)
    --- @type UIEventNewHeroQuestLayoutConfig
    self.layoutConfig = nil
    --- @type List
    self.listPoolItemShow = List()
    --- @type EventNewHeroQuestConfig
    self.eventConfig = nil
    --- @type UILoopScroll
    self.scrollQuest = nil
    --- @type EventNewHeroQuestModel
    self.eventModel = nil
    --- @type UILoopScroll
    self.scrollRoundReward = nil

    UIEventNewHeroLayout.Ctor(self, view, eventTimeType, anchor)
end

function UIEventNewHeroQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_new_hero_quest", self.anchor)
    UIEventNewHeroLayout.InitLayoutConfig(self, inst)

    self:InitButtonListener()

    self:InitLocalization()

    self:InitScrollQuest()
end

function UIEventNewHeroQuestLayout:InitScrollQuest()
    --- @param obj UIEventQuestItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type QuestUnitInBound
        local questData = self.eventModel:GetDataByIndexOfList(dataIndex)
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

function UIEventNewHeroQuestLayout:InitLocalization()
    UIEventNewHeroLayout.InitLocalization(self)
end

function UIEventNewHeroQuestLayout:InitButtonListener()

end

function UIEventNewHeroQuestLayout:GetModelConfig()
    UIEventNewHeroLayout.GetModelConfig(self)

    self.questConfig = self.eventConfig:GetQuestConfig()
end

function UIEventNewHeroQuestLayout:OnShow()
    UIEventNewHeroLayout.OnShow(self)
    self:UpdateLayoutByDataId()
    self.scrollQuest:Resize(self.eventModel.listQuestData:Count())
end

function UIEventNewHeroQuestLayout:UpdateLayoutByDataId()
    self.dataId = self.eventModel.timeData.dataId

    self.layoutConfig.textTittle.text = LanguageUtils.LocalizeCommon("new_hero_quest_tittle_" .. self.dataId)
    self.layoutConfig.textDesc.text = LanguageUtils.LocalizeCommon("new_hero_quest_desc_" .. self.dataId)

    self.layoutConfig.bgBanner.sprite = ResourceLoadUtils.LoadBannerEventNewHeroDailyQuest(self.dataId)
    self.layoutConfig.bgBanner:SetNativeSize()
end

function UIEventNewHeroQuestLayout:OnHide()
    UIEventNewHeroLayout.OnHide(self)
    self.scrollQuest:Hide()
end

function UIEventNewHeroQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.model.uiName)
    end)
end

function UIEventNewHeroQuestLayout:OnClickClaim(questId)
    self.eventModel:RequestClaimQuest(questId, function()
        self.scrollQuest:Resize(self.eventModel.listQuestData:Count())

        self.view:UpdateNotificationByTab(self.eventTimeType)
    end)
end