--- @class Hero50008_Skill3 Fanar
Hero50008_Skill3 = Class(Hero50008_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50008_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type BaseTargetSelector
    self.targetSelector = nil

    --- @type @number
    self.powerBuffAmount = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50008_Skill3:CreateInstance(id, hero)
    return Hero50008_Skill3(id, hero)
end

--- @return void
function Hero50008_Skill3:Init()
    self.powerBuffAmount = self.data.powerBuffAmount

    self.targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition, TargetTeamType.ALLY, self.data.targetNumber)
    self.targetSelector:SetIncludeSelf(false)
    self.myHero.attackListener:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50008_Skill3:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    local targetList = self.targetSelector:SelectTarget(self.myHero.battle)
    local i = 1
    while i <= targetList:Count() do
        self:BuffPower(targetList:Get(i))
        i = i + 1
    end

    self:BuffPower(self.myHero)
end

--- @return void
function Hero50008_Skill3:BuffPower(target)
    PowerUtils.GainPower(self.myHero, target, self.powerBuffAmount, false)
end

return Hero50008_Skill3