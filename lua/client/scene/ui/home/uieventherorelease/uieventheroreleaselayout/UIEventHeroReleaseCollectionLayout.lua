--- @class UIEventHeroReleaseCollectionLayout : UIEventHeroReleaseLayout
UIEventHeroReleaseCollectionLayout = Class(UIEventHeroReleaseCollectionLayout, UIEventHeroReleaseLayout)

--- @param view UIEventHeroReleaseView
--- @param eventHeroReleaseTab EventHeroReleaseTab
--- @param anchor UnityEngine_RectTransform
function UIEventHeroReleaseCollectionLayout:Ctor(view, eventHeroReleaseTab, anchor)
    ---@type UIEventHeroReleaseCollectionLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    UIEventHeroReleaseLayout.Ctor(self, view, eventHeroReleaseTab, anchor)
end

function UIEventHeroReleaseCollectionLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_hero_release_collection", self.anchor)
    UIEventHeroReleaseLayout.InitLayoutConfig(self, inst)

    self:InitScrollQuest()
end

function UIEventHeroReleaseCollectionLayout:InitScrollQuest()
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
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollQuest, UIPoolType.EventQuestItem, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig())
end

function UIEventHeroReleaseCollectionLayout:OnShow()
    UIEventHeroReleaseLayout.OnShow(self)

    self:UpdateLayoutByDataId()

    self.uiScroll:Resize(self.eventModel.listCollectionQuestData:Count())
end

function UIEventHeroReleaseCollectionLayout:UpdateLayoutByDataId()
    self.dataId = self.eventModel.timeData.dataId

    local faction = ClientConfigUtils.GetFactionIdByEventHeroRelease(self.eventConfig)

    self.layoutConfig.imageTextBG.color = ClientConfigUtils.GetBGColorByFaction(faction)
    self.layoutConfig.textTittle.text = LanguageUtils.LocalizeCommon("hero_release_collection_tittle_" .. self.dataId)
    self.layoutConfig.textDesc.text = LanguageUtils.LocalizeCommon("hero_release_collection_desc_" .. self.dataId)

    self.layoutConfig.bgBanner.sprite = ResourceLoadUtils.LoadTexture(
            "BannerEventHeroReleaseCollection", tostring(self.dataId), ComponentName.UnityEngine_Sprite)
    self.layoutConfig.bgBanner:SetNativeSize()
end

function UIEventHeroReleaseCollectionLayout:OnHide()
    UIEventHeroReleaseLayout.OnHide(self)
    self.uiScroll:Hide()
end

function UIEventHeroReleaseCollectionLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.model.uiName)
    end)
end

function UIEventHeroReleaseCollectionLayout:OnClickClaim(questId)
    QuestDataInBound.RequestClaimQuest(OpCode.EVENT_HERO_RELEASE_COLLECTION_QUEST_CLAIM, questId,
            function(rewardList)
                self.eventModel:OnClaimQuestSuccess(self.eventTab, questId)

                self.uiScroll:Resize(self.eventModel.listCollectionQuestData:Count())

                self.view:UpdateNotificationByTab(EventHeroReleaseTab.Collection)

                PopupUtils.ClaimAndShowRewardList(rewardList)
            end)
end