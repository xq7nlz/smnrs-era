--- @class Hero50006_Skill1 Enule
Hero50006_Skill1 = Class(Hero50006_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50006_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    ---@type BaseTargetSelector
    self.targetSelector = nil

    --- @type number
    self.effectChance = 0

    --- @type number
    self.effectType = 0

    --- @type number
    self.effectDuration = 0

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50006_Skill1:CreateInstance(id, hero)
    return Hero50006_Skill1(id, hero)
end

--- @return void
function Hero50006_Skill1:Init()
    self.effectType = self.data.effectType
    self.effectChance = self.data.effectChance
    self.effectDuration = self.data.effectDuration

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = Hero50006_DamageSkillHelper(self)
    self.damageSkillHelper:SetActionPerTarget(self.InflictEffect)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

--- @return number
--- @param skill BaseSkill
function Hero50006_Skill1:BindingWithSkill_2(skill)
    self.damageSkillHelper:BindingWithSkill_2(skill)
end

--- @return number
--- @param skill BaseSkill
function Hero50006_Skill1:BindingWithSkill_3(skill)
    self.skill_3 = skill
end
---------------------------------------- BATTLE -----------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero50006_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
    local result = self.damageSkillHelper:UseDamageSkill(targetList)

    local isEndTurn = true
    if self.skill_3 ~= nil then
        isEndTurn = self.skill_3:ExtraTurn() == false
    end

    return result, isEndTurn
end

--- @return void
--- @param target BaseHero
function Hero50006_Skill1:InflictEffect(target)
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local ccEffect = EffectUtils.CreateCCEffect(self.myHero, target, self.effectType, self.effectDuration)
        target.effectController:AddEffect(ccEffect)
    end
end

return Hero50006_Skill1