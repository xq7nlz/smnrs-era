--- @class Hero30010_AttackListener
Hero30010_AttackListener = Class(Hero30010_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero30010_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30010_AttackListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero30010_AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.skill_3 ~= nil then
        self.skill_3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end
end


