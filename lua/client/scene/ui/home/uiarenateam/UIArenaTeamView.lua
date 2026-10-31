require "lua.client.core.network.otherPlayer.OtherPlayerInfoInBound"
require "lua.client.scene.ui.common.MoneyBarLocalView"
require "lua.client.core.network.arena.ArenaPreviousSeasonInBound"
require "lua.client.scene.ui.notification.NotificationArenaTeam"
require "lua.client.scene.ui.RegenTime"
require "lua.client.core.network.battleRecord.BattleRecord"
require "lua.client.core.network.arena.ArenaRequest"
require "lua.client.core.network.battleRecord.BattleRecordShortBase"

--- @class UIArenaTeamView : UIBaseView
UIArenaTeamView = Class(UIArenaTeamView, UIBaseView)

--- @return void
--- @param model UIArenaTeamModel
function UIArenaTeamView:Ctor(model)
    --- @type List -- BattleTeamView
    self.listBattleTeamView = List()
    ---@type MoneyBarLocalView
    self.moneyBarView = nil
    --- @type MoneyType
    self.moneyTicket = MoneyType.ARENA_TEAM_TICKET
    --- @type UISelect
    self.tabTeam = nil
    --- @type UISelect
    self.tabHistory = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type ArenaData
    self.arenaData = nil

    ---@type List --<BattleRecordShortBase>
    self.listRecordAttack = List()
    ---@type List --<BattleRecordShortBase>
    self.listRecordDefense = List()
    ---@type List --<BattleRecordShortBase>
    self.listRecord = List()

    UIBaseView.Ctor(self, model)
    --- @type UIArenaTeamModel
    self.model = model
end

--- @return void
function UIArenaTeamView:OnReadyCreate()
    ---@type UIArenaTeamConfig
    self.config = UIBaseConfig(self.uiTransform)
    uiCanvas:SetBackgroundSize(self.config.bg)

    self:InitButtons()
    self:InitTabTeam()
    self:InitTabHistory()
    self:InitScroll()
    self:InitUpdateTime()
end

function UIArenaTeamView:InitButtons()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonBattle.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBattle()
    end)
    self.config.buttonReward.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickReward()
    end)
    self.config.buttonLeaderboard.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickLeaderBoard()
    end)
    self.config.buttonMerchant.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickShop()
    end)
    self.config.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
    self.config.changeFormation.onClick:AddListener(function ()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChangeFormation()
    end)
end

function UIArenaTeamView:InitTabTeam()
    --- @param obj UITabPopupConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect)
        obj.button.interactable = not isSelect
        obj.imageOn.gameObject:SetActive(isSelect)
    end
    local onChangeSelect = function(indexTab)
        self:ShowTeam(indexTab)
    end
    self.tabTeam = UISelect(self.config.tabTeam, UIBaseConfig, onSelect, onChangeSelect)
end

function UIArenaTeamView:InitTabHistory()
    --- @param obj UITabPopupConfig
    --- @param isSelect boolean
    local onSelect = function(obj, isSelect)
        obj.button.interactable = not isSelect
        obj.imageOn.gameObject:SetActive(isSelect)
    end
    local onChangeSelect = function(indexTab)
        if indexTab == 1 then
            self:ShowAttackLog()
        elseif indexTab == 2 then
            self:ShowDefenseLog()
        end
    end
    self.tabHistory = UISelect(self.config.tabHistory, UIBaseConfig, onSelect, onChangeSelect)
end

function UIArenaTeamView:InitScroll()
    --- @param obj ArenaRecordItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type BattleRecordShort
        local battleRecordShort = self.listRecord:Get(index + 1)
        obj:SetData(battleRecordShort, NotificationArenaTeam.CheckNotificationRecordId(battleRecordShort))
    end
    --- @param obj ArenaRecordItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        onUpdateItem(obj, index)
        obj.callbackShowInfo = function(obj1)
            self:OnClickShowInfo(obj1)
        end
        obj.callbackBattle = function(obj2)
            self:OnClickBattleRecord(obj2)
        end
        obj.callbackWatchRecord = function(obj3)
            self:OnClickWatchRecord(obj3)
            NotificationArenaTeam.RemoveNotificationRecord(obj.battleRecordShort)
        end
    end
    self.uiScroll = UILoopScroll(self.config.scrollHistory, UIPoolType.ArenaRecordItemView, onCreateItem, onUpdateItem)
