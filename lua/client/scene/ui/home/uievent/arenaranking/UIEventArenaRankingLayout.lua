--- @class UIEventArenaRankingLayout : UIEventLayout
UIEventArenaRankingLayout = Class(UIEventArenaRankingLayout, UIEventLayout)

local cellSize = U_Vector2(1137, 185)
local spacing = U_Vector2(0, 10)

function UIEventArenaRankingLayout:Ctor(view)
    UIEventLayout.Ctor(self, view)
    self.claimableIndex = nil
end

--- @param eventPopupModel EventPopupArenaRankingModel
function UIEventArenaRankingLayout:OnShow(eventPopupModel)
    self.claimableIndex = nil
    self:InitScrollContentArenaRanking()
    local dataConfig = eventPopupModel:GetConfig():GetConfig()
    self:ResizeLoopScrollContent(dataConfig:Count())
    if self.claimableIndex ~= nil then
        self.view.scrollLoopContent:ScrollToCell(self.claimableIndex, 4500)
    end
end

function UIEventArenaRankingLayout:OnHide()
    UIEventLayout.OnHide(self)
    UIEventLayout.EnableLoopScrollContent(self, false)
end

function UIEventArenaRankingLayout:InitScrollContentArenaRanking()
    self.view:SetGridContentSize(cellSize, spacing, 1)

    --- @type EventPopupArenaRankingModel
    local eventPopupArenaRankingModel = self.model.currentEventModel
    --- @type EventArenaRankingConfig
    local dataConfig = eventPopupArenaRankingModel:GetConfig()
    local playerPoint = eventPopupArenaRankingModel.playerPoint
    local playerRankType = ClientConfigUtils.GetRankingTypeByElo(playerPoint, FeatureType.ARENA)
    local totalArenaRankType = ResourceMgr.GetArenaRewardRankingConfig().totalArenaRankType
    local currentSeason = self.model.eventInBound:GetEvent(EventTimeType.ARENA).timeData.season
    for i = 1, dataConfig.arenaRankingRewardDict:Count() do
        local rankType = totalArenaRankType - i
        if rankType == playerRankType then
            if eventPopupArenaRankingModel:HasNotification()
                    or eventPopupArenaRankingModel.isClaim == true then
                self.claimableIndex = i
            end
            break
        end
    end

    --- @param obj UIEventArenaRankingItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local rankType = totalArenaRankType - index
        --- @type ArenaRewardRankingConfig
        local arenaRewardRankingConfig = ResourceMgr.GetArenaRewardRankingConfig():GetArenaRewardRankingConfigByRankType(rankType, 1, FeatureType.ARENA)
        local listRewardIconData = dataConfig:GetListRewardIconData(rankType)
        obj:SetData(arenaRewardRankingConfig, dataConfig:GetListRewardIconData(rankType))
        if eventPopupArenaRankingModel.arenaSeason >= currentSeason then
            obj:HideAllButton()
        elseif rankType == playerRankType then
            if eventPopupArenaRankingModel.isClaim == false
                    and eventPopupArenaRankingModel.rewardState ~= RewardState.NOT_AVAILABLE_TO_CLAIM then
                obj:AddOnClaimListener(function()
                    local callback = function(result)
                        local onSuccess = function()
                            eventPopupArenaRankingModel.isClaim = true
                            PopupUtils.ShowRewardList(listRewardIconData)
                            for i = 1, listRewardIconData:Count() do
                                --- @type ItemIconData
                                local rewardIconData = listRewardIconData:Get(i)
                                rewardIconData:AddToInventory()
                            end
                            RxMgr.notificationEventPopup:Next(eventPopupArenaRankingModel:GetType())
                            obj:SetAsClaimed()
                        end
                        NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
                    end
                    NetworkUtils.Request(OpCode.EVENT_ARENA_RANK_CLAIM, nil, callback)
                end)
            elseif eventPopupArenaRankingModel.isClaim == true then
                obj:SetAsClaimed()
            end
        else
            obj:SetDefaultButton()
        end
    end
    self.view.scrollLoopContent = UILoopScroll(self.config.VerticalScrollContent, UIPoolType.EventArenaRankingItem, onCreateItem)
    self.view.scrollLoopContent:SetUpMotion(MotionConfig())
end

function UIEventArenaRankingLayout:GetExtraReward(questId)
    --- @type EventDailyQuestPassModel
    local eventBirthdayModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
    if eventBirthdayModel and eventBirthdayModel:IsOpening() then
        local dataId = eventBirthdayModel.timeData.dataId
        local rewards = ResourceMgr.EventBirthdayConfig():GetEventBonusReward(dataId, questId,EventTimeType.EVENT_SUMMON_QUEST)
        return rewards
    end
    return nil
end
