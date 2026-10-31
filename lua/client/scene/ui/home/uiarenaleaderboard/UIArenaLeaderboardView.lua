--- @class UIArenaLeaderboardView : UIBaseView
UIArenaLeaderboardView = Class(UIArenaLeaderboardView, UIBaseView)

--- @return void
--- @param model UIArenaLeaderboardModel
function UIArenaLeaderboardView:Ctor(model)
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type ArenaRankingItemView
    self.currentRanking = nil
    UIBaseView.Ctor(self, model)
    --- @type UIArenaLeaderboardModel
    self.model = model
end

--- @return void
function UIArenaLeaderboardView:OnReadyCreate()
    ---@type UIArenaLeaderboardConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.currentRanking = ArenaRankingItemView()
    self.currentRanking:SetConfig(self.config.arenaRankingItemView)
    self:_InitButtonListener()

    -- Scroll
    --- @param obj ArenaRankingItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type SingleArenaRanking
        local singleArenaRanking = self.model.listRanking:Get(index + 1)
        obj:SetData(singleArenaRanking, index + 1, self.featureType)
    end
    --- @param obj ArenaRankingItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        onUpdateItem(obj, index)
        obj.callbackClickInfo = function(obj1)
            self:ShowInfoOtherPlayer(obj1)
        end
    end
    --- @type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.ArenaRankingItemView, onCreateItem, onUpdateItem)
    self.uiScroll:SetUpMotion(MotionConfig())
end

--- @return void
--- @param featureType FeatureType
function UIArenaLeaderboardView:OnReadyShow(featureType)
    self.featureType = featureType
    self:GetData(function()
        self.uiScroll:Resize(self.model.listRanking:Count())
        if self.canPlayMotion == true then
            self.canPlayMotion = false
            self.uiScroll:PlayMotion()
        end
    end)
end

function UIArenaLeaderboardView:GetData(onSuccess)
	--- @type BasicInfoInBound
	local inbound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    ---@type SingleArenaRanking
	local current = SingleArenaRanking()
    current.avatarData = inbound.avatarData
	current.playerName = inbound.name
	current.playerId = PlayerSettingData.playerId
	current.playerAvatar = inbound.avatarData:GetMyPlayerAvatar()
	current.playerLevel = inbound.level

    if self.featureType == FeatureType.ARENA then
        --- @type ServerArenaRankingInBound
        local serverArenaRankingInBound = zg.playerData:GetMethod(PlayerDataMethod.ARENA_SERVER_RANKING)
        self.model.listRanking = serverArenaRankingInBound.listRanking

		if onSuccess then
			onSuccess()
		end

        ---@type ArenaDataInBound
        local arenaDataInBound = zg.playerData:GetMethod(PlayerDataMethod.ARENA)
        current.score = arenaDataInBound.eloPoint

        local battleTeamInfo = ClientConfigUtils.GetAttackCurrentBattleTeamInfoByMode(GameMode.ARENA)
        current.power = math.floor(ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo))

        self.currentRanking:SetData(current, serverArenaRankingInBound.currentRanking)
    elseif self.featureType == FeatureType.ARENA_TEAM then
        ArenaTeamInBound.Validate(function ()
            --- @type ArenaTeamInBound
            local arenaTeamInBound = zg.playerData:GetMethod(PlayerDataMethod.ARENA_TEAM)
            arenaTeamInBound:GetArenaRanking(function ()
                self.model.listRanking = arenaTeamInBound.rankingDataList

                current.score = arenaTeamInBound.eloPoint
                self.currentRanking:SetData(current, arenaTeamInBound.currentRanking)

                if onSuccess then
                    onSuccess()
                end
            end)
        end)
    end
end

--- @return void
function UIArenaLeaderboardView:InitLocalization()
    self.config.textLeaderboardTitle.text = LanguageUtils.LocalizeCommon("leaderboard")
    self.config.textTapToClose.gameObject:SetActive(false)
end

function UIArenaLeaderboardView:_InitButtonListener()
    self.config.bgNone.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

--- @return void
--- @param ArenaRankingItemView ArenaRankingItemView
function UIArenaLeaderboardView:ShowInfoOtherPlayer(ArenaRankingItemView)
    if self.featureType == FeatureType.ARENA then
        NetworkUtils.SilentRequestOtherPlayerInfoInBoundByGameMode(ArenaRankingItemView.singleArenaRanking.playerId, GameMode.ARENA,
                function(_otherPlayerInfoInBound)
                    ---@type OtherPlayerInfoInBound
                    local otherPlayerInfoInBound = _otherPlayerInfoInBound
                    local data = {}
                    data.playerId = ArenaRankingItemView.singleArenaRanking.playerId
                    data.userName = ArenaRankingItemView.singleArenaRanking.playerName
                    data.avatar = ArenaRankingItemView.singleArenaRanking.playerAvatar
                    data.level = ArenaRankingItemView.singleArenaRanking.playerLevel
                    data.guildName = otherPlayerInfoInBound.guildName
                    data.battleTeamInfo = otherPlayerInfoInBound:CreateBattleTeamInfo(data.level, 1)
                    data.mastery = otherPlayerInfoInBound.summonerBattleInfoInBound.masteryDict
                    data.power = ArenaRankingItemView.singleArenaRanking.power
                    PopupMgr.ShowPopup(UIPopupName.UIPreviewFriend, data)
                end)
    elseif self.featureType == FeatureType.ARENA_TEAM then

    end
end

--- @return void
function UIArenaLeaderboardView:Hide()
    UIBaseView.Hide(self)
    self.uiScroll:Hide()
end