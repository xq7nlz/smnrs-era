--- @class Hero20007_AttackListener
Hero20007_AttackListener = Class(Hero20007_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero20007_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type BaseSkill List
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero20007_AttackListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero20007_AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.skill_2 ~= nil then
        self.skill_2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end
end