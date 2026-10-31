require "lua.client.scene.ui.home.WorldSpaceHeroView.WorldSpaceHeroView"
require "lua.client.scene.ui.common.UIBarPercentView"
require "lua.client.scene.ui.home.uiGuildDungeon.guildDungeonWorldView.GuildDungeonWorldView"

--- @class UIGuildDungeonView : UIBaseView
UIGuildDungeonView = Class(UIGuildDungeonView, UIBaseView)

--- @return void
--- @param model UIGuildDungeonModel
function UIGuildDungeonView:Ctor(model)
    --- @type UIGuildDungeonConfig
    self.config = nil
    ---@type MoneyBarLocalView
    self.moneyBarView = nil
    --- @type GuildDungeonWorldView
    self.guildDungeonWorld = nil
    --- @type GuildDungeonInBound
    self.guildDungeonInBound = nil
    --- @type GuildDungeonConfig
    self.csv = nil
    --- @type ItemsTableView
    self.itemTableView = nil
    --- @type List<HeroIconView>
    self.listBossIconView = List()
    --- @type GuildBasicInfoInBound
    self.guildBasicInfoInBound = nil

    UIBaseView.Ctor(self, model)
    --- @type UIGuildDungeonModel
    self.model = model
end

function UIGuildDungeonView:OnReadyCreate()
    ---@type UIGuildDungeonConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.bossHp = UIBarPercentView(self.config.bossHp)
    self:InitButtonListener()
    self:InitUI()
    self:InitUpdateTime()
    self:InitWorldView()

    self.config.textItemReward.resizeTextForBestFit = true
end

function UIGuildDungeonView:InitUI()
    self.itemTableView = ItemsTableView(self.config.rewardTableView)
end

function UIGuildDungeonView:InitButtonListener()
    self.config.backButton.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
    self.config.buttonSmash.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSmash()
    end)
    self.config.buttonBattle.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBattle()
    end)
    self.config.buttonLog.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLog()
    end)
    self.config.buttonSeasonReward.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSeasonReward()
    end)
    self.config.btnNextStage.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSwitchStage(true)
    end)
    self.config.btnPreviousStage.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickSwitchStage(false)
    end)
    self.config.buttonCurrent.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCurrent()
    end)
end

function UIGuildDungeonView:InitLocalization()
    self.config.localizeBattle.text = LanguageUtils.LocalizeCommon("battle")
    self.config.localizeSmash.text = LanguageUtils.LocalizeCommon("smash")
    self.config.localizeSeasonReward.text = LanguageUtils.LocalizeCommon("season_reward")
    self.config.localizeSeasonReward.text = LanguageUtils.LocalizeCommon("season_reward")
    self.config.localizeBackCurrent.text = LanguageUtils.LocalizeCommon("back_to_current")

    self.config.textItemReward.text = LanguageUtils.LocalizeCommon("stage_reward")
end

function UIGuildDungeonView:OnReadyShow()
    self.guildBasicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
    if self.guildBasicInfoInBound.isHaveGuild ~= true then
        local touchObject = TouchUtils.Spawn("UIGuildDungeonView:OnReadyShow")
        Coroutine.start(function()
            coroutine.yield(1)
            touchObject:Enable()
            self:OnServerNotificationGuildKicked()
        end)
    end

    self.csv = ResourceMgr.GetGuildDungeonConfig()
    self.guildDungeonInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_DUNGEON)
    self:CheckEventTimeData()
    self:ShowMoneyBar()
    self:ResetUIHpBoss()
    self.guildDungeonWorld:Show()

    GuildDungeonInBound.Validate(function()
        self:OnSuccessRequestDungeonData()
    end)

    if self.serverNotificationListener == nil then
        self.serverNotificationListener = RxMgr.guildMemberKicked:Subscribe(RxMgr.CreateFunction(self, self.OnServerNotificationGuildKicked))
    end
end

function UIGuildDungeonView:ShowMoneyBar()
    if self.moneyBarView == nil then
        self.moneyBarView = MoneyBarLocalView(self.config.moneyBarInfo)
    end
    self.moneyBarView:SetIconData(MoneyType.GUILD_DUNGEON_STAMINA)
    self.moneyBarView:SetBuyText(self.csv:GetGeneralGuildDungeonConfig().max_guild_dungeon_stamina)