end

function UIArenaTeamView:InitLocalization()
    self.config.textReward.text = LanguageUtils.LocalizeCommon("reward")
    self.config.textLeaderboard.text = LanguageUtils.LocalizeCommon("leaderboard")
    self.config.textMerchant.text = LanguageUtils.LocalizeCommon("shop")
    self.config.textBattle.text = LanguageUtils.LocalizeCommon("battle")

    local textAttacker = LanguageUtils.LocalizeCommon("attacker")
    self.config.textAttackerTeamOn.text = textAttacker
    self.config.textAttackerTeamOff.text = textAttacker
    self.config.textAttackerTeamOnLog.text = textAttacker
    self.config.textAttackerTeamOffLog.text = textAttacker

    local textDefender = LanguageUtils.LocalizeCommon("defender")
    self.config.textDefenderTeamOn.text = textDefender
    self.config.textDefenderTeamOff.text = textDefender
    self.config.textDefenderTeamOnLog.text = textDefender
    self.config.textDefenderTeamOffLog.text = textDefender

    self.config.textChangeFormation.text = LanguageUtils.LocalizeCommon("change_formation")

    self.localizeSeasonEnd = LanguageUtils.LocalizeCommon("season_end_in")
end

function UIArenaTeamView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)
    self.arenaData = zg.playerData:GetArenaData()
    --- @type ArenaTeamInBound
    self.arenaTeamInBound = zg.playerData:GetMethod(PlayerDataMethod.ARENA_TEAM)
    self.arenaTeamInBound:InitRegenTime()

    self:ShowTeam(BattleConstants.ATTACKER_TEAM_ID)

    self:ShowMoneyBar()

    self:CheckShowSeasonReward()

    self:ShowPlayerRanking()
    self.tabHistory:Select(2)

    if self.arenaTeamInBound ~= nil then
        self:ShowRegen()
        self:StartTime()
        self:LoadRecord()
    end
    self.tabTeam:Select(BattleConstants.ATTACKER_TEAM_ID)
    self.subscriptionRefresh = RxMgr.arenaRefresh:Subscribe(function()
        self:Refresh()
        self:LoadRecord()
    end)
end

--- @return void
function UIArenaTeamView:Refresh()
    if self.tabHistory.indexTab == 1 then
        self:ShowAttackLog()
    elseif self.tabHistory.indexTab == 2 then
        self:ShowDefenseLog()
    end
    self:ShowPlayerRanking()
end

function UIArenaTeamView:ShowRegen()
    if self.regenTime == nil then
        self.regenTime = RegenTime()
        self.regenTime.moneyType = self.moneyTicket
        self.regenTime.onFirstUpdateTime = function()
            self.config.timeStamina.gameObject:SetActive(true)
            UIUtils.AlignText(self.config.timeStamina)
        end
        self.regenTime.onUpdateTime = function(time)
            self.config.timeStamina.text = time
        end
        self.regenTime.onFinishUpdateTime = function(time)
            self.config.timeStamina.gameObject:SetActive(false)
        end
    end
    self.regenTime.regenTimeData = self.arenaTeamInBound.regenTimeData
    self.regenTime:Init()
end

function UIArenaTeamView:ShowTeam(teamId)
    self:ReturnPoolBattle()
    teamId = teamId or BattleConstants.ATTACKER_TEAM_ID
    for i = 1, 3 do
        ---@type BattleTeamView
        local battleTeamView = BattleTeamView(self.config.formationAnchor)
        self.listBattleTeamView:Add(battleTeamView)
        ---@type BattleTeamInfo
        local battleTeamInfo = ClientConfigUtils.GetBattleTeamInfoArenaTeam(teamId, i)
        self:UpdateTeam(battleTeamView, battleTeamInfo)
    end
