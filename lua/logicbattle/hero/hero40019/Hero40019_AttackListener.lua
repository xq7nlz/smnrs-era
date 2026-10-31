--- @class Hero40019_AttackListener
Hero40019_AttackListener = Class(Hero40019_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero40019_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40019_AttackListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero40019_AttackListener:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    end
end