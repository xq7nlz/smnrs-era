--- @class BattleSelectMapController : ClientBattleShowController
BattleSelectMapController = Class(BattleSelectMapController, ClientBattleShowController)

local treasurePosition = U_Vector3(0, -2.7, 0)

function BattleSelectMapController:Ctor()
    ClientBattleShowController.Ctor(self)

    --- @type List<BaseHero>
    self.originAttackerTeam = List()
    --- @type List<BaseHero>
    self.originDefenderTeam = List()

    --- @type List<ClientHero>
    self.listAttacker = List()
    --- @type List<ClientHero>
    self.listDefender = List()

    --- @type Dictionary<BaseHero, number> (value: basicAttackCount)
    self.basicAttackCounterDictionary = Dictionary()
    --- @type boolean
    self.isPauseByPopup = false

    --- @type function
    self.onClickLootTreasure = nil
    --- @type UnityEngine_GameObject
    self.treasure = nil
    --- @type UnityEngine_GameObject
    self.coinLoot = nil
    --- @type Coroutine
    self.treasureCoroutine = nil
end

--- @return void
function BattleSelectMapController:OnCreate()
    self:InitReference()
end

function BattleSelectMapController:InitListener()
    self.closePopupListener = RxMgr.closePopup:Subscribe(RxMgr.CreateFunction(self, self.OnPopupClosed))
end

function BattleSelectMapController:RemoveListener()
    if self.closePopupListener ~= nil then
        self.closePopupListener:Unsubscribe()
    end
end

--- @param popupEventData table
function BattleSelectMapController:OnPopupClosed(popupEventData)
    local popupName = popupEventData.name
    if popupName == UIPopupName.UILeaderBoard
            or popupName == UIPopupName.UIStageSelect
            or popupName == UIPopupName.UITrainingTeam
            or popupName == UIPopupName.UIScrollLoopReward
            or popupName == UIPopupName.UIFormation
    then
        self:SetPauseByPopup(false)
    end
end

--- Create team from Attacker Data and Defender Data
function BattleSelectMapController:InitTeam()
    self.originAttackerTeam = List()
    --- @type List {HeroResource}
    local listHeroResource = List()
    --- @type DetailTeamFormation
    local campaignDetailTeamFormation = zg.playerData:GetMethod(PlayerDataMethod.CAMPAIGN_DETAIL_FORMATION).detailTeamFormation
    for _, heroResource in pairs(campaignDetailTeamFormation.frontLineDict:GetItems()) do
        listHeroResource:Add(heroResource)
    end
    for _, heroResource in pairs(campaignDetailTeamFormation.backLineDict:GetItems()) do
        listHeroResource:Add(heroResource)
    end
    for i = 1, listHeroResource:Count() do
        self.originAttackerTeam:Add(self:CreateBaseHeroFromHeroResource(listHeroResource:Get(i), BattleConstants.ATTACKER_TEAM_ID, false))
    end

    --- Team from Defender Data
    self.originDefenderTeam = List()
    --- @type number
    local stageIdle = zg.playerData:GetCampaignData().stageIdle
    --- @return DefenderTeamData
    local dataStage = ResourceMgr.GetCampaignDataConfig():GetCampaignStageConfigById(stageIdle)
    assert(dataStage, stageIdle)
    --- @type BattleTeamInfo
    local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(dataStage)
    for i = 1, battleTeamInfo.listHeroInfo:Count() do
        self.originDefenderTeam:Add(self:CreateBaseHeroFromHeroBattleInfoId(battleTeamInfo.listHeroInfo:Get(i), BattleConstants.DEFENDER_TEAM_ID, true))
    end
end

function BattleSelectMapController:ResetFields()
    self.listPreloadedHeroEffect = List()
    self.clientHeroDictionary = Dictionary()
    self.listAttacker = List()
    self.listDefender = List()
    self.basicAttackCounterDictionary = Dictionary()
    self.pendingClientAction = Dictionary()
    self.listClientHero = List()
    self.isPauseByPopup = false
end

