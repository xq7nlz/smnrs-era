--- @class Hero50010_AttackListener Sephion
Hero50010_AttackListener = Class(Hero50010_AttackListener, AttackListener)

function Hero50010_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_2 = nil

    ---@type BaseSkill
    self.skill_3 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero50010_AttackListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param skill BaseSkill
function Hero50010_AttackListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50010_AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.skill_3 ~= nil then
        self.skill_3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero50010_AttackListener:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    end
end