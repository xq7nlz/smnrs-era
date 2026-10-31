require "lua.client.battleShow.Others.BattleRewardChest"

--- @class XmasDamageView
XmasDamageView = Class(XmasDamageView)

function XmasDamageView:Ctor(anchor)
    --- @type XmasDamageViewConfig
    self.config = UIBaseConfig(anchor)
    --- @type UIBarPercentView
    self.barPercent = UIBarPercentView(self.config.barPercent)
    --- @type number
    self.nextMilestone = 1
    --- @type number
    self.milestoneDamage = 0
    --- @type List
    self.countTurnKey = List()
    --- @type number
    self.totalDamageDeal = 0

    --- @type List
    self.listChest = nil
end

function XmasDamageView:Init()
    self.nextMilestone = 1
end

function XmasDamageView:OnShow()
    self:GetData()
end

function XmasDamageView:DoTrackingDamageProgress()
    self:SetNextMilestone(1)
    self.finishTurnListener = RxMgr.finishTurn:Subscribe(RxMgr.CreateFunction(self, self.OnFinishedTurn))
    self.totalDamageDeal = 0
    self.listChest = List()
    self.countTurnKey = List()
    self.isClearAllMilestone = false
    self:UpdateUi()
end

function XmasDamageView:SetNextMilestone(nextMilestone)
    if (self.listBossDamageRewardConfig == nil) then
        XDebug.LogError("self.listBossDamageRewardConfig nil")
    end
    if nextMilestone > self.listBossDamageRewardConfig:Count() then
        self.isClearAllMilestone = true
        return
    end
    DOTweenUtils.DOScale(self.config.imgBox.transform, U_Vector3.one * 1.15, 0.15, nil, nil, 2)
    self.nextMilestone = nextMilestone
    local bossDamageMilestoneConfig = self.listBossDamageRewardConfig:Get(nextMilestone)
    if bossDamageMilestoneConfig == nil then
        XDebug.Error("No bossDamageMilestoneConfig milestone " .. nextMilestone)
        return
    end
    -- XDebug.Log("assign damage " .. tostring(bossDamageMilestoneConfig.damage) .. "nextMilestone" .. tostring(nextMilestone) .. " count " .. tostring(self.listBossDamageRewardConfig:Count()))

    self.milestoneDamage = bossDamageMilestoneConfig.damage
end

function XmasDamageView:OnHide()
    if self.finishTurnListener ~= nil then
        self.finishTurnListener:Unsubscribe()
        self.finishTurnListener = nil
    end
end

function XmasDamageView:OnFinishedTurn()
    self:CalculateDefenderDamageTaken()
    if self.totalDamageDeal > self.milestoneDamage
            and self.isClearAllMilestone == false then
        self:OnReachMilestone()
    end
    self:UpdateUi()
end

function XmasDamageView:UpdateUi()
    self:ShowDamage()
    self:ShowRewardBox()
end

function XmasDamageView:OnReachMilestone()
    local nextMilestone = self.nextMilestone + 1
    self:SpawnChest()
    self:SetNextMilestone(nextMilestone)
end

function XmasDamageView:CalculateDefenderDamageTaken()
    local serverRound = zg.battleMgr.clientBattleShowController.roundNum
    local serverTurn = zg.battleMgr.clientBattleShowController.serverTurnNum
    local key = serverRound * 1000 + serverTurn
    if self.countTurnKey:IsContainValue(key) then
        return
    end
    self.countTurnKey:Add(key)
    local damageDeal = zg.battleMgr.clientBattleShowController.attackerTeamCtrl:GetDamageDealAtKeyTurn(key)
    self.totalDamageDeal = self.totalDamageDeal + damageDeal
end

function XmasDamageView:ShowRewardBox()
    self.config.imgBox.sprite = ResourceLoadUtils.LoadChestIcon(self:GetChestIdByIndex(self.nextMilestone))
    self.config.imgBox:SetNativeSize()
end

function XmasDamageView:ShowDamage()
    if (self.milestoneDamage == nil) then
        XDebug.Error("ERROR milestoneDamage nil")
    end
    local percent = self.totalDamageDeal / self.milestoneDamage
    self.barPercent:SetValue(percent)
    self.barPercent:SetText(string.format("%s/%s", math.floor(self.totalDamageDeal), self.milestoneDamage))
end