--- select random hero from each team
function BattleSelectMapController:InitBattle()
    self:InitTeam()

    self:CreateAttackerTeam()
    self:CreateDefenderTeam()

    for i = 1, self.listAttacker:Count() do
        local clientHero = self.listAttacker:Get(i)
        clientHero:DoFadeInOnStart()
        clientHero:PlayStartAnimation()
    end
    for i = 1, self.listDefender:Count() do
        local clientHero = self.listDefender:Get(i)
        clientHero:DoFadeInOnStart()
        clientHero:PlayStartAnimation()
    end
end

function BattleSelectMapController:CreateAttackerTeam()
    local MAX_ATTACKER_TEAM_COUNT = 3
    if self.originAttackerTeam:Count() <= MAX_ATTACKER_TEAM_COUNT then
        for i = 1, self.originAttackerTeam:Count() do
            self:CreateHero(self.originAttackerTeam:Get(i), i)
        end
    else
        --- @type List<number>
        local listAttackerIndex = List()
        for i = 1, self.originAttackerTeam:Count() do
            listAttackerIndex:Add(i)
        end

        for i = 1, MAX_ATTACKER_TEAM_COUNT do
            local randomIndex = listAttackerIndex:Get(math.random(1, listAttackerIndex:Count()))
            listAttackerIndex:RemoveByReference(randomIndex)

            self:CreateHero(self.originAttackerTeam:Get(randomIndex), i)
        end
    end
end

function BattleSelectMapController:CreateDefenderTeam()
    self.listDefender = List()
    local defenderBaseHero = self.originDefenderTeam:Get(math.random(1, self.originDefenderTeam:Count()))
    self:CreateHero(defenderBaseHero)
end

--- @param baseHero BaseHero
--- @param indexInTeam number
function BattleSelectMapController:CreateHero(baseHero, indexInTeam)
    baseHero.positionInfo = self:CreatePositionInfoFromIndex(baseHero, indexInTeam)
    local overridePosition
    if baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        overridePosition = PositionConfig.GetDemoPosByIndex(self.listAttacker:Count() + 1)
    end

    ----- @type ClientHero
    local clientHero = self:CreateClientHeroByBaseHero(baseHero)
    clientHero:Init(baseHero, overridePosition)
    clientHero:SetActive(false)
    zg.battleMgr.previewHeroMgr:AddPreviewHeroInfo(clientHero.prefabName)

    self.clientHeroDictionary:Add(baseHero, clientHero)

    if baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        self.listAttacker:Add(clientHero)
    elseif baseHero.teamId == BattleConstants.DEFENDER_TEAM_ID then
        self.listDefender:Add(clientHero)
    end
end

--- @return BaseHero
--- @param teamId number
--- @param inventoryId number
function BattleSelectMapController:CreateBaseHeroFromInventoryId(inventoryId, teamId)
    --- @type HeroResource
    local heroResource = InventoryUtils.GetHeroResourceByInventoryId(inventoryId)
    --- @type BaseHero
    local baseHero = BaseHero()
    baseHero.id = heroResource.heroId
    baseHero.teamId = teamId
    baseHero.hp = HpStat()
    baseHero.star = heroResource.heroStar
    baseHero.isBoss = false
    return baseHero
end

--- @return BaseHero
--- @param heroBattleInfo HeroBattleInfo
--- @param teamId number
--- @param isBoss boolean
function BattleSelectMapController:CreateBaseHeroFromHeroBattleInfoId(heroBattleInfo, teamId, isBoss)
    --- @type BaseHero
    local baseHero = BaseHero()
    baseHero.id = heroBattleInfo.heroId
    baseHero.teamId = teamId
    baseHero.hp = HpStat()
    baseHero.star = heroBattleInfo.star
    baseHero.isBoss = isBoss
    return baseHero
end

