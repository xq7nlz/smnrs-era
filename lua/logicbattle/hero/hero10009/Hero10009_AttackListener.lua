--- @class Hero10009_AttackListener
Hero10009_AttackListener = Class(Hero10009_AttackListener, AttackListener)

--- @return void
--- @param hero BaseHero
function Hero10009_AttackListener:Ctor(hero)
    AttackListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil

    --- @type BaseSkill
    self.skill_3 = nil

    --- @type number
    self.bouncingId = 0
end

--- @return number
--- @param skill BaseSkill
function Hero10009_AttackListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return number
--- @param skill BaseSkill
function Hero10009_AttackListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero10009_AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if self.skill_2 ~= nil then
        self.bouncingId = self.bouncingId + 1
        self.skill_2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType, self.bouncingId)
    end
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero10009_AttackListener:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.skill_3 ~= nil then
        self.skill_3:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    end
end