require "lua.client.scene.ui.common.UIBarPercentView"

--- @class UIGuildWarPhase3TeamInfoView : UIBaseView
UIGuildWarPhase3TeamInfoView = Class(UIGuildWarPhase3TeamInfoView, UIBaseView)

--- @return void
--- @param model UIGuildWarPhase3TeamInfoModel
function UIGuildWarPhase3TeamInfoView:Ctor(model)
    --- @type uiGuildWarPhase3TeamInfoConfig
    self.config = nil

    --- @type GuildWarEloPositionConfig
    self.eloPositionConfig = nil

    --- @type GuildBasicInfoInBound
    self.guildBasicInfo = nil
    --- @type GuildWarTimeInBound
    self.guildWarTimeInBound = nil
    --- @type GuildWarConfig
    self.guildWarConfig = nil
    --- @type GuildWarInBound
    self.guildWarInBound = nil
    --- @type GuildWarPlayerInBound
    self.guildWarPlayerInBound = nil
    --- @type nil
    self.guildWarRecordData = nil

    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type UnityEngine_Color
    self.colorText = nil
    --- @type List
    self.listRecord = nil

    --- @type UIBarPercentView
    self.pointBar = nil
    UIBaseView.Ctor(self, model)
    --- @type UIGuildWarPhase3TeamInfoModel
    self.model = model
end

--- @return void
function UIGuildWarPhase3TeamInfoView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self.eloPositionConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarEloPositionConfig()
    self.pointBar = UIBarPercentView(self.config.barPercent)

    self:InitButtonListener()
    self:InitScroll()
    self:ShowCondition()
end

function UIGuildWarPhase3TeamInfoView:ShowCondition()
    local guildWarConfig = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarConfig()
    self.config.textCondition1.text = LanguageUtils.LocalizeCommon("win")
    self.config.textCondition2.text = string.format(LanguageUtils.LocalizeCommon("min_hero_dead_requirement"), 5 - guildWarConfig.minAttackerHeroDeadRequirement)
    self.config.textCondition3.text = string.format(LanguageUtils.LocalizeCommon("max_round_requirement"), guildWarConfig.maxRoundRequirement)
end

function UIGuildWarPhase3TeamInfoView:InitButtonListener()
    self.config.bgNone.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonBattle.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBattle()
    end)
end

function UIGuildWarPhase3TeamInfoView:InitLocalization()
    self.config.textEmpty.text = LanguageUtils.LocalizeLogicCode(LogicCode.RECORD_NOT_FOUND)
end

function UIGuildWarPhase3TeamInfoView:InitScroll()
    --- @param obj GuildWarRecordItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type GuildWarRecord
        local guildWarRecord = self.listRecord:Get(dataIndex)
        local slotElo = self.eloPositionConfig:GetEloByPosition(guildWarRecord.defenderTeamPosition)
        obj:SetData(self.guildWarPlayerInBound.compactPlayerInfo.playerId, guildWarRecord, function()
            PopupMgr.HidePopup(self.model.uiName)
            PopupMgr.HidePopup(UIPopupName.UIGuildWarPhase3Main)
            self.guildWarRecordData:SetPlayRecord(self.isAlly, guildWarRecord)
        end, slotElo)
    end
    self.uiScroll = UILoopScroll(self.config.recordScroll, UIPoolType.GuildWarRecordItemView, onCreateItem)
end

