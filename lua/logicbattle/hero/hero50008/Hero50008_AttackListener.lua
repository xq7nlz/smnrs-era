--- @class Hero50008_AttackListener Fanar
Hero50008_AttackListener = Class(Hero50008_AttackListener, AttackListener)

function Hero50008_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_3 = nil

end

--- @return void
--- @param skill BaseSkill
function Hero50008_AttackListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50008_AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.skill_3 ~= nil then
        self.skill_3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end
end
