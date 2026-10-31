require "lua.client.core.network.playerData.common.BossChallengeTowerBattleResultInBound"

--- @class UIVictoryBossChallengeTowerLayout : UIVictoryLayout
UIVictoryBossChallengeTowerLayout = Class(UIVictoryBossChallengeTowerLayout, UIVictoryLayout)

function UIVictoryBossChallengeTowerLayout:SetUpLayout()
    UIVictoryLayout.SetUpLayout(self)
    self.config.buttonBattleLog.gameObject:SetActive(false)
end

function UIVictoryBossChallengeTowerLayout:ShowData(data)
    --- @type EventBossChallengeModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BOSS_CHALLENGE)
    ---@type EventBossChallengeConfig
    self.eventConfig = self.eventModel:GetConfig()

    if not data.isSkip then
        --- @type BossChallengeTowerBattleResultInBound
        local bossChallengeTowerBattleInbound = self.eventModel.bossChallengeResultInBound
        local battleIndex = bossChallengeTowerBattleInbound:GetBattleIndex()
        --- @type BossChallengeBattleLogInBound
        local battleLogInbound = bossChallengeTowerBattleInbound.listBattleLogs:Get(battleIndex)

        if self.eventModel.isBoughtPremiumPass then
            self.eventModel:AddPremiumPassClaimedStageList(self.eventModel.currentStage)
        end

        local rewardList = nil
        if self.eventModel.currentStage > self.eventConfig:GetTotalBossChallengeTower() then
            rewardList = RewardInBound.GetItemIconDataList(battleLogInbound.listReward)
        else
            rewardList = RewardInBound.GetItemIconDataList(battleLogInbound.listReward)
        end

        zg.playerData.rewardList = rewardList
        zg.playerData:AddListRewardToInventory()
    end

    if zg.playerData ~= nil and zg.playerData:HasReward() then
        self.view:SetReward(zg.playerData.rewardList)
    end
    if not data.isSkip and data.gameMode == GameMode.EVENT_BOSS_CHALLENGE then
        self.config.autoBattleView.gameObject:SetActive(false)
        if self.view.model.isWin == true then
            self:DoCountdownAutoNext()
        end
    end
end

function UIVictoryBossChallengeTowerLayout:DoCountdownAutoNext()
    self.coroutineWaitNextBattle = Coroutine.start(function()
        ---@type number
        local numberOfSecs = 2

        while (numberOfSecs > 0) do
            coroutine.waitforseconds(0.5)
            numberOfSecs = numberOfSecs - 1
        end
        self:ChallengeNextStage()
    end)
end

function UIVictoryBossChallengeTowerLayout:ChallengeNextStage()
    if self.eventModel.currentStage < self.eventConfig:GetTotalBossChallengeTower() + 1 then
        self.eventModel.currentStage = self.eventModel.currentStage + 1
    end

    self.eventModel.bossChallengeDetailDict:Add(self.eventModel.currentStage, self.eventModel.defenderHeroState)

    --- @type BossChallengeTowerBattleResultInBound
    local bossChallengeTowerBattleInbound = self.eventModel.bossChallengeResultInBound

    bossChallengeTowerBattleInbound:IncreaseBattleIndex()
    local battleIndex = bossChallengeTowerBattleInbound:GetBattleIndex()
    --- @type BossChallengeBattleLogInBound
    local battleLogInbound = bossChallengeTowerBattleInbound.listBattleLogs:Get(battleIndex)
    local heroStateInbound = bossChallengeTowerBattleInbound.listBattleLogs:Get(battleIndex - 1):ConvertHeroWithStateToDict()
    local gameMode = GameMode.EVENT_BOSS_CHALLENGE
    self.listHeroResource = self.eventConfig:GetHeroResourceByDay(self.eventModel.loginData.eventCurrentDay)
    ---@type BattleTeamInfo
    local defenderBattleTeamInfo = nil
    if self.eventModel.currentStage > self.eventConfig:GetTotalBossChallengeTower() then
        defenderBattleTeamInfo = self.eventConfig:GetListLineupLoopRecommendation(battleLogInbound.defenderTeamId)
    else
        defenderBattleTeamInfo = self.eventConfig:GetListLineupRecommendation(self.eventModel.currentStage)
    end
    self.eventModel.currentFinalStageTeamId = battleLogInbound.defenderTeamId
    --print("Defender Team :" .. battleLogInbound.defenderTeamId)

    self.teamFormation = self.eventModel.battleTeamInfomation
    --self.teamFormation:KazetsuTrialCheckHeroDead(heroStateInbound)
    if self.teamFormation.frontLine:Count() == 0 and self.teamFormation.backLine:Count() == 0  then
        self.teamFormation = TeamFormationInBound()
        self.teamFormation:SetDefaultTeam()
    else
        self.teamFormation:CheckHeroId(self.listHeroResource)
    end
    self.eventModel.battleTeamInfomation = self.teamFormation

    zg.battleMgr.gameMode = gameMode

    if gameMode ~= nil then
        zg.playerData:GetFormationInBound().teamDict:Add(gameMode ,TeamFormationInBound.Clone(self.teamFormation))
    end
    ---@type BattleTeamInfo
    local attackerBattleTeamInfo = ClientConfigUtils.GetAttackCurrentBattleTeamInfoByMode(gameMode ,
            self.listHeroResource)
    local listHeroInfo = attackerBattleTeamInfo.listHeroInfo

    local heroStateDict = heroStateInbound
    local inventoryId ,heroState
    for i = 1 ,listHeroInfo:Count() do
        --- @type HeroBattleInfo
        local heroInfo = listHeroInfo:Get(i)
        heroInfo.positionId = heroInfo.position
        inventoryId = self.teamFormation:GetHeroPosition(heroInfo).heroInventoryId
        heroState = heroStateDict:Get(inventoryId)
        heroInfo:SetState(heroState.hpPercent ,heroState.power)
    end

    zg.battleMgr:RunCalculatedBattleScene(attackerBattleTeamInfo ,defenderBattleTeamInfo ,gameMode ,nil ,nil ,battleLogInbound.battleLog)
end