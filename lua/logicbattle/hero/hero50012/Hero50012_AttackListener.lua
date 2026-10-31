--- @class Hero50012_AttackListener Alvar
Hero50012_AttackListener = Class(Hero50012_AttackListener, AttackListener)

function Hero50012_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_3 = nil

    ---@type BaseSkill
    self.skill_4 = nil

end

--- @return void
--- @param skill BaseSkill
function Hero50012_AttackListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param skill BaseSkill
function Hero50012_AttackListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero50012_AttackListener:OnDealCritDamage(enemyDefender, totalDamage)
    if self.skill_3 ~= nil then
        self.skill_3:OnDealCritDamage(enemyDefender, totalDamage)
    end
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50012_AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.skill_4 ~= nil then
        self.skill_4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end
end