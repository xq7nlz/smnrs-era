--- @class Hero10011_SkillListener Jeronim
Hero10011_SkillListener = Class(Hero10011_SkillListener, SkillListener)

function Hero10011_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_2 = nil

    ---@type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero10011_SkillListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param skill BaseSkill
function Hero10011_SkillListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero10011_SkillListener:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    end
end

function Hero10011_SkillListener:AfterUseSkill()
    if self.skill_2 ~= nil then
        self.skill_2:AfterSkill()
    end
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero10011_SkillListener:OnDealCritDamage(enemyTarget, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnDealCritDamage(enemyTarget, totalDamage)
    end
end