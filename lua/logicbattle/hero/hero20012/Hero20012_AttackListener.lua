--- @class Hero20012_AttackListener
Hero20012_AttackListener = Class(Hero20012_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero20012_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero20012_AttackListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return number
--- @param skill BaseSkill
function Hero20012_AttackListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero20012_AttackListener:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    end
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero20012_AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.skill_4 ~= nil then
        self.skill_4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end
end