--- @class Hero30008_Skill4 Kozorg
Hero30008_Skill4 = Class(Hero30008_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30008_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.crowdControlChance = nil
    --- @type EffectType
    self.crowdControlType = nil
    --- @type number
    self.crowdControlDuration = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30008_Skill4:CreateInstance(id, hero)
    return Hero30008_Skill4(id, hero)
end

--- @return void
function Hero30008_Skill4:Init()
    self.crowdControlChance = self.data.crowdControlChance
    self.crowdControlType = self.data.crowdControlType
    self.crowdControlDuration = self.data.crowdControlDuration

    self.myHero.attackListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero30008_Skill4:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if totalDamage > 0 then
        self:InflictEffect(enemyAttacker)
    end
end

--- @return void
--- @param target BaseHero
function Hero30008_Skill4:InflictEffect(target)
    --- check can inflict effect
    if self.myHero.randomHelper:RandomRate(self.crowdControlChance) then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, target, self.crowdControlType, self.crowdControlDuration)
        target.effectController:AddEffect(ccEffect)
    end
end

return Hero30008_Skill4