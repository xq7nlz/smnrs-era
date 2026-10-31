require "lua.client.battleShow.ClientBattleTeamController"
require "lua.client.battleShow.BattleEffectMgr"
require "lua.client.scene.ui.battle.uiHeroStatusBar.UIBattleMarkIcon"
require "lua.client.scene.ui.battle.uiHeroStatusBar.UIBattleEffectIcon"
require "lua.client.scene.ui.battle.uiBattleTextLog.BattleTextLogUtil"

local delayShow = 0.1

--- @class ClientBattleShowController
ClientBattleShowController = Class(ClientBattleShowController)

function ClientBattleShowController:Ctor()
    --- @type ClientBattleTeamController
    self.attackerTeamCtrl = ClientBattleTeamController(self)
    self.defenderTeamCtrl = ClientBattleTeamController(self)

    --- @type ClientLogDetail
    self.clientLogDetail = nil
    --- @type ClientTurnDetail -- List
    self.clientListTurnDetails = List()
    --- @type ClientTurnDetail
    self.clientTurnDetail = nil

    --- @type number
    self.roundNum = 1
    --- @type number
    self.clientTurnNum = 1
    --- @type number
    self.serverTurnNum = 1

    --- @type Dictionary <BaseHero, ClientHero>
    self.clientHeroDictionary = Dictionary()
    --- @type ClientHero -- List
    self.listClientHero = List()
    --- @type Dictionary<ClientHero, ClientActionDetail>
    self.pendingClientAction = Dictionary()
    --- @type boolean
    self.isAutoBattle = true
    --- @type RunMode
    self.runMode = nil
    --- @type boolean
    self.isGameOver = false
    --- @type boolean
    self.isPerformActionResults = false
    --- @type BattleView
    self.battleView = nil
    --- @type List
    self.listPreloadedBattleEffect = List()
    --- @type table<UnityEngine_GameObject, UIBattleEffectIcon>
    self.battleEffectIconDict = Dictionary()
    --- @type Dictionary {heroId, listHeroEffectConfig}
    self.heroEffectConfigDict = Dictionary()
    --- @type List
    self.preloadHeroEffectPathCheck = {}
    --- @type table
    self.preloadHeroSoundPathCheck = {}
    --- @type {}
    self._battleTweener = nil
end

--- @return void
function ClientBattleShowController:OnCreate()
    self:InitReference()

    self:InitBackground()

    self:InitListener()

    self:InitBattleMusic()
end

function ClientBattleShowController:InitReference()
    self.clientLogDetail = ClientBattleData.clientLogDetail
end

function ClientBattleShowController:InitBackground()
    local gameMode = zg.sceneMgr.gameMode
    local bgParams = 101001
    if gameMode == GameMode.CAMPAIGN then
        bgParams = zg.playerData:GetCampaignData().stageCurrent
    elseif gameMode == GameMode.RAID or gameMode == GameMode.RAID_HERO_FRAGMENT then
        local raidData = zg.playerData:GetRaidData()

        local id = nil
        if self.raidModeType == RaidModeType.GOLD - 1 then
            id = 402
        elseif self.raidModeType == RaidModeType.MAGIC_POTION - 1 then
            id = 801
        else
            id = 703
        end
        bgParams = id
        --bgParams = ResourceMgr.GetRaidConfig():GetBattleRaidBg(raidData.raidModeType, raidData.raidModeStage)
    elseif gameMode == GameMode.TOWER or gameMode == GameMode.TOWER_RECORD then
        bgParams = zg.playerData:GetMethod(PlayerDataMethod.TOWER).selectedLevel
    end

    self:InitBattleView()
    local bgAnchorTop, bgAnchorBot = BattleBackgroundUtils.GetBgAnchorNameByMode(gameMode, bgParams)
    self.battleView:ShowBgAnchor(bgAnchorTop, bgAnchorBot)
    self.battleView:UpdateView()
end

function ClientBattleShowController:InitBattleView()
    if self.battleView == nil then
        self.battleView = zg.battleMgr:GetBattleView()
    end
    self.battleView:EnableMainCamera(true)
    self.battleView:SetActive(true)
end

--- @return void
function ClientBattleShowController:InitListener()
    self.skipBattleListener = RxMgr.skipBattle:Subscribe(RxMgr.CreateFunction(self, self.GameOver))

    self.battleSpeedListener = RxMgr.battleSpeed:Subscribe(RxMgr.CreateFunction(self, self.SetTimeScale))

    self.switchModeListener = RxMgr.switchMode:Subscribe(RxMgr.CreateFunction(self, self.SetSwitchMode))

    self.nextTurnListener = RxMgr.nextTurn:Subscribe(RxMgr.CreateFunction(self, self.DoClientTurn))

    self.startBattleListener = RxMgr.startBattle:Subscribe(RxMgr.CreateFunction(self, self.StartTheShow))

    self.pauseBattleListener = RxMgr.pauseBattle:Subscribe(RxMgr.CreateFunction(self, self.PauseBattle))

    self.resumeBattleListener = RxMgr.resumeBattle:Subscribe(RxMgr.CreateFunction(self, self.ResumeBattle))

    self.unloadUnuseResourceListener = RxMgr.unloadUnusedResource:Subscribe(RxMgr.CreateFunction(self, self.UnloadUnuseResource))

    self.initBattleShowListener = RxMgr.finishLoading:Subscribe(RxMgr.CreateFunction(self, self.InitBattleShow))

    self.preloadStuffListener = RxMgr.hideLoading:Subscribe(RxMgr.CreateFunction(self, self.PreloadStuff))
