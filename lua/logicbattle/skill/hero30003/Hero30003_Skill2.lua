--- @class Hero30003_Skill2 Nero
Hero30003_Skill2 = Class(Hero30003_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30003_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.healPercent = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30003_Skill2:CreateInstance(id, hero)
    return Hero30003_Skill2(id, hero)
end

--- @return void
function Hero30003_Skill2:Init()
    self.healPercent = self.data.healPercent

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.skillListener:BindingWithSkill_2(self)
    self.myHero.hp:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero30003_Skill2:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        self:Heal(enemyDefender, totalDamage)
    end
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero30003_Skill2:OnDealSkillDamageToEnemy(enemyDefender, totalDamage)
    self:Heal(enemyDefender, totalDamage)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero30003_Skill2:Heal(enemyDefender, totalDamage)
    local healAmount = totalDamage * self.healPercent
    HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
end

--- @return boolean
--- @param initiator BaseHero
function Hero30003_Skill2:CanHeal(initiator)
    if initiator == self.myHero then
        return true
    end
    return false
end

return Hero30003_Skill2