require "lua.client.scene.ui.common.battleTeamView"

local ATTACKER_TEAM_ID = 1
local DEFENDER_TEAM_ID = 2

--- @class UIEventChristmasArenaItem : MotionIconView
UIEventChristmasArenaItem = Class(UIEventChristmasArenaItem, MotionIconView)

function UIEventChristmasArenaItem:Ctor()
    --- @type number
    self.day = nil
    --- @type EventChristmasModel
    self.eventModel = nil
    --- @type BattleTeamView
    self.battleAttackerTeamView = nil
    --- @type BattleTeamView
    self.battleDefenderTeamView = nil
    --- @type UIEventView
    self.view = nil
    MotionIconView.Ctor(self)
end

function UIEventChristmasArenaItem:SetPrefabName()
    self.prefabName = 'event_christmas_arena_item'
    self.uiPoolType = UIPoolType.UIEventChristmasArenaItem
end

--- @param transform UnityEngine_Transform
function UIEventChristmasArenaItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type UIEventChristmasArenaItemConfig
    self.config = UIBaseConfig(transform)
    self.config.betAttackerTeamButton.onClick:AddListener(function()
        self:OnClickBet(ATTACKER_TEAM_ID)
    end)
    self.config.betDefenderTeamButton.onClick:AddListener(function()
        self:OnClickBet(DEFENDER_TEAM_ID)
    end)
    self.config.overviewButton.onClick:AddListener(function()
        self:OnClickOverview()
    end)
    self.config.recordButton.onClick:AddListener(function()
        self:OnClickRecord()
    end)
    self:InitUpdateTime()
end

function UIEventChristmasArenaItem:InitLocalization()
    --self.config.textBattleTime.text = string.format(LanguageUtils.LocalizeCommon("event_mid_autumn_arena_item_text_battle_time"))
    self.config.textBattleEnd.text = LanguageUtils.LocalizeCommon("event_mid_autumn_arena_item_text_battle_end")
    --self.config.textNotiUpdateBet.text = LanguageUtils.LocalizeCommon("event_mid_autumn_arena_item_text_noti_update_bet")
    self.config.textAttackerTeam.text = LanguageUtils.LocalizeCommon("event_mid_autumn_arena_item_text_attacker_team")
    self.config.textDefenderTeam.text = LanguageUtils.LocalizeCommon("event_mid_autumn_arena_item_text_defender_team")
    self.config.textTotalBet.text = LanguageUtils.LocalizeCommon("event_mid_autumn_arena_item_text_total_bet")
    self.config.textCollect.text = LanguageUtils.LocalizeCommon("claim")
    self.config.textBetAttacker.text = LanguageUtils.LocalizeCommon("event_mid_autumn_arena_item_text_bet")
    self.config.textBetDefender.text = LanguageUtils.LocalizeCommon("event_mid_autumn_arena_item_text_bet")
    self.config.textComingSoon.text = LanguageUtils.LocalizeCommon("event_mid_autumn_arena_item_text_coming_soon")
end

function UIEventChristmasArenaItem:ReturnPool()
    IconView.ReturnPool(self)
    self.battleAttackerTeamView:Hide()
    self.battleDefenderTeamView:Hide()
    self:RemoveUpdateTime()
end
---@param day number
---@param currentDay number
function UIEventChristmasArenaItem:SetData(day, currentDay, view)
    --- @type UIEventView
    self.view = view
    self.day = day
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_CHRISTMAS)
    ---@type EventMidAutumnConfig
    self.eventConfig = self.eventModel:GetConfig()
    self.config.textDay.text = string.format("%s %s",LanguageUtils.LocalizeCommon("event_mid_autumn_arena_item_text_day"), day)
    self:ShowTeam(day)
    self:UpdateUI(currentDay)
    self:UpdateBetCount()
end

