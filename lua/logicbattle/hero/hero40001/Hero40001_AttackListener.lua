--- @class Hero40001_AttackListener
Hero40001_AttackListener = Class(Hero40001_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero40001_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type Hero30027_Skill2
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40001_AttackListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero40001_AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.skill_2 ~= nil then
        self.skill_2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end
end