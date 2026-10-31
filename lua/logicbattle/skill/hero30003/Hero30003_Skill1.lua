--- @class Hero30003_Skill1 Nero
Hero30003_Skill1 = Class(Hero30003_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30003_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type number
    self.healPercent = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30003_Skill1:CreateInstance(id, hero)
    return Hero30003_Skill1(id, hero)
end

--- @return void
function Hero30003_Skill1:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.healPercent = self.data.healPercent
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero30003_Skill1:UseActiveSkill()
    local targetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)

    local healAmount = self.healPercent * self.myHero.attack:GetValue()
    HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)

    local isEndTurn = true

    return results, isEndTurn
end

return Hero30003_Skill1