end

function UIGuildDungeonView:InitWorldView()
    self.guildDungeonWorld = GuildDungeonWorldView(self.config.guildDungeonWorld, self)
end

function UIGuildDungeonView:ResetUIHpBoss()
    self.bossHp:SetPercent(0)
end

function UIGuildDungeonView:OnSuccessRequestDungeonData()
    --- @type GuildDungeonInBound
    self.guildDungeonInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_DUNGEON)
    self:SetDefaultWorldView()
end

function UIGuildDungeonView:ShowCheckOutStageDetailData()
    self:ShowButtonSwitchState()
    self:ShowCheckOutReward()

    --- @param stageDetailData GuildDungeonDefenderTeamInBound
    local showUiByDetailData = function(stageDetailData, stage)
        if stageDetailData == nil then
            self.bossHp.gameObject:SetActive(false)
            self.config.buttonLog.gameObject:SetActive(false)
        else
            local percent = 0
            local battleTeamInfo = DefenderTeamData.GetBattleTeamInfoByPredefineTeam(stageDetailData.predefineTeamData)
            if stage == self.guildDungeonInBound.currentStage then
                percent = ClientConfigUtils.GetPercentHpBattle(battleTeamInfo, stageDetailData.listHeroState)
            end
            self.bossHp:SetPercent(percent)
            self.bossHp.gameObject:SetActive(true)
            self.config.buttonLog.gameObject:SetActive(true)
        end
    end
    local cacheDetailData = self.guildDungeonInBound:GetStageDetailData(self.model.checkOutStage)
    if cacheDetailData ~= nil then
        showUiByDetailData(cacheDetailData, self.model.checkOutStage)
    end
    --- @param stageDetailData GuildDungeonDefenderTeamInBound
    local onCurrentStageLoaded = function(stageDetailData)
        if cacheDetailData == nil or cacheDetailData:NeedUpdate() then
            showUiByDetailData(stageDetailData, self.model.checkOutStage)
        end
        self:ShowStageDefenderTeam(self.model.checkOutStage)
    end
    self:LoadStageDetailData(self.model.checkOutStage, onCurrentStageLoaded)
end

function UIGuildDungeonView:LoadStageDetailData(stage, callback)
    if stage > self.guildDungeonInBound.currentStage then
        callback(nil)
        return
    end
    local stageDetailData = self.guildDungeonInBound:GetStageDetailData(stage)
    if stageDetailData == nil or stageDetailData:NeedUpdate() == true then
        GuildDungeonInBound.LoadStageDetailData(stage, callback)
    else
        callback(stageDetailData)
    end
end

function UIGuildDungeonView:SetDefaultWorldView()
    self.model.checkOutStage = self.guildDungeonInBound.currentStage
    self.guildDungeonWorld:HideAllStands()
    for i = -1, 1, 1 do
        local stage = self.guildDungeonInBound.currentStage + i
        local stageStatus = self:GetStageStatus(stage)
        if stage < 1 then
            self.guildDungeonWorld:RemoveStand(stage)
        else
            local stand = self.guildDungeonWorld:SetStageHeroAtPos(i, stage, self:GetStageHeroResource(stage), stageStatus)
            if stand ~= nil then
                if stage == self.model.checkOutStage then
                    stand:SetForegroundLayer()
                else
                    stand:SetBackgroundLayer()
                end
            end
        end
    end
    self:ShowCheckOutStageDetailData()
end

function UIGuildDungeonView:OnClickSmash()
    local staminaPerDay = self.csv:GetGeneralGuildDungeonConfig().guild_dungeon_stamina_per_day
    local canBattle = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GUILD_DUNGEON_STAMINA, 1))
    if canBattle then
        local data = {}
        data.moneyType = MoneyType.GUILD_DUNGEON_STAMINA
        data.number = 1
        data.minInput = 1
        data.maxInput = staminaPerDay
        data.callbackSmash = function(number)
            self:_OnConfirmSmashFromPopup(number)
        end
        PopupMgr.ShowPopup(UIPopupName.UIPopupSmash, data)
    end
end

function UIGuildDungeonView:_BackToView()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIGuildDungeon, nil, UIPopupName.UIFormation2)
end

