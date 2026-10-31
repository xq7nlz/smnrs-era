--- @class Hero50001_Skill2 AmiableAngel
Hero50001_Skill2 = Class(Hero50001_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50001_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.enemyTargetSelector = nil
    --- @type BaseTargetSelector
    self.allyTargetSelector = nil

    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.effectDuration = nil

    --- @type number
    self.bonusDamage = nil
    --- @type number
    self.hpPercentToHeal = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50001_Skill2:CreateInstance(id, hero)
    return Hero50001_Skill2(id, hero)
end

--- @return void
function Hero50001_Skill2:Init()
    self.enemyTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.enemyTargetPosition,
            TargetTeamType.ENEMY, self.data.enemyTargetNumber)

    self.allyTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.allyTargetPosition,
            TargetTeamType.ALLY, self.data.allyTargetNumber)

    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration

    self.bonusDamage = self.data.bonusDamage
    self.hpPercentToHeal = self.data.hpPercentToHeal

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.skillListener:BindingWithSkill_2(self)
    self.myHero.battleListener:BindingWithSkill_2(self)

    self.myHero.battleHelper:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param round BattleRound
function Hero50001_Skill2:OnStartBattleRound(round)
    if self.myHero:IsDead() == false then
        local targetList = self.enemyTargetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)

            local weaknessPoint = WeaknessPoint(self.myHero, target)
            weaknessPoint:SetDuration(self.effectDuration)
            target.effectController:AddEffect(weaknessPoint)
            i = i + 1
        end
    end
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50001_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if enemyDefender.effectController:IsContainEffectType(EffectType.WEAKNESS_POINT) then
        self:TriggerSkill()
    end
end

--- @return void
--- @param enemyTarget BaseHero
function Hero50001_Skill2:OnDealSkillDamageToEnemy(enemyTarget)
    if enemyTarget.effectController:IsContainEffectType(EffectType.WEAKNESS_POINT) then
        self:TriggerSkill()
    end
end

--- @return void
function Hero50001_Skill2:TriggerSkill()
    local targetList = self.allyTargetSelector:SelectTarget(self.myHero.battle)

    local healAmount = self.hpPercentToHeal * self.myHero.attack:GetValue()

    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)

        i = i + 1
    end
end

--- @return number damage
--- @param target BaseHero
--- @param originMulti number
function Hero50001_Skill2:GetMultiplierDamage(target, originMulti)
    if target.effectController:IsContainEffectType(EffectType.WEAKNESS_POINT) then
        originMulti = originMulti * (1 + self.bonusDamage)
    end

    return originMulti
end

return Hero50001_Skill2