--- @return BaseHero
--- @param heroResource HeroResource
--- @param teamId number
--- @param isBoss boolean
function BattleSelectMapController:CreateBaseHeroFromHeroResource(heroResource, teamId, isBoss)
    --- @type BaseHero
    local baseHero = BaseHero()
    baseHero.id = heroResource.heroId
    baseHero.teamId = teamId
    baseHero.hp = HpStat()
    baseHero.star = heroResource.heroStar
    baseHero.isBoss = isBoss
    local skinId = heroResource.heroItem:Get(HeroItemSlot.SKIN)
    local effectId = heroResource.heroItem:Get(HeroItemSlot.IDLE_EFFECT)
    local addController = skinId ~= nil or effectId ~= nil
    if (addController == true) then
        baseHero.equipmentController = EquipmentController(baseHero)
        if (skinId ~= nil) then
            baseHero.equipmentController:AddItem(HeroItemSlot.SKIN, skinId)
            baseHero.equipmentController.isHideSkin = heroResource.isHideSkin
        end
        if effectId ~= nil then
            baseHero.equipmentController:AddItem(HeroItemSlot.IDLE_EFFECT, effectId)
            --baseHero.equipmentController.isHideSkin = heroResource.isHideSkin
        end

    end
    return baseHero
end

function BattleSelectMapController:CreateBattle()
    --XDebug.Log("Create battle")
    self.clientListTurnDetails = List()
    --- @type ClientTurnDetail
    self.clientTurnDetail = ClientTurnDetail()
    self.basicAttackCounterDictionary = Dictionary()

    --- @return List<ClientHero>
    local function CreateSubTeam(originTeam, subTeamCount)
        local subTeam = List()
        if originTeam:Count() < subTeamCount then
            assert(false, "Cannot create subteam with " .. subTeamCount .. "/" .. originTeam:Count() .. " hero")
        end
        for i = 1, subTeamCount do
            subTeam:Add(originTeam:Get(i))
        end
        return subTeam
    end

    local function CreateClientTurnDetail(clientTurnNum, initiator, actionResult, actionType)
        local clientTurnDetail = ClientTurnDetail()
        clientTurnDetail.clientTurn = clientTurnNum
        clientTurnDetail.initiator = initiator
        --clientTurnDetail.actionType = actionType
        clientTurnDetail.actionList = List()
        clientTurnDetail.actionList:Add(actionResult)

        if self.basicAttackCounterDictionary:IsContainKey(initiator) then
            local basicAttackCount = self.basicAttackCounterDictionary:Get(initiator)
            if basicAttackCount >= 1 then
                clientTurnDetail.actionType = ClientActionType.USE_SKILL
                self.basicAttackCounterDictionary:Add(initiator, 0)
            else
                clientTurnDetail.actionType = ClientActionType.BASIC_ATTACK
                self.basicAttackCounterDictionary:Add(initiator, basicAttackCount + 1)
            end
        else
            clientTurnDetail.actionType = ClientActionType.BASIC_ATTACK
            self.basicAttackCounterDictionary:Add(initiator, 1)
        end

        return clientTurnDetail
    end

    local subAttackerTeam = CreateSubTeam(self.listAttacker, self.listAttacker:Count())
    local subDefenderTeam = CreateSubTeam(self.listDefender, 1)

    local clientTurnNum = 1
    for i = 1, 2 do
        for k = 1, subAttackerTeam:Count() do
            local attackActionResult = AttackResult(subAttackerTeam:Get(k).baseHero, subDefenderTeam:Get(1).baseHero)
            attackActionResult.damage = 1
            local clientTurnDetail = CreateClientTurnDetail(clientTurnNum, subAttackerTeam:Get(k).baseHero, attackActionResult, ClientActionType.BASIC_ATTACK)
            self.clientListTurnDetails:Add(clientTurnDetail)
            clientTurnNum = clientTurnNum + 1
        end
        local attackActionResult = AttackResult(subDefenderTeam:Get(1).baseHero, subAttackerTeam:Get(math.random(1, subAttackerTeam:Count())).baseHero)
        attackActionResult.damage = 1
        local clientTurnDetail = CreateClientTurnDetail(clientTurnNum, subDefenderTeam:Get(1).baseHero, attackActionResult, ClientActionType.BASIC_ATTACK)
        self.clientListTurnDetails:Add(clientTurnDetail)
        clientTurnNum = clientTurnNum + 1
    end
    local lastHero = subAttackerTeam:Get(math.random(1, subAttackerTeam:Count())).baseHero
    local attackActionResult = AttackResult(lastHero, subDefenderTeam:Get(1).baseHero)
    attackActionResult.damage = 1
    local clientTurnDetail = CreateClientTurnDetail(clientTurnNum, lastHero, attackActionResult, ClientActionType.BASIC_ATTACK)

    local deadEventData = {}
    deadEventData.reason = TakeDamageReason.ATTACK_DAMAGE
    deadEventData.initiator = subDefenderTeam:Get(1).baseHero
    deadEventData.target = subDefenderTeam:Get(1).baseHero
    deadEventData.target.hp = HpStat()

    local deadActionResult = DeadForDisplayActionResult(deadEventData)
    clientTurnDetail.actionList:Add(deadActionResult)
    self.clientListTurnDetails:Add(clientTurnDetail)
