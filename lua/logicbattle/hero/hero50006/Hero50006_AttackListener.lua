--- @class Hero50006_AttackListener Enule
Hero50006_AttackListener = Class(Hero50006_AttackListener, AttackListener)

function Hero50006_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero50006_AttackListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50006_AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.skill_4 ~= nil then
        self.skill_4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero50006_AttackListener:BouncingDamageToEnemy(enemyDefender, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:DealDamageToEnemyWithinBouncing(enemyDefender, totalDamage)
    end
end