--- @class Hero60013_Skill3 DarkKnight
Hero60013_Skill3 = Class(Hero60013_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60013_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type CounterAttackSkillHelper
    self.counterAttackHelper = nil

    --- @type number
    self.counterAttackChance = 0
    --- @type number
    self.counterAttackDamage = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60013_Skill3:CreateInstance(id, hero)
    return Hero60013_Skill3(id, hero)
end

--- @return void
function Hero60013_Skill3:Init()
    self.counterAttackHelper = CounterAttackSkillHelper(self)
    self.counterAttackHelper:SetInfo(self.data.counterAttackDamage, self.data.counterAttackChance)

    self.myHero.attackListener:BindingWithSkill_3(self)
    self.myHero.skillListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero60013_Skill3:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    self:CounterAttack(enemyAttacker)
end

--- @return void
--- @param enemy BaseHero
function Hero60013_Skill3:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    self:CounterAttack(enemy)
end

--- return void
function Hero60013_Skill3:CounterAttack(enemyAttacker)
    local targetList = List()
    targetList:Add(enemyAttacker)
    self.counterAttackHelper:UseCounterAttack(targetList)
end

return Hero60013_Skill3