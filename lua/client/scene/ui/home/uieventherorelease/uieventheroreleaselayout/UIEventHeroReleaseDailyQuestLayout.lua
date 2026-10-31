--- @class UIEventHeroReleaseDailyQuestLayout : UIEventHeroReleaseLayout
UIEventHeroReleaseDailyQuestLayout = Class(UIEventHeroReleaseDailyQuestLayout, UIEventHeroReleaseLayout)

--- @param view UIEventHeroReleaseView
--- @param eventTimeType EventTimeType
--- @param anchor UnityEngine_RectTransform
function UIEventHeroReleaseDailyQuestLayout:Ctor(view, eventTimeType, anchor)
    --- @type UIEventHeroReleaseDailyQuestLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.scrollQuest = nil
    --- @type EventHeroReleaseModel
    self.eventModel = nil


    UIEventHeroReleaseLayout.Ctor(self, view, eventTimeType, anchor)
    self:InitUpdateTime()
end


function UIEventHeroReleaseDailyQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_hero_release_daily_quest", self.anchor)
    UIEventHeroReleaseLayout.InitLayoutConfig(self, inst)

    self:InitLocalization()

    self:InitScrollQuest()
end

function UIEventHeroReleaseDailyQuestLayout:InitScrollQuest()
    --- @param obj UIEventQuestItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local index = index + 1
        --- @type QuestUnitInBound
        local questData = self.eventModel.listDailyQuestData:Get(index)
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

function UIEventHeroReleaseDailyQuestLayout:GetModelConfig()
    UIEventHeroReleaseLayout.GetModelConfig(self)

    self.dataId = self.eventModel.timeData.dataId
    self.questConfig = self.eventConfig:GetDailyQuestConfig()
end

function UIEventHeroReleaseDailyQuestLayout:UpdateLayoutByDataId()
    self.dataId = self.eventModel.timeData.dataId

    self.layoutConfig.textTittle.text = LanguageUtils.LocalizeCommon("hero_release_daily_quest_tittle_" .. self.dataId)

    self.layoutConfig.bgBanner.sprite = ResourceLoadUtils.LoadTexture(
            "BannerEventHeroReleaseDailyQuest", tostring(self.dataId), ComponentName.UnityEngine_Sprite)
    self.layoutConfig.bgBanner:SetNativeSize()

   local faction = ClientConfigUtils.GetFactionIdByEventHeroRelease(self.eventModel:GetConfig())
    self.layoutConfig.imgTextBG.color = ClientConfigUtils.GetBGColorByFaction(faction)
end

function UIEventHeroReleaseDailyQuestLayout:OnShow()
    UIEventHeroReleaseLayout.OnShow(self)

    self:UpdateLayoutByDataId()

    self.scrollQuest:Resize(self.eventModel.listDailyQuestData:Count())
    self:AddTimer()
end

function UIEventHeroReleaseDailyQuestLayout:OnHide()
    UIEventHeroReleaseLayout.OnHide(self)
    self.scrollQuest:Hide()
    self:RemoveTimer()
end

function UIEventHeroReleaseDailyQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.model.uiName)
    end)
end

function UIEventHeroReleaseDailyQuestLayout:OnClickClaim(questId)
    QuestDataInBound.RequestClaimQuest(OpCode.EVENT_HERO_RELEASE_QUEST_CLAIM, questId,
            function(rewardList)
                self.eventModel:OnClaimQuestSuccess(self.eventTab, questId)

                self.scrollQuest:Resize(self.eventModel.listDailyQuestData:Count())

                self.view:UpdateNotificationByTab(EventHeroReleaseTab.DailyQuest)

                PopupUtils.ClaimAndShowRewardList(rewardList)
            end)
end

function UIEventHeroReleaseDailyQuestLayout:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeReset()
        else
            self.timeReset = self.timeReset - 1
        end
        self:SetTextTimeReset()
        if self.timeReset < 0 then
            self:OnEndResetTime()
        end
    end
end

function UIEventHeroReleaseDailyQuestLayout:SetTextTimeReset()
    self.layoutConfig.textTimer.text = string.format(LanguageUtils.LocalizeCommon("refresh_in"),
            UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeReset)))
end

function UIEventHeroReleaseDailyQuestLayout:SetTimeReset()
    self.timeReset = zg.timeMgr:GetRemainingTime()
end


function UIEventHeroReleaseDailyQuestLayout:AddTimer()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventHeroReleaseDailyQuestLayout:RemoveTimer()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end