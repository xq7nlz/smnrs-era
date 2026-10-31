--- @class Hero30014_Skill4 Kargoth
Hero30014_Skill4 = Class(Hero30014_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30014_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type CounterAttackSkillHelper
    self.counterAttackHelper = nil
    --- @type EffectType
    self.counterAttackEffect = 0
    --- @type number
    self.counterAttackChance = 0
    --- @type number
    self.counterAttackDamage = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30014_Skill4:CreateInstance(id, hero)
    return Hero30014_Skill4(id, hero)
end

--- @return void
function Hero30014_Skill4:Init()
    self.counterAttackEffect = self.data.counterAttackEffect

    self.counterAttackHelper = CounterAttackSkillHelper(self)
    self.counterAttackHelper:SetInfo(self.data.counterAttackDamage, self.data.counterAttackChance)

    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero30014_Skill4:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    self:CounterAttack(enemyAttacker)
end

--- @return void
--- @param enemy BaseHero
function Hero30014_Skill4:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    self:CounterAttack(enemy)
end

--- return void
function Hero30014_Skill4:CounterAttack(enemyAttacker)
    if enemyAttacker.effectController:IsContainEffectType(self.counterAttackEffect) then
        local targetList = List()
        targetList:Add(enemyAttacker)
        self.counterAttackHelper:UseCounterAttack(targetList)
    end
end
---------------------------------------------END BATTLE--------------------------------------
return Hero30014_Skill4