end

--- @return void
function BattleSelectMapController:StartTheShow()
    self.isGameOver = false
    self.clientTurnNum = 1
    self.clientTurnDetail = self.clientListTurnDetails:Get(self.clientTurnNum)
    self:DoClientTurn()
end

function BattleSelectMapController:RefreshBattle(delayPreload, delayStartShow)
    delayPreload = delayPreload or 0.4
    delayStartShow = delayStartShow or 0.7
    self.isGameOver = false

    ClientConfigUtils.KillCoroutine(self._battleTweener)
    self._battleTweener = Coroutine.start(function()
        coroutine.waitforseconds(delayPreload)
        --self:PreloadHeroEffect()
        self:RefreshTeams()
        if self.battleView ~= nil then
            self.battleView:EnableMainCamera(true)
        end
        coroutine.waitforseconds(delayStartShow)
        self:StartTheShow()
    end)
end

function BattleSelectMapController:RefreshTeams()
    for i = 1, self.listAttacker:Count() do
        local clientHero = self.listAttacker:Get(i)
        clientHero:SetActive(true)
        clientHero:DoFadeInOnStart()
        clientHero:PlayStartAnimation()
    end
    for i = 1, self.listDefender:Count() do
        local clientHero = self.listDefender:Get(i)
        clientHero:SetActive(true)
        clientHero:DoFadeInOnStart()
        clientHero:PlayStartAnimation()
    end
end

--- @return UIBattleTextLog
function BattleSelectMapController:GetUIBattleTextLog()
    return nil
end

function BattleSelectMapController:DoClientTurn()
    local doActionClientHero = self:GetClientHeroByBaseHero(self.clientTurnDetail.initiator)
    if doActionClientHero ~= nil then
        doActionClientHero:DoAction(self.clientTurnDetail,true)
    end
end

function BattleSelectMapController:TriggerActionResult()
    if self.isGameOver == true then
        return
    end
    if self.clientTurnDetail.actionList == nil then
        XDebug.Error("actionList is nil")
        return
    end
    --- @param activeResult BaseActionResult
    for _, activeResult in ipairs(self.clientTurnDetail.actionList:GetItems()) do
        local _target = activeResult.target
        local clientHero = self:GetClientHeroByBaseHero(_target)
        clientHero:DoActionResult(activeResult, self.clientTurnDetail.actionType)
    end
end

function BattleSelectMapController:ClientHeroFinishTurn()
    if self:IsAvailableToNextTurn() == false then
        return
    end

    if self.clientTurnNum == self.clientListTurnDetails:Count() then
        self:GameOver()
        return
    end

    self.clientTurnNum = self.clientTurnNum + 1
    self.clientTurnDetail = self.clientListTurnDetails:Get(self.clientTurnNum)

    self:DoClientTurn()
end

function BattleSelectMapController:IsAvailableToNextTurn()
    return self.pendingClientAction:Count() == 0 and self.isGameOver == false
end

