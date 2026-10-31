--- @class Hero30008_AttackListener
Hero30008_AttackListener = Class(Hero30008_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero30008_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type BaseSkill List
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30008_AttackListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero30008_AttackListener:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    end
end