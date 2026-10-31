--- @class Hero20004_AttackListener
Hero20004_AttackListener = Class(Hero20004_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero20004_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero20004_AttackListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return number
--- @param skill BaseSkill
function Hero20004_AttackListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero20004_AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.skill_2 ~= nil then
        self.skill_2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero20004_AttackListener:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    end
end