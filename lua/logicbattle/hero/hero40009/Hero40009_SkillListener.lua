--- @class Hero40009_SkillListener
Hero40009_SkillListener = Class(Hero40009_SkillListener, SkillListener)

--- @return void
--- @param hero BaseHero
function Hero40009_SkillListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40009_SkillListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero40009_SkillListener:OnDealCritDamage(enemyTarget, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnDealCritDamage(true)
    end
end
