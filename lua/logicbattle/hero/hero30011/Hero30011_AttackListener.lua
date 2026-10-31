--- @class Hero30011_AttackListener : AttackListener
Hero30011_AttackListener = Class(Hero30011_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero30011_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type BaseSkill List
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30011_AttackListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero30011_AttackListener:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    end
end