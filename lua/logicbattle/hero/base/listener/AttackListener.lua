--- @class AttackListener
AttackListener = Class(AttackListener)

--- @return void
--- @param hero BaseHero
function AttackListener:Ctor(hero)
    --- @type BaseHero
    self.myHero = hero
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function AttackListener:OnDealCritDamage(enemyDefender, totalDamage)
    --assert(enemyDefender ~= nil and self.myHero:IsAlly(enemyDefender) == false)
    --assert(MathUtils.IsNumber(totalDamage) and totalDamage >= 0)
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function AttackListener:OnTakeCritDamage(enemyAttacker, totalDamage)
    --assert(enemyAttacker ~= nil and self.myHero:IsAlly(enemyAttacker) == false)
    --assert(MathUtils.IsNumber(totalDamage) and totalDamage >= 0)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function AttackListener:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    --assert(enemyDefender ~= nil and self.myHero:IsAlly(enemyDefender) == false)
    --assert(MathUtils.IsNumber(totalDamage) and totalDamage >= 0)
    --assert(MathUtils.IsNumber(dodgeType) and dodgeType >= 0)
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function AttackListener:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    --assert(enemyAttacker ~= nil and self.myHero:IsAlly(enemyAttacker) == false)
    --assert(MathUtils.IsNumber(totalDamage) and totalDamage >= 0)
end