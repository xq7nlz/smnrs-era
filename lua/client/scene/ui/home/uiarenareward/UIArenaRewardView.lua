--- @class UIArenaRewardView : UIBaseView
UIArenaRewardView = Class(UIArenaRewardView, UIBaseView)

--- @return void
--- @param model UIArenaRewardModel
function UIArenaRewardView:Ctor(model, ctrl)
    ---@type UIArenaRewardConfig
    self.config = nil
    ---@type EventTimeData
    self.eventTime = nil

    self.localizeCurrentRanking = ""
    self.localizeSendReward = ""

    ---@type ArenaRewardRankingConfig
    self.currentRankingReward = nil

    -- init variables here
    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIArenaRewardModel
    self.model = model
end

--- @return void
function UIArenaRewardView:OnReadyCreate()
    ---@type UIArenaRewardConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtonListener()
    self:InitScrollView()
    self:InitUpdateTime()
end

function UIArenaRewardView:InitScrollView()
    --- @param obj ArenaRewardItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type ArenaRewardRankingConfig
        local data = self.listReward:Get(index + 1)
        obj:SetData(data, data == self.currentRankingReward, self.featureType)
    end

    --- @type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.ArenaRewardItemView, onUpdateItem, onUpdateItem)
end

function UIArenaRewardView:InitButtonListener()
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
function UIArenaRewardView:InitLocalization()
    self.config.titleReward.text = LanguageUtils.LocalizeCommon("reward")
    self.localizeCurrentRanking = LanguageUtils.LocalizeCommon("your_current_rank_x")
    self.localizeSendReward = LanguageUtils.LocalizeCommon("reward_will_sent_x")
    self.config.textTapToClose.gameObject:SetActive(false)
end

--- @return void
function UIArenaRewardView:OnReadyShow(featureType)
    self.featureType = featureType
    if featureType == FeatureType.ARENA then
        self.listReward = ResourceMgr.GetArenaRewardRankingConfig().listArenaReward
        self.eventTime = zg.playerData:GetEvents():GetEvent(EventTimeType.ARENA):GetTime()

        --- @type GroupArenaRankingInBound
        local arenaGroup = zg.playerData:GetMethod(PlayerDataMethod.ARENA_GROUP_RANKING)
        self.currentRanking = arenaGroup.currentRanking
        self.rankType = arenaGroup.rankType

    elseif featureType == FeatureType.ARENA_TEAM then
        self.listReward = ResourceMgr.GetArenaRewardRankingConfig().listArenaTeamReward
        self.eventTime = zg.playerData:GetEvents():GetEvent(EventTimeType.ARENA_TEAM):GetTime()

        --- @type ArenaTeamInBound
        local arenaTeamInBound = zg.playerData:GetMethod(PlayerDataMethod.ARENA_TEAM)
        self.currentRanking = arenaTeamInBound.currentRanking
        self.rankType = arenaTeamInBound.rankType
    end
    self:ShowArenaReward()
    self:StartTime()
end

function UIArenaRewardView:ShowArenaReward()
    local indexRank = nil
    if self.currentRanking ~= nil then
        ---@param v ArenaRewardRankingConfig
        for i, v in ipairs(self.listReward:GetItems()) do
            if (self.rankType == v.rankType and
                    (v.topMax == nil or v.topMax >= self.currentRanking)) then
                self.currentRankingReward = v
                indexRank = i
                break
            end
        end
    end
    self.uiScroll:SetSize(self.listReward:Count())
    if indexRank ~= nil then
        self.uiScroll:RefillCells(math.min(indexRank - 2, self.listReward:Count() - 4))
    else
        self.uiScroll:RefillCells()
    end
end

---@return void
function UIArenaRewardView:Hide()
    UIBaseView.Hide(self)
    self.uiScroll:Hide()
    self:StopTime()
end

function UIArenaRewardView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self.timeFinish = self.eventTime.endTime - zg.timeMgr:GetServerTime()
        else
            self.timeFinish = self.timeFinish - 1
        end
        if self.timeFinish > 0 then
            self.config.localizeRewardWillBeSent.text = string.format(self.localizeSendReward, UIUtils.SetColorString(UIUtils.color2, TimeUtils.GetDeltaTime(self.timeFinish, 4)))
        else
            self.config.localizeRewardWillBeSent.text = ""
            self:StopTime()
        end
    end
end

--- @return void
function UIArenaRewardView:StartTime()
    if self.updateTime ~= nil then
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end

--- @return void
function UIArenaRewardView:StopTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end