--- @param data {guildWarPlayerInBound : GuildWarPlayerInBound, isAlly : boolean, position : number}
function UIGuildWarPhase3TeamInfoView:OnReadyShow(data)
    self.guildBasicInfo = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
    self.guildWarTimeInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR_TIME)
    self.guildWarInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR)
    self.guildWarPlayerInBound = data.guildWarPlayerInBound
    self.guildWarRecordData = zg.playerData:GetGuildData():GetGuildWarRecordData(self.guildWarInBound.battleIdOfGuildWar)
    self.isAlly = data.isAlly

    self:ShowEloWinCondition(data.position)
    self:GetColorText(self.isAlly)
    self.config.buttonBattle.gameObject:SetActive(self.isAlly == false
            and self.guildWarInBound.selectedForGuildWar
            and self.guildWarPlayerInBound.medalHoldDefense > 0)
    self:ShowPlayerData(self.isAlly, self.guildWarPlayerInBound)

    local playerId = self.guildWarPlayerInBound.compactPlayerInfo.playerId
    local isContainPlayerRecord = self.guildWarRecordData:IsContainPlayerRecord(playerId)
    self.config.loading:SetActive(isContainPlayerRecord == false)
    self.config.empty:SetActive(false)
    if isContainPlayerRecord then
        local playerRecord = self.guildWarRecordData:GetPlayerRecord(playerId)
        self:ShowPlayerRecord(playerRecord)
    end

    self.config.textName.text = string.format("%d. %s", data.position, self.guildWarPlayerInBound.compactPlayerInfo.playerName)
end

function UIGuildWarPhase3TeamInfoView:ShowEloWinCondition(position)
    local elo = tostring(self.eloPositionConfig:GetEloByPosition(position))
    self.config.textRewardCondition1.text = elo
    self.config.textRewardCondition2.text = elo
    self.config.textRewardCondition3.text = elo
end

function UIGuildWarPhase3TeamInfoView:OnClickBattle()
    self:RequestChallenge(self.guildWarPlayerInBound.compactPlayerInfo.playerId)
end

--- @param isAlly boolean
--- @param guildWarPlayerInBound GuildWarPlayerInBound
function UIGuildWarPhase3TeamInfoView:ShowPlayerData(isAlly, guildWarPlayerInBound)
    self.config.playerName.text = guildWarPlayerInBound.compactPlayerInfo.playerName
    self.config.textSlotIndex.text = guildWarPlayerInBound.positionInGuildWarBattle

    local medalHold = guildWarPlayerInBound.medalHoldDefense
    local numberMedal = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarConfig().numberMedal
    self.config.towerImage.sprite = ClientConfigUtils.GetGuildWarTowerSprite(isAlly, guildWarPlayerInBound.positionInGuildWarBattle, medalHold / numberMedal)
    self.config.towerImage:SetNativeSize()

    self.pointBar:SetPercent(medalHold / numberMedal)
    self.pointBar:SetText(medalHold * ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarEloPositionConfig():GetEloByPosition(guildWarPlayerInBound.positionInGuildWarBattle))
    self:ShowTeamInfo(guildWarPlayerInBound.compactPlayerInfo)
end

--- @param compactPlayerInfo OtherPlayerInfoInBound
function UIGuildWarPhase3TeamInfoView:ShowTeamInfo(compactPlayerInfo)
    --- @type SummonerBattleInfo
    local summonerBattleInfo = compactPlayerInfo.summonerBattleInfoInBound.summonerBattleInfo
    --- @type BattleTeamInfo
    local battleTeamInfo = compactPlayerInfo:CreateBattleTeamInfo(compactPlayerInfo.playerLevel)

    self.battleTeamView = BattleTeamView(self.config.defenderTeamAnchor)
    self.battleTeamView:Show()

    self.battleTeamView:SetDataDefender(UIPoolType.HeroIconView, battleTeamInfo)
    self.battleTeamView.uiTeamView:SetSummonerInfo(summonerBattleInfo)
    self.battleTeamView.uiTeamView:ActiveBuff(false)
    self.battleTeamView.uiTeamView:ActiveLinking(false)

    local power = ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo, false)
    self.config.textApValue.text = tostring(math.floor(power))
end

function UIGuildWarPhase3TeamInfoView:Hide()
    UIBaseView.Hide(self)
    if self.battleTeamView ~= nil then
        self.battleTeamView:Hide()
    end
    self.uiScroll:Hide()
end

