--- @class Hero60004_Skill2 Karos
Hero60004_Skill2 = Class(Hero60004_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60004_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type EffectType
    self.effectType = nil

    --- @type number
    self.effectChance = 0

    --- @type number
    self.effectDuration = 0

    --- @type number
    self.effectAmount = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60004_Skill2:CreateInstance(id, hero)
    return Hero60004_Skill2(id, hero)
end

--- @return void
function Hero60004_Skill2:Init()
    self.effectType = self.data.effectType
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration
    self.effectAmount = self.data.effectAmount

    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.myHero.attackController:SetSelector(targetSelector)
    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.skillListener:BindingWithSkill_2(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero60004_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if enemyDefender.effectController:IsContainEffectType(self.effectType) == true then
            local healAmount = self.myHero.attack:GetValue() * self.effectAmount
            HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
        end

        if self.myHero.randomHelper:RandomRate(self.effectChance) then
            local darkMark = DarkMark(self.myHero, enemyDefender)
            darkMark:SetDuration(self.effectDuration)

            enemyDefender.effectController:AddEffect(darkMark)
        end
    end
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero60004_Skill2:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if enemyTarget.effectController:IsContainEffectType(self.effectType) == true then
        local healAmount = self.myHero.attack:GetValue() * self.effectAmount
        HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
    end
end

return Hero60004_Skill2