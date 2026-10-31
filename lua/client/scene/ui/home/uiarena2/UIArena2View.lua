require "lua.client.core.network.playerData.arena.ArenaOpponentCompactInfoInBound"
require "lua.client.core.network.otherPlayer.OtherPlayerInfoInBound"
require "lua.client.scene.ui.common.MoneyBarLocalView"
require "lua.client.core.network.arena.ArenaPreviousSeasonInBound"
require "lua.client.scene.ui.notification.NotificationArena"
require "lua.client.scene.ui.RegenTime"
require "lua.client.core.network.battleRecord.BattleRecord"
require "lua.client.core.network.arena.ArenaRequest"
require "lua.client.core.network.battleRecord.BattleRecordShortBase"

--- @class UIArena2View : UIBaseView
UIArena2View = Class(UIArena2View, UIBaseView)

--- @return void
--- @param model UIArena2Model
function UIArena2View:Ctor(model, ctrl)
    ---@type ArenaDataInBound
    self.arenaDataInBound = nil
    ---@type UIArena2Config
    self.config = nil
    --- @type UISelect
    self.tab = nil
    ---@type MoneyBarLocalView
    self.moneyBarView = nil
    --- @type ArenaData
    self.arenaData = nil
    --- @type RegenTime
    self.regenTime = nil

    --- @type WorldFormation
    self.worldFormation = nil

    ---@type List --<BattleRecordShortBase>
    self.listRecordAttack = List()
    ---@type List --<BattleRecordShortBase>
    self.listRecordDefense = List()
    ---@type List --<BattleRecordShortBase>
    self.listRecord = List()
    ---@type boolean
    self.cacheWorldFormation = false
    --- @type MoneyType
    self.moneyTicket = MoneyType.ARENA_TICKET
    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIArena2Model
    self.model = model
end

--- @return void
function UIArena2View:OnReadyCreate()
    ---@type UIArena2Config
    self.config = UIBaseConfig(self.uiTransform)
    self:_InitButtonListener()

    -- Tab
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
    self.tab = UISelect(self.config.tab, UIBaseConfig, onSelect, onChangeSelect)

    -- Scroll
    --- @param obj ArenaRecordItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type BattleRecordShort
        local battleRecordShort = self.listRecord:Get(index + 1)
        obj:SetData(battleRecordShort, NotificationArena.CheckNotificationRecordId(battleRecordShort))
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
            NotificationArena.RemoveNotificationRecord(obj.battleRecordShort)
        end
    end

    --- @type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.ArenaRecordItemView, onCreateItem, onUpdateItem)

    self:InitUpdateTime()
end

--- @return void
function UIArena2View:InitLocalization()
    self.config.localizeBattle.text = LanguageUtils.LocalizeCommon("battle")
    self.config.localizeDefense.text = LanguageUtils.LocalizeCommon("defense")
    self.config.localizeRecord.text = LanguageUtils.LocalizeCommon("leaderboard")
    self.config.localizeReward.text = LanguageUtils.LocalizeCommon("reward")
    local attackLog = LanguageUtils.LocalizeCommon("attack_log")
    self.config.localizeAttack1.text = attackLog
    self.config.localizeAttack2.text = attackLog
    local defenseLog = LanguageUtils.LocalizeCommon("defense_log")
    self.config.localizeDefense1.text = defenseLog
    self.config.localizeDefense2.text = defenseLog
    self.localizeSeasonEnd = LanguageUtils.LocalizeCommon("season_end_in")
end

