--- @class Hero30007_AttackListener
Hero30007_AttackListener = Class(Hero30007_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero30007_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type BaseSkill List
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30007_AttackListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero30007_AttackListener:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.skill_3 ~= nil then
        self.skill_3:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    end
end