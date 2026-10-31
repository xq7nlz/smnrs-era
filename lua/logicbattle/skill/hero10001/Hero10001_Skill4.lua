--- @class Hero10001_Skill4 ColdAxe
Hero10001_Skill4 = Class(Hero10001_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10001_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type ReflectDamageHelper
    self.reflectDamageHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10001_Skill4:CreateInstance(id, hero)
    return Hero10001_Skill4(id, hero)
end

--- @return void
function Hero10001_Skill4:Init()
    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)

    self.reflectDamageHelper = ReflectDamageHelper(self)
    self.reflectDamageHelper:SetInfo(self.data.reflectChance, self.data.reflectDamage)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero10001_Skill4:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    self:ReflectDamage(enemyAttacker, totalDamage)
    self:InflictEffect(enemyAttacker)
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero10001_Skill4:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    self:ReflectDamage(enemy, totalDamage)
    self:InflictEffect(enemy)
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero10001_Skill4:ReflectDamage(enemyAttacker, totalDamage)
    self.reflectDamageHelper:ReflectDamage(enemyAttacker, totalDamage)
end

--- @return void
--- @param target BaseHero
function Hero10001_Skill4:InflictEffect(target)
    --- check can inflict effect
    if self.myHero.randomHelper:RandomRate(self.data.effectChance) then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, target, self.data.effectType, self.data.effectDuration)
        target.effectController:AddEffect(ccEffect)
    end
end

return Hero10001_Skill4