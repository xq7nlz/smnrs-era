--- @class Hero30024_AttackListener Ozroth
Hero30024_AttackListener = Class(Hero30024_AttackListener, AttackListener)

function Hero30024_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_3 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero30024_AttackListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero30024_AttackListener:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.skill_3 ~= nil then
        self.skill_3:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    end
end