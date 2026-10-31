--- @class Hero30007_Skill3 Zygor
Hero30007_Skill3 = Class(Hero30007_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30007_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.passiveChance = nil
    --- @type number
    self.blockAmount = nil
    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.effectDuration = nil

    --- @type boolean
    self.isTriggerPassive = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30007_Skill3:CreateInstance(id, hero)
    return Hero30007_Skill3(id, hero)
end

--- @return void
function Hero30007_Skill3:Init()
    self.passiveChance = self.data.passiveChance
    self.blockAmount = self.data.blockAmount
    self.effectType = self.data.effectType
    self.effectDuration = self.data.effectDuration

    self.myHero.attackListener:BindingWithSkill_3(self)
    self.myHero.skillListener:BindingWithSkill_3(self)
    self.myHero.skillController:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param target BaseHero
--- @param type DamageFormulaType
function Hero30007_Skill3:GetBlockDamageRate(target, type)
    if type == DamageFormulaType.BASIC_ATTACK or type == DamageFormulaType.ACTIVE_SKILL then
        self.isTriggerPassive = self.myHero.randomHelper:RandomRate(self.passiveChance)
        if self.isTriggerPassive == true then
            return self.blockAmount
        end
    end

    return 0
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero30007_Skill3:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    self:InflictEffect(enemyAttacker)
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero30007_Skill3:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    self:InflictEffect(enemy)
end

--- @return void
--- @param target BaseHero
function Hero30007_Skill3:InflictEffect(target)
    if self.isTriggerPassive == true then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, target, self.effectType, self.effectDuration)
        target.effectController:AddEffect(ccEffect)

        self.isTriggerPassive = false
    end
end

return Hero30007_Skill3