function UIArena2View:_InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonReward.onClick:AddListener(function()
        self:OnClickReward()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonRecord.onClick:AddListener(function()
        self:OnClickLeaderBoard()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonDefense.onClick:AddListener(function()
        self:OnClickDefence()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonBattle.onClick:AddListener(function()
        self:OnClickBattle()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonStore.onClick:AddListener(function()
        self:OnClickShop()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buttonHelp.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

--- @return void
function UIArena2View:Refresh()
    if self.tab.indexTab == 1 then
        self:ShowAttackLog()
    elseif self.tab.indexTab == 2 then
        self:ShowDefenseLog()
    end
    self:ShowRanking()
    self:CheckNotiFreeTurn()
end

--- @return void
function UIArena2View:CheckNotiFreeTurn()
    self.config.notiBattle:SetActive(InventoryUtils.CanUseFreeTurnArena())
end

function UIArena2View:OnShowWorldFormation()
    local teamFormation = TeamFormationInBound.Clone(zg.playerData:GetFormationInBound().teamDict:Get(GameMode.ARENA))
    local summonerInbound = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
    self.worldFormation:SetAttackerFormation(teamFormation.formationId)
    self.worldFormation:EnableModification(false)
    self.coroutine = Coroutine.start(function()
        coroutine.waitforseconds(0.15)
        ---@type DetailTeamFormation
        local detailTeamFormation = DetailTeamFormation.CreateByTeamFormationInBound(teamFormation)
        self.worldFormation:ShowAttackerPredefineTeam(detailTeamFormation)
        self.worldFormation:ShowAttackerSummoner(teamFormation.summonerId, summonerInbound.star)
        self.worldFormation:EnableModification(false)
    end)
end

--- @return void
function UIArena2View:OnReadyShow(result)
    UIBaseView.OnReadyShow(self, result)
    if result ~= nil then
        self.worldFormation = result.worldFormation
    end
    self.cacheWorldFormation = false
    self.model.listSingleArenaRankingInBound = zg.playerData:GetMethod(PlayerDataMethod.ARENA_SERVER_RANKING)

    if self.worldFormation == nil then
        require "lua.client.scene.ui.home.uiFormation2.worldFormation.WorldFormation"
        local transform = SmartPool.Instance:SpawnTransform(AssetType.UI, "world_formation")
        self.worldFormation = WorldFormation(transform)
        self.worldFormation:OnShow()
        self:OnShowWorldFormation()
        local bgAnchorTop, bgAnchorBot = BattleBackgroundUtils.GetBgAnchorNameByMode(GameMode.ARENA)
        self.worldFormation:ShowBgAnchor(bgAnchorTop, bgAnchorBot)
    end
    self.worldFormation:EnableModification(false)

    self.canPlayMotion = true

    self:CheckShowSeasonReward()
    self:CheckNotiFreeTurn()
    self.arenaDataInBound = zg.playerData:GetMethod(PlayerDataMethod.ARENA)
    self.arenaDataInBound:InitRegenTime()
    self.arenaData = zg.playerData:GetArenaData()

    if self.regenTime == nil then
        self.regenTime = RegenTime()
        self.regenTime.moneyType = self.moneyTicket
        self.regenTime.onFirstUpdateTime = function()
            self.config.timeStamina.gameObject:SetActive(true)
            UIUtils.AlignText(self.config.timeStamina)
        end
        self.regenTime.onUpdateTime = function(time)
            self.config.timeStamina.text = time--UIUtils.SetColorString(UIUtils.color2, time)
        end
        self.regenTime.onFinishUpdateTime = function(time)
            self.config.timeStamina.gameObject:SetActive(false)
        end
    end
    self.regenTime.regenTimeData = self.arenaDataInBound.regenTimeData
    self.regenTime:Init()
    if zg.playerData:GetFormationInBound().teamDict:IsContainKey(GameMode.ARENA) == false then
        self:OnClickDefence()
    else
        self:OnShowUI()
        self:StartTime()
    end
    self.subscriptionRefresh = RxMgr.arenaRefresh:Subscribe(function()
        self:Refresh()
        self:LoadRecord()
    end)

    self:LoadRecord()
end

function UIArena2View:HideWorldFormation()
    if self.worldFormation ~= nil and self.cacheWorldFormation ~= true then
        self.worldFormation:OnHide()
        self.worldFormation = nil
    end
end

--- @return void
function UIArena2View:Hide()
    UIBaseView.Hide(self)
    self.uiScroll:Hide()
    if self.moneyBarView ~= nil then
        self.moneyBarView:RemoveListener()
    end
    self:StopTime()
    if self.subscriptionRefresh ~= nil then
        self.subscriptionRefresh:Unsubscribe()
    end
    if self.regenTime ~= nil then
        self.regenTime:Hide()
    end
    ClientConfigUtils.KillCoroutine(self.coroutine)
    self:HideWorldFormation()
end

--- @return void
function UIArena2View.RequestArenaPreviousSeason(onSuccess, onFailed)
    local onReceived = function(result)
        ---@type ArenaPreviousSeasonInBound
        local arenaPreviousSeasonInBound = nil
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            arenaPreviousSeasonInBound = ArenaPreviousSeasonInBound.CreateByBuffer(buffer)
        end
        local success = function()
            XDebug.Log("ARENA_PREVIOUS_SEASON_RESULT_GET success")
            onSuccess(arenaPreviousSeasonInBound)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, success, onFailed)
    end
    NetworkUtils.Request(OpCode.ARENA_PREVIOUS_SEASON_RESULT_GET,
            nil, onReceived)
end

--- @return void
function UIArena2View:CheckShowSeasonReward()
    ---@type EventTimeData
    local eventTime = zg.playerData:GetEvents():GetEvent(EventTimeType.ARENA):GetTime()
    if zg.playerData.arenaDataNoti.season ~= eventTime.season then
        UIArena2View.RequestArenaPreviousSeason(function(data)
            local season = data.season
            zg.playerData.arenaDataNoti.season = eventTime.season
            if season ~= zg.playerData.remoteConfig.arenaPreviousSeason then
                zg.playerData.remoteConfig.arenaPreviousSeason = season
                zg.playerData:SaveRemoteConfig()
                data.callbackGotoMail = function()
                    PopupMgr.HidePopup(UIPopupName.UIArena2)
                end
                data.featureType = FeatureType.ARENA
                PopupMgr.ShowPopup(UIPopupName.UIPopupRewardArena, data)
            end
        end)
    end
end

--- @return void
function UIArena2View:OnShowUI()
    self.tab:Select(2)
    self:ShowRanking()
    if self.moneyBarView == nil then
        self.moneyBarView = MoneyBarLocalView(self.config.moneyBarInfo)
        self.moneyBarView:AddListener(function()
            self:ShowBuyArenaTicket()
        end)
    end
    self.moneyBarView:SetIconData(self.moneyTicket, true)
    self.moneyBarView:SetBuyText(ResourceMgr.GetArenaConfig().maxTicket)
end

--- @return void
function UIArena2View:ShowRanking()
    self.config.textPoint.text = UIUtils.SetColorString(UIUtils.color11, self.arenaDataInBound.eloPoint) --LanguageUtils.LocalizeCommon("point") ..
    --string.format(": %s", self.arenaDataInBound.eloPoint)
    local currentRanking = nil
    if self.model.listSingleArenaRankingInBound ~= nil then
        currentRanking = self.model.listSingleArenaRankingInBound.currentRanking
    end
    if currentRanking ~= nil and currentRanking >= 0 then
        self.config.textRanking.text = string.format(LanguageUtils.LocalizeCommon("rank_x"), UIUtils.SetColorString(UIUtils.color11, currentRanking))
    else
        self.config.textRanking.text = string.format(LanguageUtils.LocalizeCommon("rank_x"), UIUtils.SetColorString(UIUtils.color11, "N/A"))
    end
    self.config.iconRankArena.sprite = ClientConfigUtils.GetIconRankingArenaByElo(self.arenaDataInBound.eloPoint, currentRanking, FeatureType.ARENA)
    self.config.iconRankArena:SetNativeSize()
end

function UIArena2View:ShowBuyArenaTicket()
    ---@type ArenaDataInBound
    local arenaDataInBound = self.arenaDataInBound
    --- @type VipData
    local vipDataConfig = ResourceMgr.GetVipConfig():GetCurrentBenefits()
    local turnCanBuy = ResourceMgr.GetArenaConfig().singlePassMaxBuy - arenaDataInBound.turnBoughtDaily + vipDataConfig.arenaBonusTicketBuy
    if turnCanBuy > 0 then
        local callback = function(numberReturn, priceTotal)
            local onReceived = function(result)
                local onSuccess = function()
                    InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, priceTotal)
                    InventoryUtils.Add(ResourceType.Money, self.moneyTicket, numberReturn)
                    arenaDataInBound.turnBoughtDaily = arenaDataInBound.turnBoughtDaily + numberReturn
                    SmartPoolUtils.ShowReward1Item(ItemIconData.CreateInstance(ResourceType.Money, self.moneyTicket, numberReturn))
                end
                NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
            end
            NetworkUtils.Request(OpCode.ARENA_TICKET_BUY, UnknownOutBound.CreateInstance(PutMethod.Byte, numberReturn), onReceived)
        end
        ---@type PopupBuyItemData
        local dataPurchase = PopupBuyItemData()
        dataPurchase:SetData(ResourceType.Money, self.moneyTicket, 1, 1, turnCanBuy,
                MoneyType.GEM, ResourceMgr.GetArenaConfig().gemPrice, callback, LanguageUtils.LocalizeMoneyType(self.moneyTicket), LanguageUtils.LocalizeCommon("buy"), false)
        PopupMgr.ShowPopup(UIPopupName.UIPopupBuyItem, dataPurchase)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_turn_bought"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

function UIArena2View:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UIArena2View:OnReadyHide()
    if self.callbackClose ~= nil then
        self.callbackClose()
    else
        --- @type FeatureConfigInBound
        local featureConfigInBound = zg.playerData:GetMethod(PlayerDataMethod.FEATURE_CONFIG)
        local featureItemInBound = featureConfigInBound:GetFeatureConfigInBound(FeatureType.ARENA_TEAM)
        if featureItemInBound.featureState ~= FeatureState.COMING_SOON
                and featureItemInBound.featureState ~= FeatureState.UNLOCK then
            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
        else
            PopupMgr.ShowAndHidePopup(UIPopupName.UISelectArena, nil, self.model.uiName)
        end
    end
end

function UIArena2View:ShowAttackLog()
    self.listRecord = self.listRecordAttack
    self:ShowRecord()
end

function UIArena2View:ShowDefenseLog()
    self.listRecord = self.listRecordDefense
    self:ShowRecord()
end

--- @return void
function UIArena2View:OnClickReward()
    PopupMgr.ShowPopup(UIPopupName.UIArenaReward, FeatureType.ARENA)
end

--- @return void
function UIArena2View:OnClickLeaderBoard()
    PopupMgr.ShowPopup(UIPopupName.UIArenaLeaderboard, FeatureType.ARENA)
end

--- @return void
function UIArena2View.OverridePower(power)
    if zg.playerData:GetMethod(PlayerDataMethod.ARENA_SERVER_RANKING) ~= nil then
        ---@param v SingleArenaRanking
        for _, v in ipairs(zg.playerData:GetMethod(PlayerDataMethod.ARENA_SERVER_RANKING).listRanking:GetItems()) do
            if v.playerId == PlayerSettingData.playerId then
                v.power = power
                break
            end
        end
    end
    if zg.playerData:GetMethod(PlayerDataMethod.ARENA_GROUP_RANKING) ~= nil then
        ---@param v SingleArenaRanking
        for _, v in ipairs(zg.playerData:GetMethod(PlayerDataMethod.ARENA_GROUP_RANKING).listRanking:GetItems()) do
            if v.playerId == PlayerSettingData.playerId then
                v.power = power
                break
            end
        end
    end
end

--- @return void
function UIArena2View:OnClickDefence(callbackSuccess, callbackClose)

    local result = {}
    result.gameMode = GameMode.ARENA
    self.cacheWorldFormation = true
    result.worldFormation = self.worldFormation
    result.returnWorldFormation = function()
        return nil
    end
    local getResultCallback = function()
        --return nil
        return { ["worldFormation"] = result.returnWorldFormation() }
    end
    result.callbackClose = function()
        PopupMgr.HidePopup(UIPopupName.UIFormation2)
        PopupMgr.ShowPopup(UIPopupName.UIArena2, getResultCallback())
        if callbackClose ~= nil then
            callbackClose()
        end
    end
    result.callbackPlayBattle = function(uiFormationTeamData, callback, power)
        ArenaRequest.SetFormationArena(uiFormationTeamData, function()
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.ARENA,
                                                   PlayerDataMethod.ARENA_GROUP_RANKING,
                                                   PlayerDataMethod.ARENA_SERVER_RANKING },
                    function()
                        UIArena2View.OverridePower(power)
                        PopupMgr.ShowAndHidePopup(UIPopupName.UIArena2, getResultCallback(), UIPopupName.UIFormation2)
                        self:OnShowUI()
                        if callbackSuccess ~= nil then
                            callbackSuccess()
                        end
                    end
            )
        end)
    end
    result.tittle = LanguageUtils.LocalizeCommon("save")
    PopupMgr.ShowAndHidePopup(UIPopupName.UIFormation2, result, UIPopupName.UIArena2)
end

--- @return void
function UIArena2View.RequestArenaRecord(callbackSuccess, callbackFailed)
    local onReceived = function(result)
        ---@type ArenaData
        local arenaData = zg.playerData:GetArenaData()
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            if arenaData.arenaRecordDataInBound ~= nil then
                arenaData.arenaRecordDataInBound:Ctor(buffer)
            else
                arenaData.arenaRecordDataInBound = BattleRecordDataInBound(buffer)
            end
        end
        local onSuccess = function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
        end
        local onFailed = function(logicCode)
            if callbackFailed ~= nil then
                callbackFailed()
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.RECORD_LIST_GET, UnknownOutBound.CreateInstance(PutMethod.Byte, GameMode.ARENA, PutMethod.Long, PlayerSettingData.playerId), onReceived)
end