function UIGuildDungeonView:OnClickBattle()
    --- @type GuildDungeonDefenderTeamInBound
    local stageDetailData = self.guildDungeonInBound:GetStageDetailData(self.guildDungeonInBound.currentStage)
    local canBattle = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.GUILD_DUNGEON_STAMINA, 1))
    if canBattle then
        --- @type {gameMode, battleTeamInfo, callbackPlayBattle, callbackClose}
        local data = {}
        data.gameMode = GameMode.GUILD_DUNGEON
        data.battleTeamInfo = UIGuildDungeonModel.PrepareBattleTeamInfo(stageDetailData)
        data.callbackPlayBattle = function(uiFormationTeamData, callback)
            --- @param battleResultInBound BattleResultInBound
            --- @param eventReward List
            local onSuccess = function(battleResultInBound, smashUse, eventReward)
                stageDetailData.lastUpdated = nil
                InventoryUtils.Sub(ResourceType.Money, MoneyType.GUILD_DUNGEON_STAMINA, 1)
                self:OnSuccessChallengeGuildDungeon()
                local guildCoinParticipateReward = self.csv:GetJoinReward()

                local rewardIconList = List()
                rewardIconList = List()
                rewardIconList:Add(guildCoinParticipateReward:GetIconData())
                if eventReward ~= nil and eventReward:Count() > 0 then
                    for i = 1, eventReward:Count() do
                        --- @type RewardInBound
                        local eventRewardInBound = eventReward:Get(i)
                        rewardIconList:Add(eventRewardInBound:GetIconData())
                        eventRewardInBound:AddToInventory()
                    end
                end
                guildCoinParticipateReward:AddToInventory()
                zg.playerData.rewardList = rewardIconList

                if callback ~= nil then
                    callback(nil, nil, nil, battleResultInBound.battleLog)
                end
            end
            local onFailed = function()
                self.guildDungeonInBound.lastTimeRequest = nil
                self:_BackToView()
            end
            GuildDungeonInBound.ChallengeBoss(uiFormationTeamData,
                    stageDetailData.bossCreatedTime, 1, onSuccess, onFailed)
        end
        data.callbackClose = function()
            self:_BackToView()
        end
        PopupMgr.ShowAndHidePopup(UIPopupName.UIFormation2, data, UIPopupName.UIGuildArea, UIPopupName.UIGuildDungeon)
    end
end

function UIGuildDungeonView:OnClickSeasonReward()
    PopupMgr.ShowPopup(UIPopupName.UILeaderBoard, LeaderBoardType.GUILD_DUNGEON_RANKING)
end

function UIGuildDungeonView:OnClickHelpInfo()
    local info = LanguageUtils.LocalizeHelpInfo("guid_dungeon_boss_info")
    info = string.gsub(info, "{1}", tostring(self.csv:GetGeneralGuildDungeonConfig().max_guild_dungeon_stamina))
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

function UIGuildDungeonView:OnClickLog()
    local onLoadDataSuccess = function(stageDetailData)
        PopupMgr.ShowPopup(UIPopupName.UIPopupDamageStats, { ["isGuildDungeonBossStatistic"] = true,
                                                             ["listOfGuildDungeonStatistics"] = stageDetailData.listOfGuildDungeonStatistics })
    end
    self:LoadStageDetailData(self.model.checkOutStage, onLoadDataSuccess)
end

function UIGuildDungeonView:_OnConfirmSmashFromPopup(number)
    --- @type {gameMode, battleTeamInfo, callbackPlayBattle, callbackClose}
    local data = {}
    data.gameMode = GameMode.GUILD_DUNGEON
    data.battleTeamInfo = nil
    data.callbackPlayBattle = function(uiFormationTeamData, callback)
        self:_OnClickBattleFromUIFormationSmash(uiFormationTeamData, number)
    end
    data.callbackClose = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIGuildDungeon, nil, UIPopupName.UIFormation2)
    end
    PopupMgr.ShowAndHidePopup(UIPopupName.UIFormation2, data, UIPopupName.UIGuildDungeon)
end

