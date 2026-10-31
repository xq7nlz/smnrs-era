--- @class Hero10009_Skill3 Lashna
Hero10009_Skill3 = Class(Hero10009_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10009_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.healChance = 0

    --- @type number
    self.healAmount = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10009_Skill3:CreateInstance(id, hero)
    return Hero10009_Skill3(id, hero)
end

--- @return void
function Hero10009_Skill3:Init()
    self.healChance = self.data.healChance
    self.healAmount = self.data.healAmount

    self.myHero.attackListener:BindingWithSkill_3(self)
    self.myHero.skillListener:BindingWithSkill_3(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero10009_Skill3:OnTakeDamageFromEnemy(enemy, totalDamage)
    self:BuffHeal()
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero10009_Skill3:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    self:BuffHeal()
end

--- @return void
function Hero10009_Skill3:BuffHeal()
    if self.myHero.randomHelper:RandomRate(self.healChance) then
        local healAmount = self.healAmount * self.myHero.attack:GetValue()
        HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
    end
end

return Hero10009_Skill3