--- @class Hero40011_Skill2 Neutar
Hero40011_Skill2 = Class(Hero40011_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40011_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type number
    self.effectChance = nil
    ---@type EffectType
    self.effectType = nil
    ---@type number
    self.effectDuration = nil
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40011_Skill2:CreateInstance(id, hero)
    return Hero40011_Skill2(id, hero)
end

--- @return void
function Hero40011_Skill2:Init()
    self.effectChance = self.data.effectChance
    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.skillListener:BindingWithSkill_2(self)
end

-----------------------------------------Battle---------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero40011_Skill2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if totalDamage > 0 then
        self:InflictEffect(enemyAttacker)
    end
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero40011_Skill2:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if totalDamage > 0 then
        self:InflictEffect(enemy)
    end
end

--- @return void
--- @param enemyAttacker BaseHero
function Hero40011_Skill2:InflictEffect(enemyAttacker)
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, enemyAttacker, self.effectType, self.effectDuration)
        enemyAttacker.effectController:AddEffect(ccEffect)
    end
end

return Hero40011_Skill2