--- @return void
function UIArena2View:StopCoroutineRequestOpponent()
    if self.coroutineRequestOpponent ~= nil then
        Coroutine.stop(self.coroutineRequestOpponent)
        self.coroutineRequestOpponent = nil
    end
end

--- @return void
function UIArena2View:OnClickHelpInfo()
    local info = LanguageUtils.LocalizeHelpInfo("arena_info")
    --info = string.gsub(info, "{1}", tostring(ResourceMgr.GetArenaConfig().singleTurnFreeDaily))
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

--- @return void
function UIArena2View:OnClickShop()
    if ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(FeatureType.BLACK_MARKET) then
        PopupMgr.ShowAndHidePopup(UIPopupName.UIMarket, { ["marketType"] = MarketType.ARENA_MARKET, ["callbackClose"] = function()
            PopupMgr.ShowAndHidePopup(self.model.uiName, nil, UIPopupName.UIMarket)
        end },
                self.model.uiName)
    end
end

--- @return void
function UIArena2View:OnClickBattle()
    local requestAndShowPopup = function()
        ArenaRequest.RequestArenaOpponent(
                function(data)
                    zg.playerData:GetArenaData().arenaOpponentInBound = data
                    PopupMgr.ShowPopup(UIPopupName.UIArenaChooseRival)
                end)
    end
    if self.arenaData.arenaOpponentInBound == nil or self.arenaData.arenaOpponentInBound:IsAvailableToRequest() == true then
        requestAndShowPopup()
    else
        PopupMgr.ShowPopup(UIPopupName.UIArenaChooseRival)
    end
