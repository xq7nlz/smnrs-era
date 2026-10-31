require "lua.client.scene.ui.home.uiEventMidAutumn.ItemShowWithNameAndType"

--- @class UIEventNewHeroCollectionLayout : UIEventNewHeroLayout
UIEventNewHeroCollectionLayout = Class(UIEventNewHeroCollectionLayout, UIEventNewHeroLayout)

--- @param view UIEventLunarNewYearView
--- @param eventTimeType EventTimeType
--- @param anchor UnityEngine_RectTransform
function UIEventNewHeroCollectionLayout:Ctor(view, eventTimeType, anchor)
    --- @type UIEventNewHeroSummonLayoutConfig
    self.layoutConfig = nil
    --- @type List
    self.listPoolItemShow = List()
    --- @type EventNewHeroCollectionConfig
    self.eventConfig = nil
    --- @type UILoopScroll
    self.scrollQuest = nil
    --- @type EventNewHeroCollectionModel
    self.eventModel = nil
    --- @type UILoopScroll
    self.scrollRoundReward = nil

    UIEventNewHeroLayout.Ctor(self, view, eventTimeType, anchor)
end

function UIEventNewHeroCollectionLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_new_hero_collection", self.anchor)
    UIEventNewHeroLayout.InitLayoutConfig(self, inst)

    self:InitLocalization()

    self:InitScrollQuest()
end

function UIEventNewHeroCollectionLayout:InitScrollQuest()
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

function UIEventNewHeroCollectionLayout:InitLocalization()
    UIEventNewHeroLayout.InitLocalization(self)
end

function UIEventNewHeroCollectionLayout:GetModelConfig()
    UIEventNewHeroLayout.GetModelConfig(self)

    self.questConfig = self.eventConfig:GetQuestConfig()
end

function UIEventNewHeroCollectionLayout:OnShow()
    UIEventNewHeroLayout.OnShow(self)
    self:UpdateLayoutByDataId()
    self.scrollQuest:Resize(self.eventModel.listQuestData:Count())
end

function UIEventNewHeroCollectionLayout:UpdateLayoutByDataId()
    self.dataId = self.eventModel.timeData.dataId

    self.layoutConfig.textTittle.text = LanguageUtils.LocalizeCommon("new_hero_collection_tittle_" .. self.dataId)
    self.layoutConfig.textDesc.text = LanguageUtils.LocalizeCommon("new_hero_collection_desc_" .. self.dataId)

    self.layoutConfig.bgBanner.sprite = ResourceLoadUtils.LoadBannerEventNewHeroCollectionQuest(self.dataId)
    self.layoutConfig.bgBanner:SetNativeSize()
end

function UIEventNewHeroCollectionLayout:OnHide()
    UIEventNewHeroLayout.OnHide(self)
    self.scrollQuest:Hide()
end

function UIEventNewHeroCollectionLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.model.uiName)
    end)
end

function UIEventNewHeroCollectionLayout:OnClickClaim(questId)
    self.eventModel:RequestClaimQuest(questId, function()
        self.scrollQuest:Resize(self.eventModel.listQuestData:Count())

        self.view:UpdateNotificationByTab(self.eventTimeType)
    end)
end