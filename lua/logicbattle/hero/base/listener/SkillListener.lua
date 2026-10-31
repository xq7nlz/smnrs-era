--- @class SkillListener
SkillListener = Class(SkillListener)

--- @return void
--- @param hero BaseHero
function SkillListener:Ctor(hero)
    --- @type BaseHero
    self.myHero = hero
end

---------------------------------------- Listeners ----------------------------------------
--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function SkillListener:OnDealCritDamage(enemyTarget, totalDamage)
    --assert(enemyTarget ~= nil)
    --assert(MathUtils.IsNumber(totalDamage) and totalDamage >= 0)
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function SkillListener:OnTakeCritDamage(enemyAttacker, totalDamage)
    --assert(enemyAttacker ~= nil)
    --assert(MathUtils.IsNumber(totalDamage) and totalDamage >= 0)
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function SkillListener:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    --assert(enemyTarget ~= nil)
    --assert(MathUtils.IsNumber(totalDamage) and totalDamage >= 0)
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function SkillListener:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    --assert(enemy ~= nil)
    --assert(MathUtils.IsNumber(totalDamage) and totalDamage >= 0)
end
