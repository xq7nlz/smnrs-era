--- @class Hero40019_Skill4 Lith
Hero40019_Skill4 = Class(Hero40019_Skill4, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40019_Skill4:CreateInstance(id, hero)
    return Hero40019_Skill4(id, hero)
end

--- @return void
function Hero40019_Skill4:Init()
    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero40019_Skill4:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    self:InflictEffect(enemyAttacker)
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero40019_Skill4:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    self:InflictEffect(enemy)
end

--- @return void
--- @param target BaseHero
function Hero40019_Skill4:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.data.effectChance) then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, target, self.data.effectType, self.data.effectDuration)
        target.effectController:AddEffect(ccEffect)
    end
end

return Hero40019_Skill4