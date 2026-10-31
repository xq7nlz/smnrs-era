--- @class Hero10003_Skill3 Glacious_Fairy
Hero10003_Skill3 = Class(Hero10003_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10003_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type HealSkillHelper
    self.healSkillHelper = nil

    --- @type BaseTargetSelector
    self.healTargetSelector = nil

    --- @type number
    self.effectChance = nil

    --- @type BaseSkill
    self.skill_2 = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10003_Skill3:CreateInstance(id, hero)
    return Hero10003_Skill3(id, hero)
end

--- @return void
function Hero10003_Skill3:Init()
    self.healTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    self.effectChance = self.data.effectChance

    self.healSkillHelper = Hero10003_HealSkillHelper(self)
    self.healSkillHelper:SetHealData(self.data.effectAmount, self.data.healMarkType, self.data.healMarkBonusPercent)
    self.healSkillHelper:SetActionPerTarget(self.ActionPerTargetHeal)

    self.myHero.attackListener:BindingWithSkill_3(self)
    self.myHero.skillListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero10003_Skill3:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local targetList = self.healTargetSelector:SelectTarget(self.myHero.battle)
        self.healSkillHelper:UseHealSkill(targetList)
    end
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero10003_Skill3:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.myHero.randomHelper:RandomRate(self.effectChance) then
        local targetList = self.healTargetSelector:SelectTarget(self.myHero.battle)
        self.healSkillHelper:UseHealSkill(targetList)
    end
end

--- @return void
--- @param skill BaseSkill
function Hero10003_Skill3:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param target BaseHero
function Hero10003_Skill3:ActionPerTargetHeal(target)
    if self.skill_2 ~= nil then
        self.skill_2:AddMarkToTarget(target)
    end
end

return Hero10003_Skill3