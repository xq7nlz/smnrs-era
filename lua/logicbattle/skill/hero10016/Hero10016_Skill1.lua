--- @class Hero10016_Skill1 Croconile
Hero10016_Skill1 = Class(Hero10016_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10016_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type EffectType
    self.effectType = nil
    --- @type number
    self.effectAmount = nil
    --- @type number
    self.effectDuration = nil

    --- @type HeroClassType
    self.enemyClass = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10016_Skill1:CreateInstance(id, hero)
    return Hero10016_Skill1(id, hero)
end

--- @return void
function Hero10016_Skill1:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.effectType = self.data.effectType
    self.effectAmount = self.data.effectAmount
    self.effectDuration = self.data.effectDuration
    self.enemyClass = self.data.enemyClass
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero10016_Skill1:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)

    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero10016_Skill1:InflictEffect(target)
    if target.originInfo.class == self.enemyClass then
        local dotEffect = EffectUtils.CreateDotEffect(self.myHero, target, self.effectType, self.effectDuration, self.effectAmount)
        target.effectController:AddEffect(dotEffect)
    end
end

return Hero10016_Skill1