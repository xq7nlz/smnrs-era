---@class ClientHeroActionResultsHandler
ClientHeroActionResultsHandler = Class(ClientHeroActionResultsHandler)

--- @param clientHero ClientHero
function ClientHeroActionResultsHandler:Ctor(clientHero)
    self.clientHero = clientHero
    self.baseHero = clientHero.baseHero
    self.clientBattleShowController = zg.battleMgr.clientBattleShowController
end

--- @param actionResult BaseActionResult
--- @param clientActionType ClientActionType
function ClientHeroActionResultsHandler:HandleActionResult(actionResult, clientActionType)
    --- @type ActionResultType
    local actionResultType = actionResult.type
    --- @type BaseHero
    local _target = actionResult.target
    --- @type BaseHero
    local _initiator = actionResult.initiator
    --- @type boolean
    local _isTarget = _target == self.baseHero
    --- @type boolean
    local _isInitiator = _initiator == self.baseHero

    -- DAMAGE
    if ClientActionResultUtils.IsDamageActionType(actionResultType) then
        if _isTarget then
            local _damage = actionResult.damage
            local _isCrit = actionResult.isCrit
            local _dodgeType = actionResult.dodgeType
            local _isBlock = actionResult.isBlock

            if (clientActionType == ClientActionType.BASIC_ATTACK
                    or clientActionType == ClientActionType.USE_SKILL
                    or clientActionType == ClientActionType.COUNTER_ATTACK
                    or clientActionType == ClientActionType.BOUNCING_DAMAGE)
                    and actionResultType ~= ActionResultType.REFLECT_DAMAGE
                    and ClientActionResultUtils.IsDOT(actionResultType) == false
                    and _damage > 0 then
                self.clientHero:PlayGetHurtAnimation()
            end
            if actionResultType == ActionResultType.ATTACK
                    or actionResultType == ActionResultType.USE_ACTIVE_DAMAGE_SKILL
                    or actionResultType == ActionResultType.BONUS_ATTACK
                    or actionResultType == ActionResultType.BOUNCING_DAMAGE
                    or actionResultType == ActionResultType.COUNTER_ATTACK
                    or actionResultType == ActionResultType.REFLECT_DAMAGE then
                self.clientHero:LogDamageResult(actionResultType, _damage, _isCrit, _isBlock, _dodgeType)
            else
                self.clientHero:AddLogToStack(actionResultType, actionResult.damage)
            end

            if actionResultType == ActionResultType.BOND_SHARE_DAMAGE then
                self.clientHero:CreateDamageBondEffectShow(actionResult)
                self.clientHero:AddLogToStack(actionResultType, actionResult.damage)
            end
        end
    elseif actionResultType == ActionResultType.BOUNCING_DAMAGE then
        if _isTarget then
            --local _damage = actionResult.damage
            --local _isCrit = actionResult.isCrit
            --local _dodgeType = actionResult.dodgeType
            --local _isBlock = actionResult.isBlock
            self.clientHero:PlayGetHurtAnimation()
            self.clientHero:AddLogToStack(actionResultType, actionResult.damage)
            --self.clientHero:LogDamageResult(_actionResultType, _damage, _isCrit, _isBlock, _dodgeType)
        end
    elseif actionResultType == ActionResultType.CHANGE_POWER then
        -- DEAD_FOR_DISPLAY
    elseif actionResultType == ActionResultType.DEAD_FOR_DISPLAY then
        if _isTarget then
            self.clientHero:DeadForDisplay(actionResult)
        end
        -- DEAD
    elseif actionResultType == ActionResultType.DEAD then
        if _isTarget then
            self.clientHero:Dead(actionResult)
        end
        -- REGENERATE
    elseif actionResultType == ActionResultType.REGENERATE then
        if _isTarget then
            self.clientHero:Regenerate(actionResult, clientActionType)
        end
        -- HEAL_EFFECT
    elseif actionResultType == ActionResultType.HEAL_EFFECT then
        if _isTarget then
            local _healAmount = actionResult.healAmount
            self.clientHero:LogHealing(_healAmount)
        end
        -- FREEZE_BREAK
    elseif actionResultType == ActionResultType.FREEZE_BREAK then
        if _isTarget then
            self.clientHero:AddLogToStack(actionResultType, actionResult.damage)
        end
        -- BOND_SHARE_DAMAGE
    elseif actionResultType == ActionResultType.BOND_SHARE_DAMAGE then
        if _isTarget then
            self.clientHero:CreateDamageBondEffectShow(actionResult)
            self.clientHero:AddLogToStack(actionResultType, actionResult.damage)
            if actionResult.damage > 0 then
                self.clientHero:PlayGetHurtAnimation()
            end
        end
        -- SPLASH_DAMAGE
    elseif actionResultType == ActionResultType.SPLASH_DAMAGE then
        if _isTarget then
            self.clientHero:AddLogToStack(actionResultType, actionResult.damage)
            if actionResult.damage > 0 then
                self.clientHero:PlayGetHurtAnimation()
            end
        end
        -- BOND_EFFECT
    elseif actionResultType == ActionResultType.BOND_EFFECT then
        if _isInitiator and actionResult.remainingRound > 0 then
            local bondType = actionResult.bondType
            local _bondHeroList = List()
            for _, heroUniqueId in ipairs(actionResult.bondedHeroList) do
                _bondHeroList:Add(ClientBattleData.battle:GetHeroByUniqueId(heroUniqueId))
            end
            if bondType == BondType.AQUALORD
                    or bondType == BondType.SUMMONER_2 then
                for i = 1, _bondHeroList:Count() do
                    if _bondHeroList:Get(i) ~= self.baseHero then
                        local bondLink = self.clientBattleShowController:GetBondLink()
                        bondLink:MakeBond(self.clientHero, self.clientBattleShowController:GetClientHeroByBaseHero(_bondHeroList:Get(i)))
                    end
                end
            elseif bondType == BondType.SUMMONER_4 then
                local initiatorClient = self.clientBattleShowController:GetClientHeroByBaseHero(_bondHeroList:Get(1))
                for i = 2, _bondHeroList:Count() do
                    local bondLink = self.clientBattleShowController:GetBondLink()
                    bondLink:MakeBond(initiatorClient, self.clientBattleShowController:GetClientHeroByBaseHero(_bondHeroList:Get(i)))
                end
            else
                for i = 1, _bondHeroList:Count() - 1 do
                    local bondLink = self.clientBattleShowController:GetBondLink()
                    bondLink:MakeBond(self.clientBattleShowController:GetClientHeroByBaseHero(_bondHeroList:Get(i)),
                            self.clientBattleShowController:GetClientHeroByBaseHero(_bondHeroList:Get(i + 1)))
                end
                local bondLink = self.clientBattleShowController:GetBondLink()
                bondLink:MakeBond(self.clientBattleShowController:GetClientHeroByBaseHero(_bondHeroList:Get(_bondHeroList:Count())),
                        self.clientBattleShowController:GetClientHeroByBaseHero(_bondHeroList:Get(1)))
            end
        end
        -- RESIST_EFFECT
    elseif actionResultType == ActionResultType.RESIST_EFFECT then
        local battleTextLog = self.clientBattleShowController:GetUIBattleTextLog()
        if battleTextLog ~= nil then
            local clientInitiator = self.clientBattleShowController:GetClientHeroByBaseHero(_initiator)
            battleTextLog:LogResist(clientInitiator)
        end
        -- REVIVE
        -- REBORN
    elseif actionResultType == ActionResultType.REVIVE or actionResultType == ActionResultType.REBORN then
        if _isTarget then
            local isPermanent = false
            if _initiator.id == HeroConstants.ABYSS_NERO_ID then
                isPermanent = true
            end
            local _initiatorFaction = _initiator.originInfo.faction
            self.clientBattleShowController:AddPendingClientAction(self.clientHero, actionResult)
            self.clientHero.isPlayingDead = false
            self.clientHero:DoRebornOrReviveActionResult(actionResult, _initiatorFaction, isPermanent)
        end
        -- STEAL_STAT
    elseif actionResultType == ActionResultType.STEAL_STAT then
        self.clientBattleShowController:ShowAddOrStealStatEffect(actionResultType, _initiator, _target, actionResult.statType, function()
            if actionResult.statType == StatType.HP then
                self.clientBattleShowController:ShowHealingEffect(self.clientBattleShowController:GetClientHeroByBaseHero(_initiator))
            else
                local impactEffect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, "absorb_add_or_steal_" .. actionResult.statType)
                if impactEffect ~= nil then
                    local clientHero = self.clientBattleShowController:GetClientHeroByBaseHero(_initiator)
                    impactEffect:SetToHeroAnchor(clientHero)
                end
            end
        end)
        -- ADD_STOLEN_STAT
    elseif actionResultType == ActionResultType.ADD_STOLEN_STAT then
        if _target ~= _initiator then
            self.clientBattleShowController:ShowAddOrStealStatEffect(actionResultType, _initiator, _target, actionResult.statType, function()
                if actionResult.statType == StatType.HP then
                    self.clientBattleShowController:ShowHealingEffect(self.clientHero)
                end
            end)
        end
        -- INSTANT_KILL = 502
    elseif actionResultType == ActionResultType.INSTANT_KILL then
        if _isTarget then
            self.clientHero:Dead(actionResult)

            local battleTextLog = self.clientBattleShowController:GetUIBattleTextLog()
            if battleTextLog ~= nil then
                battleTextLog:LogExecute(self.clientHero)
            end
            local instantKillEffect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, "instant_skill_effect")
            instantKillEffect:SetToHeroAnchor(self.clientHero)
        end
        -- MAGIC_SHIELD
    elseif actionResultType == ActionResultType.MAGIC_SHIELD then
        if _isInitiator then
            local battleTextLog = self.clientBattleShowController:GetUIBattleTextLog()
            if battleTextLog ~= nil then
                battleTextLog:LogBlock(self.clientHero, -0.5)
            end
            local shieldBlockEffect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, "shield_block")
            shieldBlockEffect:SetToHeroAnchor(self.clientHero)
        end
        -- TRIGGER_SUB_ACTIVE
    elseif actionResultType == ActionResultType.TRIGGER_SUB_ACTIVE then
        if _isInitiator then
            self.clientHero:TriggerSubActiveSkill(actionResult)
        end
        -- DRYAD_EFFECT
    elseif actionResultType == ActionResultType.DRYAD_EFFECT then
        --if _isInitiator then
        --    self.clientHero:TriggerSubActiveSkill(actionResult)
        --end
    elseif actionResultType == ActionResultType.DROWNING_MARK then
        self.clientHero.clientHeroEffectMgr.effectOnMarBarMgr:UpdateEffectByAction(EffectLogType.DROWNING_MARK, actionResult)
    elseif actionResultType == ActionResultType.TRANSFORM then
        self.clientHero:OnTransform(actionResult)
    elseif actionResultType == ActionResultType.DIVINE_SHIELD then
        --- @type DivineEffectResult
        local divineEffectResult = actionResult
        self.clientHero:LogDamageResult(actionResultType, divineEffectResult.damage, false, false, DodgeType.NO_DODGE)
    elseif actionResultType == ActionResultType.TRANSFER_STAT then
        local clientInitiator = self.clientBattleShowController:GetClientHeroByBaseHero(_initiator)
        local target = self.clientBattleShowController:GetClientHeroByBaseHero(_target)
        clientInitiator:OnTransferStat(target)
    elseif actionResultType == ActionResultType.TALENT_INSTANT_KILL then
        if _isTarget then
            self.clientHero:Dead(actionResult)
            local battleTextLog = self.clientBattleShowController:GetUIBattleTextLog()
            if battleTextLog ~= nil then
                battleTextLog:LogExecute(self.clientHero)
            end
            local instantKillEffect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, "effect_type_563_instant_kill")
            instantKillEffect:SetToHeroAnchor(self.clientHero)
        end
    elseif actionResultType == ActionResultType.RESIST_INSTANT_KILL then
        local battleTextLog = self.clientBattleShowController:GetUIBattleTextLog()
        if battleTextLog ~= nil then
            local clientInitiator = self.clientBattleShowController:GetClientHeroByBaseHero(_initiator)
            if battleTextLog ~= nil then
                battleTextLog:LogResistInstantKill(clientInitiator)
            end
            local blockInstantKillEffect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, "effect_type_564_resistant_instant_kill")
            blockInstantKillEffect:SetToHeroAnchor(self.clientHero)
        end
    elseif actionResultType == ActionResultType.CHANGE_LESS_POWER then
        local powerLessEffect = self.clientBattleShowController:GetClientEffect(AssetType.GeneralBattleEffect, "effect_type_569_competitor")
        powerLessEffect:SetToHeroAnchor(self.clientHero)
    else
        assert(false, "Missing ActionResultType Handler " .. actionResultType)
    end
end

return ClientHeroActionResultsHandler