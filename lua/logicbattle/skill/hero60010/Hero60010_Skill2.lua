--- @class Hero60010_Skill2 Diadora
Hero60010_Skill2 = Class(Hero60010_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60010_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.enemyTargetSelector = nil

    --- @type number
    self.effectChance = 0

    --- @type EffectType
    self.effectType = nil

    --- @type number
    self.effectDuration = 0

    --- @param List<BaseHero>
    self.allyCanRebuff = List()

end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60010_Skill2:CreateInstance(id, hero)
    return Hero60010_Skill2(id, hero)
end

--- @return void
function Hero60010_Skill2:Init()
    self.myHero.effectController:BindingWithSkill_2(self)
    self.myHero.battleListener:BindingWithSkill_2(self)
    self.myHero.hp:BindingWithSkill_2(self)

    self.effectChance = self.data.effectChance

    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration

    self.enemyTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
end

-----------------------------------BATTLE---------------------------------

--- @return void
--- @param round BattleRound
function Hero60010_Skill2:OnStartBattleRound(round)
    self.allyCanRebuff:Clear()
end

--- @return void
--- @param effect BaseEffect
function Hero60010_Skill2:AddEffect(effect)
    if effect.persistentType ~= EffectPersistentType.NON_PERSISTENT and
            effect.persistentType ~= EffectPersistentType.NON_PERSISTENT_NOT_DISPELLABLE then
        return
    end

    if self.myHero:IsAlly(effect.initiator) == false then
        return
    end

    if effect.isBuff == false then
        return
    end

    if effect.initiator.id < HeroConstants.FACTION_HERO_ID_DELTA then
        return
    end

    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local enemyTarget = self.enemyTargetSelector:SelectTarget(self.myHero.battle)

        local i = 1
        while i <= enemyTarget:Count() do
            local target = enemyTarget:Get(i)
            EffectUtils.CreateCurseEffect(self.myHero, target, self.effectType, self.effectDuration)

            i = i + 1
        end
    end
end

--- @return void
--- @param initiator BaseHero
--- @param reason HealReason
--- @param healAmount number
function Hero60010_Skill2:OnHeal(initiator, reason, healAmount)
    if reason == HealReason.HEAL_SKILL then
        if self.myHero.randomHelper:RandomRate(self.data.effectChance) then
            HealUtils.Heal(self.myHero, initiator, healAmount, HealReason.DIADORA_HEAL_SKILL)
        end
    end
end

return Hero60010_Skill2