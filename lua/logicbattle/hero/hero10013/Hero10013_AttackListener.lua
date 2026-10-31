--- @class Hero10013_AttackListener Oceanee
Hero10013_AttackListener = Class(Hero10013_AttackListener, AttackListener)

function Hero10013_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_2 = nil
    ---@type BaseSkill
    self.skill_3 = nil
    ---@type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero10013_AttackListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param skill BaseSkill
function Hero10013_AttackListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end


--- @return void
--- @param skill BaseSkill
function Hero10013_AttackListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end


--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero10013_AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.skill_2 ~= nil then
        self.skill_2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end

    if self.skill_3 ~= nil then
        self.skill_3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    end
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero10013_AttackListener:OnTakeCritDamage(enemyAttacker, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnTakeCritDamage(enemyAttacker, totalDamage)
    end
end