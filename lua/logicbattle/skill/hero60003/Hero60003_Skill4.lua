--- @class Hero60003_Skill4 ShadowBlade
Hero60003_Skill4 = Class(Hero60003_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60003_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.healthTrigger = 0

    --- @type number
    self.healChance = 0

    --- @type number
    self.healAmount = 0

end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60003_Skill4:CreateInstance(id, hero)
    return Hero60003_Skill4(id, hero)
end

--- @return void
function Hero60003_Skill4:Init()
    self.healthTrigger = self.data.healthTrigger
    self.healChance = self.data.healChance
    self.healAmount = self.data.healAmount

    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero60003_Skill4:OnDealCritDamage(enemyDefender, totalDamage)
    self:TriggerHeal(enemyDefender, totalDamage)
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero60003_Skill4:OnDealCritDamage(enemyTarget, totalDamage)
    self:TriggerHeal(enemyTarget, totalDamage)
end

--- @return void
--- @param target BaseHero
--- @param totalDamage number
function Hero60003_Skill4:TriggerHeal(target, totalDamage)
    if self.myHero.hp:GetStatPercent() < self.healthTrigger and self.myHero.randomHelper:RandomRate(self.healChance) then
        local healAmount = self.healAmount * totalDamage
        HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
    end
end

return Hero60003_Skill4