function BattleSelectMapController:GameOver()
    local clientHero = self.listDefender:Get(1)
    if clientHero ~= nil then
        self:DropCoin(clientHero.originPosition)
    end
    ClientConfigUtils.KillCoroutine(self._battleTweener)
    self._battleTweener = Coroutine.start(function()
        coroutine.waitforseconds(1.3)
        self:RemoveClientDefender()
        coroutine.waitforseconds(0.2)
        self:CreateDefenderTeam()
        for i = 1, self.listDefender:Count() do
            --- @type ClientHero
            local clientHero = self.listDefender:Get(i)
            clientHero:SetActive(true)
            clientHero:DoFadeInOnStart()
            clientHero:PlayStartAnimation()
        end
        coroutine.waitforseconds(1)
        self:CreateBattle()
        self:StartTheShow()
    end)
end

function BattleSelectMapController:RemoveClientDefender()
    local clientDefender = self.listDefender:Get(1)
    if clientDefender ~= nil then
        self.clientHeroDictionary:RemoveByKey(clientDefender.baseHero)
        self.listDefender:RemoveByReference(clientDefender)
        self:DespawnHeroByClientHero(clientDefender)
        self.listClientHero:RemoveByReference(clientDefender)
    end
end

--- @param baseHero BaseHero
--- @param indexInTeam number
function BattleSelectMapController:CreatePositionInfoFromIndex(baseHero, indexInTeam)
    local positionInfo = PositionInfo(baseHero)
    positionInfo.position = indexInTeam

    if baseHero.teamId == BattleConstants.ATTACKER_TEAM_ID then
        positionInfo.formationId = 1
        positionInfo.isFrontLine = (indexInTeam <= 2)
        if indexInTeam > 2 then
            positionInfo.position = 1
        else
            positionInfo.position = indexInTeam + 1
        end
    elseif baseHero.teamId == BattleConstants.DEFENDER_TEAM_ID then
        positionInfo.formationId = 6
        positionInfo.isFrontLine = false
        positionInfo.position = 1
    end
    return positionInfo
end

--- @param clientHero ClientHero
function BattleSelectMapController:ShowDieEffect(clientHero)

end

function BattleSelectMapController:StopBattle()
    ClientConfigUtils.KillCoroutine(self._battleTweener)
    self.isGameOver = true
end

function BattleSelectMapController:OnShowBattle()
    self:InitListener()
    self:InitBattle()
    self:CreateBattle()
    self:RefreshBattle()
end

function BattleSelectMapController:OnHide()
    self:RemoveListener()
    self:StopBattle()
    self:ReturnPoolGameObjects()
    self:ResetFields()
    zg.battleMgr.previewHeroMgr:ClearPool()
end

--- @param baseHero BaseHero
function BattleSelectMapController:IncreaseBasicAttackCounter(baseHero)
    if self.basicAttackCounterDictionary:IsContainKey(baseHero) then
        local basicAttackCount = self.basicAttackCounterDictionary:Get(baseHero)
        self.basicAttackCounterDictionary:Add(baseHero, basicAttackCount + 1)
    else
        self.basicAttackCounterDictionary:Add(baseHero, 1)
    end
end

--- @param clientHero ClientHero
function BattleSelectMapController:DespawnHeroByClientHero(clientHero)
    if clientHero ~= nil then
        clientHero:ReturnPool()
        clientHero = nil
    end
end

function BattleSelectMapController:IsAvailableToNextTurn()
    return self.pendingClientAction:Count() == 0
            and self.isGameOver == false
            and self.isPerformActionResults == false
            and self.isPauseByPopup == false
end

--- @param isPauseByPopup boolean
function BattleSelectMapController:SetPauseByPopup(isPauseByPopup)
    if self.isPauseByPopup == isPauseByPopup then
        return
    end
    self.isPauseByPopup = isPauseByPopup
    if isPauseByPopup == false then
        self:ClientHeroFinishTurn()
    end
end