function XmasDamageView:GetChestIdByIndex(index)
    if index == 1 then
        return 1
    elseif index == 2 then
        return 4
    elseif index == 3 then
        return 7
    elseif index == 4 then
        return 8
    elseif index == 5 then
        return 9
    end
    return 9
end

function XmasDamageView:GetData()
    local gameMode = ClientBattleData.battleResult.gameMode
    self.listBossDamageRewardConfig = List()
    if gameMode == GameMode.EVENT_CHRISTMAS then
        --- @type EventXmasModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_XMAS)
        ---@tupe EventXmasConfig
        local eventConfig = eventModel:GetConfig()
        --self.listBossDamageRewardConfig = eventConfig:GetListExchangeConfig()
        self.listBossDamageRewardConfig = eventConfig:GetListIgnatiusConfig()
        --XDebug.Log("GET self.listBossDamageRewardConfig" .. self.listBossDamageRewardConfig:Count())
    elseif gameMode == GameMode.EVENT_VALENTINE_BOSS then
        --- @type EventValentineModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_VALENTINE)
        local eventConfig = eventModel:GetConfig():GetBossChallengeConfig()
        self.listBossDamageRewardConfig = eventConfig.listBossDamageRewardConfig
    elseif gameMode == GameMode.EVENT_KAZETSU_BOSS then
        --- @type EventKazetsuModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
        local eventConfig = eventModel:GetConfig():GetBossChallengeConfig()
        self.listBossDamageRewardConfig = eventConfig.listBossDamageRewardConfig
    elseif gameMode == GameMode.EVENT_FINDE_BOSS then
        --- @type EventFindeBossModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_FINDE_BOSS)
        local eventConfig = eventModel:GetConfig()
        self.listBossDamageRewardConfig = eventConfig.listBossDamageRewardConfig
    elseif gameMode == GameMode.EVENT_SEASONAL_ROYAL_CHALLENGE then
        --- @type EventSeasonalModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SEASONAL)
        local eventConfig = eventModel:GetConfig()
        self.listBossDamageRewardConfig = eventConfig:GetBossDamageRewardConfig()
    elseif gameMode == GameMode.EVENT_BIRTHDAY_BOSS then
        --- @type EventBirthdayModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
        local eventConfig = eventModel:GetConfig().bossConfig
        self.listBossDamageRewardConfig = eventConfig.listBossDamageRewardConfig
    end
end

function XmasDamageView:SpawnChest()
    --- @type BattleRewardChest
    local battleRewardChest = SmartPool.Instance:SpawnGameObject(AssetType.Battle, "battle_reward_chest")
    battleRewardChest = BattleRewardChest(battleRewardChest)
    self.listChest:Add(battleRewardChest)
    local pos, fall = self:GetChestPos()
    battleRewardChest:OnShow(pos, fall, self.flyPos, function()
        SmartPool.Instance:DespawnGameObject(AssetType.Battle, "battle_reward_chest", battleRewardChest.config.transform)
        self.listChest:RemoveByReference(battleRewardChest)
    end)
end

function XmasDamageView:GetChestPos()
    local clientBattleShowController = zg.battleMgr.clientBattleShowController
    --- @type Dictionary
    local heroDict = clientBattleShowController.defenderTeamCtrl.heroDictionary
    local listHero = List()
    --- @param v ClientHero
    for _, v in pairs(heroDict:GetItems()) do
        if v:IsDummy() == false then
            listHero:Add(v)
        end
    end
    --- @type ClientHero
    local clientHero = listHero:Get(math.random(1, listHero:Count()))
    local pos = clientHero.components:GetAnchorPosition(ClientConfigUtils.FOOT_ANCHOR)
    local fall = pos + U_Vector3(math.random(-3, 2), math.random(-2, -1), 0)

    if self.flyPos == nil then
        local worldPosition = uiCanvas.camUI:WorldToScreenPoint(self.config.imgBox.transform.position)
        self.flyPos = clientBattleShowController.battleView:ScreenToWorldPoint(worldPosition)
    end

    return pos, fall
end

function XmasDamageView:ReleaseChest()
    for i = 1, self.listChest:Count() do
        --- @type BattleRewardChest
        local chest = self.listChest:Get(i)
        chest:OnHide()
        SmartPool.Instance:DespawnGameObject(AssetType.Battle, "battle_reward_chest", chest.config.transform)
    end
    self.listChest:Clear()
end