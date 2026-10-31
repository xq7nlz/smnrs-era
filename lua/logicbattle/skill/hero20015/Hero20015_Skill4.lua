--- @class Hero20015_Skill4 Rufus
Hero20015_Skill4 = Class(Hero20015_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20015_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.healTargetSelector = nil
    --- @type number
    self.healPercent = nil
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero20015_Skill4:CreateInstance(id, hero)
    return Hero20015_Skill4(id, hero)
end

---- @return void
function Hero20015_Skill4:Init()
    self.healTargetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.healTargetPosition,
            TargetTeamType.ALLY, self.data.healTargetNumber)

    self.healPercent = self.data.healPercent

    self.myHero.attackListener:BindingWithSkill_4(self)
end

----------------------------------------- Calculate -------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero20015_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    local healAmount = self.healPercent * self.myHero.attack:GetValue()
    local allyTargetList = self.healTargetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= allyTargetList:Count() do
        local target = allyTargetList:Get(i)
        HealUtils.Heal(self.myHero, target, healAmount, HealReason.HEAL_SKILL)
        i = i + 1
    end
end

return Hero20015_Skill4