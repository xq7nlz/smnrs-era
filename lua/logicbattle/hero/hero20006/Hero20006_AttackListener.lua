--- @class Hero20006_AttackListener
Hero20006_AttackListener = Class(Hero20006_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero20006_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type BaseSkill List
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero20006_AttackListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero20006_AttackListener:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    end
end