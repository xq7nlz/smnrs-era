--- @class Hero50001_Skill3 AmiableAngel
Hero50001_Skill3 = Class(Hero50001_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50001_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.damagePercentToHeal = nil

    --- @type BaseTargetSelector
    self.targetSelector = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50001_Skill3:CreateInstance(id, hero)
    return Hero50001_Skill3(id, hero)
end

--- @return void
function Hero50001_Skill3:Init()
    self.damagePercentToHeal = self.data.damagePercentToHeal

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    self.myHero.attackListener:BindingWithSkill_3(self)
    self.myHero.skillListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero50001_Skill3:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if enemyAttacker.effectController:IsContainEffectType(EffectType.WEAKNESS_POINT) then
        self:TriggerSkill(totalDamage)
    end
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero50001_Skill3:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if enemy.effectController:IsContainEffectType(EffectType.WEAKNESS_POINT) then
        self:TriggerSkill(totalDamage)
    end
end

--- @return void
--- @param totalDamage number
function Hero50001_Skill3:TriggerSkill(totalDamage)
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)

    local healAmount = self.damagePercentToHeal * totalDamage
    local isHealSelf = false

    local i = 1
    while i <= targetList:Count() do
        local target = targetList:Get(i)
        if target == self.myHero then
            isHealSelf = true
        end

        HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)
        i = i + 1
    end

    if isHealSelf == false then
        HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
    end
end

return Hero50001_Skill3