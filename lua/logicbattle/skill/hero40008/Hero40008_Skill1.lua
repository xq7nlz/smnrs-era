--- @class Hero40008_Skill1 Lass
Hero40008_Skill1 = Class(Hero40008_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40008_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type EffectType
    self.effectType = 0
    --- @type number
    self.effectAmount = 0
    --- @type number
    self.effectDuration = 0

    --- @type number
    self.silenceChance = 0
    --- @type number
    self.silenceDuration = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40008_Skill1:CreateInstance(id, hero)
    return Hero40008_Skill1(id, hero)
end

--- @return void
function Hero40008_Skill1:Init()
    self.effectType = self.data.effectType
    self.effectAmount = self.data.effectAmount
    self.effectDuration = self.data.effectDuration

    self.silenceChance = self.data.silenceChance
    self.silenceDuration = self.data.silenceDuration

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

----------------------------------- Battle -------------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero40008_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero40008_Skill1:InflictEffect(target)
    local dotEffect = EffectUtils.CreateDotEffect(self.myHero, target, self.effectType, self.effectDuration, self.effectAmount)
    target.effectController:AddEffect(dotEffect)

    if self.myHero.randomHelper:RandomRate(self.silenceChance) then
        local silenceEffect = SilenceEffect(self.myHero, target, self.silenceDuration)
        target.effectController:AddEffect(silenceEffect)
    end
end

return Hero40008_Skill1