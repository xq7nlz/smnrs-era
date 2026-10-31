require "lua.client.core.network.battleFormation.BattleFormationOutBound"

require "lua.client.scene.ui.common.BattleTeamView"

--- @class UIArenaChooseRivalView : UIBaseView
UIArenaChooseRivalView = Class(UIArenaChooseRivalView, UIBaseView)

--- @return void
--- @param model UIArenaChooseRivalModel
function UIArenaChooseRivalView:Ctor(model, ctrl)
    --- @type UIArenaChooseRivalConfig
    self.config = nil
    --- @type BattleTeamView
    self.battleTeamView = nil
    --- @type List
    self.listArenaItemView = List()
    --- @type ArenaData
    self.arenaData = nil
    ---@type PlayerSummonerInBound
    self.summonerInbound = nil
    ---@type boolean
    self.unlockSkip = false
    ---@type boolean
    self.needRequestArena = false

    UIBaseView.Ctor(self, model, ctrl)
    --- @type UIArenaChooseRivalModel
    self.model = model
end

--- @return void
function UIArenaChooseRivalView:OnReadyCreate()
    ---@type UIArenaChooseRivalConfig
    self.config = UIBaseConfig(self.uiTransform)
    self.config.buttonClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonChange.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChange()
    end)
    self.config.buttonRefresh.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRefresh()
    end)
    self.config.buttonSkip.onClick:AddListener(function()
        self:OnClickSkip()
    end)
end

--- @return void
function UIArenaChooseRivalView:InitLocalization()
    self.config.titleChooseRival.text = LanguageUtils.LocalizeCommon("choose_rival")
    self.config.localizeChange.text = LanguageUtils.LocalizeCommon("change")
    self.config.localizeRefresh.text = LanguageUtils.LocalizeCommon("refresh")
    self.config.localizeSkipBattle.text = LanguageUtils.LocalizeCommon("skip_battle")
    self.config.textTapToClose.gameObject:SetActive(false)
end

--- @return void
function UIArenaChooseRivalView:OnReadyShow()
    self.summonerInbound = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
    self.arenaData = zg.playerData:GetArenaData()
    self:ShowBattle()
    if self.cache ~= true then
        self:CreateListOpponent()
    end
    self.unlockSkip = ResourceMgr.GetVipConfig():GetCurrentBenefits().battleUnlockSkipArena or ClientConfigUtils.CheckUnlockMinorFeatureAndNotification(MinorFeatureType.BATTLE_SKIP_PRE, false)
    self.config.buttonSkip.gameObject:SetActive(true)
    self:UpdateSkip()

    self.subscriptionRefresh = RxMgr.arenaChooseRivalRefresh:Subscribe(function()
        self:OnClickRefresh()
    end)
end

--- @return void
function UIArenaChooseRivalView:ShowBattle()
    self.battleTeamInfo = ClientConfigUtils.GetAttackCurrentBattleTeamInfoByMode(GameMode.ARENA)
    if self.battleTeamView == nil then
        self.battleTeamView = BattleTeamView(self.config.teamInfo)
    else
        self.battleTeamView:Hide()
    end
    self.battleTeamView:Show()
    self.battleTeamView:SetDataDefender(UIPoolType.HeroIconView, self.battleTeamInfo)
    self.battleTeamView.uiTeamView:SetSummonerInfo(self.battleTeamInfo.summonerBattleInfo)
    self.battleTeamView.uiTeamView:ActiveBuff(false)
    self.battleTeamView.uiTeamView:ActiveLinking(false)
    self.config.textPower.text = tostring(math.floor(ClientConfigUtils.GetPowerByBattleTeamInfo(self.battleTeamInfo)))
end

--- @return void
function UIArenaChooseRivalView:CreateListOpponent()
    local arenaOpponentInBound = self.arenaData.arenaOpponentInBound
    ---@type List
    local listOpponent = List()
    ---@param v ArenaOpponentInfo
    for i, v in pairs(arenaOpponentInBound.listOpponent:GetItems()) do
        listOpponent:Add(v)
    end
    ---@param v ArenaBotOpponentInfo
    for i, v in pairs(arenaOpponentInBound.listBot:GetItems()) do
        listOpponent:Add(v)
    end
    local count = math.min(listOpponent:Count(), 3)
    for _ = 1, count do
        ---@type ArenaBattleItemView
        local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ArenaBattleItemView, self.config.content)
        local randomNumber = math.random(1, listOpponent:Count())
        item:SetData(listOpponent:Get(randomNumber))
        listOpponent:RemoveByIndex(randomNumber)
        item.callbackClickBattle = function()
            self:OnClickBattle(item)
        end
        self.listArenaItemView:Add(item)
    end
