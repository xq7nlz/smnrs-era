--- @class Hero40012_AttackListener
Hero40012_AttackListener = Class(Hero40012_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero40012_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)
    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40012_AttackListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero40012_AttackListener:OnDealCritDamage(enemyDefender, totalDamage)
    if self.skill_3 ~= nil then
        self.skill_3:OnDealCritDamage(enemyDefender, totalDamage)
    end
end