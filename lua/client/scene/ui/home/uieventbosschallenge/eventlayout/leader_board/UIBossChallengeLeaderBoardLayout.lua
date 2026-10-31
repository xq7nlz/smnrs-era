--- @class UIBossChallengeLeaderBoardLayout : UIEventBossChallengeLayout
UIBossChallengeLeaderBoardLayout = Class(UIBossChallengeLeaderBoardLayout, UIEventBossChallengeLayout)

--- @param view UIEventBossChallenge
--- @param eventBossChallengeTab EventBossChallengeTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIBossChallengeLeaderBoardLayout:Ctor(view, eventBossChallengeTab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    --- @type UIBossChallengeLeaderBoardLayoutConfig
    self.layoutConfig = nil
    ---@type BossChallengeRankingItemView
    self.currentRanking = nil
    --- @type EventBossChallengeModel
    self.eventModel = nil
    UIEventBossChallengeLayout.Ctor(self, view, eventBossChallengeTab, anchor)
end

function UIBossChallengeLeaderBoardLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_boss_challenge_leader_board_layout", self.anchor)
    UIEventBossChallengeLayout.InitLayoutConfig(self, inst)
    self.currentRanking = BossChallengeRankingItemView(self.layoutConfig.arenaRankingItemView)
    self.currentRanking:SetConfig(self.layoutConfig.arenaRankingItemView)
    self.currentRanking:InitLocalization()
    self:InitLocalization()
end

function UIBossChallengeLeaderBoardLayout:InitLocalization()
    self.layoutConfig.eventTittle.text = LanguageUtils.LocalizeCommon("leaderboard")
    self.layoutConfig.textReward.text = LanguageUtils.LocalizeCommon("reward")
end

function UIBossChallengeLeaderBoardLayout:SetUpLayout()
    UIEventBossChallengeLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
    self:InitScroll()
    self:GetData()
    self:InitButtons()
end

function UIBossChallengeLeaderBoardLayout:GetData()
    local onSuccess = function(eventModel)
        self.playerId = PlayerSettingData.playerId
        self.eventModel = eventModel
        self.uiScroll:Resize(self.eventModel.BossChallengeRankingInBound.listRanking:Count())
        self:_SetUserRankingItemView()
    end
    require "lua.client.core.network.event.eventBossChallenge.BossChallengeRankingInBound"
    BossChallengeRankingInBound.GetLeaderBoard(onSuccess)
end

function UIBossChallengeLeaderBoardLayout:InitScroll()
    --- @param obj BossChallengeRankingItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type BossChallengeRanking
        local singleArenaRanking = self.eventModel.BossChallengeRankingInBound.listRanking:Get(index + 1)
        obj:SetData(singleArenaRanking, index + 1)
    end
    --- @param obj BossChallengeRankingItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        onUpdateItem(obj, index)
    end

    self.uiScroll = UILoopScroll(self.layoutConfig.scroll,
            UIPoolType.BossChallengeRankingItemView, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig())
end

function UIBossChallengeLeaderBoardLayout:_SetUserRankingItemView()
    ---@type BasicInfoInBound
    local basicInfo = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    self.userSingleArenaRanking = SingleArenaRanking()
    self.userSingleArenaRanking.score = self.eventModel.BossChallengeRankingInBound.score
    self.userSingleArenaRanking.avatarData = basicInfo.avatarData
    self.userSingleArenaRanking.playerLevel = basicInfo.level
    self.userSingleArenaRanking.playerName = basicInfo.name
    self.userSingleArenaRanking.playerId = PlayerSettingData.playerId

    self.currentRanking:SetData(self.userSingleArenaRanking, self.eventModel.BossChallengeRankingInBound.currentRanking)
end

--- @return void
function UIBossChallengeLeaderBoardLayout:OnClickReward()
    local data = {}
    data.BossChallengeRankingInBound = self.eventModel.BossChallengeRankingInBound
    PopupMgr.ShowPopup(UIPopupName.UIBossChallengeReward, data)
end

function UIBossChallengeLeaderBoardLayout:InitButtons()
    self.layoutConfig.buttonReward.onClick:AddListener(function()
        self:OnClickReward()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function UIBossChallengeLeaderBoardLayout:OnShow()
    UIEventBossChallengeLayout.OnShow(self)
    self:GetData()
    self:InitLocalization()
end

function UIBossChallengeLeaderBoardLayout:ReturnPoolScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIBossChallengeLeaderBoardLayout:OnHide()
    self:ReturnPoolScroll()
    UIEventBossChallengeLayout.OnHide(self)
end