end

--- @return void
--- @param ArenaRankingItemView ArenaRankingItemView
function UIArena2View:ShowInfoOtherPlayer(ArenaRankingItemView)
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
end

function UIArena2View:InitUpdateTime()
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

--- @return void
function UIArena2View:StartTime()
    if self.updateTime ~= nil then
        ---@type EventTimeData
        self.eventTime = zg.playerData:GetEvents():GetEvent(EventTimeType.ARENA):GetTime()
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end

--- @return void
function UIArena2View:StopTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end

--- @return void
function UIArena2View:ShowRecord()
    self.uiScroll:Resize(self.listRecord:Count())
    if self.canPlayMotion == true then
        self.canPlayMotion = false
        self.uiScroll:PlayMotion()
    end
end

--- @return void
function UIArena2View:LoadRecord()
    ---@type Job
    local checkDataNotiRecord = Job(function(onSuccess, onFailed)
        if NotificationArena.records == nil then
            NotificationArena.LoadFromServer(onSuccess, onSuccess)
        else
            if onSuccess ~= nil then
                onSuccess()
            end
        end
    end)

    ---@type Job
    local checkDataRecord = Job(function(onSuccess, onFailed)
        if self.arenaData.arenaRecordDataInBound == nil or self.arenaData.arenaRecordDataInBound:IsAvailableToRequest() then
            ArenaRequest.RequestArenaRecord(GameMode.ARENA, function(battleRecordDataInBound)
                zg.playerData:GetArenaData().arenaRecordDataInBound = battleRecordDataInBound
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
        self.arenaData = zg.playerData:GetArenaData()
        self.listRecordAttack:Clear()
        self.listRecordDefense:Clear()
        ---@param v BattleRecordShort
        for i, v in ipairs(self.arenaData.arenaRecordDataInBound.listRecord:GetItems()) do
            if v:IsAttacker() then
                self.listRecordAttack:Add(v)
            else
                self.listRecordDefense:Add(v)
            end
        end
        for i, v in ipairs(self.arenaData.arenaRecordDataInBound.listRecordBot:GetItems()) do
            self.listRecordAttack:Add(v)
        end
        self.listRecordAttack:SortWithMethod(BattleRecordShortBase.Sort)
        if self.listRecordAttack:Count() > 10 then
            for i = self.listRecordAttack:Count(), 11, -1 do
                self.listRecordAttack:RemoveByIndex(i)
            end
        end
        self.listRecordDefense:SortWithMethod(BattleRecordShortBase.Sort)
        self.uiScroll:Resize(self.listRecord:Count())
    end)
end

--- @return void
--- @param arenaRecordItemView ArenaRecordItemView
function UIArena2View:OnClickShowInfo(arenaRecordItemView)
    local showInfo = function(attackerData, defenderData, attackerTeamInfo, defenderTeamInfo, seedInBound)
        local data = {}
        data.userName = arenaRecordItemView.teamOpponent.playerName
        data.avatar = arenaRecordItemView.teamOpponent.playerAvatar
        data.level = arenaRecordItemView.teamOpponent.playerLevel
        if arenaRecordItemView.battleRecordShort:IsAttacker() then
            data.battleTeamInfo = defenderTeamInfo
        else
            data.battleTeamInfo = attackerTeamInfo
        end
        --data.mastery = otherPlayerRecord.summonerBattleInfoInBound.masteryDict
        PopupMgr.ShowPopup(UIPopupName.UIPreviewFriend, data)
    end

    arenaRecordItemView.battleRecordShort:RequestGetBattleData(showInfo, SmartPoolUtils.LogicCodeNotification)
end

--- @return void
--- @param arenaRecordItemView ArenaRecordItemView
function UIArena2View:OnClickBattleRecord(arenaRecordItemView)
    local battleRecord = function()
        ---@type BattleTeamInfo
        local attackerTeam = ClientConfigUtils.GetAttackCurrentBattleTeamInfoByMode(GameMode.ARENA)
        ArenaRequest.RequestBattleArena(arenaRecordItemView.teamOpponent.playerId, attackerTeam, function(_arenaSingleChallengeInBound)
            ---@type ArenaSingleChallengeInBound
            local arenaSingleChallengeInBound = _arenaSingleChallengeInBound
            ArenaRequest.RequestRevenge(GameMode.ARENA, arenaRecordItemView.battleRecordShort.recordId)
            arenaRecordItemView.battleRecordShort.isRevenge = true
            ---@type BasicInfoInBound
            local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
            local eloChange = arenaSingleChallengeInBound.arenaChallengeReward.eloChange
            zg.battleMgr.attacker = {
                ["avatar"] = basicInfoInBound.avatarData:GetMyPlayerAvatar(),
                ["level"] = basicInfoInBound.level,
                ["name"] = basicInfoInBound.name,
                ["score"] = arenaSingleChallengeInBound.arenaChallengeReward.attackerElo,
                ["scoreChange"] = eloChange,
            }
            zg.battleMgr.defender = {
                ["avatar"] = arenaRecordItemView.teamOpponent.playerAvatar,
                ["level"] = arenaRecordItemView.teamOpponent.playerLevel,
                ["name"] = arenaRecordItemView.teamOpponent.playerName,
                ["score"] = arenaSingleChallengeInBound.arenaChallengeReward.defenderElo,
                ["scoreChange"] = eloChange
            }
        end, function()
        end)
    end
    if InventoryUtils.CanUseFreeTurnArena() then
        battleRecord()
    else
        local canUpgrade = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, self.moneyTicket, 1))
        if canUpgrade then
            battleRecord()
        end
    end
