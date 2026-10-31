--- @class Hero50013_Skill3 Celes
Hero50013_Skill3 = Class(Hero50013_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50013_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.triggerChance = nil

    --- @type number
    self.blockRate = nil

    --- @type EffectType
    self.effectType = nil

    --- @type number
    self.effectDuration = nil

    --- @type boolean
    self.isTriggerPassive = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50013_Skill3:CreateInstance(id, hero)
    return Hero50013_Skill3(id, hero)
end

--- @return void
function Hero50013_Skill3:Init()
    self.triggerChance = self.data.triggerChance
    self.blockRate = self.data.blockRate
    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration

    self.myHero.skillController:BindingWithSkill_3(self)
    self.myHero.attackListener:BindingWithSkill_3(self)
    self.myHero.skillListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param target BaseHero
--- @param type DamageFormulaType
function Hero50013_Skill3:GetBlockDamageRate(target, type)
    if type == DamageFormulaType.BASIC_ATTACK or type == DamageFormulaType.ACTIVE_SKILL then
        self.isTriggerPassive = self.myHero.randomHelper:RandomRate(self.triggerChance)
        if self.isTriggerPassive == true then
            return self.blockRate
        end
    end
    return 0
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero50013_Skill3:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.isTriggerPassive == true then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, enemyAttacker, self.effectType, self.effectDuration)
        enemyAttacker.effectController:AddEffect(ccEffect)
        self.isTriggerPassive = false
    end
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero50013_Skill3:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.isTriggerPassive == true then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, enemy, self.effectType, self.effectDuration)
        enemy.effectController:AddEffect(ccEffect)
        self.isTriggerPassive = false
    end
end

return Hero50013_Skill3