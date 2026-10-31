--- @class Hero10011_AttackListener Jeronim
Hero10011_AttackListener = Class(Hero10011_AttackListener, AttackListener)

function Hero10011_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_2 = nil

    ---@type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero10011_AttackListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param skill BaseSkill
function Hero10011_AttackListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero10011_AttackListener:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    end
end


--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero10011_AttackListener:OnDealCritDamage(enemyTarget, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnDealCritDamage(enemyTarget, totalDamage)
    end
end