end

--- @return void
--- @param battleTeamInfo BattleTeamInfo
--- @param battleTeamView BattleTeamView
function UIArenaTeamView:UpdateTeam(battleTeamView, battleTeamInfo)
    battleTeamView:Show()
    battleTeamView:SetDataDefender(UIPoolType.HeroIconView, battleTeamInfo)
    battleTeamView.uiTeamView:SetSummonerInfo(battleTeamInfo.summonerBattleInfo)
    battleTeamView.uiTeamView:ActiveBuff(false)
    battleTeamView.uiTeamView:ActiveLinking(false)
end

--- @return void
--- @param arenaRecordItemView ArenaRecordItemView
function UIArenaTeamView:OnClickBattleRecord(arenaRecordItemView)
    arenaRecordItemView.battleRecordShort:RequestBattleArenaTeam()
end

--- @return void
function UIArenaTeamView:ClickChangeTeam(team, id)
    ---@type TeamFormationInBound
    local teamFormationInBound = zg.playerData:GetFormationInBound().arenaTeamDict:Get(team * 1000 + id)
    if teamFormationInBound == nil then
        teamFormationInBound = TeamFormationInBound()
        teamFormationInBound:SetDefaultTeam()
    end
    local data = {}
    data.teamFormation = teamFormationInBound
    data.listHeroIgnor = ClientConfigUtils.GetListHeroIgnor(team, id)
    data.callbackClose = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIArenaTeam, nil, UIPopupName.UIFormation2)
    end
    data.callbackPlayBattle = function(uiFormationTeamData, callback, power)
        --UIArenaTeamView.SetFormationArenaTeam(uiFormationTeamData, team, id, function()
        --    PopupMgr.ShowAndHidePopup(UIPopupName.UIArenaTeam, nil, UIPopupName.UIFormation2)
        --    --self:ShowBattle()
        --end)
    end
    self.cache = true
    PopupMgr.ShowAndHidePopup(UIPopupName.UIFormation2, data, UIPopupName.UIArenaTeam)
end

--- @return void
function UIArenaTeamView:ReturnPoolBattle()
    if self.listBattleTeamView ~= nil then
        ---@param v BattleTeamView
        for i, v in ipairs(self.listBattleTeamView:GetItems()) do
            v:Hide()
        end
        self.listBattleTeamView:Clear()
    end
end

--- @return void
function UIArenaTeamView:Hide()
    UIBaseView.Hide(self)
    self:ReturnPoolBattle()
    if self.moneyBarView ~= nil then
        self.moneyBarView:RemoveListener()
    end
    self:StopTime()
end

function UIArenaTeamView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UIArenaTeamView:OnReadyHide()
    if self.callbackClose ~= nil then
        self.callbackClose()
    else
        PopupMgr.ShowAndHidePopup(UIPopupName.UISelectArena, nil, self.model.uiName)
        --PopupMgr.ShowPopup(UIPopupName.UISelectArena)
    end
end

function UIArenaTeamView:OnClickBattle()
    ArenaRequest.RequestArenaTeamOpponent(function()
        local result = {}
        result.callbackUpdateFormation = function()
            self:ShowTeam(self.tabTeam.indexTab)
        end
        PopupMgr.ShowPopup(UIPopupName.UIArenaTeamSearch, result)
    end)
end

function UIArenaTeamView:OnClickReward()
    PopupMgr.ShowPopup(UIPopupName.UIArenaReward, FeatureType.ARENA_TEAM)
end

function UIArenaTeamView:OnClickLeaderBoard()
    PopupMgr.ShowPopup(UIPopupName.UIArenaLeaderboard, FeatureType.ARENA_TEAM)
end

