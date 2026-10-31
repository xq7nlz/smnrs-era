--- @class Hero40023_Skill2 HoundMaster
Hero40023_Skill2 = Class(Hero40023_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40023_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type CounterAttackSkillHelper
    self.counterAttackHelper = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40023_Skill2:CreateInstance(id, hero)
    return Hero40023_Skill2(id, hero)
end

--- @return void
function Hero40023_Skill2:Init()
    self.counterAttackHelper = CounterAttackSkillHelper(self)
    self.counterAttackHelper:SetInfo(self.data.counterAttackDamage, self.data.counterAttackChance)

    self.myHero.attackListener:BindingWithSkill_2(self)
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero40023_Skill2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    local targetList = List()
    targetList:Add(enemyAttacker)

    self.counterAttackHelper:UseCounterAttack(targetList)
end


return Hero40023_Skill2