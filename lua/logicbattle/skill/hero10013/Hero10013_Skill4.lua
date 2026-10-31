--- @class Hero10013_Skill4 Oceanee
Hero10013_Skill4 = Class(Hero10013_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10013_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.healthTrigger = 0

    --- @type number
    self.healAmountByDamage = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10013_Skill4:CreateInstance(id, hero)
    return Hero10013_Skill4(id, hero)
end

--- @return void
function Hero10013_Skill4:Init()
    self.healthTrigger = self.data.healthTrigger
    self.healAmountByDamage = self.data.healAmountByDamage

    self.healTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.healTargetPosition,
            TargetTeamType.ALLY, self.data.healTargetNumber)
    self.healTargetSelector:SetIncludeSelf(false)

    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero10013_Skill4:OnTakeCritDamage(enemyDefender, totalDamage)
    self:TriggerHeal(totalDamage)
end

--- @return void
--- @param totalDamage number
function Hero10013_Skill4:TriggerHeal(totalDamage)
    local healAmount = totalDamage * self.healAmountByDamage
    local targetList = self.healTargetSelector:SelectTarget(self.myHero.battle)

    HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
    local i = 1
    while i <= targetList:Count() do
        local ally = targetList:Get(i)
        HealUtils.Heal(self.myHero, ally, healAmount, HealReason.HEAL_SKILL)
        i = i + 1
    end
end

return Hero10013_Skill4