end

function ClientBattleShowController:RemoveListener()
    self.skipBattleListener:Unsubscribe()
    self.battleSpeedListener:Unsubscribe()
    self.switchModeListener:Unsubscribe()
    self.nextTurnListener:Unsubscribe()
    self.startBattleListener:Unsubscribe()
    self.pauseBattleListener:Unsubscribe()
    self.resumeBattleListener:Unsubscribe()
    self.initBattleShowListener:Unsubscribe()
    self.preloadStuffListener:Unsubscribe()
end

function ClientBattleShowController:InitBattleMusic()
    if not zg.canPlayPVEMode then
        local battleMusicFileName = ClientConfigUtils.GetBattleMusicPath()
        zg.audioMgr:PlayMusic(battleMusicFileName)
    end
end

function ClientBattleShowController:OnEnable()
    self:SetRound(1, false)
    if UIBaseView.IsActiveTutorial() == true then
        local step = UIBaseView.tutorial.currentStep
        if step == TutorialStartGame.stepId then
            self:SetTimeScale(ClientConfigUtils.GetTimeScaleBySpeedUpLevel(2))
            return
        end
    end
    self:SetTimeScale(ClientConfigUtils.GetTimeScaleBySpeedUpLevel(PlayerSettingData.battleSpeed))
end

function ClientBattleShowController:PreloadStuff()
    self.clientListTurnDetails = self.clientLogDetail.turnDetailList
    self.clientTurnDetail = self.clientListTurnDetails:Get(self.clientTurnNum)

    self:PreloadHeroEffect()
    --self:PreloadHeroSoundEffect()
    self:PreloadGameBattleEffect()

    self:DoShowDefenderTeam()
end

function ClientBattleShowController:InitBattleShow()
    Coroutine.start(function()
        coroutine.yield(nil)

        --- @param clientTeamDetail ClientTeamDetail
        --- @param clientBattleTeamController ClientBattleTeamController
        --- @param teamId number
        local function CreateTeam(teamId, clientTeamDetail, clientBattleTeamController)
            clientBattleTeamController:Init(teamId, clientTeamDetail)
            for i = 1, clientTeamDetail.baseHeroList:Count() do
                --- @type BaseHero
                local _baseHero = clientTeamDetail.baseHeroList:Get(i)
                local _clientHero = self:CreateClientHeroByBaseHero(_baseHero)
                clientBattleTeamController:AddHero(_baseHero, _clientHero)
                self.clientHeroDictionary:Add(_baseHero, _clientHero)
            end
            for baseHero, clientHero in pairs(clientBattleTeamController.heroDictionary:GetItems()) do
                clientHero:Init(baseHero)
                clientHero:SetActive(false)
            end
        end
        self.runMode = self.clientLogDetail.runMode
        CreateTeam(BattleConstants.ATTACKER_TEAM_ID, self.clientLogDetail.attackerTeam, self.attackerTeamCtrl)
        CreateTeam(BattleConstants.DEFENDER_TEAM_ID, self.clientLogDetail.defenderTeam, self.defenderTeamCtrl)
        self:InitBeforeBattleStatusLog()

        coroutine.waitforseconds(0.3)

        if not zg.canPlayPVEMode then
            coroutine.yield(5 * delayShow + 0.3)
        end

        coroutine.yield(nil)
        if self.battleView ~= nil then
            self.battleView:EnableMainCamera(true)
        end

        coroutine.yield(nil)
        if zg.canPlayPVEMode then
            self:PreloadStuff()
        end
    end)
end

--- @return ClientHero
--- @param baseHero BaseHero
function ClientBattleShowController:CreateClientHeroByBaseHero(baseHero)
    local id = baseHero.id
    local luaRequire = ClientConfigUtils.GetClientHeroLuaRequire(id)
    --- @type UnityEngine_GameObject
    local heroObject
    local heroPrefabName
    if baseHero.isDummy == false then
        heroPrefabName = string.format("hero_%d_%s", id, ClientConfigUtils.GetSkinNameByBaseHero(baseHero))
        heroObject = SmartPool.Instance:SpawnGameObject(AssetType.Hero, heroPrefabName)
        if self.battleView and heroObject then
            heroObject.transform:SetParent(self.battleView.transform)
        elseif self.battleView == nil then
            XDebug.Error(string.format("battleView is nil"))
        else
            XDebug.Error(string.format("heroObject is nil: %s", heroPrefabName))
            return
        end
        heroObject:SetActive(true)
    end
    --- @type ClientHero
    local clientHero = require(luaRequire):CreateInstance(HeroModelType.Full)
    clientHero:SetPrefabName(heroPrefabName)
    clientHero.gameObject = heroObject
    self.listClientHero:Add(clientHero)
    return clientHero
end