function UIArenaTeamView:OnClickShop()
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.BLACK_MARKET) then
        PopupMgr.ShowAndHidePopup(UIPopupName.UIMarket,
                {
                    ["marketType"] = MarketType.ARENA_TEAM_MARKET,
                    ["callbackClose"] = function()
                        PopupMgr.ShowAndHidePopup(self.model.uiName, nil, UIPopupName.UIMarket)
                    end },
                self.model.uiName)
    end
end

function UIArenaTeamView:OnClickHelpInfo()
    local info = LanguageUtils.LocalizeHelpInfo("arena_team_info")
    info = string.gsub(info, "{1}", tostring(ResourceMgr.GetArenaTeamConfig().singleTurnFreeDaily))
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

function UIArenaTeamView:ShowMoneyBar()
    if self.moneyBarView == nil then
        self.moneyBarView = MoneyBarLocalView(self.config.moneyBarInfo)
        self.moneyBarView:AddListener(function()
            self:OnClickBuyTicket()
        end)
    end
    self.moneyBarView:SetIconData(self.moneyTicket, true)
    self.moneyBarView:SetBuyText(ResourceMgr.GetArenaTeamConfig().maxTicket)
end

function UIArenaTeamView:OnClickBuyTicket()
    ---@type ArenaTeamInBound
    local arenaTeamInBound = self.arenaTeamInBound
    --- @type VipData
    local vipDataConfig = ResourceMgr.GetVipConfig():GetCurrentBenefits()
    local turnCanBuy = ResourceMgr.GetArenaTeamConfig().singlePassMaxBuy - arenaTeamInBound.turnBoughtDaily + vipDataConfig.arenaBonusTicketBuy
    if turnCanBuy > 0 then
        local callback = function(numberReturn, priceTotal)
            local onReceived = function(result)
                local onSuccess = function()
                    InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, priceTotal)
                    InventoryUtils.Add(ResourceType.Money, self.moneyTicket, numberReturn)
                    arenaTeamInBound.turnBoughtDaily = arenaTeamInBound.turnBoughtDaily + numberReturn
                    SmartPoolUtils.ShowReward1Item(ItemIconData.CreateInstance(ResourceType.Money, self.moneyTicket, numberReturn))
                end
                NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
            end
            NetworkUtils.Request(OpCode.ARENA_TEAM_TICKET_BUY, UnknownOutBound.CreateInstance(PutMethod.Byte, numberReturn), onReceived)
        end
        ---@type PopupBuyItemData
        local dataPurchase = PopupBuyItemData()
        dataPurchase:SetData(ResourceType.Money, self.moneyTicket, 1, 1, turnCanBuy,
                MoneyType.GEM, ResourceMgr.GetArenaTeamConfig().gemPrice, callback,
                LanguageUtils.LocalizeMoneyType(self.moneyTicket), LanguageUtils.LocalizeCommon("buy"), false)
        PopupMgr.ShowPopup(UIPopupName.UIPopupBuyItem, dataPurchase)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_turn_bought"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

function UIArenaTeamView:ShowPlayerRanking()
    self.config.textPoint.text = UIUtils.SetColorString(UIUtils.color11, self.arenaTeamInBound.eloPoint)
    local currentRanking = self.arenaTeamInBound.currentRanking
    self.config.iconCurrentRanking.sprite = ClientConfigUtils.GetIconRankingArenaByElo(self.arenaTeamInBound.eloPoint, currentRanking, FeatureType.ARENA_TEAM)
    self.config.iconCurrentRanking:SetNativeSize()
    local showRank = function()
        if currentRanking ~= nil and currentRanking >= 0 then
            self.config.textRanking.text = string.format(LanguageUtils.LocalizeCommon("rank_x"),
                    UIUtils.SetColorString(UIUtils.color11, currentRanking))
        else
            self.config.textRanking.text = string.format(LanguageUtils.LocalizeCommon("rank_x"),
                    UIUtils.SetColorString(UIUtils.color11, "N/A"))
        end
        self.config.iconCurrentRanking.sprite = ClientConfigUtils.GetIconRankingArenaByElo(self.arenaTeamInBound.eloPoint, currentRanking, FeatureType.ARENA_TEAM)
        self.config.iconCurrentRanking:SetNativeSize()
    end
    if currentRanking == nil then
        self.arenaTeamInBound:GetArenaRanking(function ()
            currentRanking = self.arenaTeamInBound.currentRanking
            showRank()
        end)
    else
        showRank()
    end
