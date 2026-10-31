--- @class Hero50010_Skill1 Shephion
Hero50010_Skill1 = Class(Hero50010_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50010_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type TargetPositionType
    self.targetPosition = nil

    --- @type number
    self.targetNumberMin = 0

    --- @type number
    self.targetNumberMax = 0

    --- @type number
    self.damageMin = 0

    --- @type number
    self.damageMax = 0

    --- @type number
    self.silenceChanceDebuffMage = 0

    --- @type EffectType
    self.effectTypeDebuffWarrior = nil

    --- @type number
    self.effectChanceDebuffWarrior = 0

    --- @type number
    self.effectDuration = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50010_Skill1:CreateInstance(id, hero)
    return Hero50010_Skill1(id, hero)
end

--- @return void
function Hero50010_Skill1:Init()
    self.targetPosition = self.data.targetPosition
    self.targetNumberMin = self.data.targetNumberMin
    self.targetNumberMax = self.data.targetNumberMax

    self.damageMin = self.data.damageMin
    self.damageMax = self.data.damageMax

    self.silenceChanceDebuffMage = self.data.silenceChanceDebuffMage
    self.effectTypeDebuffWarrior = self.data.effectTypeDebuffWarrior
    self.effectChanceDebuffWarrior = self.data.effectChanceDebuffWarrior

    self.effectDuration = self.data.effectDuration

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.targetPosition, TargetTeamType.ENEMY, self.targetNumberMax)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(0)
end

---------------------------------------- Calculate ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero50010_Skill1:UseActiveSkill()
    local numberTarget = self.myHero.randomHelper:RandomMinMax(self.targetNumberMin, self.targetNumberMax + 1)
    local damageTarget = self.myHero.randomHelper:RandomMinMax(self.damageMin, self.damageMax)

    self.targetSelector:SetInfo(self.targetPosition, TargetTeamType.ENEMY, numberTarget)
    self.damageSkillHelper:SetDamage(damageTarget)

    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, numberTarget)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)
    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero50010_Skill1:InflictEffect(target)
    if target.originInfo.class == HeroClassType.MAGE and self.myHero.randomHelper:RandomRate(self.silenceChanceDebuffMage) then
        local silenceEffect = SilenceEffect(self.myHero, target, self.effectDuration)
        target.effectController:AddEffect(silenceEffect)
    elseif target.originInfo.class == HeroClassType.WARRIOR and self.myHero.randomHelper:RandomRate(self.effectChanceDebuffWarrior) then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, target, self.effectTypeDebuffWarrior, self.effectDuration)
        target.effectController:AddEffect(ccEffect)
    end
end

return Hero50010_Skill1