--- @param shakeTable table
--- table[1] duration
--- table[2] strengthX
--- table[3] strengthY
--- table[4] vibrato
--- table[5] randomness
function BattleSelectMapController:DoShake(shakeTable)

end

--- @param coverDuration number
--- @param fadeInDuration number
--- @param fadeOutDuration number
--- @param coverAlpha number
--- @param onEndFadeIn function
--- @param onEndFade function
function BattleSelectMapController:DoCoverBattle(coverDuration, fadeInDuration, fadeOutDuration, coverAlpha, onEndFadeIn, onEndFade)

end

function BattleSelectMapController:ReturnPoolGameObjects()
    ClientBattleShowController.ReturnPoolGameObjects(self)
    ClientConfigUtils.KillCoroutine(self.treasureCoroutine)
    if self.treasure ~= nil then
        if EventInBound.IsEventOpening(EventTimeType.EVENT_HALLOWEEN) then
            SmartPool.Instance:DespawnGameObject(AssetType.Battle, "treasure_halloween", self.treasure.transform)
        else
            SmartPool.Instance:DespawnGameObject(AssetType.Battle, "treasure", self.treasure.transform)
        end
        self.treasure = nil
        self.onClickLootTreasure = nil
    end
    if self.coinLoot ~= nil then
        SmartPool.Instance:DespawnGameObject(AssetType.Battle, "coin_loot", self.coinLoot.transform)
        self.coinLoot = nil
    end
end