function UIGuildWarPhase3TeamInfoView:RequestChallenge(opponentId)
    if self.guildWarInBound.selectedForGuildWar == false then
        SmartPoolUtils.LogicCodeNotification(LogicCode.GUILD_WAR_OPPONENT_CAN_NOT_BE_ATTACKED)
        return
    end
    local onReceived = function(result)
        --- @type BattleResultInBound
        local battleResultInBound = nil
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            battleResultInBound = BattleResultInBound.CreateByBuffer(buffer)
        end
        local onSuccess = function()
            local selfPlayerGuildWarInBound = self.guildWarInBound:FindSelectedMemberById(PlayerSettingData.playerId)
            ---@type BattleTeamInfo
            local attackerTeam = selfPlayerGuildWarInBound.compactPlayerInfo:CreateBattleTeamInfo()
            local defenderTeam = self.guildWarPlayerInBound.compactPlayerInfo:CreateBattleTeamInfo(self.guildWarPlayerInBound.compactPlayerInfo.playerLevel, BattleConstants.DEFENDER_TEAM_ID)
            zg.battleMgr:RunCalculatedBattleScene(attackerTeam, defenderTeam, GameMode.GUILD_WAR, nil, function()
                self:OnSuccessRequestChallenge(battleResultInBound, ClientBattleData.battleResult.numberRounds)
            end, battleResultInBound.battleLog)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    --zg.playerData:CheckDataLinking(function ()
        NetworkUtils.Request(OpCode.GUILD_WAR_CHALLENGE, UnknownOutBound.CreateInstance(PutMethod.Long, opponentId), onReceived)
    --end, true)
end

function UIGuildWarPhase3TeamInfoView:GetColorText(isAlly)
    local color = isAlly and UIUtils.ALLY_COLOR or UIUtils.OPPONENT_COLOR
    local colorBar = isAlly and UIUtils.RECORD_WIN or UIUtils.RECORD_LOSE
    self.config.textName.color = color
    self.config.playerName.color = color
    self.config.textApValue.color = color
    self.config.bgBossHp.color = colorBar
    self.config.iconAp.color = color
    self.config.opponentFrag:SetActive(isAlly)
    self.config.allyFrag:SetActive(not isAlly)
end

--- @param battleId number
--- @param playerId number
function UIGuildWarPhase3TeamInfoView:CheckLoadListRecord(battleId, playerId)
    self.listRecord = List()
    --- @param playerGuildWarRecord PlayerGuildWarRecord
    local onRecordLoaded = function(playerGuildWarRecord)
        self.config.loading:SetActive(false)
        if playerGuildWarRecord ~= nil and playerGuildWarRecord.listRecord ~= nil then
            self:ShowPlayerRecord(playerGuildWarRecord)
        else
            self.config.empty:SetActive(true)
        end
    end
    self.guildWarRecordData:RequestGuildWarPlayerRecord(battleId, playerId, onRecordLoaded)
end

--- @param playerGuildWarRecord PlayerGuildWarRecord
function UIGuildWarPhase3TeamInfoView:ShowPlayerRecord(playerGuildWarRecord)
    if playerGuildWarRecord ~= nil then
        self.listRecord = playerGuildWarRecord.listRecord
        local recordCount = self.listRecord:Count()
        self.uiScroll:Resize(recordCount)
        self.config.empty:SetActive(recordCount == 0)
    else
        self.config.empty:SetActive(true)
    end
end

function UIGuildWarPhase3TeamInfoView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    if self.guildWarRecordData:IsContainPlayerRecord(self.guildWarPlayerInBound.compactPlayerInfo.playerId) == false then
        self:CheckLoadListRecord(self.guildWarInBound.battleIdOfGuildWar, self.guildWarPlayerInBound.compactPlayerInfo.playerId)
    end
end

--- @param battleResultInBound BattleResultInBound
function UIGuildWarPhase3TeamInfoView:OnSuccessRequestChallenge(battleResultInBound, numberRounds)
    self.guildWarInBound.numberAttack = self.guildWarInBound.numberAttack + 1
    InventoryUtils.Sub(ResourceType.Money, MoneyType.GUILD_WAR_STAMINA, 1)
    self.guildWarRecordData:OnSuccessChallenge(battleResultInBound, numberRounds, self.guildWarPlayerInBound)

    --- @type GuildWarRankingInBound
    local guildWarRankingInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR_RANKING)
    if guildWarRankingInBound ~= nil then
        guildWarRankingInBound.lastTimeRequest = nil
    end
end