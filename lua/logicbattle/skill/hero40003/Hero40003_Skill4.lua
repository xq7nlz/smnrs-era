--- @class Hero40003_Skill4 Arryl
Hero40003_Skill4 = Class(Hero40003_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40003_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.reflectChance = 0

    --- @type number
    self.reflectDamage = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40003_Skill4:CreateInstance(id, hero)
    return Hero40003_Skill4(id, hero)
end

--- @return void
function Hero40003_Skill4:Init()
    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)

    self.reflectDamageHelper = ReflectDamageHelper(self)
    self.reflectDamageHelper:SetInfo(self.data.reflectChance, self.data.reflectDamage)
end

--------------------------------- BATTLE ----------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero40003_Skill4:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    self:ReflectDamage(enemyAttacker, totalDamage)
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero40003_Skill4:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    self:ReflectDamage(enemy, totalDamage)
end

--- @return number
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero40003_Skill4:ReflectDamage(enemyAttacker, totalDamage)
    self.reflectDamageHelper:ReflectDamage(enemyAttacker, totalDamage)
end

return Hero40003_Skill4