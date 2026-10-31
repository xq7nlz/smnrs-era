--- @class Hero50023_AttackListener
Hero50023_AttackListener = Class(Hero50023_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero50023_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50023_AttackListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number
--- @param skill BaseSkill
function Hero50023_AttackListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50023_AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.skill_3 ~= nil then
        self.skill_3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end

    if self.skill_4 ~= nil then
        self.skill_4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end
end