--- @param uiFormationTeamData UIFormationTeamData
function UIGuildDungeonView:_OnClickBattleFromUIFormationSmash(uiFormationTeamData, number)
    --- @type GuildDungeonDefenderTeamInBound
    local stageDetailData = self.guildDungeonInBound:GetStageDetailData(self.guildDungeonInBound.currentStage)
    if stageDetailData == nil then
        return
    end
    --- @param battleResultInBound BattleResultInBound
    --- @param smashUsed number
    --- @param eventReward List
    local onSuccess = function(battleResultInBound, smashUsed, eventReward)
        stageDetailData.lastUpdated = nil
        self:OnSuccessChallengeGuildDungeon()
        InventoryUtils.Sub(ResourceType.Money, MoneyType.GUILD_DUNGEON_STAMINA, smashUsed)

        local rewardIconList = List()

        local joinReward = self.csv:GetJoinReward()
        joinReward.number = joinReward.number * smashUsed
        joinReward:AddToInventory()

        rewardIconList:Add(joinReward:GetIconData())
        if eventReward ~= nil and eventReward:Count() > 0 then
            for i = 1, eventReward:Count() do
                --- @type RewardInBound
                local eventRewardInBound = eventReward:Get(i)
                eventRewardInBound:AddToInventory()
                rewardIconList:Add(eventRewardInBound:GetIconData())
            end
        end

        PopupUtils.ShowRewardList(rewardIconList)

        GuildDungeonInBound.Validate(function()
            self:_BackToView()
        end)
    end
    local onFailed = function()
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        self.guildDungeonInBound.lastTimeRequest = nil
        self:_BackToView()

        local stageDetailData = self.guildDungeonInBound:GetStageDetailData(self.guildDungeonInBound.currentStage)
        if stageDetailData ~= nil then
            stageDetailData.lastUpdated = nil
        end
    end
    GuildDungeonInBound.ChallengeBoss(uiFormationTeamData, stageDetailData.bossCreatedTime, number, onSuccess, onFailed)
end

function UIGuildDungeonView:OnServerNotificationGuildKicked()
    PopupUtils.BackToMainArea()
    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("guild_was_kicked"))
end

function UIGuildDungeonView:OnSuccessChallengeGuildDungeon()
    self.guildDungeonInBound.lastTimeRequest = nil
    --- @type GuildDungeonDefenderTeamInBound
    local data = self.guildDungeonInBound:GetStageDetailData(self.model.checkOutStage)
    if data ~= nil then
        data.lastUpdated = nil
    end

    local guildData = zg.playerData:GetGuildData()
    if guildData.guildDungeonStatisticsGetInBound ~= nil then
        guildData.guildDungeonStatisticsGetInBound.lastTimeRequest = nil
    end
    zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO).lastChallengeDungeon = zg.timeMgr:GetServerTime()
    --- @type GuildDungeonRankingDataInBound
    local guildDungeonRanking = zg.playerData:GetMethod(PlayerDataMethod.GUILD_DUNGEON_RANKING)
    if guildDungeonRanking ~= nil then
        guildDungeonRanking.lastTimeRequest = nil
    end
end

function UIGuildDungeonView:CheckEventTimeData()
    ---@type EventTimeData
    local eventTimeData = zg.playerData:GetEvents():GetEvent(EventTimeType.GUILD_DUNGEON):GetTime()
    if eventTimeData == nil or eventTimeData.endTime <= zg.timeMgr:GetServerTime() then
        EventInBound.ValidateEventModel(function()
            self:CheckEventTimeData()
        end, true)
    elseif eventTimeData.startTime > zg.timeMgr:GetServerTime() then
        self:ShowClosedSeasonStatus(eventTimeData.startTime)
    elseif eventTimeData.startTime <= zg.timeMgr:GetServerTime() then
        self:ShowOpenedSeasonStatus(eventTimeData.endTime)
    end
end

function UIGuildDungeonView:ShowOpenedSeasonStatus(endTime)
    self.model.isSeasonOpen = true
    self.config.textSeasonStatus.text = LanguageUtils.LocalizeCommon("season_end_in")
    self.model.seasonTimeReach = endTime
    self:StartUpdateTime()
    self:ShowButtonBattle(true)
end

function UIGuildDungeonView:ShowClosedSeasonStatus(startTime)
    self.model.isSeasonOpen = false
    self.config.textSeasonStatus.text = LanguageUtils.LocalizeCommon("season_open_in")
    self.model.seasonTimeReach = startTime
    self:StartUpdateTime()
    self:ShowButtonBattle(false)
end

