--- @class Hero10003_Skill1 Glacious_Fairy
Hero10003_Skill1 = Class(Hero10003_Skill1, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10003_Skill1:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.enemyTargetSelector = nil

    --- @type BaseTargetSelector
    self.allyTargetSelector = nil

    --- @type DamageSkillHelper
    self.damageSkillHelper = nil

    --- @type HealSkillHelper
    self.healSkillHelper = nil

    --- @type BaseSkill
    self.skill_2 = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10003_Skill1:CreateInstance(id, hero)
    return Hero10003_Skill1(id, hero)
end

--- @return void
function Hero10003_Skill1:Init()
    self.allyTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.healTargetPosition,
            TargetTeamType.ALLY, self.data.healTargetNumber)

    self.healSkillHelper = Hero10003_HealSkillHelper(self)
    self.healSkillHelper:SetHealData(self.data.healPercent, self.data.healMarkType, self.data.healMarkBonusPercent)
    self.healSkillHelper:SetActionPerTarget(self.ActionPerTargetHeal)

    self.enemyTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.damageSkillHelper = DamageSkillHelper(self)
    self.damageSkillHelper:SetDamage(self.data.damage)
end

---------------------------------------- Calculate Active skill ----------------------------------------
--- @return List<BaseActionResult>, boolean turn of this hero should be ended or not
function Hero10003_Skill1:UseActiveSkill()
    local enemyTargetList = TargetSelectorUtils.SelectTarget(self.myHero.battle, self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)
    local results = self.damageSkillHelper:UseDamageSkill(enemyTargetList)

    local allyTargetList = self.allyTargetSelector:SelectTarget(self.myHero.battle)
    self.healSkillHelper:UseHealSkill(allyTargetList)

    local isEndTurn = true

    return results, isEndTurn
end

--- @return void
--- @param skill BaseSkill
function Hero10003_Skill1:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param target BaseHero
function Hero10003_Skill1:ActionPerTargetHeal(target)
    if self.skill_2 ~= nil then
        self.skill_2:AddMarkToTarget(target)
    end
end

return Hero10003_Skill1