function ClientBattleShowController:PreloadHeroEffect()
    --- @type ClientEffect
    local effectName
    --- @param baseHero BaseHero
    for baseHero, _ in pairs(self.clientHeroDictionary:GetItems()) do
        if baseHero.isDummy == false then
            local heroEffect = ResourceMgr.GetHeroesConfig():GetHeroEffect():Get(baseHero.id)
            if heroEffect ~= nil then
                local heroEffectConfig = self.heroEffectConfigDict:Get(baseHero.id)
                if heroEffectConfig == nil then
                    local listFilesName = heroEffect.generalEffect
                    local fileName
                    for i = 1, listFilesName:Count() do
                        fileName = listFilesName:Get(i)
                        if string.match(fileName, "_skin_") then

                        else
                            effectName = listFilesName:Get(i)
                            self:PreloadHeroEffectType(effectName)
                        end
                    end
                    self.heroEffectConfigDict:Add(baseHero.id, listFilesName)
                end
            end
        end
    end

    --- @param baseHero BaseHero
    --- @param clientHero ClientHero
    for baseHero, clientHero in pairs(self.clientHeroDictionary:GetItems()) do
        if baseHero.isDummy == false then
            clientHero:PreloadHeroEffectBySkin(self.heroEffectConfigDict:Get(baseHero.id))
        end
    end
end

function ClientBattleShowController:PreloadHeroSoundEffect()
    for baseHero, clientHero in pairs(self.clientHeroDictionary:GetItems()) do
        local dataList = ResourceMgr.GetHeroesConfig():GetHeroAnimSound():ConfigFromHeroSkin(baseHero.id, clientHero.skinName)
        if dataList ~= nil then
            --- @param animSound AnimSound
            for _, animSound in ipairs(dataList:GetItems()) do
                self:PreloadSfxGeneralBattleSound(animSound.folderPath, animSound.fileName)
            end
        end
    end
end

--- @param folderPath string
--- @param fileName string
function ClientBattleShowController:PreloadSfxGeneralBattleSound(folderPath, fileName)
    if self.preloadHeroSoundPathCheck[fileName] == nil then
        self.preloadHeroSoundPathCheck[fileName] = true
        local onAudioLoaded = function(audioClip)
        end
        ResourceLoadUtils.LoadAsyncBundleAudioClip(folderPath, fileName, onAudioLoaded)
    end
end

--- @param effectName string
function ClientBattleShowController:PreloadHeroEffectType(effectName)
    if self.preloadHeroEffectPathCheck[effectName] == nil then
        local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
        if luaConfigFile ~= nil then
            --- @type ClientEffect
            local clientEffect = self:GetClientEffect(AssetType.HeroBattleEffect, effectName)
            if clientEffect.ReturnPool == nil then
                XDebug.Log("Return Pool: " .. LogUtils.ToDetail(clientEffect))
            else
                clientEffect:ReturnPool()
            end
        else
            local onSpawned = function(gameObject)
                if gameObject then
                    SmartPool.Instance:DespawnGameObject(AssetType.HeroBattleEffect, effectName, gameObject.transform)
                else
                    XDebug.Error("Effect is nil: " .. effectName)
                end
            end
            SmartPool.Instance:SpawnGameObjectAsync(AssetType.HeroBattleEffect, effectName, onSpawned)
        end
        self.preloadHeroEffectPathCheck[effectName] = true
    end
end

--- @return ClientHero
--- @param baseHero BaseHero
function ClientBattleShowController:GetClientHeroByBaseHero(baseHero)
    return self.clientHeroDictionary:Get(baseHero)
end

function ClientBattleShowController:InitBeforeBattleStatusLog()
    --- @type {attackerSummoner : BaseHero, defenderSummoner : BaseHero}
    local initTeamWrathView = {}
    initTeamWrathView.attackerSummoner = self.attackerTeamCtrl.summoner
    initTeamWrathView.defenderSummoner = self.defenderTeamCtrl.summoner
    RxMgr.updateBattleUI:Next({ ['initTeamWrathView'] = initTeamWrathView })

    --- @param teamLog List<HeroStatusLog>
    local initTeamLog = function(teamLog, teamId)
        --- @param heroStatusLog HeroStatusLog
        for _, heroStatusLog in ipairs(teamLog) do
            heroStatusLog.myHero = ClientBattleData.battle:GetHeroByUniqueId(heroStatusLog.mh)
            if heroStatusLog.myHero == nil then
                XDebug.Log("hero is nil: " .. heroStatusLog.mh)
            end
            local clientHero = self:GetClientHeroByBaseHero(heroStatusLog.myHero)
            if heroStatusLog.myHero == nil or clientHero == nil then
                XDebug.Log("hero is nil: " .. heroStatusLog.mh)
            end
            clientHero:InitHealth(heroStatusLog.hp)
            clientHero:UpdatePower(heroStatusLog.pp, false)
        end
        self:UpdateTeamWrathPower(teamId, HeroConstants.DEFAULT_SUMMONER_POWER / HeroConstants.MAX_SUMMONER_POWER, false)
    end

    initTeamLog(self.clientLogDetail.beforeAttackerTeamLog, BattleConstants.ATTACKER_TEAM_ID)
    initTeamLog(self.clientLogDetail.beforeDefenderTeamLog, BattleConstants.DEFENDER_TEAM_ID)

    --- @type {attackerCompanionsId : number, defenderCompanionsId : number}
    local companionBuff = {}
    companionBuff.attackerCompanionsId = self.clientLogDetail.attackerTeam.companionBuffId
    companionBuff.defenderCompanionsId = self.clientLogDetail.defenderTeam.companionBuffId
    RxMgr.updateBattleUI:Next({ ['companionBuff'] = companionBuff })
