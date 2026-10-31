--- @class Hero50010_Skill2 Sephion
Hero50010_Skill2 = Class(Hero50010_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50010_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type CounterAttackSkillHelper
    self.counterAttackHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50010_Skill2:CreateInstance(id, hero)
    return Hero50010_Skill2(id, hero)
end

--- @return void
function Hero50010_Skill2:Init()
    self.counterAttackHelper = CounterAttackSkillHelper(self)
    self.counterAttackHelper:SetInfo(self.data.counterAttackDamage, self.data.counterAttackChance)

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.skillListener:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero50010_Skill2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    self:CounterAttack(enemyAttacker)
end

--- @return void
--- @param enemy BaseHero
function Hero50010_Skill2:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    self:CounterAttack(enemy)
end

--- return void
function Hero50010_Skill2:CounterAttack(enemyAttacker)
    local targetList = List()
    targetList:Add(enemyAttacker)

    self.counterAttackHelper:UseCounterAttack(targetList)
end

return Hero50010_Skill2