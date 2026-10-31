--- @class Hero60013_AttackListener DarkKnight
Hero60013_AttackListener = Class(Hero60013_AttackListener, AttackListener)

function Hero60013_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_3 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero60013_AttackListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero60013_AttackListener:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.skill_3 ~= nil then
        self.skill_3:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    end
end