end

--- @return void
function ClientBattleShowController:StartTheShow()
    self.isGameOver = false
    ClientConfigUtils.KillCoroutine(self._battleTweener)
    self._battleTweener = Coroutine.start(function()
        self:DoShowAttackerTeam()
        coroutine.waitforseconds(1.5)
        self:DoClientTurn()
    end)
end

--- @return void
function ClientBattleShowController:GameOver()
    if not zg.canPlayPVEMode then
        local battleMusicPath = ClientConfigUtils.GetBattleMusicPath()
        zg.audioMgr:StopMusic(battleMusicPath)
    end
    self.isGameOver = true

    ClientConfigUtils.KillCoroutine(self._battleTweener)
    self._battleTweener = Coroutine.start(function()
        coroutine.waitforseconds(0.75)
        self:SetTimeScale(1)
        self:RemoveListener()
        self:CloseOpeningPopup()

        local isWin = self:IsWin()
        local gameMode = zg.battleMgr.gameMode

        local data = {
            ["gameMode"] = gameMode,
            ["isWin"] = self:IsWin(),
            ["result"] = ClientBattleData.battleResult,
            ["clientLogDetail"] = ClientBattleData.clientLogDetail,
            ["callbackClose"] = function()
                RxMgr.unloadUnusedResource:Next()
                zg.sceneMgr:SwitchScene(SceneConfig.HomeScene)
            end
        }
        if gameMode == GameMode.ARENA_TEAM
                or gameMode == GameMode.ARENA_TEAM_RECORD then
            --- @type ArenaData
            local arenaData = zg.playerData:GetArenaData()
            if arenaData.indexArenaTeam < 3 then
                coroutine.waitforseconds(1)
                RxMgr.finishBattle:Next()
                arenaData.indexArenaTeam = arenaData.indexArenaTeam + 1
                BattleMgr.RunArenaTeamBattle(arenaData.arenaTeamBattleData, arenaData.indexArenaTeam, gameMode, arenaData.arenaTeamBattleData.listBattleDetail:Get(arenaData.indexArenaTeam).battleLog)
                return
            end
        elseif gameMode == GameMode.DEFENSE_MODE
                or gameMode == GameMode.DEFENSE_MODE_RECORD then
            --- @type DefenseModeInbound
            local defenseModeInbound = zg.playerData:GetMethod(PlayerDataMethod.DEFENSE_MODE)
            if defenseModeInbound.defenseChallengeResultInBound:RunTheNextBattle() then
                return
            else
                isWin = defenseModeInbound.defenseChallengeResultInBound.isWin
            end
        elseif gameMode == GameMode.RAID_HERO_FRAGMENT then
            --- @type RaidInBound
            local raidModeInbound = zg.playerData:GetMethod(PlayerDataMethod.RAID)
            if raidModeInbound.raidBattleResultInbound:RunTheNextBattle() then
                return
            else
                isWin = raidModeInbound.raidBattleResultInbound.battleResultInBound.isWin
            end
        end

        if isWin == true
                or gameMode == GameMode.EVENT_CHRISTMAS
                or gameMode == GameMode.EVENT_VALENTINE_BOSS
                or gameMode == GameMode.EVENT_KAZETSU_BOSS
                --or gameMode == GameMode.EVENT_AIRYUU_TRIAL
                or gameMode == GameMode.EVENT_FINDE_BOSS
                or gameMode == GameMode.EVENT_SEASONAL_ROYAL_CHALLENGE
                or gameMode == GameMode.EVENT_BIRTHDAY_BOSS
                or gameMode == GameMode.GUILD_BOSS then
            PopupMgr.ShowPopup(UIPopupName.UIVictory, data)
        else
            PopupMgr.ShowPopup(UIPopupName.UIDefeat, data)
        end
        RxMgr.finishBattle:Next()
    end)
end

function ClientBattleShowController:CloseOpeningPopup()
    if PopupUtils.IsPopupShowing(UIPopupName.UICompanionCollection) then
        PopupMgr.HidePopup(UIPopupName.UICompanionCollection)
    end
end

--- @return UIBattleTextLog
function ClientBattleShowController:GetUIBattleTextLog()
    return zg.battleEffectMgr:GetUIBattleTextLog()
end

--- @return BondLink
function ClientBattleShowController:GetBondLink()
    local bondObject = SmartPool.Instance:SpawnGameObject(AssetType.GeneralBattleEffect, "bond_linking")
    bondObject:SetActive(true)
    return zg.battleEffectMgr:GetBondLink(bondObject)
end

--- @return UIBattleEffectIcon
--- @param effectLogType EffectLogType
--- @param isBuff boolean
function ClientBattleShowController:GetBattleEffectIcon(effectLogType, isBuff)
    local uiBattleEffectIcon = zg.battleEffectMgr:GetUIBattleEffectIcon()
    if uiBattleEffectIcon ~= nil then
        uiBattleEffectIcon:ShowIcon(effectLogType, isBuff)
    end
    return uiBattleEffectIcon
