--- @class Hero50009_AttackListener Aris
Hero50009_AttackListener = Class(Hero50009_AttackListener, AttackListener)

function Hero50009_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_4 = nil

end

--- @return void
--- @param skill BaseSkill
function Hero50009_AttackListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50009_AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.skill_4 ~= nil then
        self.skill_4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end
end
