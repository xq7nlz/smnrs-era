--- @class Hero50025_Skill1 Avorn
Hero50025_Skill1 = Class(Hero50025_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50025_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.damageTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50025_Skill1:CreateInstance(id, hero)
    return Hero50025_Skill1(id, hero)
end

--- @return void
function Hero50025_Skill1:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

----------------------------------- Battle -------------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero50025_Skill1:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)

    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero50025_Skill1:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.data.effectChance) then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, target, self.data.effectType, self.data.effectDuration)
        target.effectController:AddEffect(ccEffect)
    end
end

return Hero50025_Skill1