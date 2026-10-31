--- @class UIEventProphetTreeLayout : UIEventQuestLayout
UIEventProphetTreeLayout = Class(UIEventProphetTreeLayout, UIEventQuestLayout)

local BG_TEXT_GLOW_COLOR = U_Color(0, 1, 0.89, 0.6)
local OUTLINE_ROUND_COLOR = U_Color(0.17, 0.57, 0.58, 1)

function UIEventProphetTreeLayout:SetUpLayout()
    self.config.bgTextGlow.color = BG_TEXT_GLOW_COLOR
    self.config.outLineTextRound.effectColor = OUTLINE_ROUND_COLOR
    UIEventQuestLayout.SetUpLayout(self)
end

function UIEventProphetTreeLayout:InitScrollContentQuest()

    if self.eventPopupQuestModel.dataList:Count() > 0 then
        local eventBirthdayModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
        local isEventOpen = false
        if eventBirthdayModel and eventBirthdayModel:IsOpening() then
            isEventOpen =true
        end
        --- @param obj UIEventQuestItem
        --- @param index number
        local onCreateItem = function(obj, index)
            local dataIndex = index + 1
            --- @type QuestUnitInBound
            local questData = self.eventPopupQuestModel:GetDataByIndexOfList(dataIndex)
            --- @type List
            local extraRewards = self:GetExtraReward(questData.questId)
            questData.config:AddListResData(extraRewards)
            obj:SetData(questData.config, questData)
            if extraRewards ~= nil then
                for i = 1, extraRewards:Count() do
                    questData.config._listReward:RemoveByIndex(questData.config._listReward:Count())
                end
                obj:SetItemSpacing(-265)
            else
                obj:SetItemSpacing(0)
            end
            if questData.config:IsFeatureMappingAvailable() then
                obj:AddGoListener(function()
                    self:OnClickGo(questData.questId, questData.config)
                end)
            end
        end
        self.view.scrollLoopContent = UILoopScroll(self.config.VerticalScrollContent, UIPoolType.EventQuestItem, onCreateItem)
        self.view.scrollLoopContent:SetUpMotion(MotionConfig())
    else
        XDebug.Warning("Quest data count = 0")
    end
end

function UIEventProphetTreeLayout:GetExtraReward(questId)
    --- @type EventDailyQuestPassModel
    local eventBirthdayModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
    if eventBirthdayModel and eventBirthdayModel:IsOpening() then
        local dataId = eventBirthdayModel.timeData.dataId
        local rewards = ResourceMgr.EventBirthdayConfig():GetEventBonusReward(dataId,
                questId,
                EventTimeType.EVENT_PROPHET_TREE_QUEST)
        return rewards
    end
    return nil
end