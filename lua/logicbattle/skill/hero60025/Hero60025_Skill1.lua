--- @class Hero60025_Skill1 Vampire
Hero60025_Skill1 = Class(Hero60025_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60025_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.damageTargetSelector = nil
    --- @type BaseTargetSelector
    self.healTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil
    --- @type HealSkillHelper
    self.healSkillHelper = nil

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60025_Skill1:CreateInstance(id, hero)
    return Hero60025_Skill1(id, hero)
end

--- @return void
function Hero60025_Skill1:Init()
    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.healTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.healTargetPosition,
            TargetTeamType.ALLY, self.data.healTargetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)

    self.healSkillHelper = HealSkillHelperRandom(self)
    self.healSkillHelper:SetHealChance(self.data.healChance)
end

----------------------------------- Battle -------------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero60025_Skill1:UseActiveSkill()

    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local results = self.damageSkillHelper:UseDamageSkill(targetList)

    local allyTargetList = self.healTargetSelector:SelectTarget(self.myHero.battle)

    local healBonus = 0
    if self.skill_2 ~= nil then
        healBonus = self.skill_2:GetHealBonus()
    end
    self.healSkillHelper:SetHealData(self.data.healPercent + healBonus, self.data.healDuration)
    self.healSkillHelper:UseHealSkill(allyTargetList)

    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param skill BaseSkill
function Hero60025_Skill1:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

return Hero60025_Skill1