end

--- @param eventData {}
function ClientBattleShowController:SetSwitchMode(eventData)
    self.isAutoBattle = eventData.isAuto
end

--- @param actionResultType ActionResultType
--- @param initiator BaseHero
--- @param target BaseHero
--- @param statType StatType
--- @param onEffectComplete function
function ClientBattleShowController:ShowAddOrStealStatEffect(actionResultType, initiator, target, statType, onEffectComplete)
    local effectName = string.format("add_or_steal_stat_%d", statType)

    local addStolenEffect = zg.battleEffectMgr:GetClientEffect(AssetType.GeneralBattleEffect, effectName)
    if addStolenEffect == nil then
        return
    end

    if addStolenEffect.isInited == false then
        local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
        addStolenEffect:InitRef(AssetType.GeneralBattleEffect, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
        addStolenEffect:AddConfigField("originSpeed", 5.5)
        addStolenEffect:AddConfigField("deltaSpeed", 7)
        addStolenEffect:AddConfigField("rotationSpeed", 4)
        addStolenEffect.isInited = true
    end
    addStolenEffect:Play()

    local fromClientHero
    local toClientHero
    if actionResultType == ActionResultType.ADD_STOLEN_STAT then
        fromClientHero = self:GetClientHeroByBaseHero(initiator)
        toClientHero = self:GetClientHeroByBaseHero(target)
    elseif actionResultType == ActionResultType.STEAL_STAT then
        fromClientHero = self:GetClientHeroByBaseHero(target)
        toClientHero = self:GetClientHeroByBaseHero(initiator)
    end
    addStolenEffect:DoCurveMoveBetweenHero(fromClientHero, toClientHero, function()
        if onEffectComplete ~= nil then
            onEffectComplete()
        end
    end)
end

--- @return ClientEffect
--- @param effectType string
--- @param effectName string
function ClientBattleShowController:GetClientEffect(effectType, effectName)
    local clientEffect = zg.battleEffectMgr:GetClientEffect(effectType, effectName)
    if clientEffect == nil then
        XDebug.Error("There is no client effect ", effectType, effectName)
        return nil
    end
    if clientEffect.isInited == false then
        local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
        clientEffect:InitRef(effectType, effectName, GeneralEffectPoolType.ClientEffect, luaConfigFile)
        clientEffect.isInited = true
    end
    return clientEffect
end

--- @param clientHero BaseHero
--- @param initiatorFaction HeroFactionType
--- @param isPermanent boolean
function ClientBattleShowController:ShowRebornOrReviveEffect(clientHero, initiatorFaction,isPermanent)
    local rebornOrReviveEffect = self:GetClientEffect(AssetType.GeneralBattleEffect,
            "reborn_or_revive_" .. initiatorFaction)
    if rebornOrReviveEffect ~= nil then
        rebornOrReviveEffect:SetToHeroAnchor(clientHero,isPermanent)
    end
    if initiatorFaction == HeroFactionType.ABYSS or initiatorFaction == HeroFactionType.LIGHT then
        zg.audioMgr:PlaySound(AssetType.GeneralBattleSound, "sfx_reborn_or_revive_" .. initiatorFaction)
    end
end

--- @param clientHero ClientHero
function ClientBattleShowController:ShowDieEffect(clientHero)
    --- @type ClientEffect
    local dieEffect
    if clientHero.baseHero.originInfo.faction == HeroFactionType.LIGHT
            or clientHero.baseHero.originInfo.faction == HeroFactionType.DARK then
        dieEffect = self:GetClientEffect(AssetType.GeneralBattleEffect, "die_" .. clientHero.baseHero.originInfo.faction)
    else
        dieEffect = self:GetClientEffect(AssetType.GeneralBattleEffect, "die_" .. 0)
    end
    if dieEffect ~= nil then
        dieEffect:SetToHeroAnchor(clientHero)
    end
end

--- @return boolean
function ClientBattleShowController:IsWin()
    if zg.battleMgr.gameMode == GameMode.ARENA_TEAM
            or zg.battleMgr.gameMode == GameMode.ARENA_TEAM_RECORD then
        return zg.playerData:GetArenaData().arenaTeamBattleData.winnerTeam == BattleConstants.ATTACKER_TEAM_ID
    end
    if self.clientLogDetail ~= nil then
        return self.clientLogDetail.winnerTeam == BattleConstants.ATTACKER_TEAM_ID
    else
        return false
    end
end

function ClientBattleShowController:SetTimeScale(timeScale)
    ClientConfigUtils.SetTimeScale(timeScale)
    zg.battleEffectMgr:AdjustVideoSpeed(timeScale)
end

function ClientBattleShowController:PauseBattle(isUseTimeScale)
    if isUseTimeScale == nil then
        isUseTimeScale = true
    end
    if isUseTimeScale == true then
        self:SetTimeScale(0)
    else
        self.isAutoBattle = false
    end
end

function ClientBattleShowController:ResumeBattle(isUseTimeScale)
    if isUseTimeScale == nil then
        isUseTimeScale = true
    end
    if isUseTimeScale == true then
        self:SetTimeScale(ClientConfigUtils.GetTimeScaleBySpeedUpLevel(PlayerSettingData.battleSpeed))
    else
        if self:IsAvailableToNextTurn() == true then
            self.isAutoBattle = true
            self:DoClientTurn()
        else
            XDebug.Error("Cannot Resume when a turn is running")
        end
    end
end

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------

function ClientBattleShowController:ClearPendingCollection()
    self.pendingClientAction = Dictionary()
end

function ClientBattleShowController:IsAvailableToNextTurn()
    return self.pendingClientAction:Count() == 0
            and self.isGameOver == false
            and self.isPerformActionResults == false
end

function ClientBattleShowController:DoClientTurn()
    --print("ROUND:" .. self.roundNum .. "    SERVER TURN:" .. self.serverTurnNum .. "    CLIENT TURN:" .. self.clientTurnNum)
    self:ClearPendingCollection()

    --- @type ClientHero
    local _doActionClientHero = self:GetClientHeroByBaseHero(self.clientTurnDetail.initiator)
    if _doActionClientHero then
        _doActionClientHero:DoAction(self.clientTurnDetail)
    else
        self:TriggerActionResult()
        if self:IsAvailableToNextTurn() then
            self:ClientHeroFinishTurn()
        end
    end
end

function ClientBattleShowController:TriggerActionResult()
    --- @param baseHero BaseHero
    --- @param clientHero ClientHero
    for baseHero, clientHero in pairs(self.clientHeroDictionary:GetItems()) do
        clientHero:UpdateHealth(self.clientTurnDetail.hpPercentDict:Get(baseHero))
        clientHero:UpdatePower(self.clientTurnDetail.powerPercentDict:Get(baseHero))
        clientHero:UpdateEffect(self.clientTurnDetail.effectIconDict:Get(baseHero))

        clientHero:ClearLogStack()
    end
    self:UpdateTeamWrathPowerByTurn()

    -- Update CC Effect
    --- @param v EffectChangeResult
    for _, v in pairs(self.clientTurnDetail.effectCCList:GetItems()) do
        self:GetClientHeroByBaseHero(v.target):UpdateCCEffect(v)
    end

    self.isPerformActionResults = true
    --- @param v BaseActionResult
    for _, v in pairs(self.clientTurnDetail.actionList:GetItems()) do
        if v.type == ActionResultType.BOND_EFFECT
                or v.type == ActionResultType.MAGIC_SHIELD
                or v.type == ActionResultType.TRIGGER_SUB_ACTIVE then
            self:GetClientHeroByBaseHero(v.initiator):DoActionResult(v, self.clientTurnDetail.actionType)
        else
            self:GetClientHeroByBaseHero(v.target):DoActionResult(v, self.clientTurnDetail.actionType)
        end
    end

    --- @param v ClientHero
    for _, v in pairs(self.listClientHero:GetItems()) do
        v:LogAllFromStack()
    end
    self.attackerTeamCtrl:LogAllDamageFromStack()
    self.defenderTeamCtrl:LogAllDamageFromStack()

    self.isPerformActionResults = false
    self:ClientHeroFinishTurn()
end

--- @return void
function ClientBattleShowController:ClientHeroFinishTurn()
    if self:IsAvailableToNextTurn() == false then
        return
    end

    if self.clientTurnNum == self.clientListTurnDetails:Count() then
        self:GameOver()
        return
    end

    RxMgr.finishTurn:Next()

    self.clientTurnNum = self.clientTurnNum + 1
    self.clientTurnDetail = self.clientListTurnDetails:Get(self.clientTurnNum)
    self.serverTurnNum = self.clientTurnDetail.serverTurn

    if self.roundNum ~= self.clientTurnDetail.serverRound then
        self:SetRound(self.clientTurnDetail.serverRound, true)
    end

    if self.isAutoBattle then
        self:DoClientTurn()
    end
end

--- @param clientActionDetail ClientActionDetail
--- @param clientHero ClientHero
function ClientBattleShowController:AddPendingClientAction(clientHero, clientActionDetail)
    self.pendingClientAction:Add(clientHero, clientActionDetail)
end

--- @param clientActionDetail ClientActionDetail
--- @param clientHero ClientHero
function ClientBattleShowController:FinishClientAction(clientHero, clientActionDetail)
    self.pendingClientAction:RemoveByKey(clientHero)
    if self.pendingClientAction:Count() == 0 then
        self:ClientHeroFinishTurn()
    end
end

--- @param clientHero ClientHero
function ClientBattleShowController:ShowHealingEffect(clientHero)
    local fxHealing = self:GetClientEffect(AssetType.GeneralBattleEffect, "healing")
    if fxHealing ~= nil then
        fxHealing:SetToHeroAnchor(clientHero)
    end
end

--- @param shakeTable table
--- table[1] duration
--- table[2] strengthX
--- table[3] strengthY
--- table[4] vibrato
--- table[5] randomness
function ClientBattleShowController:DoShake(shakeTable)
    self.battleView:DoShakeCamera(shakeTable)
end

--- @param coverDuration number
--- @param fadeInDuration number
--- @param fadeOutDuration number
--- @param coverAlpha number
--- @param onEndFadeIn function
--- @param onEndFade function
function ClientBattleShowController:DoCoverBattle(coverDuration, fadeInDuration, fadeOutDuration, coverAlpha, onEndFadeIn, onEndFade)
    self.battleView:DoCoverBattle(coverDuration, fadeInDuration, fadeOutDuration, coverAlpha, onEndFadeIn, onEndFade)
end

--- @param baseHero BaseHero
--- @param sortingLayerId number
function ClientBattleShowController:ChangeHeroLayerByBaseHero(baseHero, sortingLayerId)
    local clientHero = self:GetClientHeroByBaseHero(baseHero)
    if clientHero ~= nil then
        clientHero:ChangeSortingLayerId(sortingLayerId)
    end
end

--- @return void
--- @param round number
--- @param useMotion boolean
function ClientBattleShowController:SetRound(round, useMotion)
    self.roundNum = round
    useMotion = useMotion or false
    RxMgr.updateRound:Next({ ["round"] = self.roundNum, ["useMotion"] = useMotion })
end

function ClientBattleShowController:UnloadUnuseResource()
    self:ReturnPoolGameObjects()
    self:DestroyGameObjects()
    zg.battleMgr:ReleaseBattle()
    self.unloadUnuseResourceListener:Unsubscribe()
end

function ClientBattleShowController:ReturnPoolGameObjects()
    if self.battleView ~= nil then
        self.battleView:OnHide()
        self.battleView = nil
    end
    zg.battleEffectMgr:OnHide()
    for i = 1, self.listClientHero:Count() do
        self.listClientHero:Get(i):ReturnPool()
    end
end

function ClientBattleShowController:DestroyGameObjects()
    SmartPool.Instance:DestroyGameObjectByPoolType(AssetType.GeneralBattleEffect)
    SmartPool.Instance:DestroyGameObjectByPoolType(AssetType.HeroBattleEffect)

    SmartPool.Instance:DestroyGameObjectByPoolType(AssetType.Hero)
    SmartPool.Instance:DestroyGameObjectByPoolType(AssetType.Battle)
    SmartPool.Instance:DestroyGameObjectByPoolType(AssetType.Background)
end

function ClientBattleShowController:PreloadGameBattleEffect()
    for i = 1, self.clientListTurnDetails:Count() do
        --- @type ClientTurnDetail
        local currentTurnDetail = self.clientListTurnDetails:Get(i)
        for k = 1, currentTurnDetail.actionList:Count() do
            --- @type BaseActionResult
            local actionResult = currentTurnDetail.actionList:Get(k)
            local actionResultType = actionResult.type
            if actionResultType == ActionResultType.DEAD_FOR_DISPLAY then
                local target = actionResult.target
                local effectName
                if target.originInfo.faction == HeroFactionType.LIGHT
                        or target.originInfo.faction == HeroFactionType.DARK then
                    effectName = "die_" .. target.originInfo.faction
                else
                    effectName = "die_" .. 0
                end
                self:AddPreloadGeneralBattleEffect(effectName)
            elseif actionResultType == ActionResultType.HEAL_EFFECT then
                self:AddPreloadGeneralBattleEffect("healing")
            elseif actionResultType == ActionResultType.MAGIC_SHIELD then
                self:AddPreloadGeneralBattleEffect("shield_block")
            elseif actionResultType == ActionResultType.HEAL_EFFECT then
                self:AddPreloadGeneralBattleEffect("healing")
            elseif actionResultType == ActionResultType.STEAL_STAT then
                --- @type StatType
                local statType = actionResult.statType
                if statType == StatType.ATTACK
                        or statType == StatType.DEFENSE
                        or statType == StatType.POWER then
                    self:AddPreloadGeneralBattleEffect("absorb_add_or_steal_" .. actionResult.statType)
                end
            elseif actionResultType == ActionResultType.INSTANT_KILL then
                self:AddPreloadGeneralBattleEffect("instant_skill_effect")
            elseif actionResultType == ActionResultType.BOND_EFFECT then
            elseif actionResultType == ActionResultType.BOND_SHARE_DAMAGE then
                self:AddPreloadGeneralBattleEffect("bond_linking")
            elseif actionResultType == ActionResultType.REBORN
                    or actionResultType == ActionResultType.REVIVE then
                local initiator = actionResult.initiator
                local effectName = "reborn_or_revive_" .. initiator.originInfo.faction
                self:AddPreloadGeneralBattleEffect(effectName)
            end
        end
    end

    for i = 1, self.listPreloadedBattleEffect:Count() do
        local effectName = self.listPreloadedBattleEffect:Get(i)
        local luaConfigFile = ResourceMgr.GetEffectLuaConfig(effectName)
        local clientEffect
        if luaConfigFile ~= nil then
            clientEffect = self:GetClientEffect(AssetType.GeneralBattleEffect, effectName)
            clientEffect:ReturnPool()
        else
            local onSpawned = function(gameObject)
                SmartPool.Instance:DespawnGameObject(AssetType.GeneralBattleEffect, effectName, gameObject.transform)
            end
            SmartPool.Instance:SpawnGameObjectAsync(AssetType.GeneralBattleEffect, effectName, onSpawned)
        end
    end

    local listBattleTextLog = List()
    for _ = 1, 6 do
        local battleTextLog = zg.battleEffectMgr:GetUIBattleTextLog()
        listBattleTextLog:Add(battleTextLog)
    end
    for i = 1, listBattleTextLog:Count() do
        local battleTextLog = listBattleTextLog:Get(i)
        battleTextLog:ReturnPool()
    end

    ResourceLoadUtils.PreloadAtlas(ResourceLoadUtils.iconBuffDebuffs)
end

--- @param preloadEffectName string
function ClientBattleShowController:AddPreloadGeneralBattleEffect(preloadEffectName)
    if self.listPreloadedBattleEffect:IsContainValue(preloadEffectName) == false then
        self.listPreloadedBattleEffect:Add(preloadEffectName)
    end
end

--- @param preloadSprite string
function ClientBattleShowController:AddPreloadBattleSprite(preloadSprite)
    if self.listPreloadedSprite:IsContainValue(preloadSprite) == false then
        self.listPreloadedSprite:Add(preloadSprite)
    end
end

function ClientBattleShowController:GetTeamBossCount(teamId)
    if teamId == BattleConstants.DEFENDER_TEAM_ID then
        return self.defenderTeamCtrl:GetTeamBossCount()
    else
        return self.attackerTeamCtrl:GetTeamBossCount()
    end
end

function ClientBattleShowController:GetTeamCount(teamId)
    if teamId == BattleConstants.DEFENDER_TEAM_ID then
        return self.defenderTeamCtrl:GetTeamCount()
    else
        return self.attackerTeamCtrl:GetTeamCount()
    end
end

function ClientBattleShowController:UpdateTeamWrathPowerByTurn()
    --- @type number
    local powerNumber
    powerNumber = self.clientTurnDetail.powerPercentDict:Get(self.attackerTeamCtrl.summoner)
    if powerNumber ~= nil then
        self:UpdateTeamWrathPower(BattleConstants.ATTACKER_TEAM_ID, powerNumber, true)
    end

    powerNumber = self.clientTurnDetail.powerPercentDict:Get(self.defenderTeamCtrl.summoner)
    if powerNumber ~= nil then
        self:UpdateTeamWrathPower(BattleConstants.DEFENDER_TEAM_ID, powerNumber, true)
    end
end

function ClientBattleShowController:DoShowAttackerTeam()
    local summoner = self.attackerTeamCtrl.summoner
    local clientSummoner = self:GetClientHeroByBaseHero(summoner)
    if clientSummoner ~= nil then
        clientSummoner:SetActive(true)
        if clientSummoner:IsDummy() == false then
            clientSummoner:PlayStartAnimation()
        end
    end

    Coroutine.start(function()
        --- @param baseHero BaseHero
        --- @param clientHero ClientHero
        for baseHero, clientHero in pairs(self.attackerTeamCtrl.heroDictionary:GetItems()) do
            if baseHero.isSummoner == false then
                clientHero:SetActive(false)
                local fxSpawn = self:GetClientEffect(AssetType.GeneralBattleEffect, "battle_spawn_hero")
                fxSpawn:SetToHeroAnchor(clientHero)
                coroutine.waitforseconds(0.15)
                clientHero:SetActive(true)
                if clientHero:IsDummy() == false then
                    clientHero:PlayStartAnimation()
                end
            end
        end
    end)
end

function ClientBattleShowController:DoShowDefenderTeam()
    --- @param _ BaseHero
    --- @param clientHero ClientHero
    for _, clientHero in pairs(self.defenderTeamCtrl.heroDictionary:GetItems()) do
        clientHero:SetActive(true)
        if clientHero:IsDummy() == false then
            clientHero:PlayStartAnimation()
        end
    end
end

--- @param teamId number
--- @param powerAmount number
--- @param useTween boolean
function ClientBattleShowController:UpdateTeamWrathPower(teamId, powerAmount, useTween)
    --- @type {teamId : number, powerAmount : number, useTween : boolean}
    local updateTeamWrathPower = {}
    updateTeamWrathPower.teamId = teamId
    updateTeamWrathPower.powerAmount = powerAmount
    updateTeamWrathPower.useTween = useTween
    RxMgr.updateBattleUI:Next({ ['updateTeamWrathPower'] = updateTeamWrathPower })
end

--- @param videoClipName string
--- @param isFlipHorizontal boolean
function ClientBattleShowController:ShowVideoCutScene(videoClipName, isFlipHorizontal, fadeOutDuration, fadeInDuration)
    zg.battleEffectMgr:ShowVideoCutScene(videoClipName, isFlipHorizontal, fadeOutDuration, fadeInDuration, function()
        self.battleView:EnableMainCamera(false)
    end, function()
        self.battleView:EnableMainCamera(true)
    end)
end

function ClientBattleShowController:UpdateTeamEffect(teamId, effectLogType, ClientEffectDetail)
    if teamId == BattleConstants.ATTACKER_TEAM_ID then
        self.attackerTeamCtrl:UpdateTeamEffect(effectLogType, ClientEffectDetail)
    else
        self.defenderTeamCtrl:UpdateTeamEffect(effectLogType, ClientEffectDetail)
    end
end

function ClientBattleShowController:DoTeamAction(teamId, actionResultType, actionResult)
    if teamId == BattleConstants.ATTACKER_TEAM_ID then
        self.attackerTeamCtrl:DoTeamAction(actionResultType, actionResult)
    else
        self.defenderTeamCtrl:DoTeamAction(actionResultType, actionResult)
    end
end