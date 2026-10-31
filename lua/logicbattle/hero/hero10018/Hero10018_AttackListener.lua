--- @class Hero10018_AttackListener
Hero10018_AttackListener = Class(Hero10018_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero10018_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero10018_AttackListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero10018_AttackListener:OnDealCritDamage(enemyDefender, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnDealCritDamage(enemyDefender, totalDamage)
    end
end


