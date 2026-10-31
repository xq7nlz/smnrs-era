--- @class Hero60001_AttackListener
Hero60001_AttackListener = Class(Hero60001_AttackListener, AttackListener)

function Hero60001_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero60001_AttackListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero60001_AttackListener:OnDealCritDamage(enemyDefender, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnDealCritDamage(enemyDefender, totalDamage)
    end
end