function UIGuildDungeonView:ShowButtonBattle(isEnable)
    self.config.buttonBattle.gameObject:SetActive(isEnable)
    self.config.buttonSmash.gameObject:SetActive(isEnable)
end

function UIGuildDungeonView:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIGuildDungeonView:SetTextSeasonTime()
    self.config.textSeasonTimer.text = TimeUtils.GetDeltaTime(self.timeRefresh)
end

function UIGuildDungeonView:SetTimeRefresh()
    self.timeRefresh = self.model.seasonTimeReach - zg.timeMgr:GetServerTime()
end

function UIGuildDungeonView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            self.guildDungeonInBound:Init()
            GuildDungeonInBound.Validate(function()
                self.guildDungeonWorld:HideAllStands()
                self:OnReadyShow()
            end, true)
        else
            self:SetTextSeasonTime()
        end
    end
end

function UIGuildDungeonView:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIGuildDungeonView:OnClickBackOrClose()
    UIBaseView.OnClickBackOrClose(self)
    PopupMgr.ShowPopup(UIPopupName.UIGuildArea)
end

function UIGuildDungeonView:Hide()
    UIBaseView.Hide(self)
    self:RemoveUpdateTime()
    if self.serverNotificationListener ~= nil then
        self.serverNotificationListener:Unsubscribe()
        self.serverNotificationListener = nil
    end
    self.guildDungeonWorld:Hide()

    if self.moneyBarView ~= nil then
        self.moneyBarView:RemoveListener()
    end
    self.itemTableView:Hide()
    self:HideBossIconView()
    zg.battleMgr.previewHeroMgr:ClearPool()
end

--- @param isNext boolean
function UIGuildDungeonView:OnClickSwitchStage(isNext)
    self:DoMoveStand(isNext)
    if isNext then
        self.model.checkOutStage = self.model.checkOutStage + 1
    else
        self.model.checkOutStage = self.model.checkOutStage - 1
    end
    self:ShowCheckOutStageDetailData()
end

function UIGuildDungeonView:OnClickCurrent()
    self:SetDefaultWorldView()
end

--- @return HeroResource
--- @param stage number
function UIGuildDungeonView:GetStageHeroResource(stage)
    local fixedStageCount = self.csv:GetGuildDungeonTeamConfig():GetDefenderTeamConfig():Count()
    local heroBattleInfo
    if stage > 0 and stage <= fixedStageCount then
        --- @type DefenderTeamData
        local defenderTeamData = self.csv:GetGuildDungeonTeamConfig():GetDefenderTeamDataByStage(stage)
        --- @type BattleTeamInfo
        local battleTeamInfo = defenderTeamData:GetBattleTeamInfo()
        --- @type HeroBattleInfo
        heroBattleInfo = battleTeamInfo:GetListHero():Get(1)
    else
        --- @type GuildDungeonDefenderTeamInBound
        local defenderStageDetail = self.guildDungeonInBound:GetStageDetailData(stage)
        if defenderStageDetail ~= nil then
            --- @type BattleTeamInfo
            local battleTeamInfo = DefenderTeamData.GetBattleTeamInfoByPredefineTeam(defenderStageDetail.predefineTeamData)
            --- @type HeroBattleInfo
            heroBattleInfo = battleTeamInfo:GetListHero():Get(1)
        end
    end
    if heroBattleInfo ~= nil then
        return HeroResource.CreateInstanceByHeroBattleInfo(heroBattleInfo)
    end
    return nil
end

function UIGuildDungeonView:ShowStageDefenderTeam(stage)
    self:HideBossIconView()
    if stage > self.csv:GetGuildDungeonTeamConfig():GetDefenderTeamConfig():Count() then
        self:ShowSpecialStageDetail(stage)
        return
    end
    local battleTeamInfo
    --- @type DefenderTeamData
    local defenderTeamData = self.csv:GetGuildDungeonTeamConfig():GetDefenderTeamDataByStage(stage)
    if defenderTeamData ~= nil then
        --- @type BattleTeamInfo
        battleTeamInfo = defenderTeamData:GetBattleTeamInfo()
    else
        local stageDetailData = self.guildDungeonInBound:GetStageDetailData(stage)
        if stageDetailData ~= nil then
            --- @type BattleTeamInfo
            battleTeamInfo = DefenderTeamData.GetBattleTeamInfoByPredefineTeam(stageDetailData.predefineTeamData)
        end
    end
    self:ShowBossViewByBattleTeamInfo(battleTeamInfo)
