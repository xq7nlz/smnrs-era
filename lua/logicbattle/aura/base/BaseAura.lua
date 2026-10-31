--- @class BaseAura
BaseAura = Class(BaseAura)

--- @return void
--- @param initiator BaseHero
--- @param skill BaseSkill
--- @param isBuff boolean
function BaseAura:Ctor(initiator, skill, isBuff)
    --- @type BaseHero
    self.initiator = initiator

    --- @type BaseSkill
    self.skill = skill

    --- @type boolean
    self.isBuff = isBuff

    --- @type List<BaseHero>
    self.targetList = nil

    --- @type number
    self.targetTeamType = nil

    --- @type Dictionary<BaseHero, List<BaseEffect>>
    self.effects = Dictionary()

    --- @type AuraState
    self.auraState = AuraState.STOP

    --- @type EventListener
    self.heroReviveListener = EventListener(self.initiator, self, self.OnOtherHeroRevive)

    --- @type EventListener
    self.heroDeadListener = EventListener(self.initiator, self, self.OnOtherHeroDead)
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param targetList List<BaseHero>
--- @param targetTeamType TargetTeamType
function BaseAura:SetTarget(targetList, targetTeamType)
    --- @type BaseHero
    self.targetList = targetList

    --- @type number
    self.targetTeamType = targetTeamType
end

--- @return void
--- @param hero BaseHero
--- @param effect BaseEffect
function BaseAura:AddEffect(hero, effect)
    local effectsByHero = self.effects:Get(hero)
    if effectsByHero == nil then
        effectsByHero = List()
        self.effects:Add(hero, effectsByHero)
    end

    effectsByHero:Add(effect)
end

--- @return void
function BaseAura:ClearEffect(hero, effect)
    self.effects:Clear()
end

--- @return void
function BaseAura:_AddEffectToHero()
    for i = 1, self.targetList:Count() do
        local target = self.targetList:Get(i)
        local effectsByHero = self.effects:Get(target)

        if effectsByHero ~= nil then
            target.effectController:AddMultipleEffects(effectsByHero)
        end
    end

    self.initiator.battle.eventManager:AddListener(EventType.HERO_REVIVE, self.heroReviveListener)
    self.initiator.battle.eventManager:AddListener(EventType.HERO_DEAD, self.heroDeadListener)
end

--- @return void
function BaseAura:_RemoveEffectFromHero()
    for i = 1, self.targetList:Count() do
        local target = self.targetList:Get(i)
        local effectsByHero = self.effects:Get(target)

        if effectsByHero ~= nil then
            target.effectController:RemoveAuraEffects(effectsByHero)
        end
    end

    self.initiator.battle.eventManager:RemoveListener(EventType.HERO_REVIVE, self.heroReviveListener)
    self.initiator.battle.eventManager:RemoveListener(EventType.HERO_DEAD, self.heroDeadListener)
end

---------------------------------------- Getters ----------------------------------------
--- @return boolean
--- @param hero BaseHero
function BaseAura:CanBeAffected(hero)
    if self.targetTeamType == TargetTeamType.ENEMY then
        return not hero:IsAlly(self.initiator)
    elseif self.targetTeamType == TargetTeamType.ALLY then
        return hero:IsAlly(self.initiator)
    else
        return true
    end
end

--- @return boolean
function BaseAura:IsInitiatorDead()
    return self.initiator:IsDead()
end

--- @return number
--- @param aura BaseAura
--- Positive: self > aura, 0: self == aura, Negative: self < aura
function BaseAura:Compare(aura)
    if self.targetList:Count() > aura.targetList:Count() then
        return 1
    elseif self.targetList:Count() < aura.targetList:Count() then
        return -1
    end

    return self.skill.skillLevel - aura.skill.skillLevel
end

--- @return AuraState
function BaseAura:GetState()
    return self.auraState
end

---------------------------------------- Manage ----------------------------------------
--- @return void
function BaseAura:Start()
    if self.auraState ~= AuraState.RUNNING then
        self.auraState = AuraState.RUNNING

        self:_AddEffectToHero()
    end
end

--- @return void
function BaseAura:Stop()
    if self.auraState ~= AuraState.STOP then
        self.auraState = AuraState.STOP

        self:_RemoveEffectFromHero()
    end
end

--- @return void
function BaseAura:StopByStrongerAura()
    if self.auraState ~= AuraState.STOP_BY_STRONGER_AURA then
        self.auraState = AuraState.STOP_BY_STRONGER_AURA

        self:_RemoveEffectFromHero()
    end
end

--- @return void
function BaseAura:Recalculate()
    if self.effects:Count() > 0 then
        for _, effectList in pairs(self.effects:GetItems()) do
            for i = 1, effectList:Count() do
                ---@type BaseEffect
                local effect = effectList:Get(i)
                effect:Recalculate()
            end
        end
    end
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param eventData table
function BaseAura:OnOtherHeroRevive(eventData)
    if self.auraState == AuraState.RUNNING then
        local hero = eventData.target
        if self:CanBeAffected(hero) and hero ~= self.initiator then
            ---@type BaseEffect
            local effectsByHero = self.effects:Get(hero)
            if effectsByHero ~= nil then
                hero.effectController:AddMultipleEffects(effectsByHero)
            end
        end
    end
end

--- @return void
--- @param eventData table
function BaseAura:OnOtherHeroDead(eventData)
    if self.auraState == AuraState.RUNNING then
        local hero = eventData.target
        if self:CanBeAffected(hero) and hero ~= self.initiator then
            ---@type BaseEffect
            local effectsByHero = self.effects:Get(hero)
            if effectsByHero ~= nil then
                hero.effectController:RemoveAuraEffects(effectsByHero)
            end
        end
    end
end

--- @return string
function BaseAura:GetAuraTag()
    return self.initiator.id .. self.initiator.teamId .. self.skill.id
end