end

--- @return void
--- @param arenaRecordItemView ArenaRecordItemView
function UIArena2View:OnClickWatchRecord(arenaRecordItemView)
    ---@param seedInBound SeedInBound
    ---@param attackerTeamInfo BattleTeamInfo
    ---@param defenderTeamInfo BattleTeamInfo
    local runRecord = function(attackerData, defenderData, attackerTeamInfo, defenderTeamInfo, seedInBound, battleLog)
        ClientBattleData.skipForReplay = true
        zg.playerData.rewardList = nil
        ---@type BattleMgr
        local battleMgr = zg.battleMgr
        battleMgr.attacker = attackerData
        battleMgr.defender = defenderData
        battleMgr.attacker.score = arenaRecordItemView.battleRecordShort.attackerElo
        battleMgr.defender.score = arenaRecordItemView.battleRecordShort.defenderElo
        battleMgr.attacker.scoreChange = arenaRecordItemView.battleRecordShort.eloChange
        battleMgr.defender.scoreChange = arenaRecordItemView.battleRecordShort.eloChange

        ---@type RandomHelper
        local randomHelper = RandomHelper()
        randomHelper:SetSeed(seedInBound.seed)

        zg.battleMgr:RunVirtualBattle(attackerTeamInfo, defenderTeamInfo, GameMode.ARENA, randomHelper, RunMode.FASTEST, battleLog)

        if arenaRecordItemView.battleRecordShort.isAttackWin ~= (ClientBattleData.battleResult.winnerTeam == BattleConstants.ATTACKER_TEAM_ID) then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("play_record_failed"))
        else
            randomHelper:SetSeed(seedInBound.seed)
            zg.battleMgr:RunCalculatedBattleScene(attackerTeamInfo, defenderTeamInfo, GameMode.ARENA, randomHelper, nil, battleLog)
        end
    end

    arenaRecordItemView.battleRecordShort:RequestGetBattleData(runRecord, SmartPoolUtils.LogicCodeNotification)
end