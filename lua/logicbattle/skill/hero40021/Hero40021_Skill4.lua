--- @class Hero40021_Skill4 Titi
Hero40021_Skill4 = Class(Hero40021_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40021_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type CounterAttackSkillHelper
    self.counterAttackHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40021_Skill4:CreateInstance(id, hero)
    return Hero40021_Skill4(id, hero)
end

--- @return void
function Hero40021_Skill4:Init()
    self.counterAttackHelper = CounterAttackSkillHelper(self)
    self.counterAttackHelper:SetInfo(self.data.counterAttackDamage, self.data.counterAttackChance)

    self.myHero.attackListener:BindingWithSkill_4(self)
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero40021_Skill4:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    local targetList = List()
    targetList:Add(enemyAttacker)

    self.counterAttackHelper:UseCounterAttack(targetList)
end

return Hero40021_Skill4