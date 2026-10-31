--- @class Hero40010_AttackListener
Hero40010_AttackListener = Class(Hero40010_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero40010_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type Hero50005_Skill3
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40010_AttackListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero40010_AttackListener:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    end
end