end

function UIGuildDungeonView:ShowButtonSwitchState()
    self.config.btnNextStage.gameObject:SetActive(true)
    self.config.btnPreviousStage.gameObject:SetActive(true)
    local fixedStageCount = self.csv:GetGuildDungeonTeamConfig():GetDefenderTeamConfig():Count()
    if self.model.checkOutStage == 1 then
        self.config.btnPreviousStage.gameObject:SetActive(false)
    elseif self.model.checkOutStage > self.guildDungeonInBound.currentStage
            and self.model.checkOutStage >= fixedStageCount then
        self.config.btnNextStage.gameObject:SetActive(false)
    end

    self.config.buttonBattle.gameObject:SetActive(self.model.checkOutStage == self.guildDungeonInBound.currentStage)
    self.config.buttonSmash.gameObject:SetActive(self.model.checkOutStage == self.guildDungeonInBound.currentStage)
    self.config.buttonCurrent.gameObject:SetActive(math.abs(self.model.checkOutStage - self.guildDungeonInBound.currentStage) > 1)
end

function UIGuildDungeonView:ShowCheckOutReward()
    local stageReward = math.max(self.model.checkOutStage, self.guildDungeonInBound.currentStage - 1)
    --- @type RewardByStageRangeConfig
    local stageRewardConfig = self.csv:GetDungeonStageRewardConfig():GetStageRewardByStage(stageReward)
    self.itemTableView:SetData(RewardInBound.GetItemIconDataList(stageRewardConfig.listReward))

    if self.model.checkOutStage < self.guildDungeonInBound.currentStage then
        self.config.textItemReward.text = LanguageUtils.LocalizeCommon("current_season_reward")
    else
        self.config.textItemReward.text = LanguageUtils.LocalizeCommon("clear_stage_to_get_reward")
    end
end

function UIGuildDungeonView:DoMoveStand(isNext)
    local deltaMove = 1
    if isNext then
        deltaMove = -1
    end
    local moveStand = function(stage, startIndex, endIndex)
        local onStartMove = function(guildDungeonBossStand)
            if guildDungeonBossStand ~= nil then
                local stageStatus = self:GetStageStatus(stage)
                self.guildDungeonWorld:SetStandView(stage, self:GetStageHeroResource(stage), stageStatus)
            end
        end
        --- @param guildDungeonBossStand GuildDungeonBossStand
        local onEndMove = function(guildDungeonBossStand)
            if guildDungeonBossStand ~= nil then
                if math.abs(stage - self.model.checkOutStage) > 1 then
                    self.guildDungeonWorld:RemoveStand(stage)
                end
                if stage == self.model.checkOutStage then
                    guildDungeonBossStand:SetForegroundLayer()
                else
                    guildDungeonBossStand:SetBackgroundLayer()
                end
            end
        end
        self.guildDungeonWorld:MoveStandPos(stage, startIndex, endIndex, onStartMove, onEndMove)
    end
    for i = -1, 1 do
        local stage = self.model.checkOutStage + i
        moveStand(stage, i, i + deltaMove)
    end
    local outComeIndex = -2 * deltaMove
    local outComeStage = self.model.checkOutStage + outComeIndex
    moveStand(outComeStage, outComeIndex, outComeIndex + deltaMove)
end

--- @param stage number
function UIGuildDungeonView:GetStageStatus(stage)
    if stage < self.guildDungeonInBound.currentStage then
        return GuildDungeonWorldView.STAGE_PASS
    elseif stage == self.guildDungeonInBound.currentStage then
        return GuildDungeonWorldView.STAGE_BATTLE
    else
        return GuildDungeonWorldView.STAGE_LOCK
    end
end

function UIGuildDungeonView:HideBossIconView()
    if self.listBossIconView:Count() == 0 then
        return
    end
    ---@param iconView IconView
    for _, iconView in pairs(self.listBossIconView:GetItems()) do
        iconView:ActiveFrameBoss(false)
        iconView:ReturnPool()
    end
    self.listBossIconView = List()
end