--- @param timePercent number
function BattleSelectMapController:SetTreasureView(timePercent)
    local onSpawned = function()
        --- @type UnityEngine_Canvas
        local canvas = self.treasure:GetComponent(ComponentName.UnityEngine_Canvas)
        if self.battleView ~= nil then
            canvas.worldCamera = self.battleView:GetMainCamera()
        else
            canvas.worldCamera = U_Camera.main
        end
        self.treasure.transform.position = treasurePosition
        self.treasure:SetActive(true)
        --- @type UnityEngine_UI_Button
        local button = self.treasure:GetComponent(ComponentName.UnityEngine_UI_Button)
        button.onClick:RemoveAllListeners()
        button.onClick:AddListener(function()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            if self.onClickLootTreasure ~= nil then
                self.onClickLootTreasure()
            end
        end)
        --- @type Spine_Unity_SkeletonAnimation
        local animTreasure = self.treasure.transform:Find("anim"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
        local skinName = "default"
        if timePercent > 0.3 and timePercent < 0.7 then
            skinName = "coin_small"
        elseif timePercent >= 0.7 then
            skinName = "coin_big"
        end
        animTreasure.skeleton:SetSkin(skinName)
        animTreasure.skeleton:SetSlotsToSetupPose()

        animTreasure.AnimationState:SetAnimation(0, "fx", true)
        animTreasure.AnimationState:SetAnimation(1, "idle", true)
    end
    self:GetTreasureObject(onSpawned)
end

--- @param position UnityEngine_Vector3
function BattleSelectMapController:DropCoin(position)
    if self.coinLoot == nil then
        self.coinLoot = SmartPool.Instance:SpawnGameObject(AssetType.Battle, "coin_loot")
    end
    self.coinLoot.transform.position = position
    self.coinLoot:SetActive(true)
    local moveCoinBone = self.coinLoot.transform:Find("root/move_coin")
    moveCoinBone.position = treasurePosition + U_Vector3.up * 0.6

    --- @type Spine_Unity_SkeletonAnimation
    local skeletonAnimation = self.coinLoot:GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
    skeletonAnimation.AnimationState:ClearTracks()
    skeletonAnimation.skeleton:SetToSetupPose()

    local animName = "coin_" .. math.random(1, 3)
    local trackEntryCoin = skeletonAnimation.AnimationState:SetAnimation(0, animName, false)
    trackEntryCoin:AddCompleteListenerFromLua(function()
        if self.coinLoot ~= nil then
            SmartPool.Instance:DespawnGameObject(AssetType.Battle, "coin_loot", self.coinLoot.transform)
            self.coinLoot = nil
        end
    end)

    ClientConfigUtils.KillCoroutine(self.treasureCoroutine)
    self.treasureCoroutine = Coroutine.start(function()
        coroutine.yield(U_WaitForSeconds(40 / ClientConfigUtils.FPS))
        local onSpawned = function()
            --- @type Spine_Unity_SkeletonAnimation
            local treasureAnim = self.treasure.transform:Find("anim"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
            local trackEntryTreasure = treasureAnim.AnimationState:SetAnimation(1, "chest_start", false)
            trackEntryTreasure:AddCompleteListenerFromLua(function()
                treasureAnim.AnimationState:SetAnimation(1, "idle", true)
                ClientConfigUtils.KillCoroutine(self.treasureCoroutine)
            end)
            coroutine.yield(U_WaitForSeconds(4 / ClientConfigUtils.FPS))
            --- @type UnityEngine_ParticleSystem
            local fxStart = self.treasure.transform:Find("anim/bone_glow2/fx_start"):GetComponent(ComponentName.UnityEngine_ParticleSystem)
            fxStart:Play()
        end
        self:GetTreasureObject(onSpawned)
    end)
end

function BattleSelectMapController:GetTreasureObject(onFinish)
    if self.treasure == nil then
        local onSpawned = function(gameObject)
            self.treasure = gameObject
            self.treasure.transform:SetParent(zgUnity.transform)
            onFinish()
        end

        if EventInBound.IsEventOpening(EventTimeType.EVENT_LUNAR_NEW_YEAR_2022) then
            onSpawned(SmartPool.Instance:SpawnGameObject(AssetType.Battle, "treasure_lunar_new_year"))
            --SmartPool.Instance:SpawnGameObjectAsync(AssetType.Battle, "treasure", onSpawned)
        elseif EventInBound.IsEventOpening(EventTimeType.EVENT_HALLOWEEN) then
            onSpawned(SmartPool.Instance:SpawnGameObject(AssetType.Battle, "treasure_halloween"))
        elseif EventInBound.IsEventOpening(EventTimeType.EVENT_XMAS) then
            onSpawned(SmartPool.Instance:SpawnGameObject(AssetType.Battle, "treasure_xmas"))

        else
            onSpawned(SmartPool.Instance:SpawnGameObject(AssetType.Battle, "treasure"))
        end
    else
        onFinish()
    end
end

function BattleSelectMapController:GetTeamBossCount(teamId)
    if teamId == BattleConstants.DEFENDER_TEAM_ID then
        return 1
    else
        return 0
    end
end

function BattleSelectMapController:OnGainLootSuccess()
    ClientConfigUtils.KillCoroutine(self.treasureCoroutine)
    self.treasureCoroutine = Coroutine.start(function()
        local treasureAnim = self.treasure.transform:Find("anim"):GetComponent(ComponentName.Spine_Unity_SkeletonAnimation)
        treasureAnim.skeleton:SetSkin("default")
        local trackEntry = treasureAnim.AnimationState:SetAnimation(1, "chest_end", false)
        --- @type Spine_Unity_SkeletonAnimation
        trackEntry:AddCompleteListenerFromLua(function()
            treasureAnim.AnimationState:SetAnimation(1, "idle", true)
        end)
        zg.audioMgr:PlaySfxUi(SfxUiType.TREASURE_OPEN)
        coroutine.yield(U_WaitForSeconds(8 / ClientConfigUtils.FPS))
        --- @type UnityEngine_ParticleSystem
        local fxStart = self.treasure.transform:Find("anim/bone_glow2/fx_end"):GetComponent(ComponentName.UnityEngine_ParticleSystem)
        fxStart:Play()
    end)
end

--- @param prefabAnchorTopName string
--- @param prefabAnchorBotName string
function BattleSelectMapController:ShowBgAnchor(prefabAnchorTopName, prefabAnchorBotName)
    if self.battleView ~= nil then
        self.battleView:ShowBgAnchor(prefabAnchorTopName, prefabAnchorBotName)
        self.battleView:UpdateView()
    end
end