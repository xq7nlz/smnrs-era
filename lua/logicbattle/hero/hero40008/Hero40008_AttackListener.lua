--- @class Hero40008_AttackListener
Hero40008_AttackListener = Class(Hero40008_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero40008_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type Hero50005_Skill3
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40008_AttackListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero40008_AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.skill_4 ~= nil then
        self.skill_4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end
end