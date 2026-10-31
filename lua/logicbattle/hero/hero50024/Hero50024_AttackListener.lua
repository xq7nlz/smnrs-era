--- @class Hero50024_AttackListener
Hero50024_AttackListener = Class(Hero50024_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero50024_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50024_AttackListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero50024_AttackListener:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    end
end