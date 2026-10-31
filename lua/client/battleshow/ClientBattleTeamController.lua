---@class ClientBattleTeamController
ClientBattleTeamController = Class(ClientBattleTeamController)

function ClientBattleTeamController:Ctor(clientBattleShowController)
    --- @type number
    self.formationId = 0
    self.teamId = 0
    self.companionId = 0

    --- @type ClientBattleShowController
    self.clientBattleShowController = clientBattleShowController

    --- @type Dictionary<BaseHero, ClientHero>
    self.heroDictionary = Dictionary()

    --- @type table<BaseHero, ClientHero>
    self.heroTeamTable = {}

    --- @type boolean
    self.isEnableDivineShield = false

    --- @type Dictionary<EffectLogType, ClientEffect>
    self.teamEffectDict = Dictionary()

    --- @type BaseHero
    self.summoner = nil

    self.totalBlockDamageByDivine = 0
end

--- @param clientTeamDetail ClientTeamDetail
--- @param teamId number
function ClientBattleTeamController:Init(teamId, clientTeamDetail)
    self.formationId = clientTeamDetail.formationId
    self.teamId = teamId

    if clientTeamDetail.companionBuffId ~= nil then
        self.companionId = clientTeamDetail.companionBuffId
    end
end

--- @param baseHero BaseHero
function ClientBattleTeamController:AddHero(baseHero, clientHero)
    self.heroDictionary:Add(baseHero, clientHero)
    if baseHero.isSummoner == true and baseHero.isDummy == false then
        self.summoner = baseHero
    end
end

--- @return void
function ClientBattleTeamController:TriggerActivelyActionResult()
    self.clientBattleShowController:TriggerActivelyActionResult()
end

function ClientBattleTeamController:DoCounterAttackAction(counterAttackResult, baseHero)
    for _baseHero, _hero in pairs(self.heroTeamTable) do
        if _baseHero == baseHero then
            _hero:DoCounterAttackAction(counterAttackResult)
        end
    end
end

function ClientBattleTeamController:DoCounterAttackStatus(counterAttackResult, baseHero)
    for _baseHero, _hero in pairs(self.heroTeamTable) do
        if _baseHero == baseHero then
            _hero:DoCounterAttackStatus(counterAttackResult)
        end
    end
end

--- @param effectLogType EffectLogType
--- @param clientEffectDetail ClientEffectDetail
function ClientBattleTeamController:UpdateTeamEffect(effectLogType, clientEffectDetail)
    if clientEffectDetail.buff > 0 or clientEffectDetail.debuff > 0 then
        self:EnableTeamEffect(effectLogType)
    else
        self:DisableTeamEffect(effectLogType)
    end
end

function ClientBattleTeamController:ClearTeamTotalActionResultType()
    for _baseHero, _hero in pairs(self.heroTeamTable) do
        _hero:ClearTotalActionResultType()
    end
end

function ClientBattleTeamController:LogTeamViewAllActionResultType()
    for _baseHero, _hero in pairs(self.heroTeamTable) do
        _hero:LogViewAllActionResultType()
    end
end

function ClientBattleTeamController:GetTeamBossCount()
    local count = 0
    --- @param baseHero BaseHero
    for baseHero, _ in pairs(self.heroDictionary:GetItems()) do
        if baseHero.isBoss == true then
            count = count + 1
        end
    end
    return count
end

function ClientBattleTeamController:GetTeamCount()
    return self.heroDictionary:Count()
end

--- @return number
function ClientBattleTeamController:GetDamageDealAtKeyTurn(key)
    local total = 0
    local heroStatisticsDict = ClientBattleData.battleResult.heroStatisticsDict
    --- @param baseHero BaseHero
    --- @param heroStatistics HeroStatistics
    for _, heroStatistics in pairs(heroStatisticsDict) do
        if heroStatistics.teamId == BattleConstants.ATTACKER_TEAM_ID then
            local damageDealHistory = heroStatistics.damageDealHistory1
            if damageDealHistory[tostring(key)] ~= nil then
                total = total + damageDealHistory[tostring(key)]
            end
        end
    end
    return total
end

--- @param actionResultType ActionResultType
--- @param baseActionResult BaseActionResult
function ClientBattleTeamController:DoTeamAction(actionResultType, baseActionResult)
    if actionResultType == ActionResultType.DIVINE_SHIELD then
        --- @type DivineShieldResult
        local divineEffectResult = baseActionResult
        local remainingRound = baseActionResult.remainingRound
        if remainingRound < 0 then
            self:DisableTeamEffect(EffectLogType.DIVINE_SHIELD, baseActionResult.initiator)
        else
            self:EnableTeamEffect(EffectLogType.DIVINE_SHIELD)
        end
        if divineEffectResult.damage > 0 then
            self.totalBlockDamageByDivine = self.totalBlockDamageByDivine + divineEffectResult.damage
        end
    end
end

--- @param effectLogType EffectLogType
function ClientBattleTeamController:EnableTeamEffect(effectLogType)
    --- @type ClientEffect
    local clientEffect = self.teamEffectDict:Get(effectLogType)
    if clientEffect == nil then
        clientEffect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, "effect_type_" .. effectLogType)

        clientEffect:SetPosition(U_Vector3.zero)
        clientEffect:LookAtPosition(PositionConfig.GetOpponentCenterTeamPosition(self.teamId))

        clientEffect:Play()

        self.teamEffectDict:Add(effectLogType, clientEffect)
    end
end

--- @param effectLogType EffectLogType
--- @param initiator BaseHero
function ClientBattleTeamController:DisableTeamEffect(effectLogType,initiator)
    --- @type ClientEffect
    local clientEffect = self.teamEffectDict:Get(effectLogType)
    local clientHero = self.heroDictionary:Get(initiator)
    if clientEffect ~= nil then
        clientEffect:Release()
        self.teamEffectDict:RemoveByKey(effectLogType)
    end
    if effectLogType == EffectLogType.DIVINE_SHIELD then
        local effectName = "effect_type_" .. effectLogType .. "_broke"
        if clientHero.skinId ~= -1 then
            effectName = effectName .. "_"..clientHero.skinId
        end
        print("effectName",effectName)
        local clientEffect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, effectName)
        clientEffect:SetPosition(U_Vector3.zero)
        clientEffect:LookAtPosition(PositionConfig.GetOpponentCenterTeamPosition(self.teamId))
        clientEffect:Play()
    end
end

function ClientBattleTeamController:LogAllDamageFromStack()
    if self.totalBlockDamageByDivine > 0 then
        local battleTextLog = self.clientBattleShowController:GetUIBattleTextLog()
        if battleTextLog ~= nil then
            battleTextLog:LogDamageAtPosition(PositionConfig.GetDivineShieldTeamPosition(self.teamId), self.totalBlockDamageByDivine)
        end
        self.totalBlockDamageByDivine = 0
    end
end