--- @class Hero40020_Skill3 Athelas
Hero40020_Skill3 = Class(Hero40020_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40020_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.healTargetSelector = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero40020_Skill3:CreateInstance(id, hero)
    return Hero40020_Skill3(id, hero)
end

--- @return void
function Hero40020_Skill3:Init()
    self.healTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ALLY, self.data.targetNumber)

    self.myHero.attackListener:BindingWithSkill_3(self)
    self.myHero.skillListener:BindingWithSkill_3(self)
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero40020_Skill3:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    self:HealAllies()
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero40020_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    self:HealAllies()
end

--- @return void
function Hero40020_Skill3:HealAllies()
    if self.myHero.randomHelper:RandomRate(self.data.healChance) then
        local healAmount = self.data.healPercent * self.myHero.attack:GetValue()

        local targetList = self.healTargetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)

            HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)
            i = i + 1
        end
    end
end

return Hero40020_Skill3