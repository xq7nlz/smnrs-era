--- @class Hero20011_Skill4 Labord
Hero20011_Skill4 = Class(Hero20011_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20011_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.healChance = nil

    --- @type number
    self.healAmount = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20011_Skill4:CreateInstance(id, hero)
    return Hero20011_Skill4(id, hero)
end

--- @return void
function Hero20011_Skill4:Init()
    self.healChance = self.data.healChance
    self.healAmount = self.data.healAmount

    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero20011_Skill4:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    self:InflictEffect(enemyAttacker)
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero20011_Skill4:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    self:InflictEffect(enemy)
end

--- @return void
function Hero20011_Skill4:InflictEffect()
    --- check can inflict effect
    if self.myHero.randomHelper:RandomRate(self.healChance) then
        local healAmount = self.myHero.attack:GetValue() * self.healAmount
        HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
    end
end

return Hero20011_Skill4