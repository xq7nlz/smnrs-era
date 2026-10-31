--- @class Hero20026_Skill2 Kardoh
Hero20026_Skill2 = Class(Hero20026_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20026_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20026_Skill2:CreateInstance(id, hero)
    return Hero20026_Skill2(id, hero)
end

--- @return void
function Hero20026_Skill2:Init()
    self.healChance = self.data.healChance
    self.healPercent = self.data.healPercent

    self.healTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.healTargetPosition,
            TargetTeamType.ALLY, self.data.healTargetNumber)

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.skillListener:BindingWithSkill_2(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero20026_Skill2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    self:OnAttacked()
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero20026_Skill2:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    self:OnAttacked()
end

--- @return void
function Hero20026_Skill2:OnAttacked()
    if self.myHero.randomHelper:RandomRate(self.healChance) then
        local healAmount = self.healPercent * self.myHero.attack:GetValue()

        local targetList = self.healTargetSelector:SelectTarget(self.myHero.battle)
        local i = 1
        while i <= targetList:Count() do
            local target = targetList:Get(i)
            HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)
            i = i + 1
        end
    end
end

return Hero20026_Skill2