function UIGuildDungeonView:ShowSpecialStageDetail(stage)
    --- @param stageDetailData GuildDungeonDefenderTeamInBound
    local onSuccess = function(stageDetailData)
        if stageDetailData == nil then
            return
        end
        --- @type BattleTeamInfo
        local battleTeamInfo = DefenderTeamData.GetBattleTeamInfoByPredefineTeam(stageDetailData.predefineTeamData)
        self:ShowBossViewByBattleTeamInfo(battleTeamInfo)
        --- @type GuildDungeonBossStand
        local stand = self.guildDungeonWorld.standDict:Get(self.model.checkOutStage)
        if stand ~= nil then
            local heroResource = HeroResource.CreateInstanceByHeroBattleInfo(battleTeamInfo.listHeroInfo:Get(1))
            stand:ShowHero(heroResource)
            stand:SetForegroundLayer()
        end
    end
    self:LoadStageDetailData(stage, onSuccess)
end

--- @param battleTeamInfo BattleTeamInfo
function UIGuildDungeonView:ShowBossViewByBattleTeamInfo(battleTeamInfo)
    local listBossBattleInfo = List()
    for i = 1, battleTeamInfo.listHeroInfo:Count() do
        if battleTeamInfo.listHeroInfo:Get(i).isBoss == true then
            listBossBattleInfo:Add(battleTeamInfo.listHeroInfo:Get(i))
        end
    end
    ClientConfigUtils.RequireBattleTeam(battleTeamInfo)
    local teamPowerCalculator = TeamPowerCalculator()
    teamPowerCalculator:SetDefenderTeamInfo(battleTeamInfo)
    --- @type Dictionary -- <number, number>
    local powerMap = teamPowerCalculator:CalculatePowerDetail(ResourceMgr.GetServiceConfig():GetBattle(),
            ResourceMgr.GetServiceConfig():GetHeroes(), battleTeamInfo.teamId)
    --- @param heroBattleInfo HeroBattleInfo
    local showPopupHeroInfo = function(heroBattleInfo)
        local battleSlot = ClientConfigUtils.GetSlotNumberByPositionInfo(battleTeamInfo.formation,
                heroBattleInfo.isFrontLine,
                heroBattleInfo.position)
        if heroBattleInfo ~= nil then
            local heroResource = HeroResource.CreateInstanceByHeroBattleInfo(heroBattleInfo)
            local power = powerMap:Get(battleSlot)
            local statDict = ClientConfigUtils.GetHeroStatDictByHeroBattleInfo(heroBattleInfo, teamPowerCalculator)
            PopupMgr.ShowPopup(UIPopupName.UIHeroSummonInfo, { ["heroResource"] = heroResource,
                                                               ["power"] = power,
                                                               ["statDict"] = statDict })
            zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
        end
    end

    for i = 1, listBossBattleInfo:Count() do
        --- @type HeroBattleInfo
        local heroBattleInfo = listBossBattleInfo:Get(i)
        --- @type HeroIconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.defenderTeamAnchor)
        iconView:SetIconData(HeroIconData.CreateByHeroBattleInfo(heroBattleInfo))
        self.listBossIconView:Add(iconView)
        iconView:ActiveFrameBoss(true)
        iconView:RemoveAllListeners()
        iconView:AddListener(function()
            showPopupHeroInfo(heroBattleInfo)
        end)
    end
end

function UIGuildDungeonView:OnClickMystery()
    local listDefenderTeamData = self.csv:GetGuildDungeonTeamConfig():GetListSpecialStage()
    local listHeroBattleInfo = List()
    for i = 1, listDefenderTeamData:Count() do
        --- @type DefenderTeamData
        local defenderTeamData = listDefenderTeamData:Get(i)
        --- @type BattleTeamInfo
        local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(defenderTeamData)
        for k = 1, battleTeamInfo.listHeroInfo:Count() do
            --- @type HeroBattleInfo
            local heroBattleInfo = battleTeamInfo.listHeroInfo:Get(k)
            --- @type {heroBattleInfo : HeroBattleInfo, battleTeamInfo : BattleTeamInfo}
            local info = {}
            info.heroBattleInfo = heroBattleInfo
            info.battleTeamInfo = battleTeamInfo
            listHeroBattleInfo:Add(info)
        end
    end
    PopupMgr.ShowPopup(UIPopupName.UIPreviewDailyBoss, listHeroBattleInfo)
end

function UIGuildDungeonView:OnDestroy()
    self.guildDungeonWorld:OnDestroy()
end