function UIEventChristmasArenaItem:ShowTeam(day)
    local battleAttackerTeamInfo = self.eventConfig:GetListLineupAttackerRecommendation(day)
    local battleDefenderTeamInfo = self.eventConfig:GetListLineupDefenderRecommendation(day)

    if self.battleAttackerTeamView == nil and self.battleDefenderTeamView == nil  then
        self.battleAttackerTeamView = BattleTeamView(self.config.attackerTeamAnchor)
        self.battleDefenderTeamView = BattleTeamView(self.config.defenderTeamAnchor)
    else
        self.battleAttackerTeamView:Hide()
        self.battleDefenderTeamView:Hide()
    end
    self.battleAttackerTeamView:Show()
    self.battleAttackerTeamView:SetDataDefender(UIPoolType.HeroIconView, battleAttackerTeamInfo)
    self.battleAttackerTeamView.uiTeamView:SetSummonerInfo(battleAttackerTeamInfo.summonerBattleInfo)
    self.battleAttackerTeamView.uiTeamView:ActiveBuff(false)
    self.battleAttackerTeamView.uiTeamView:ActiveLinking(false)

    self.battleDefenderTeamView:Show()
    self.battleDefenderTeamView:SetDataDefender(UIPoolType.HeroIconView, battleDefenderTeamInfo)
    self.battleDefenderTeamView.uiTeamView:SetSummonerInfo(battleDefenderTeamInfo.summonerBattleInfo)
    self.battleDefenderTeamView.uiTeamView:ActiveBuff(false)
    self.battleDefenderTeamView.uiTeamView:ActiveLinking(false)
end

function UIEventChristmasArenaItem:UpdateUI(currentDay)
    self.config.textNotiUpdateBet.gameObject:SetActive(false)
    if self.day < currentDay then
        self:UpdatePointBar()
        self.config.dayLayout.gameObject:SetActive(true)
        self.config.nextDayLayout.gameObject:SetActive(false)
        self.config.previousDay.gameObject:SetActive(true)
        self.config.currentDay.gameObject:SetActive(false)
        self.config.overviewButton.gameObject:SetActive(false)
        self.config.recordButton.gameObject:SetActive(true)
        self.config.iconVictory.gameObject:SetActive(true)

        if self.eventConfig:GetBetArenaResult():Get(self.day) == ATTACKER_TEAM_ID then
            self.config.iconVictory.transform.localPosition = U_Vector3(-375,0,0)
        else
            self.config.iconVictory.transform.localPosition = U_Vector3(375,0,0)
        end

        local betScoreInbound = self.eventModel:GetBetScoreInboundByDay(self.day)
        if betScoreInbound ~= nil then
            local reward = 0
            if self.eventConfig:GetBetArenaResult():Get(self.day) == ATTACKER_TEAM_ID then
                reward = (betScoreInbound.teamOne * 5) + (betScoreInbound.teamTwo * 3)
            else
                reward = (betScoreInbound.teamOne * 3) + (betScoreInbound.teamTwo * 5)
            end
            self.config.textReward.text = string.format("%s: %s",LanguageUtils.LocalizeCommon("reward"), reward)
        else
            self.config.textReward.text = string.format("%s: %s",LanguageUtils.LocalizeCommon("reward"), 0)
        end

        if self.eventModel:IsClaimedBetReward(self.day) or betScoreInbound == nil then
            UIUtils.SetActiveColorByMaterial(self.config.collectButton.gameObject, false, "ui_gray_mat")
            self.config.noti.gameObject:SetActive(false)
        else
            UIUtils.SetActiveColorByMaterial(self.config.collectButton.gameObject, true, "ui_gray_mat")
            self.config.noti.gameObject:SetActive(true)
        end
    elseif self.day > currentDay then
        self.config.dayLayout.gameObject:SetActive(false)
        self.config.nextDayLayout.gameObject:SetActive(true)
        self.config.overviewButton.gameObject:SetActive(false)
        self.config.recordButton.gameObject:SetActive(false)
    else
        self:StartUpdateTime()

        self:UpdatePointBar()
        self.config.dayLayout.gameObject:SetActive(true)
        self.config.nextDayLayout.gameObject:SetActive(false)
        self.config.previousDay.gameObject:SetActive(false)
        self.config.currentDay.gameObject:SetActive(true)
        self.config.overviewButton.gameObject:SetActive(true)
        self.config.recordButton.gameObject:SetActive(false)
        self.config.iconVictory.gameObject:SetActive(false)
    end