end

--- @return void
function UIArenaChooseRivalView:ClearListOpponent()
    ---@param v ArenaBattleItemView
    for _, v in pairs(self.listArenaItemView:GetItems()) do
        v:ReturnPool()
    end
    self.listArenaItemView:Clear()
end

--- @return void
function UIArenaChooseRivalView:CheckRefreshArena(callbackSuccess)
    if self.needRequestArena then
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.ARENA }, function()
            RxMgr.arenaRefresh:Next()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
        end, nil, true, true)
        self.needRequestArena = false
    elseif callbackSuccess ~= nil then
        callbackSuccess()
    end
end

--- @return void
function UIArenaChooseRivalView:OnClickBackOrClose()
    self.cache = nil
    self:CheckRefreshArena(function()
        UIBaseView.OnClickBackOrClose(self)
    end)
end

--- @return void
function UIArenaChooseRivalView:Hide()
    UIBaseView.Hide(self)
    if self.battleTeamView ~= nil then
        self.battleTeamView:Hide()
        self.battleTeamView = nil
    end
    if self.cache ~= true then
        self:ClearListOpponent()
    end
    if self.subscriptionRefresh ~= nil then
        self.subscriptionRefresh:Unsubscribe()
    end
    self.needRequestArena = false
end

--- @return void
function UIArenaChooseRivalView:OnClickChange()
    local data = {}
    data.gameMode = GameMode.ARENA
    data.callbackClose = function()
        PopupMgr.ShowAndHidePopup(UIPopupName.UIArena2, nil, UIPopupName.UIFormation2)
        PopupMgr.ShowPopup(UIPopupName.UIArenaChooseRival)
    end
    data.callbackPlayBattle = function(uiFormationTeamData, callback, power)
        ArenaRequest.SetFormationArena(uiFormationTeamData, function()
            UIArena2View.OverridePower(power)
            PopupMgr.ShowAndHidePopup(UIPopupName.UIArena2, nil, UIPopupName.UIFormation2)
            PopupMgr.ShowPopup(UIPopupName.UIArenaChooseRival)
            --self:ShowBattle()
        end)
    end
    self.cache = true
    PopupMgr.ShowAndHidePopup(UIPopupName.UIFormation2, data, UIPopupName.UIArenaChooseRival, UIPopupName.UIArena2)
end

