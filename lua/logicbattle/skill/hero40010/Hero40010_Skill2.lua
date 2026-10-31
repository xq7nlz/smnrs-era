--- @class Hero40010_Skill2 Yome
Hero40010_Skill2 = Class(Hero40010_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40010_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type number
    self.effectDotChance = nil
    ---@type EffectType
    self.effectDotType = nil
    ---@type number
    self.effectDotAmount = nil
    ---@type number
    self.effectDotDuration = nil
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40010_Skill2:CreateInstance(id, hero)
    return Hero40010_Skill2(id, hero)
end

--- @return void
function Hero40010_Skill2:Init()
    self.effectDotChance = self.data.effectDotChance
    self.effectDotType = self.data.effectDotType
    self.effectDotAmount = self.data.effectDotAmount
    self.effectDotDuration = self.data.effectDotDuration

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.skillListener:BindingWithSkill_2(self)
end

-----------------------------------------Battle---------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero40010_Skill2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if totalDamage > 0 then
        self:InflictEffect(enemyAttacker)
    end
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero40010_Skill2:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if totalDamage > 0 then
        self:InflictEffect(enemy)
    end
end

--- @return void
--- @param enemyAttacker BaseHero
function Hero40010_Skill2:InflictEffect(enemyAttacker)
    if self.myHero.randomHelper:RandomRate(self.effectDotChance) then
        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, enemyAttacker, self.effectDotType, self.effectDotDuration, self.effectDotAmount)
        enemyAttacker.effectController:AddEffect(dotEffect)
    end
end

return Hero40010_Skill2