end

--- @param func function
function UIEventChristmasArenaItem:AddClaimListener(func)
    self.config.collectButton.onClick:RemoveAllListeners()
    self.config.collectButton.onClick:AddListener(function()
        if func ~= nil then
            func()
        end
        UIUtils.SetActiveColorByMaterial(self.config.collectButton.gameObject, false, "ui_gray_mat")
        self.config.noti.gameObject:SetActive(false)
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

--- @return void
function UIEventChristmasArenaItem:RemoveAllListeners()
end

--- @return void
function UIEventChristmasArenaItem:OnClickBet(teamId)
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.EVENT_CHRISTMAS, "is_betting")
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    local eventTimeData = self.eventModel.timeData
    if eventTimeData.endTime - zg.timeMgr:GetServerTime() > TimeUtils.SecondAMin * 30 then
        local canBet = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.EVENT_CHRISTMAS_CANDLE, 1))
        if canBet then
            local data = {}
            data.teamId = teamId
            data.callbackBet = function(number, teamId)
                self:CallbackBet(number, teamId)
            end
            PopupMgr.ShowPopup(UIPopupName.UIChristmasArenaBet,data)
        end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("bet_time_out"))
    end
end

--- @return void
function UIEventChristmasArenaItem:OnClickOverview()
    local defenderTeamInfo = self.eventConfig:GetListLineupDefenderRecommendation(self.day)
    ---@type BattleTeamInfo
    local attackerTeamInfo = self.eventConfig:GetListLineupAttackerRecommendation(self.day)
    attackerTeamInfo.teamId = BattleConstants.ATTACKER_TEAM_ID
    attackerTeamInfo.summonerBattleInfo.teamId = BattleConstants.ATTACKER_TEAM_ID
    ---@type List --<HeroBattleInfo>
    local attackerListHeroInfo = attackerTeamInfo:GetListHero()
    ---@param v HeroBattleInfo
    for _, v in ipairs(attackerListHeroInfo:GetItems()) do
        v.teamId = BattleConstants.ATTACKER_TEAM_ID
    end

    local result = {}
    result.gameMode = GameMode.CHRISTMAS_ARENA_RECORD
    result.defenderTeamInfo = defenderTeamInfo
    result.attackerTeamInfo = attackerTeamInfo
    result.day = self.day
    local data = { tab = ChristmasTab.ARENA }
    result.callbackClose = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIEventChristmas, data, UIPopupName.UIMidAutumnArenaFormation)
    end
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMidAutumnArenaFormation, result, UIPopupName.UIEventChristmas)
end

--- @return void
function UIEventChristmasArenaItem:OnClickRecord()
    self.listHeroResource = self.eventModel:GetConfig().attackerTeamConfig:GetListHeroResourceByDay(self.day)
    ---@type BattleTeamInfo
    local attackerTeamInfo = self.eventConfig:GetListLineupAttackerRecommendation(self.day)
    attackerTeamInfo.teamId = BattleConstants.ATTACKER_TEAM_ID
    attackerTeamInfo.summonerBattleInfo.teamId = BattleConstants.ATTACKER_TEAM_ID
    ---@type List --<HeroBattleInfo>
    local attackerListHeroInfo = attackerTeamInfo:GetListHero()
    ---@param v HeroBattleInfo
    for _, v in ipairs(attackerListHeroInfo:GetItems()) do
        v.teamId = BattleConstants.ATTACKER_TEAM_ID
    end
    ---@type BattleTeamInfo
    local defenderTeamInfo = self.eventConfig:GetListLineupDefenderRecommendation(self.day)
    ---@type RandomHelper
    local randomHelper = RandomHelper()
    randomHelper:SetSeed(1)
    zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
    zg.battleMgr:RunCalculatedBattleScene(attackerTeamInfo, defenderTeamInfo, GameMode.CHRISTMAS_ARENA_RECORD, randomHelper)
