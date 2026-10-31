--- @class Hero50019_Skill1 Nun
Hero50019_Skill1 = Class(Hero50019_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50019_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.damageTargetSelector = nil
    --- @type BaseTargetSelector
    self.healTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil
    --- @type HealSkillHelper
    self.healSkillHelper = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50019_Skill1:CreateInstance(id, hero)
    return Hero50019_Skill1(id, hero)
end

--- @return void
function Hero50019_Skill1:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.healTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.healTargetPosition,
            TargetTeamType.ALLY, self.data.healTargetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.healSkillHelper = HealSkillHelperRandom(self)
    self.healSkillHelper:SetHealData(self.data.healPercent, self.data.healDuration)
    self.healSkillHelper:SetHealChance(self.data.healChance)
end

----------------------------------- Battle -------------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero50019_Skill1:UseActiveSkill()
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)

    local allyTargetList = self.healTargetSelector:SelectTarget(self.myHero.battle)
    self.healSkillHelper:UseHealSkill(allyTargetList)

    local isEndTurn = true

    return results, isEndTurn
end

return Hero50019_Skill1