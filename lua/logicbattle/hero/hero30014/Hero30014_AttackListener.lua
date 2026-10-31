--- @class Hero30014_AttackListener
Hero30014_AttackListener = Class(Hero30014_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero30014_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30014_AttackListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return number
--- @param skill BaseSkill
function Hero30014_AttackListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end


--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero30014_AttackListener:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    end

    if self.skill_2 ~= nil then
        self.skill_2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    end
end