end

function UIArenaTeamView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self.timeFinish = self.eventTime.endTime - zg.timeMgr:GetServerTime()
        else
            self.timeFinish = self.timeFinish - 1
        end
        if self.timeFinish > 0 then
            self.config.textSeasonEnd.text = string.format("%s %s", self.localizeSeasonEnd, UIUtils.SetColorString(UIUtils.color2, TimeUtils.GetDeltaTime(self.timeFinish, 4)))
            if isSetTime == true then
                UIUtils.AlignText(self.config.textSeasonEnd)
            end
        else
            self.config.textSeasonEnd.text = ""
            self:StopTime()
        end
    end
end

function UIArenaTeamView:StartTime()
    if self.updateTime ~= nil then
        ---@type EventTimeData
        self.eventTime = zg.playerData:GetEvents():GetEvent(EventTimeType.ARENA_TEAM):GetTime()
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end

function UIArenaTeamView:StopTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end

function UIArenaTeamView:ShowAttackLog()
    self.listRecord = self.listRecordAttack
    self:ShowRecord()
end

function UIArenaTeamView:ShowDefenseLog()
    self.listRecord = self.listRecordDefense
    self:ShowRecord()
end

function UIArenaTeamView:ShowRecord()
    self.uiScroll:Resize(self.listRecord:Count())
end

function UIArenaTeamView:LoadRecord()
    ---@type Job
    local checkDataNotiRecord = Job(function(onSuccess, onFailed)
        if NotificationArenaTeam.records == nil then
            NotificationArenaTeam.LoadFromServer(onSuccess, onSuccess)
        else
            if onSuccess ~= nil then
                onSuccess()
            end
        end
    end)

    ---@type Job
    local checkDataRecord = Job(function(onSuccess, onFailed)
        if self.arenaData.arenaTeamRecordDataInBound == nil or self.arenaData.arenaTeamRecordDataInBound:IsAvailableToRequest() then
            ArenaRequest.RequestArenaRecord(GameMode.ARENA_TEAM, function (battleRecordDataInBound)
                zg.playerData:GetArenaData().arenaTeamRecordDataInBound = battleRecordDataInBound
                if onSuccess ~= nil then
                    onSuccess()
                end
            end, onFailed)
        else
            if onSuccess ~= nil then
                onSuccess()
            end
        end
    end)

    ---@type Job
    local job = checkDataRecord + checkDataNotiRecord
    job:Complete(function()
        ---@type  ArenaData
        self.arenaData = zg.playerData:GetArenaData()
        self.listRecordAttack:Clear()
        self.listRecordDefense:Clear()
        if (self.arenaData.arenaTeamRecordDataInBound ~= nil) then
            ---@param v BattleRecordShort
            for i, v in ipairs(self.arenaData.arenaTeamRecordDataInBound.listRecord:GetItems()) do
                if v:IsAttacker() then
                    self.listRecordAttack:Add(v)
                else
                    self.listRecordDefense:Add(v)
                end
            end
            for i, v in ipairs(self.arenaData.arenaTeamRecordDataInBound.listRecordBot:GetItems()) do
                self.listRecordAttack:Add(v)
            end
            self.listRecordAttack:SortWithMethod(BattleRecordShortBase.Sort)
            if self.listRecordAttack:Count() > 10 then
                for i = self.listRecordAttack:Count(), 11, -1 do
                    self.listRecordAttack:RemoveByIndex(i)
                end
            end
            self.listRecordDefense:SortWithMethod(BattleRecordShortBase.Sort)
        end
        self.uiScroll:Resize(self.listRecord:Count())
        self.uiScroll:PlayMotion()
    end)
end