end

--- @return void
function UIEventChristmasArenaItem:CallbackBet(number, teamId)
    InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_CHRISTMAS_CANDLE, number)
    self.eventModel:ListQuestBetAddCurrentNumber(number)
    self.view:UpdateNotificationByTab(ChristmasTab.QUEST)
    --- @type EventChristmasModel
    local betScoreInbound = self.eventModel:GetBetScoreInboundByDay(self.day)
    if betScoreInbound == nil then
        if teamId == ATTACKER_TEAM_ID then
            self.eventModel:AddBetScoreInboundByDay(self.day, number,0)
        else
            self.eventModel:AddBetScoreInboundByDay(self.day, 0,number)
        end
    else
        if teamId == ATTACKER_TEAM_ID then
            betScoreInbound.teamOne = betScoreInbound.teamOne + number
        else
            betScoreInbound.teamTwo = betScoreInbound.teamTwo + number
        end
    end

    self:UpdateBetCount()
end

function UIEventChristmasArenaItem:UpdateBetCount()
    --- @type EventMidAutumnBetArenaScoreInBound
    local betScoreInbound = self.eventModel:GetBetScoreInboundByDay(self.day)

    if betScoreInbound == nil then
        self.config.textBetAttackerCount.text = 0
        self.config.textBetDefenderCount.text = 0
    else
        self.config.textBetAttackerCount.text = betScoreInbound.teamOne
        self.config.textBetDefenderCount.text = betScoreInbound.teamTwo
    end
end

function UIEventChristmasArenaItem:CalculateRateRelative()
    local betScoreServerInbound = self.eventModel:GetBetScoreServerInboundByDay(self.day)
    if betScoreServerInbound == nil then
        return 0.5
    elseif betScoreServerInbound.teamOne == betScoreServerInbound.teamTwo and betScoreServerInbound.teamOne == 0 then
        return 0.5
    end
    local targetPoint = betScoreServerInbound.teamOne + betScoreServerInbound.teamTwo
    local rate = betScoreServerInbound.teamOne / targetPoint
    rate = rate > 0.8 and 0.8 or rate
    rate = rate < 0.2 and 0.2 or rate
    return rate
end

function UIEventChristmasArenaItem:UpdatePointBar()
    --- @type EventMidAutumnBetArenaScoreInBound
    local betScoreServerInbound = self.eventModel:GetBetScoreServerInboundByDay(self.day)

    local fillAmount = self:CalculateRateRelative()
    self.config.barAttackerProgressPercent.fillAmount = fillAmount

    self.config.barAttackerProgressPercentHeader.anchorMin = U_Vector2(fillAmount, 0.5)
    self.config.barAttackerProgressPercentHeader.anchorMax = U_Vector2(fillAmount, 0.5)

    if betScoreServerInbound ~= nil then
        self.config.textAttackerProgressPercent.text = betScoreServerInbound.teamOne
        self.config.textDefenderProgressPercent.text = betScoreServerInbound.teamTwo
    else
        self.config.textAttackerProgressPercent.text = 0
        self.config.textDefenderProgressPercent.text = 0
    end
end

function UIEventChristmasArenaItem:InitUpdateTime()
    self.config.textBattleTime.gameObject:SetActive(true)
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.config.textBattleTime.text = string.format(LanguageUtils.LocalizeCommon("event_mid_autumn_arena_item_text_battle_time"),
                TimeUtils.GetDeltaTime(self.timeRefresh))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end

function UIEventChristmasArenaItem:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventChristmasArenaItem:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventChristmasArenaItem:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventChristmasArenaItem:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

return UIEventChristmasArenaItem