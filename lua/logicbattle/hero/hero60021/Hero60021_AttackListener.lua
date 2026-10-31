--- @class Hero60021_AttackListener
Hero60021_AttackListener = Class(Hero60021_AttackListener, AttackListener)

function Hero60021_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_2 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero60021_AttackListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero60021_AttackListener:OnDealCritDamage(enemyDefender, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnDealCritDamage(enemyDefender, totalDamage)
    end
end