function UIArenaTeamView:OnClickChangeFormation()
    local result = {}
    result.callbackUpdateFormation = function()
        self:ShowTeam(self.tabTeam.indexTab)
    end
    PopupMgr.ShowPopup(UIPopupName.UIChangeFormationArenaTeam, result)
end

--- @return void
--- @param arenaRecordItemView ArenaRecordItemView
function UIArenaTeamView:OnClickWatchRecord(arenaRecordItemView)
    ---@param arenaTeamBattleRecordInBound ArenaTeamBattleRecordInBound
    local runRecord = function(arenaTeamBattleRecordInBound)
        ClientBattleData.skipForReplay = true
        zg.playerData.rewardList = nil
        ---@type ArenaData
        local arenaData = zg.playerData:GetArenaData()
        ---@type BattleMgr
        local battleMgr = zg.battleMgr

        battleMgr.attacker = arenaTeamBattleRecordInBound:GetAttackerData()
        battleMgr.defender = arenaTeamBattleRecordInBound:GetDefenderData()
        battleMgr.attacker.score = arenaRecordItemView.battleRecordShort.attackerElo
        battleMgr.defender.score = arenaRecordItemView.battleRecordShort.defenderElo
        battleMgr.attacker.scoreChange = arenaRecordItemView.battleRecordShort.eloChange
        battleMgr.defender.scoreChange = arenaRecordItemView.battleRecordShort.eloChange

        if arenaRecordItemView.battleRecordShort:IsBot() then
            arenaData.arenaTeamBattleData = ArenaTeamBattleData.CreateByArenaTeamBattleBotRecordInBound(arenaTeamBattleRecordInBound)
        else
            arenaData.arenaTeamBattleData = ArenaTeamBattleData.CreateByArenaTeamBattleRecordInBound(arenaTeamBattleRecordInBound)
        end
        arenaData.indexArenaTeam = 1
        BattleMgr.RunArenaTeamBattle(arenaData.arenaTeamBattleData, arenaData.indexArenaTeam, GameMode.ARENA_TEAM_RECORD, arenaData.arenaTeamBattleData.listBattleDetail:Get(arenaData.indexArenaTeam).battleLog)
    end

    arenaRecordItemView.battleRecordShort:RequestGetBattleData(runRecord, SmartPoolUtils.LogicCodeNotification)
end

--- @return void
function UIArenaTeamView:CheckShowSeasonReward()
    ---@type EventTimeData
    local eventTime = zg.playerData:GetEvents():GetEvent(EventTimeType.ARENA_TEAM):GetTime()
    if zg.playerData.arenaTeamDataNoti.season ~= eventTime.season then
        UIArenaTeamView.RequestArenaPreviousSeason(function(data)
            local season = data.season
            zg.playerData.arenaTeamDataNoti.season = eventTime.season
            if season ~= zg.playerData.remoteConfig.arenaTeamPreviousSeason then
                zg.playerData.remoteConfig.arenaTeamPreviousSeason = season
                zg.playerData:SaveRemoteConfig()
                data.callbackGotoMail = function()
                    PopupMgr.HidePopup(UIPopupName.UIArenaTeam)
                end
                data.featureType = FeatureType.ARENA_TEAM
                PopupMgr.ShowPopup(UIPopupName.UIPopupRewardArena, data)
            end
        end)
    end
end

--- @return void
function UIArenaTeamView.RequestArenaPreviousSeason(onSuccess, onFailed)
    local onReceived = function(result)
        ---@type ArenaPreviousSeasonInBound
        local arenaPreviousSeasonInBound = nil
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            require("lua.client.core.network.arena.ArenaPreviousSeasonInBound")
            arenaPreviousSeasonInBound = ArenaPreviousSeasonInBound.CreateByBuffer(buffer)
        end
        local success = function()
            XDebug.Log("ARENA_PREVIOUS_SEASON_RESULT_GET success")
            onSuccess(arenaPreviousSeasonInBound)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, success, onFailed)
    end
    NetworkUtils.Request(OpCode.ARENA_TEAM_PREVIOUS_SEASON_RESULT_GET,
            nil, onReceived)
end