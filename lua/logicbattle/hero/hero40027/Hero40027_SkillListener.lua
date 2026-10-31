--- @class Hero40027_SkillListener : SkillListener
Hero40027_SkillListener = Class(Hero40027_SkillListener, SkillListener)

--- @return void
--- @param hero BaseHero
function Hero40027_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    --- @type Hero40027_Skill3
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40027_SkillListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero40027_SkillListener:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.skill_3 ~= nil then
        self.skill_3:AddPoisonEffect(enemy)
    end
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero40027_SkillListener:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if self.skill_3 ~= nil then
        self.skill_3:AddPoisonEffect(enemyTarget)
    end
end