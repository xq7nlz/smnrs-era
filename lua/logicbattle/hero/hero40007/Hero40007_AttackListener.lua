--- @class Hero40007_AttackListener
Hero40007_AttackListener = Class(Hero40007_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero40007_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type Hero50005_Skill3
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40007_AttackListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero40007_AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.skill_2 ~= nil then
        self.skill_2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end
end