--- @return void
---@param arenaBattleItemView ArenaBattleItemView
function UIArenaChooseRivalView:OnClickBattle(arenaBattleItemView)
    local canClackBattle = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.ARENA_TICKET, 1))
    if canClackBattle then
        XDebug.Log("Start Click Battle")
        local isSkip = self:IsSkipBattle()
        local resultBattleClose = Subject.Create()
        ---@param arenaChallengeRewardInBound ArenaChallengeRewardInBound
        ---@param battleTeamInfo BattleTeamInfo
        local battleSuccess = function(arenaChallengeRewardInBound, battleTeamInfo)
            XDebug.Log("Request Battle Success")
            self.cache = nil
            ---@type BasicInfoInBound
            local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
            zg.battleMgr.attacker = {
                ["avatar"] = basicInfoInBound.avatarData:GetMyPlayerAvatar(),
                ["level"] = basicInfoInBound.level,
                ["name"] = basicInfoInBound.name,
                ["score"] = arenaChallengeRewardInBound.attackerElo,
                ["scoreChange"] = arenaChallengeRewardInBound.eloChange
            }
            zg.battleMgr.defender = {
                ["avatar"] = arenaBattleItemView.arenaOpponentInfo:GetAvatar(),
                ["level"] = arenaBattleItemView.arenaOpponentInfo:GetLevel(),
                ["name"] = arenaBattleItemView.arenaOpponentInfo:GetName(),
                ["score"] = arenaChallengeRewardInBound.defenderElo,
                ["scoreChange"] = arenaChallengeRewardInBound.eloChange
            }
            if isSkip then
                self.needRequestArena = true
                ArenaRequest.RequestArenaOpponent()
                ---@type Subscription
                local subscription
                subscription = resultBattleClose
                        :Subscribe(function()
                    RxMgr.arenaChooseRivalRefresh:Next()
                    subscription:Unsubscribe()
                end)
            end

            if InventoryUtils.CanUseFreeTurnArena() then
                InventoryUtils.Sub(ResourceType.Money, MoneyType.ARENA_FREE_CHALLENGE_TURN, 1)
            else
                InventoryUtils.Sub(ResourceType.Money, MoneyType.ARENA_TICKET, 1)
            end
            ---@type ArenaData
            local arenaData = zg.playerData:GetArenaData()
            if arenaData.arenaRecordDataInBound ~= nil then
                arenaData.arenaRecordDataInBound.needRequest = true
            end
            zg.playerData.rewardList = RewardInBound.GetItemIconDataList(arenaChallengeRewardInBound.rewards)
            XDebug.Log("Reward Count : " .. zg.playerData.rewardList:Count())

            for i = 1,zg.playerData.rewardList:Count() do
                XDebug.Log("Reward Id : " .. i)
                XDebug.Log("Reward Type : " .. zg.playerData.rewardList:Get(i).itemId)
                XDebug.Log("Reward Quantity : " .. zg.playerData.rewardList:Get(i).quantity)
            end
            zg.playerData:AddListRewardToInventory()

            if isSkip == true then
                ClientBattleData.SetCalculationBattle(function()
                    arenaChallengeRewardInBound.battleResult.seedInBound:Initialize()
                    zg.battleMgr:RunVirtualBattle(self.battleTeamInfo,
                            battleTeamInfo, GameMode.ARENA, nil, RunMode.FAST)
                end
                )
                local data = {}
                data.gameMode = GameMode.ARENA
                --XDebug.Log("defe " .. LogUtils.ToDetail(zg.battleMgr.defender))
                --XDebug.Log("atk: " .. LogUtils.ToDetail(zg.battleMgr.attacker))
                if arenaChallengeRewardInBound.battleResult.isWin then
                    data.callbackClose = function()
                        PopupMgr.HidePopup(UIPopupName.UIVictory)
                        if resultBattleClose ~= nil then
                            resultBattleClose:Next()
                        end
                    end
                    PopupMgr.ShowPopup(UIPopupName.UIVictory, data)
                else
                    data.callbackClose = function()
                        PopupMgr.HidePopup(UIPopupName.UIDefeat)
                        if resultBattleClose ~= nil then
                            resultBattleClose:Next()
                        end
                    end
                    data.callbackUpgrade = function(popupName)
                        if popupName == UIPopupName.UIHeroCollection then
                            PopupMgr.ShowPopup(UIPopupName.UIMainArea)
                        end
                        PopupMgr.ShowPopup(popupName, nil, UIPopupHideType.HIDE_ALL)
                    end
                    PopupMgr.ShowPopup(UIPopupName.UIDefeat, data)
                end
            else
                zg.battleMgr:RunCalculatedBattleScene(self.battleTeamInfo, battleTeamInfo, GameMode.ARENA, nil, nil, arenaChallengeRewardInBound.battleResult.battleLog)
                PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.ARENA, PlayerDataMethod.ARENA_GROUP_RANKING, PlayerDataMethod.ARENA_SERVER_RANKING })
                ArenaRequest.RequestArenaOpponent()
            end
        end
        arenaBattleItemView.arenaOpponentInfo:RequestBattle(battleSuccess, resultBattleClose)
        zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
    end
end

--- @return void
function UIArenaChooseRivalView:OnClickRefresh()
    self:ClearListOpponent()
    self:CreateListOpponent()
end

--- @return boolean
function UIArenaChooseRivalView:IsSkipBattle()
    return self.unlockSkip and PlayerSettingData.isSkipArena == true
end

--- @return void
function UIArenaChooseRivalView:UpdateSkip()
    self.config.iconTickSkip:SetActive(self:IsSkipBattle())
end

--- @return void
function UIArenaChooseRivalView:OnClickSkip()
    if ResourceMgr.GetVipConfig():GetCurrentBenefits().battleUnlockSkipArena or ClientConfigUtils.CheckUnlockMinorFeatureAndNotification(MinorFeatureType.BATTLE_SKIP_PRE, false)then
        if PlayerSettingData.isSkipArena == true then
            PlayerSettingData.isSkipArena = false
        else
            PlayerSettingData.isSkipArena = true
        end
        PlayerSetting.SaveData()
        self:UpdateSkip()
    else
        local levelRequire, stageRequire = ClientConfigUtils.GetLevelStageRequire(MinorFeatureType.BATTLE_SKIP_PRE)
        local vipUnlock = ResourceMgr.GetVipConfig():RequireLevelUnlockSkipArea()
        SmartPoolUtils.NotificationRequireVipOrLevelAndStage(vipUnlock, levelRequire, stageRequire)
    end
end